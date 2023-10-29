include("expressions.jl")


const Environment = Dict{Symbol, Union{SchemeObject, Function}}

function getVariable(expr::Symbol, env::Environment)
    return env[expr]
end
function setVariable(expr::SchemeObject, env::Environment)
    expr = expr.second
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
    expr = expr.second
    key = expr.first
    value = expr.second.first
    push!(env, key => value)
    return nothing
end

function initTopEnvironment()
    env = Environment([
        :(==) => ==,
        :> => >,
        :< => <,
    ])
    return env
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
