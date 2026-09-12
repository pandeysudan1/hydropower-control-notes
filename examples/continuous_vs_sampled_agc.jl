using DifferentialEquations
using Plots

# ------------------------------------------------------------
# Toy hydropower frequency-control model
# ------------------------------------------------------------
# States: x = [df, v, yg, xi]
# df : frequency deviation [pu or normalized]
# v  : pilot-servo state
# yg : guide-vane opening
# xi : AGC integral state
#
# Plant / control equations
#   M*d(df)/dt = Kt*yg - dPL - D*df
#   Tp*dv/dt + v = e
#   e = -df - R*(yg-yg0) + xi
#   dxi/dt = -Ki*B*df
#
# Two implementations are compared:
#   1) continuous controller with hard position/rate limits
#   2) synchronous sampled controller with zero-order hold
# ------------------------------------------------------------

Base.@kwdef mutable struct Params
    M::Float64 = 8.0
    D::Float64 = 1.0
    Kt::Float64 = 1.0
    Tp::Float64 = 0.08
    Tg::Float64 = 0.25
    R::Float64 = 0.05
    Ki::Float64 = 0.35
    B::Float64 = 1.0
    yg0::Float64 = 0.50
    ygmin::Float64 = 0.0
    ygmax::Float64 = 1.0
    ropen::Float64 = 0.08       # max opening rate [1/s]
    rclose::Float64 = 0.12      # max closing rate [1/s]
    tdist::Float64 = 5.0
    dPL0::Float64 = 0.50
    dPLstep::Float64 = 0.16
    Ts::Float64 = 0.10
    Kc::Float64 = 0.45
end

load_disturbance(t, p) = t < p.tdist ? p.dPL0 : p.dPL0 + p.dPLstep

# ------------------------------------------------------------
# 1) Continuous AGC + continuous hard gate/rate constraints
# ------------------------------------------------------------
function f_continuous!(du, u, p, t)
    df, v, yg, xi = u

    dPL = load_disturbance(t, p)
    e = -df - p.R * (yg - p.yg0) + xi

    du[1] = (p.Kt * yg - dPL - p.D * df) / p.M
    du[2] = (e - v) / p.Tp
    du[4] = -p.Ki * p.B * df

    raw_rate = v / p.Tg
    limited_rate = clamp(raw_rate, -p.rclose, p.ropen)

    # Position limits introduce branch switching
    if yg >= p.ygmax && limited_rate > 0
        du[3] = 0.0
    elseif yg <= p.ygmin && limited_rate < 0
        du[3] = 0.0
    else
        du[3] = limited_rate
    end
end

function affect_upper!(integrator)
    integrator.u[3] = integrator.p.ygmax
end

function affect_lower!(integrator)
    integrator.u[3] = integrator.p.ygmin
end

function continuous_case(p)
    u0 = [0.0, 0.0, p.yg0, 0.0]
    prob = ODEProblem(f_continuous!, u0, (0.0, 60.0), p)

    cb_upper = ContinuousCallback((u,t,integrator)->u[3]-p.ygmax, affect_upper!, nothing)
    cb_lower = ContinuousCallback((u,t,integrator)->u[3]-p.ygmin, nothing, affect_lower!)
    cb = CallbackSet(cb_upper, cb_lower)

    solve(prob, Rodas5P(); callback=cb, abstol=1e-8, reltol=1e-8,
          saveat=0.02, tstops=[p.tdist])
end

# ------------------------------------------------------------
# 2) Synchronous sampled controller
# ------------------------------------------------------------
# Continuous plant state: [df, v, xi]
# Gate yg is updated only at t_k = k*Ts and held between ticks.
# ------------------------------------------------------------
mutable struct SampledControlState
    yg::Float64
end

function f_sampled!(du, u, ps, t)
    p, cs = ps
    df, v, xi = u
    dPL = load_disturbance(t, p)
    e = -df - p.R * (cs.yg - p.yg0) + xi

    du[1] = (p.Kt * cs.yg - dPL - p.D * df) / p.M
    du[2] = (e - v) / p.Tp
    du[3] = -p.Ki * p.B * df
end

function sampled_case(p)
    cs = SampledControlState(p.yg0)
    u0 = [0.0, 0.0, 0.0]
    prob = ODEProblem(f_sampled!, u0, (0.0, 60.0), (p, cs))

    yg_hist_t = Float64[]
    yg_hist = Float64[]

    function tick!(integrator)
        p, cs = integrator.p
        df, v, xi = integrator.u
        e = -df - p.R * (cs.yg - p.yg0) + xi

        # Equivalent desired one-step gate increment
        ycmd = cs.yg + p.Kc * e
        dy = clamp(ycmd - cs.yg, -p.rclose*p.Ts, p.ropen*p.Ts)
        cs.yg = clamp(cs.yg + dy, p.ygmin, p.ygmax)

        push!(yg_hist_t, integrator.t)
        push!(yg_hist, cs.yg)
    end

    cb = PeriodicCallback(tick!, p.Ts; initial_affect=true)
    sol = solve(prob, Rodas5P(); callback=cb, abstol=1e-8, reltol=1e-8,
                saveat=0.02, tstops=[p.tdist])

    return sol, yg_hist_t, yg_hist
end

# ------------------------------------------------------------
# Run comparison
# ------------------------------------------------------------
p = Params()
sol_c = continuous_case(p)
sol_s, tk, ygk = sampled_case(p)

# Recover sampled gate as zero-order-held signal on saved time grid
function zoh_gate(ts, tk, ygk, yg0)
    y = similar(ts)
    j = 1
    current = yg0
    for i in eachindex(ts)
        while j <= length(tk) && tk[j] <= ts[i] + eps()
            current = ygk[j]
            j += 1
        end
        y[i] = current
    end
    y
end

yg_s = zoh_gate(sol_s.t, tk, ygk, p.yg0)

p1 = plot(sol_c.t, sol_c[1,:], label="continuous AGC", xlabel="t [s]", ylabel="Δf")
plot!(p1, sol_s.t, sol_s[1,:], label="sampled AGC")

p2 = plot(sol_c.t, sol_c[3,:], label="continuous gate", xlabel="t [s]", ylabel="y_g")
plot!(p2, sol_s.t, yg_s, label="sampled gate")

p3 = plot(sol_c.t, sol_c[4,:], label="continuous ξ_AGC", xlabel="t [s]", ylabel="ξ_AGC")
plot!(p3, sol_s.t, sol_s[3,:], label="sampled ξ_AGC")

savefig(p1, "frequency_response.png")
savefig(p2, "gate_response.png")
savefig(p3, "agc_state.png")

println("Continuous solve stats:")
println(sol_c.destats)
println("\nSampled solve stats:")
println(sol_s.destats)
println("\nSaved plots: frequency_response.png, gate_response.png, agc_state.png")
