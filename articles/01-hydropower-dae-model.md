---
layout: default
title: Nonlinear Hydropower DAE Model
---

# Nonlinear Hydropower DAE Model

This note develops a compact nonlinear differential-algebraic model of a hydropower plant, starting from reservoir and waterways and ending at turbine, shaft, generator, and electrical load. The purpose is to obtain a physically interpretable model that can later be linearized around an operating point for load-frequency control and FCR studies.

## 1. System boundary and modeling assumptions

We consider the chain

$$
\text{reservoir}
\rightarrow
\text{intake/penstock}
\rightarrow
\text{surge tank}
\rightarrow
\text{turbine}
\rightarrow
\text{shaft}
\rightarrow
\text{generator}
\rightarrow
\text{load/grid}.
$$

The following simplifications are used in this first model:

- the reservoir and tailrace are constant-head boundaries;
- the waterways are represented by lumped momentum equations;
- hydraulic friction is nonlinear and quadratic in flow;
- the surge tank is represented by continuity plus downstream flow dynamics;
- the turbine is represented by algebraic constitutive relations;
- shaft dynamics are represented by rotor angle and speed;
- electromagnetic generator transients are neglected;
- the electrical network and load are represented algebraically.

The resulting model is a nonlinear DAE.

## 2. Differential and algebraic variables

A convenient differential-state vector is

$$
x =
\begin{bmatrix}
Q_1 & h_s & Q_2 & \delta & \omega
\end{bmatrix}^{\!T},
$$

where

$$
Q_1 = \text{upstream conduit flow},
$$

$$
h_s = \text{surge-tank water level},
$$

$$
Q_2 = \text{downstream penstock/turbine flow},
$$

$$
\delta = \text{generator rotor angle},
$$

and

$$
\omega = \text{generator angular speed}.
$$

A possible algebraic-variable vector is

$$
z =
\begin{bmatrix}
H_t & P_h & P_m & T_m & P_e & P_L
\end{bmatrix}^{\!T}.
$$

The control or external-input vector may be written as

$$
u =
\begin{bmatrix}
y_g & H_r & H_{tr} & P_{\mathrm{grid}}
\end{bmatrix}^{\!T},
$$

where $y_g$ is the guide-vane opening.

## 3. Reservoir and tailrace

For a large reservoir and a stiff downstream water level, we take

$$
H_r = H_{r0},
$$

and

$$
H_{tr} = H_{tr0}.
$$

These are algebraic boundary conditions and therefore introduce no new differential states.

## 4. Upstream conduit or penstock dynamics

For a lumped water column, the momentum balance may be written as

$$
L_1 \dot Q_1
=
 g A_1
\left(
H_r-h_s-h_{f,1}(Q_1)
\right).
$$

With quadratic hydraulic friction,

$$
h_{f,1}(Q_1)=K_1 Q_1|Q_1|.
$$

Therefore,

$$
\boxed{
\dot Q_1
=
\frac{gA_1}{L_1}
\left(
H_r-h_s-K_1Q_1|Q_1|
\right)
}.
$$

This is the first hydraulic differential equation.

## 5. Surge-tank continuity equation

The surge tank stores water volume. If its effective cross-sectional area is $A_s$, continuity gives

$$
A_s \dot h_s = Q_1-Q_2.
$$

Hence,

$$
\boxed{
\dot h_s = \frac{Q_1-Q_2}{A_s}
}.
$$

This is the second hydraulic differential equation.

## 6. Downstream penstock dynamics

The flow from the surge tank to the turbine is modeled by another lumped momentum equation,

$$
L_2\dot Q_2
=
 gA_2
\left(
h_s-H_t-h_{f,2}(Q_2)
\right).
$$

Using

$$
h_{f,2}(Q_2)=K_2Q_2|Q_2|,
$$

we obtain

$$
\boxed{
\dot Q_2
=
\frac{gA_2}{L_2}
\left(
h_s-H_t-K_2Q_2|Q_2|
\right)
}.
$$

This is the third hydraulic differential equation.

The hydraulic state vector is therefore

$$
x_h=
\begin{bmatrix}
Q_1 & h_s & Q_2
\end{bmatrix}^{\!T}.
$$

## 7. Turbine algebraic equations

The turbine couples the hydraulic and mechanical domains. A simple nonlinear flow law is

$$
Q_2
=
C_d A_g(y_g)\sqrt{2gH_t}.
$$

Equivalently,

$$
\boxed{
0
=
Q_2-C_d A_g(y_g)\sqrt{2gH_t}
}.
$$

The hydraulic power available at the runner is

