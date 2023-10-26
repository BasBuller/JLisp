SchemeObject = Union{Number, String, Bool, Symbol, Pair}

isSelfEvaluating(expr::SchemeObject) = isa(expr, Number) | isa(expr, String) | isa(expr, Bool)
isVariable(expr::SchemeObject) = isa(expr, Symbol)
isQuoted(expr::SchemeObject) = isa(expr, Pair) & (expr.first == :quote)
function isAssignment(expr::SchemeObject) end
function isDefinition(expr::SchemeObject) end
function isIf(expr::SchemeObject) end
function isCond(expr::SchemeObject) end
function isLet(expr::SchemeObject) end
function isBegin(expr::SchemeObject) end
function isApplication(expr::SchemeObject) end
