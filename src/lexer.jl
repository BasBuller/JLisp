@enum SToken begin
    SBool
    SNumber
    SIdentifier
    SString
    SLeftParen
    SRightParen
    SComment
    SQuote
end
function stringToSToken(str::String)
    symb = Symbol(str)
    for val in instances(SToken)
        if symb == Symbol(val)
            return val
        end
    end
    error("Invalid SToken value provided as string")
end

struct Token
    token_type::SToken
    offset::UInt
    val::String
end

initial_identifier_regex = "([a-zA-Z]|[!\$%&*.:<=>?^_~])"
subsequent_identifier_regex = "($initial_identifier_regex|[0-9]|[+-.@])"
peculiar_identifier_regex = "([+\\-.]|\\.\\.\\.)"
identifier_regex = "$initial_identifier_regex$subsequent_identifier_regex*|$peculiar_identifier_regex"
TOKEN_STRINGS = [
    "?<SBool>#[tf]",                       
    "?<SNumber>[0-9]+",                    
    "?<SIdentifier>$identifier_regex",     
    "?<SString>\".*\"",                    
    "?<SLeftParen>\\(",                    
    "?<SRightParen>\\)",                   
    "?<SComment>;[^\\n]*",                 
    "?<SQuote>\\'",
]

mutable struct Lexer
    const buffer::String
    offset::UInt
    const regex::Regex
    const skipWhitespace::Bool

    function Lexer(code_string)
        token_strings = ["($str)" for str in TOKEN_STRINGS]
        re_pattern = Regex(join(token_strings, "|"))
        new(code_string, UInt(1), re_pattern, true)
    end
end

function getToken(lexer::Lexer)
    if lexer.offset > length(lexer.buffer)
        return nothing
    else
        if lexer.skipWhitespace
            matched_pattern = match(r"\S", lexer.buffer, lexer.offset)
            if !isnothing(matched_pattern)
                setfield!(lexer, :offset, UInt(matched_pattern.offset))
            else
                return nothing
            end
        end

        matched_pattern = match(lexer.regex, lexer.buffer, lexer.offset)
        if !isnothing(matched_pattern)
            for key in keys(matched_pattern)
                if !isnothing(matched_pattern[key])
                    token = Token(stringToSToken(key), matched_pattern.offset, matched_pattern.match)
                    setfield!(lexer, :offset, UInt(matched_pattern.offset + length(matched_pattern.match)))
                    return token
                end
            end
        end

        error("Failed during lexing")
    end
end
