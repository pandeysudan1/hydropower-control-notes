---
layout: default
title: Hydropower Dynamics and Frequency Control
---

# Hydropower Dynamics and Frequency Control

These notes develop a nonlinear hydropower model from physical equations and connect it to frequency-control theory, acausal modeling, digital control, AGC, and numerical methods.

## Complete article series

1. [Nonlinear Hydropower DAE Model](articles/01-hydropower-dae-model.html)
2. [Acausal Modeling of Hydropower Systems](articles/02-acausal-modeling.html)
3. [Governor and Droop Control](articles/03-governor-droop-control.html)
4. [Primary and Secondary Frequency Control](articles/04-primary-secondary-control.html)
5. [Continuous Physics and Discrete Control](articles/05-continuous-discrete-control.html)
6. [Homotopy and DAE Events](articles/06-homotopy-dae-events.html)

## Mathematical roadmap

The series starts from the nonlinear physical model

$$
F(\dot{x},x,z,u,\theta)=0,
$$

then separates physical causality from controller execution, develops droop/FCR and AGC, and finally treats hybrid events and consistent DAE reinitialization.

The next stage will derive equilibrium conditions, linearize the nonlinear DAE,

$$
E\,\Delta\dot X=A\,\Delta X+B\,\Delta u,
$$

reduce it to state-space form where possible, and derive transfer functions for classical LFC/FCR analysis.
