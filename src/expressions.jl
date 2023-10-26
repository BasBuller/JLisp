SchemeObject = Union{Number, String, Bool, Symbol, Pair}

isTaggedList(expr::SchemeObject, tag::Symbol) = isa(expr, Pair) & (expr.first == tag)

isSelfEvaluating(expr::SchemeObject) = isa(expr, Number) | isa(expr, String) | isa(expr, Bool)
isVariable(expr::SchemeObject) = isa(expr, Symbol)
isQuoted(expr::SchemeObject) = isTaggedList(expr, :quote)
isSetVariable(expr::SchemeObject) = isTaggedList(expr, :set!)
isDefinition(expr::SchemeObject) = isTaggedList(expr, :define)
isIf(expr::SchemeObject) = isTaggedList(expr, :if)
isCond(expr::SchemeObject) = isTaggedList(expr, :cond)
isLet(expr::SchemeObject) = isTaggedList(expr, :let)
isBegin(expr::SchemeObject) = isTaggedList(expr, :let)
isApplication(expr::SchemeObject) = isa(expr, Pair)

ifPredicate(expr::Pair) = expr.second.first
ifConsequent(expr::Pair) = expr.second.second.first
ifAlternative(expr::Pair) = expr.second.second.second.first