$$
P_h=\rho g Q_2 H_t.
$$

The mechanical turbine power is

$$
\boxed{
P_m
=
\eta_t(Q_2,H_t,\omega)\,\rho gQ_2H_t
}.
$$

The turbine torque is

$$
\boxed{
T_m=\frac{P_m}{\omega}
}.
$$

These equations are algebraic in the present model.

## 8. Shaft and rotor dynamics

The turbine and generator are coupled through a rotating shaft. A classical mechanical model uses rotor angle and speed.

The rotor-angle equation is

$$
\boxed{
\dot\delta = \omega-\omega_s
}.
$$

The rotational momentum balance is

$$
J\dot\omega
=
T_m-T_e-D(\omega-\omega_s).
$$

Equivalently, using power variables,

$$
M\dot{\Delta\omega}
=
P_m-P_e-D\Delta\omega,
$$

where

$$
\Delta\omega = \omega-\omega_s.
$$

Thus the mechanical subsystem contributes two differential equations.

The mechanical state vector is

$$
x_m=
\begin{bmatrix}
\delta & \omega
\end{bmatrix}^{\!T}.
$$

## 9. Generator algebraic model

If electromagnetic transients are neglected, the generator can be represented by a classical electrical power-angle relation. For a generator with internal emf $E$ connected through reactance $X$ to a bus with voltage magnitude $V$,

$$
\boxed{
P_e
=
\frac{EV}{X}\sin\delta
}.
$$

Equivalently,

$$
0
=
P_e-
\frac{EV}{X}\sin\delta.
$$

The electromagnetic torque is

$$
T_e=\frac{P_e}{\omega}.
$$

In a more detailed model, stator algebraic equations and network current-balance equations could be added without changing the overall DAE structure.

## 10. Load model and electrical power balance

A static voltage- and frequency-dependent load can be represented as

$$
P_L
=
P_{L0}
\left(\frac{V}{V_0}\right)^{\alpha}
\left(\frac{\omega}{\omega_0}\right)^{\beta}.
$$

For a single-bus representation, active-power balance may be written as

$$
\boxed{
0=P_e-P_L-P_{\mathrm{grid}}
}.
$$

If the generator is connected to an infinite bus, $P_{\mathrm{grid}}$ represents the exported or imported electrical power.

## 11. Complete nonlinear DAE model

Collecting all differential states gives

$$
x=
\begin{bmatrix}
Q_1 & h_s & Q_2 & \delta & \omega
\end{bmatrix}^{\!T}.
$$

The differential equations can be written compactly as

$$
\boxed{
\dot x=f(x,z,u,\theta)
}.
$$

The algebraic constitutive and network relations can be written as

$$
\boxed{
0=g(x,z,u,\theta)
}.
$$

The complete model is therefore

$$
\boxed{
F(\dot x,x,z,u,\theta)=0
}.
$$

Here,

$$
x \in \mathbb{R}^{5}
$$

contains the five dynamic states of this simplified model, while $z$ contains the algebraic hydraulic, turbine, mechanical, and electrical variables.

## 12. Explicit state equations

Using the chosen states, the differential part can be displayed explicitly as

$$
\dot x=
\begin{bmatrix}
\dfrac{gA_1}{L_1}\left(H_r-h_s-K_1Q_1|Q_1|\right)\\[3mm]
\dfrac{Q_1-Q_2}{A_s}\\[3mm]
\dfrac{gA_2}{L_2}\left(h_s-H_t-K_2Q_2|Q_2|\right)\\[3mm]
\omega-\omega_s\\[2mm]
\dfrac{1}{J}\left(T_m-T_e-D(\omega-\omega_s)\right)
\end{bmatrix}.
$$

The quantities $H_t$, $T_m$, and $T_e$ are obtained from the algebraic subsystem.

## 13. Algebraic subsystem

A compact set of algebraic equations is

$$
0
=
Q_2-C_dA_g(y_g)\sqrt{2gH_t},
$$

$$
0
=
P_h-\rho gQ_2H_t,
$$

$$
0
=
P_m-\eta_t\rho gQ_2H_t,
$$

$$
0
=
T_m-\frac{P_m}{\omega},
$$

$$
0
=
P_e-\frac{EV}{X}\sin\delta,
$$

$$
0
=
P_L-P_{L0}
\left(\frac{V}{V_0}\right)^\alpha
\left(\frac{\omega}{\omega_0}\right)^\beta,
$$

and

$$
0=P_e-P_L-P_{\mathrm{grid}}.
$$

The exact number of algebraic equations depends on the level of detail chosen for the turbine, generator, and network.

## 14. Why this model is naturally acausal

