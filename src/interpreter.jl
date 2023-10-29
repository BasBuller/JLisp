include("expressions.jl")
include("environment.jl")

"""
This is a lambda
"""
struct Lambda <: Function
    args::Pair
    body::SchemeObject
    env::Environment
    
    function Lambda(expr::SchemeObject, env::Environment)
        args = expr.second.first
        body = expr.second.second.first
        return new(args, body, env)
    end
end

function evalExpr(expr::SchemeObject, env::Environment)
    if isSelfEvaluating(expr)
        return expr
    elseif isVariable(expr)
        return getVariable(expr, env)
    elseif isQuoted(expr)
        return expr.second
    elseif isSetVariable(expr)
        return setVariable(expr, env)
    elseif isDefinition(expr)
        return defineVariable(expr, env)
    elseif isIf(expr)
        bool = evalExpr(ifPredicate(expr))
        if bool
            return ifConsequent(expr)
        else
            return ifAlternative(expr)
        end
    elseif isCond(expr)
        expr = convertCondToIfStatements(expr)
        # return evalExpr(expr)
        return expr
    # elseif isLet(expr)
    #     ...
    elseif isLambda(expr)
        return Lambda(expr, env)
    # elseif isBegin(expr)
    #     ...
    elseif isApplication(expr)
        evalFunction(expr)
    else
        error("Interpreter error, cannot interpret expression: $expr")
    end
end
evalExpr(expr::SchemeObject) = evalExpr(expr, Environment([]))

function evalFunction(expr) end
