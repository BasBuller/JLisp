struct LexerException <: Exception end

@enum SToken begin
    SBool=1
    SNumber
    SString
    SLeftParen
    SRightParen
end
    # SChar
    # SSymbol

struct Token
    token_type::SToken
    offset::UInt
    val::String
end

TOKEN_STRINGS = [
    "(#[tf])",          # SBool
    "([0-9]+)",         # SNumber
    "(\".*\")",         # SString
    "(\\()",            # SLeftParen
    "(\\))",            # SRightParen
]

mutable struct Lexer
    const buffer::String
    offset::UInt
    const regex::Regex
    const skipWhitespace::Bool

    function Lexer(code_string)
        re_pattern = Regex(join(TOKEN_STRINGS, "|"))
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
                    token = Token(SToken(key), matched_pattern.offset, matched_pattern.match)
                    setfield!(lexer, :offset, UInt(matched_pattern.offset + length(matched_pattern.match)))
                    return token
                end
            end
        end

        error("Failed during lexing")
    end
end

lexer = Lexer("(#f")
getToken(lexer) |> println
getToken(lexer) |> println
