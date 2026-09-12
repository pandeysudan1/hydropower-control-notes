---
layout: default
title: OpenHPL Hydropower Control Notes
---

# OpenHPL Hydropower Control Notes

This site develops hydropower frequency-control models directly from the OpenHPL library used by USN/OpenSimHub. The workflow starts from the nonlinear acausal Modelica plant, derives reduced control models around an operating point, and connects them to FCR/LFC analysis in Julia.

## Complete article series

1. [OpenHPL-Based Nonlinear Hydropower DAE](articles/01-hydropower-dae-model.html)
2. [Acausal Modeling and OpenHPL Interfaces](articles/02-acausal-modeling.html)
3. [Hydraulic Dynamics: Reservoir, PenstockKP and Surge Tank](articles/03-governor-droop-control.html)
4. [Francis Turbine: Hydraulic-to-Mechanical Coupling](articles/04-primary-secondary-control.html)
5. [OpenHPL Generator and Grid Coupling](articles/05-continuous-discrete-control.html)
6. [OpenHPL Governor, Droop and Guide-Vane Servo](articles/06-homotopy-dae-events.html)
7. [Building the Complete OpenHPL FCR Loop](articles/07-openhpl-fcr-loop.html)
8. [Operating Point, DAE Linearization and Model Reduction](articles/08-operating-point-linearization.html)
9. [Continuous Physics, Digital Events and Homotopy](articles/09-hybrid-events-homotopy.html)
10. [From OpenHPL to Julia and ControlSystems.jl](articles/10-julia-control-workflow.html)
11. [OpenHPL Source Map Used in These Notes](articles/11-openhpl-source-map.html)

## Central mathematical path

$$
F(\dot{x},x,z,u,\theta)=0
$$

$$
\Downarrow
$$

$$
F(0,x^\star,z^\star,u^\star,\theta)=0
$$

$$
\Downarrow
$$

$$
E\,\Delta\dot{x}=A\,\Delta x+B\,\Delta u
$$

$$
\Downarrow
$$

$$
G(s)=C(sE-A)^{-1}B+D
$$

$$
\Downarrow
$$

$$
\text{FCR / LFC analysis and controller design}
$$

The detailed OpenHPL model remains the nonlinear reference model; reduced transfer functions are derived for analysis and must be validated back against the nonlinear plant.
