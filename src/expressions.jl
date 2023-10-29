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
isLambda(expr::SchemeObject) = isTaggedList(expr, :lambda)
isBegin(expr::SchemeObject) = isTaggedList(expr, :let)
isApplication(expr::SchemeObject) = isa(expr, Pair)

# If utilities
ifPredicate(expr::Pair) = expr.second.first
ifConsequent(expr::Pair) = expr.second.second.first
ifAlternative(expr::Pair) = expr.second.second.second.first

function convertCondToIfStatements_(expr::Pair)
    leadCond = expr.first
    restConds = expr.second
    
    # Deal with else branches
    if restConds.first.first == :else
        elseBranch = restConds.first.second
    else
        elseBranch = convertCondToIfStatements_(restConds)
    end
    
    # Convert lead condition to if else block
    mainBranch = getUnitListValue(leadCond.second)
    elseBranch = getUnitListValue(elseBranch)
    ifElseChain = makeList(:if, leadCond.first, mainBranch, elseBranch)
    
    return ifElseChain
end

"""
Convert a sequence of cond statements into a nested set of if else statements

Example:
(cond (x)
    ((x < 0)  (display "Negative"))
    ((x == 0) (display "Zero))
    ((x > 0)  (display "Positive))
    (else     (display "Should not be reached!))
    
becomes:
(if (x < 0)
    (display "Negative")
    (if (x == 0)
        (display "Zero")
        (if (x > 0)
            (display "Positive")
            (display "Should not be reached))))
"""
convertCondToIfStatements(expr::Pair) = convertCondToIfStatements_(expr.second)  # Remove cond tag
