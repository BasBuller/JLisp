include("expressions.jl")

const Environment = Dict{Symbol, SchemeObject}

function getVariable(expr::SchemeObject, env::Environment) end
