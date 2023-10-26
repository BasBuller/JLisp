module JLisp

greet() = print("Hello World!")

end # module JLisp

include("parser.jl")
include("interpreter.jl")

Parser("'(1 2 3)") |> parseExpr |> evalExpr |> println
Parser("(set! a 2)") |> parseExpr |> evalExpr |> println
