include("lexer.jl")

SchemeObject = Union{Number, String, Char, Bool, Symbol, Pair}

struct Parser
    currentToken
    lexer::Lexer
    
    function Parser(code_string::String)
        lexer = Lexer(code_string)
        return new(nothing, lexer)
    end
end
getToken(parser::Parser) = getToken(parser.lexer)

function nextToken(parser::Parser)
    token = getToken(parser)
    while !isnothing(token) & (token.token_type == SComment)
        token = getToken(parser)
    end
    return token
end
