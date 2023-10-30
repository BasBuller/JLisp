include("src/interpreter.jl")

codeStr = open(io -> read(io, String), ARGS[1])
env = initTopEnvironment()
for codeLine in split(codeStr, "\n")
    interpretCode(string(codeLine), env)
end
