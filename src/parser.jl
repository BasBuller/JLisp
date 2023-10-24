abstract type SchemeObject end
struct SNumber{T<:Number} <: SchemeObject
    value::T
end
struct SString <: SchemeObject
    value::String
end
struct SChar <: SchemeObject
    value::Char
end
struct SBool <: SchemeObject
    value::Bool
end
struct SSymbol <: SchemeObject
    value::Symbol
end
struct Pair{V<:SchemeObject, W<:SchemeObject} <: SchemeObject
    car::V
    cdr::W
end
