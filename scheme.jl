include("src/interpreter.jl")

function interpret(codeString::String)
    parser = Parser(codeString)
    env = initTopEnvironment()

    expr = parseExpr(parser)
    while !isnothing(expr)
        evalExpr(expr, env)
        expr = parseExpr(parser)
    end
end

codeString = open(io -> read(io, String), ARGS[1])
interpret(codeString)
