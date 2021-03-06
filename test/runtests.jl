#!/usr/bin/env julia

using Test
using EAGO, JuMP, MathOptInterface, StaticArrays, Ipopt, ForwardDiff
using EAGO.McCormick
using IntervalArithmetic
const MOI = MathOptInterface
using ForwardDiff: Dual, Partials

include("branch_bound.jl")
include("mccormick.jl")
include("domain_reduction.jl")
include("optimizer.jl")
include("script_optimizer.jl")
include("semiinfinite.jl")
