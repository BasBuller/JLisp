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
        return getVariable(expr, env)
    elseif isQuoted(expr)
        return expr.second
    elseif isSetVariable(expr)
        return setVariable(expr.second, env)
    elseif isDefinition(expr)
        return defineVariable(expr.second, env)
    elseif isIf(expr)
        bool = evalExpr(ifPredicate(expr))
        if bool
            return ifConsequent(expr)
        else
            return ifAlternative(expr)
        end
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
