include("expressions.jl")
include("environment.jl")

"""
This is a lambda
"""
struct Procedure
    args::Pair
    body::SchemeObject
    env::Environment
end

function evalExpr(expr::SchemeObject, env::Environment)
    if isSelfEvaluating(expr)
        return expr
    elseif isVariable(expr)
        return getVariable(env, expr)
    elseif isQuoted(expr)
        return expr.second
    # elseif isAssignment(expr)
    #     assignVariable(expr, env)
    # elseif isDefinition(expr)
    #     defineVariable(expr, env)
    # elseif isIf(expr)
    #     ...
    # elseif isCond(expr)
    #     ...
    # elseif isLet(expr)
    #     ...
    # elseif isBegin(expr)
    #     ...
    # elseif isApplication(expr)
    #     ...
    else
        error("Interpreter error, cannot interpret expression: $expr")
    end
end
evalExpr(expr::SchemeObject) = evalExpr(expr, Environment([]))
