include("expressions.jl")

# TODO: Implement set-car! & set-cdr!
lazyUnimplementedThrow(msg::String) = () -> error("UNIMPLEMENTED: " * msg)
nativeFunctions::Vector{Pair{Symbol, Function}} = [
    # Maths
    :(=) => ==,
    :> => >,
    :< => <,
    :+ => +,
    :* => *,
    :- => -,
    :quotient => ÷,
    :remainder => %,
    # Type checking in Scheme
    Symbol("null?") => isnothing,
    Symbol("boolean?") => x -> isa(x, Bool),
    Symbol("symbol?") => x -> isa(x, Symbol),
    Symbol("integer?") => x -> isa(x, Int),
    Symbol("char?") => x -> isa(x, Char),
    Symbol("string?") => x -> isa(x, String),
    Symbol("pair?") => x -> isa(x, Pair),
    Symbol("procedure?") => x -> isa(x, Pair),
    Symbol("eq?") => ===,
    # Casting
    Symbol("char->integer") => lazyUnimplementedThrow("'char->integer' not yet implemented, chars not supported yet."),
    Symbol("integer->char") => lazyUnimplementedThrow("'integer->char' not yet implemented, chars not supported yet."),
    Symbol("number->string") => string,
    Symbol("string->number") => x -> parse(Int, x),
    Symbol("symbol->string") => string,
    Symbol("string->symbol") => x -> Symbol(x),
    # Basic list ops
    Symbol("cons") => (x, y) -> Pair(x, y),
    Symbol("car") => x -> x.first,
    Symbol("cdr") => x -> x.second,
    Symbol("set-car!") => lazyUnimplementedThrow("'set-car!' not yet implemented, Julia Pairs are immutable so need to refactor."),
    Symbol("set-cdr!") => lazyUnimplementedThrow("'set-cdr!' not yet implemented, Julia Pairs are immutable so need to refactor."),
    Symbol("list") => x -> x.second,
]

# Constructors and initialisation of environment
const SchemeState = Union{SchemeObject, Function}
struct Environment
    symbolLut::Dict{Symbol, SchemeState}
    outerEnvironment::Union{Environment, Nothing}
end
initTopEnvironment() = Environment(Dict(nativeFunctions), nothing)
initSubEnvironment(outerEnv::Environment) = Environment(Dict([]), outerEnv)

# Environment API functions
function getVariable(key::Symbol, env::Environment)
    if haskey(env.symbolLut, key)
        return env.symbolLut[key]
    elseif !isnothing(env.outerEnvironment)
        return getVariable(key, env.outerEnvironment)
    else
        error("Symbol not defined in any namespace")
    end
end

function setVariable(key::Symbol, value::SchemeState, env::Environment)
    if !haskey(env.symbolLut, key)
        error("Setting undefined variable")
    else
        push!(env.symbolLut, key => value)
        return nothing
    end
end

function defineVariable(key::Symbol, value::SchemeState, env::Environment)
    push!(env.symbolLut, key => value)
    return nothing
end
