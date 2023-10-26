include("expressions.jl")

const Environment = Dict{Symbol, SchemeObject}

function getVariable(expr::SchemeObject, env::Environment) end
function assignVariable(expr::SchemeObject, env::Environment) end
function defineVariable(expr::SchemeObject, env::Environment) end
