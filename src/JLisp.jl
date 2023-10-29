module JLisp

greet() = print("Hello World!")

end # module JLisp

include("parser.jl")
include("interpreter.jl")
include("utils.jl")

# env = initTopEnvironment()
env = Environment([])
evalExpr(Parser("'(1 2 3)") |> parseExpr, env) |> formatExpr |> println
println(env, "\n")
evalExpr(Parser("(if #t correct incorrect)") |> parseExpr, env) |> formatExpr |> println
println(env, "\n")
evalExpr(Parser("(if #f incorrect correct)") |> parseExpr, env) |> formatExpr |> println
println(env, "\n")
evalExpr(Parser("(define a 2)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(define b 4)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(set! a 3)") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("a") |> parseExpr, env) |> formatExpr |> println
println(env, "\n")
evalExpr(Parser("(lambda (a) (+ 1 a))") |> parseExpr, env) |> println
println(env, "\n")
evalExpr(Parser("(cond ((x > 0) 1) ((x == 0) 0) ((x < 0) -1) (else -999))") |> parseExpr, env) |> formatExpr |> println
println(env, "\n")
