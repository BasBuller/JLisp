include("expressions.jl")

function formatExpr(list::Pair)
    string = "("
    while !isnothing(list.second)
        val = formatExpr(list.first)
        string = string * "$val "
        list = list.second
    end
    val = formatExpr(list.first)
    string = string * "$val)"
    return string
end
formatExpr(expr::SchemeObject) = expr
