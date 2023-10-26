include("expressions.jl")

const Environment = Dict{Symbol, SchemeObject}

function getVariable(expr::Symbol, env::Environment)
    return env[expr]
end
function setVariable(expr::SchemeObject, env::Environment)
    key = expr.first
    value = expr.second.first
    if !haskey(env, key)
        error("Setting undefined variable")
    else
        push!(env, key => value)
        return nothing
    end
end
function defineVariable(expr::SchemeObject, env::Environment)
    key = expr.first
    value = expr.second.first
    push!(env, key => value)
    return nothing
end
