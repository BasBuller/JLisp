module JLisp

greet() = print("Hello World!")

end # module JLisp

include("parser.jl")
include("interpreter.jl")
include("utils.jl")

env = initTopEnvironment()
evalExpr(Parser("(display '(5 6))") |> parseExpr, env)
evalExpr(Parser("'(1 2 3)") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(if #t correct incorrect)") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(if #f incorrect correct)") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(define a 2)") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(define b 4)") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(set! a 3)") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("a") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(define square (lambda (x) (* x x)))") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("(square 2)") |> parseExpr, env) |> println
evalExpr(Parser("(cond ((> a 0) 1) ((== a 0) 0) ((< a 0) -1) (else -999))") |> parseExpr, env) |> formatExpr |> println
evalExpr(Parser("((lambda (a) (+ 1 a)) 2)") |> parseExpr, env) |>  formatExpr |> println
