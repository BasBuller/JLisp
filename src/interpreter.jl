include("environment.jl")
include("parser.jl")
include("utils.jl")

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

function formatExpr(proc::Lambda)
    args = formatExpr(proc.args)
    body = formatExpr(proc.body)
    return "(lambda $args $body)"
end

function evalExpr(expr::SchemeObject, env::Environment)
    if isSelfEvaluating(expr)
        return expr
    elseif isVariable(expr)
        return getVariable(expr, env)
    elseif isQuoted(expr)
        return expr.second
    elseif isSetVariable(expr)
        key = expr.second.first
        value = evalExpr(expr.second.second.first, env)
        return setVariable(key, value, env)
    elseif isDefinition(expr)
        key = expr.second.first
        value = evalExpr(expr.second.second.first, env)
        return defineVariable(key, value, env)
    elseif isIf(expr)
        bool = evalExpr(ifPredicate(expr), env)
        return bool ? ifConsequent(expr) : ifAlternative(expr)
    elseif isCond(expr)
        return evalExpr(convertCondToIfStatements(expr), env)
    elseif isLet(expr)
        error("UNIMPLEMENTED: let construct")
    elseif isLambda(expr)
        return Lambda(expr, env)
    elseif isBegin(expr)
        error("UNIMPLEMENTED: begin construct")
    elseif isApplication(expr)
        return evalFunction(expr, env)
    else
        error("Interpreter error, cannot interpret expression: $expr")
    end
end

function evalFunction(expr::SchemeObject, env::Environment)
    func = evalExpr(expr.first, env)
    args = mapList(expr.second, x -> evalExpr(x, env)) |> toArray
    
    if typeof(func) == Lambda
        env = initSubEnvironment(func.env)
        identifiers = toArray(func.args)
        for (identifier, value) in zip(identifiers, args)
            env.symbolLut[identifier] = value
        end
        return evalExpr(func.body, env)
    elseif typeof(func) <: Function
        env = initSubEnvironment(env)
        return func(args...)
    else
        error("Function evaluation failed")
    end
end
