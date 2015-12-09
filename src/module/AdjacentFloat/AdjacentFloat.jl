module AdjacentFloat

export prevFloat, nextFloat, prevprevFloat, nextnextFloat,
       nextAwayFromZero, nextnextAwayFromZero,
       nextNearerToZero, nextnextNearerToZero

# exact for |x| > 8.900295434028806e-308
nextNearerToZero(x::Float64)   = (x-1.1102230246251568e-16*x)-5.0e-324  # do not simplify
nextAwayFromZero(x::Float64)   = (x+1.1102230246251568e-16*x)+5.0e-324  # do not simplify
nextnextNearerToZero(x::Float64)   = nextNearerToZero(nextNearerToZero(x)) # changing the multiplier does not work  
nextnextAwayFromZero(x::Float64)   = nextAwayFromZero(nextAwayFromZero(x)) 

# exact for |x| > 4.814825f-35
nextNearerToZero(x::Float32)   = (x-5.960465f-8*x)-1.435f-42 # do not simplify
nextAwayFromZero(x::Float32)   = (x+5.960465f-8*x)+1.435f-42 # do not simplify
nextnextNearerToZero(x::Float64)   = nextNearerToZero(nextNearerToZero(x)) # changing the multiplier does not work  
nextnextAwayFromZero(x::Float64)   = nextAwayFromZero(nextAwayFromZero(x)) 

# the multiplicative formulation for Float16 is exact for |x| > Float16(0.25)
# which is quite coarse, we do not use that here
nextNearerToZero(x::Float16) = (x < 0) ? nextfloat(x) : prevfloat(x)
nextAwayFromZero(x::Float16) = (x < 0) ? prevfloat(x) : nextfloat(x)
nextFloat(x::Float16) = nextfloat(x)
prevFloat(x::Float16) = prevfloat(x)

nextFloat{T<:AbstractFloat}(x::T) = signbit(x) ? nextNearerToZero(x) : nextAwayFromZero(x)
prevFloat{T<:AbstractFloat}(x::T) = signbit(x) ? nextAwayFromZero(x) : nextNearerToZero(x)

nextnextFloat{T<:AbstractFloat}(x::T) = signbit(x) ? nextnextNearerToZero(x) : nextnextAwayFromZero(x)
prevprevFloat{T<:AbstractFloat}(x::T) = signbit(x) ? nextnextAwayFromZero(x) : nextnextNearerToZero(x)

end # module
