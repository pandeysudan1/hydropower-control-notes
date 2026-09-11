---
layout: default
title: Nonlinear Hydropower DAE Model
---

# Nonlinear Hydropower DAE Model

This note develops a compact nonlinear differential-algebraic model of a hydropower plant, from reservoir and waterways to turbine, shaft, generator, and load.

## 1. State variables

A simple dynamic state vector is

$$
x_h = \begin{bmatrix}Q_p \\ h_s \\ Q_s\end{bmatrix},
\qquad
x_m = \begin{bmatrix}\delta \\ \omega\end{bmatrix},
$$

with

$$
x = \begin{bmatrix}x_h \\ x_m\end{bmatrix}.
$$

The simplified plant therefore contains five differential states: three hydraulic states and two mechanical states.

## 2. Penstock or intake-conduit dynamics

A lumped nonlinear waterway model can be written as

$$
L_p \dot Q_p = gA_p\left(H_r-h_s-h_f(Q_p)\right),
$$

with nonlinear friction

$$
h_f(Q_p)=K_fQ_p|Q_p|.
$$

Hence,

$$
\dot Q_p = \frac{gA_p}{L_p}\left(H_r-h_s-K_fQ_p|Q_p|\right).
$$

## 3. Surge-tank dynamics

A mass balance gives

$$
A_s\dot h_s = Q_p-Q_t,
$$

so that

$$
\dot h_s = \frac{Q_p-Q_t}{A_s}.
$$

If a second dynamic conduit exists between the surge tank and turbine,

$$
L_s\dot Q_s = gA_s\left(h_s-H_t-K_sQ_s|Q_s|\right).
$$

## 4. Reservoir and tailrace

The reservoir and tailrace may be treated as constant-head boundary conditions,

$$
H_r=H_{r0},
\qquad
H_{tr}=H_{tr0}.
$$

They then contribute algebraic constraints rather than dynamic states.

## 5. Turbine equations

A simple nonlinear turbine flow relation is

$$
Q_t=C_dA_g(y_g)\sqrt{2gH_t}.
$$

This can be written as the algebraic constraint

$$
0=Q_t-C_dA_g(y_g)\sqrt{2gH_t}.
$$

Hydraulic power is

$$
P_h=\rho gQ_tH_t,
$$

and turbine mechanical power is

$$
P_m=\eta_t(Q_t,H_t,\omega)\rho gQ_tH_t.
$$

The corresponding mechanical torque is

$$
T_m=\frac{P_m}{\omega}.
$$

## 6. Shaft dynamics

The shaft connects the turbine and generator. A classical two-state mechanical model is

$$
\dot\delta=\omega-\omega_s,
$$

and

$$
J\dot\omega=T_m-T_e-D(\omega-\omega_s).
$$

In power form,

$$
M\dot{\Delta\omega}=P_m-P_e-D\Delta\omega.
$$

## 7. Generator and load

If electromagnetic transients are neglected, a classical generator relation may be written as

$$
P_e=\frac{EV}{X}\sin\delta.
$$

Equivalently,

$$
0=P_e-\frac{EV}{X}\sin\delta.
$$

A static load may be represented by

$$
P_L=P_{L0}\left(\frac{V}{V_0}\right)^\alpha\left(\frac{\omega}{\omega_0}\right)^\beta,
$$

with power balance

$$
0=P_e-P_L-P_{grid}.
$$

## 8. Complete DAE form

The complete physical plant can be written compactly as

$$
\dot x=f(x,z,u,\theta),
$$

$$
0=g(x,z,u,\theta),
$$

or equivalently,

$$
F(\dot x,x,z,u,\theta)=0.
$$

Here, $x$ contains the differential states, $z$ contains algebraic variables, $u$ contains external or control inputs, and $\theta$ denotes parameters.

## 9. Why the model is naturally acausal

For connected hydraulic components,

$$
Q_1+Q_2=0,
\qquad
H_1=H_2.
$$

For connected rotational components,

$$
\tau_1+\tau_2=0,
\qquad
\omega_1=\omega_2.
$$

For electrical connections,

$$
i_1+i_2=0,
\qquad
v_1=v_2.
$$

These equations do not prescribe a fixed input-output direction. Instead, the complete coupled system is solved simultaneously. This is the essential mathematical character of equation-based acausal modeling.

## 10. Next step

The next article will add governor, droop, FCR, and secondary control on top of this nonlinear physical plant and separate continuous plant dynamics from discrete controller timing.
