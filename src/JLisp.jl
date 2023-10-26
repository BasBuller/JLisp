module JLisp

greet() = print("Hello World!")

end # module JLisp

include("parser.jl")
include("interpreter.jl")

env = Environment([])
evalExpr(Parser("'(1 2 3)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(if #t correct incorrect)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(if #f incorrect correct)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(define a 2)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(set! a 3)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("a") |> parseExpr, env) |> println
println(env, "\n")
# Parser("a") |> parseExpr |> typeof |> println
