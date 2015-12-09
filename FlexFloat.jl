module FlexFloat

# provide these modular services

include("module/AdjacentFloat/AdjacentFloat.jl")
using .AdjacentFloat
include("module/RoundFast/RoundFast.jl")
using .RoundFast

include("type/flexible.jl")
include("type/primitive.jl")

end # module
