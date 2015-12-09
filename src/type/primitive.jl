
sculpt{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = S
clay{S<:Sculpt, C<:Clay}(x::Flex{S,C})   = C
value{S<:Sculpt, C<:Clay}(x::Flex{S,C})  = (lo,hi)

# each boundry is closed(false) or Open (true)
# get boundries from Sculpt
boundries(::Type{ClCl}) = (false,false)
boundries(::Type{ClOp}) = (false,true)
boundries(::Type{OpCl}) = (true,false)
boundries(::Type{OpOp}) = (true,true)
# get Sculpt from boundries
boundries{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = boundries(S)
# get Sculpt from boundries
const Boundries = [ClCl, OpCl, ClOp, OpOp]
boundries{B<:Bool}(lo::B,hi::B) = Boundries[ one(Int8)+reinterpret(Int8,lo)+(reinterpret(Int8,hi)<<1) ]

# select type corresponding to negation of type given
@inline negate(::Type{ClCl}) = ClCl
@inline negate(::Type{ClOp}) = OpCl
@inline negate(::Type{OpCl}) = ClOp
@inline negate(::Type{OpOp}) = OpOp

#=
    Closed bounds are reached but Not Exceeded.
    Open bounds are approached but Not Reached.
    
    closed(Flex)   gives the ClCl inclusion of Flex
    opened(Flex) gives the OpOp inclusion of Flex
=#

closed{S<:Sculpt,C<:Clay}(x::Flex{S,C}) = ClCl(x.lo, x.hi)

opened{C<:Clay}(x::Flex{ClCl,C}) = OpOp(prevFloat(x.lo), nextFloat(x.hi))
opened{C<:Clay}(x::Flex{ClOp,C}) = OpOp(prevFloat(x.lo), x.hi)
opened{C<:Clay}(x::Flex{OpCl,C}) = OpOp(x.lo, nextFloat(x.hi))
opened{C<:Clay}(x::Flex{OpOp,C}) = x
