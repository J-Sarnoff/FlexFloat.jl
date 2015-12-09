
sculpt{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = S
clay{S<:Sculpt, C<:Clay}(x::Flex{S,C})   = C
values{S<:Sculpt, C<:Clay}(x::Flex{S,C})  = (x.lo,x.hi)

# each boundry is closed(false) or Open (true)
# get boundries from Sculpt
boundries(::Type{CLCL}) = (false,false)
boundries(::Type{CLOP}) = (false,true)
boundries(::Type{OPCL}) = (true,false)
boundries(::Type{OPOP}) = (true,true)
# get Sculpt from boundries
boundries{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = boundries(S)
# get Sculpt from boundries
const Boundries = [CLCL, OPCL, CLOP, OPOP]
boundries{B<:Bool}(lo::B,hi::B) = Boundries[ one(Int8)+reinterpret(Int8,lo)+(reinterpret(Int8,hi)<<1) ]

# select type corresponding to negation of type given
@inline negate(::Type{CLCL}) = CLCL
@inline negate(::Type{CLOP}) = OPCL
@inline negate(::Type{OPCL}) = CLOP
@inline negate(::Type{OPOP}) = OPOP

#=
    Closed bounds are reached but Not Exceeded.
    Open bounds are approached but Not Reached.
    
    closed(Flex)   gives the ClCl inclusion of Flex
    opened(Flex) gives the OpOp inclusion of Flex
=#

closed{S<:Sculpt,C<:Clay}(x::Flex{S,C}) = ClCl(x.lo, x.hi)

opened{C<:Clay}(x::Flex{CLCL,C}) = OpOp(prevFloat(x.lo), nextFloat(x.hi))
opened{C<:Clay}(x::Flex{CLOP,C}) = OpOp(prevFloat(x.lo), x.hi)
opened{C<:Clay}(x::Flex{OPCL,C}) = OpOp(x.lo, nextFloat(x.hi))
opened{C<:Clay}(x::Flex{OPOP,C}) = x
