module RoundFast

import Base:(+),(-),(*),(/),sqrt
export square

include("../../module/AdjacentFloat/AdjacentFloat.jl")
using .AdjacentFloat

include("eftArith.jl")
include("eftRound.jl")
include("rounding.jl")

end # module