Acausal modeling is most naturally expressed through conservation equations and constitutive relations rather than a prescribed signal direction.

For a hydraulic connection between two components,

$$
Q_1+Q_2=0,
$$

and

$$
H_1=H_2.
$$

For a rotational mechanical connection,

$$
\tau_1+\tau_2=0,
$$

and

$$
\omega_1=\omega_2.
$$

For an electrical connection,

$$
i_1+i_2=0,
$$

and

$$
v_1=v_2.
$$

These equations do not say in advance which variable is an input and which is an output. Instead, the complete set of equations is assembled and solved simultaneously.

Mathematically, the distinction is

$$
\text{causal form:}\qquad y=\phi(u),
$$

versus

$$
\text{acausal form:}\qquad F(y,u)=0.
$$

The latter is the natural form for interconnected hydraulic, mechanical, and electrical physical components.

## 15. Controller is conceptually separate from causality

The physical plant can be acausal whether or not a controller is present. A governor does not make the physical plant causal or acausal by itself.

For example, a continuous isochronous PI governor may be written as

$$
\dot\xi=\omega_{\mathrm{ref}}-\omega,
$$

and

$$
y_g
=
K_p(\omega_{\mathrm{ref}}-\omega)+K_i\xi.
$$

Droop control may be written as

$$
\Delta P_{\mathrm{ref}}
=
-\frac{1}{R}\Delta\omega.
$$

These controller equations can be coupled to the same nonlinear DAE plant.

## 16. Equilibrium operating point

To prepare the model for classical control analysis, first determine an equilibrium

$$
(x^\star,z^\star,u^\star)
$$

such that

$$
\boxed{
f(x^\star,z^\star,u^\star,\theta)=0
}
$$

and

$$
\boxed{
g(x^\star,z^\star,u^\star,\theta)=0
}.
$$

At equilibrium,

$$
\dot Q_1=0,
\qquad
\dot h_s=0,
\qquad
\dot Q_2=0,
\qquad
\dot\delta=0,
\qquad
\dot\omega=0.
$$

This operating point is the bridge between the nonlinear physical model and small-signal LFC/FCR analysis.

## 17. Linearization around the operating point

Define perturbations

$$
\Delta x=x-x^\star,
\qquad
\Delta z=z-z^\star,
\qquad
\Delta u=u-u^\star.
$$

Linearization gives

$$
\Delta\dot x
=
A_x\Delta x+A_z\Delta z+B\Delta u,
$$

and

$$
0
=
G_x\Delta x+G_z\Delta z+G_u\Delta u.
$$

If $G_z$ is nonsingular, then

$$
\Delta z
=
-G_z^{-1}G_x\Delta x
-G_z^{-1}G_u\Delta u.
$$

Substitution into the differential equations gives the reduced state-space model

$$
\boxed{
\Delta\dot x
=
A\Delta x+B_r\Delta u
}.
$$

This reduced linear model can then be used to derive transfer functions and frequency-response models.

## 18. Connection to FCR and load-frequency control

For primary frequency control, the key small-signal path is

$$
\Delta\omega
\rightarrow
\text{governor}
\rightarrow
\Delta y_g
\rightarrow
\text{hydraulic system}
\rightarrow
\Delta P_m
\rightarrow
\text{shaft/generator}
\rightarrow
\Delta\omega.
$$

A useful transfer function is therefore

$$
\boxed{
G_{P_m\omega}(s)
=
\frac{\Delta P_m(s)}{\Delta\omega(s)}
}.
$$

Alternatively, one may derive

$$
G_{P_my_g}(s)
=
\frac{\Delta P_m(s)}{\Delta y_g(s)},
$$

and then connect the governor dynamics separately.

## 19. Differential-equation count in this simplified model

With the assumptions used here, the model contains

$$
\boxed{3\text{ hydraulic differential equations}}
$$

and

$$
\boxed{2\text{ mechanical differential equations}}.
$$

Therefore,

$$
\boxed{n_x=5}.
$$

The number of algebraic equations is not universal. It depends on how much detail is included in the turbine, generator, electrical network, and load models.

## 20. Final compact representation

The entire plant can finally be summarized as

$$
\boxed{
\begin{aligned}
\dot x &= f(x,z,u,\theta),\\
0 &= g(x,z,u,\theta),\\
y &= h(x,z,u,\theta).
\end{aligned}
}
$$

The physical model is nonlinear, multi-domain, and naturally equation based. The next stage is to add governor, droop control, primary FCR, secondary AGC, and discrete controller timing, and then compare the nonlinear model with the linearized transfer-function representation.
