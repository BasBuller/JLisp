include("lexer.jl")

struct Parser
    lexer::Lexer
    
    function Parser(code_string::String)
        lexer = Lexer(code_string)
        return new(lexer)
    end
end
getToken(parser::Parser) = getToken(parser.lexer)

function nextToken(parser::Parser)
    token = getToken(parser)
    while !isnothing(token) && (token.token_type == SComment)
        token = getToken(parser)
    end
    return token
end

function parseExpr(parser::Parser)
    curToken = nextToken(parser)
    return !isnothing(curToken) ? parseNode(curToken, parser) : curToken
end

function parseNode(curToken::Token, parser::Parser)
    if curToken.token_type == SLeftParen
        return parseList(parser)
    elseif curToken.token_type == SQuote
        return parseQuote(parser)
    else
        return parseIdentifier(curToken)
    end
end

function parseList(parser::Parser)
    token = nextToken(parser)
    if token.token_type == SRightParen
        return nothing  # Empty list
    else
        car = parseNode(token, parser)  # Want this to start with previously parsed token...
        cdr = parseList(parser)
        return Pair(car, cdr)
    end
end
function parseIdentifier(currentToken::Token)
    if currentToken.token_type == SBool
        return currentToken.val == "#t"
    elseif currentToken.token_type == SNumber
        return Base.parse(Int, currentToken.val)
    elseif currentToken.token_type == SIdentifier
        return Symbol(currentToken.val)
    elseif currentToken.token_type == SString
        return currentToken.val[2:end-1]
    end
end
function parseQuote(parser::Parser)
    cdr = parseExpr(parser)
    return Pair(:quote, cdr)
end

@assert parseExpr(Parser("abc")) == :abc
@assert parseExpr(Parser("#t")) == true
@assert parseExpr(Parser("#f")) == false
@assert parseExpr(Parser("123")) == 123
@assert parseExpr(Parser("\"BaasB is lekker\"")) == "BaasB is lekker"
@assert parseExpr(Parser("(+ 1 2)")) == Pair(:+, Pair(1, Pair(2, nothing)))
@assert parseExpr(Parser("(+ 1 (- 2 3))")) == Pair(:+, Pair(1, Pair(Pair(:-, Pair(2, Pair(3, nothing))), nothing)))
@assert parseExpr(Parser("'1")) == Pair(:quote, 1)
@assert parseExpr(Parser("'(+ 1 2)")) == Pair(:quote, Pair(:+, Pair(1, Pair(2, nothing))))
