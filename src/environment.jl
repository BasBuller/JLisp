include("expressions.jl")

NoOp(args...) = nothing

nativeFunctions::Vector{Pair{Symbol, Function}} = [
    # Comparison
    :(=) => ==,
    :> => >,
    :< => <,
    # Maths
    :+ => +,
    :* => *,
    :- => -,
    :quotient => ÷,
    :remainder => %,
    # Type checking in Scheme
    Symbol("null?") => isnothing,
    Symbol("boolean?") => x -> isa(x, Bool),
    Symbol("symbol?") => x -> isa(x, Symbol),
    Symbol("integer?") => x -> isa(x, Int),
    Symbol("char?") => x -> isa(x, Char),
    Symbol("string?") => x -> isa(x, String),
    Symbol("pair?") => x -> isa(x, Pair),
    Symbol("procedure?") => isApplication,
    Symbol("eq?") => NoOp,
    # Casting
    Symbol("char->integer") => NoOp,
    Symbol("integer->char") => NoOp,
    Symbol("number->string") => NoOp,
    Symbol("string->number") => NoOp,
    Symbol("symbol->string") => NoOp,
    Symbol("string->symbol") => NoOp,
    # Basic list ops
    Symbol("cons") => NoOp,
    Symbol("car") => NoOp,
    Symbol("cdr") => NoOp,
    Symbol("set-car!") => NoOp,
    Symbol("set-cdr!") => NoOp,
    Symbol("list") => NoOp,
]

# Constructors and initialisation of environment
struct Environment
    symbolLut::Dict{Symbol, Union{SchemeObject, Function}}
    outerEnvironment::Union{Environment, Nothing}
end
initTopEnvironment() = Environment(Dict(nativeFunctions), nothing)
initSubEnvironment(outerEnv::Environment) = Environment(Dict([]), outerEnv)

# Environment API functions
function getVariable(key::Symbol, env::Environment)
    if haskey(env.symbolLut, key)
        return env.symbolLut[key]
    elseif !isnothing(env.outerEnvironment)
        return getVariable(key, env.outerEnvironment)
    else
        error("Symbol not defined in any namespace")
    end
end

function setVariable(expr::SchemeObject, env::Environment)
    expr = expr.second
    key = expr.first
    value = expr.second.first
    if !haskey(env, key)
        error("Setting undefined variable")
    else
        push!(env.symbolLut, key => value)
        return nothing
    end
end

function defineVariable(expr::SchemeObject, env::Environment)
    expr = expr.second
    key = expr.first
    value = expr.second.first
    push!(env.symbolLut, key => value)
    return nothing
end


# // Insert symbols
# try state.putSymbol("quote");
# try state.putSymbol("define");
# try state.putSymbol("set!");
# try state.putSymbol("ok");
# try state.putSymbol("if");

# // Add constant objects
# try state.putConstant("true", Object{ .boolean = true });
# try state.putConstant("false", Object{ .boolean = false });
# try state.putConstant("emptylist", Object{ .emptyList = true });

# // Add procedures
# try state.addPrimitiveProc("null?", &isNullProc);
# try state.addPrimitiveProc("boolean?", &isBooleanProc);
# try state.addPrimitiveProc("symbol?", &isSymbolProc);
# try state.addPrimitiveProc("integer?", &isIntegerProc);
# try state.addPrimitiveProc("char?", &isCharProc);
# try state.addPrimitiveProc("string?", &isStringProc);
# try state.addPrimitiveProc("pair?", &isPairProc);
# try state.addPrimitiveProc("procedure?", &isProcedureProc);

# // try state.addPrimitiveProc("char->integer", &charToIntegerProc);
# // try state.addPrimitiveProc("integer->char", &integerToCharProc);
# // try state.addPrimitiveProc("number->string", &numberToStringProc);
# // try state.addPrimitiveProc("string->number", &stringToNumberProc);
# // try state.addPrimitiveProc("symbol->string", &symbolToStringProc);
# // try state.addPrimitiveProc("string->symbol", &stringToSymbolProc);

# try state.addPrimitiveProc("+", &addProc);
# try state.addPrimitiveProc("-", &subProc);
# try state.addPrimitiveProc("*", &mulProc);
# try state.addPrimitiveProc("quotient", &quotientProc);
# try state.addPrimitiveProc("remainder", &remainderProc);
# try state.addPrimitiveProc("=", &isNumberEqualProc);
# try state.addPrimitiveProc("<", &isLessThanProc);
# try state.addPrimitiveProc(">", &isGreaterThanProc);

# // try state.addPrimitiveProc("cons", &consProc);
# // try state.addPrimitiveProc("car", &carProc);
# // try state.addPrimitiveProc("cdr", &cdrProc);
# // try state.addPrimitiveProc("set-car!", &setCarProc);
# // try state.addPrimitiveProc("set-cdr!", &setCdrProc);
# // try state.addPrimitiveProc("list", &listProc);

# // try state.addPrimitiveProc("eq?", &isEqProc);
