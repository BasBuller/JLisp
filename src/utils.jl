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

function makeList(args...)
    if length(args) == 1
        return Pair(args[1], nothing)
    else
        return Pair(args[1], makeList(args[2:end]...))
    end
end

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