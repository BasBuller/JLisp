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
function formatExpr(proc::Lambda)
    args = formatExpr(proc.args)
    body = formatExpr(proc.body)
    return "(lambda $args $body)"
end
formatExpr(expr) = expr

function makeList(args...)
    if length(args) == 1
        return Pair(args[1], nothing)
    else
        return Pair(args[1], makeList(args[2:end]...))
    end
end

function toArray(list::Pair)
    arr = []
    while !isnothing(list)
        push!(arr, list.first)
        list = list.second
    end
    return arr
end

function mapList(list::Pair, func::Function)
    first = func(list.first)
    second = mapList(list.second, func)
    return Pair(first, second)
end
mapList(_::Nothing, _::Function) = nothing

getUnitListValue(expr::Pair) = isnothing(expr.second) ? expr.first : expr

function parsePrint(expr)
    parsedExpr = Parser(expr) |> parseExpr
    println(expr)
    println(formatExpr(parsedExpr))
    println(parsedExpr)
    return nothing
end

function evalPrint(expr)
    parsedExpr = Parser(expr) |> parseExpr
    res = evalExpr(parsedExpr, env)
    println(expr)
    println(formatExpr(res))
    println(res)
    return nothing
end
