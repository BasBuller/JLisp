include("src/interpreter.jl")
include("src/parser.jl")
include("src/utils.jl")

codeStr = open(io -> read(io, String), ARGS[1])
env = initTopEnvironment()
for codeLine in split(codeStr, "\n")
    interpretCode(string(codeLine), env)
end
