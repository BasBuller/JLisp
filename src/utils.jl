function formatExpr(list::SPair)
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
formatExpr(expr) = expr

function makeList(args...)
    if length(args) == 1
        return SPair(args[1], nothing)
    else
        return SPair(args[1], makeList(args[2:end]...))
    end
end

function toArray(list::SPair)
    arr = []
    while !isnothing(list)
        push!(arr, list.first)
        list = list.second
    end
    return arr
end

function mapList(list::SPair, func::Function)
    first = func(list.first)
    second = mapList(list.second, func)
    return SPair(first, second)
end
mapList(_::Nothing, _::Function) = nothing

getUnitListValue(expr::SPair) = isnothing(expr.second) ? expr.first : expr

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
