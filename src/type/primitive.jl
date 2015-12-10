
sculpt{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = S
qualia{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = Q
clay{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C})   = C
values{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C})  = (x.lo,x.hi)

# each boundry is closed(false) or Open (true)
# get boundries from Sculpt
boundries(::Type{CLCL}) = (false,false)
boundries(::Type{CLOP}) = (false,true)
boundries(::Type{OPCL}) = (true,false)
boundries(::Type{OPOP}) = (true,true)
# get Sculpt from boundries
boundries{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = boundries(S)
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

closed{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = ClCl(x.lo, x.hi)

opened{Q<:Qualia,C<:Clay}(x::Flex{CLCL,Q,C}) = OpOp{Q,C}(prevFloat(x.lo), nextFloat(x.hi))
opened{Q<:Qualia,C<:Clay}(x::Flex{CLOP,Q,C}) = OpOp(prevFloat(x.lo), x.hi)
opened{Q<:Qualia,C<:Clay}(x::Flex{OPCL,Q,C}) = OpOp(x.lo, nextFloat(x.hi))
opened{Q<:Qualia,C<:Clay}(x::Flex{OPOP,Q,C}) = x

clopened{Q<:Qualia,C<:Clay}(x::Flex{CLCL,Q,C}) = ClOp(x.lo, nextFloat(x.hi))
clopened{Q<:Qualia,C<:Clay}(x::Flex{CLOP,Q,C}) = x
clopened{Q<:Qualia,C<:Clay}(x::Flex{OPCL,Q,C}) = ClOp(x.lo, nextFloat(x.hi))
clopened{Q<:Qualia,C<:Clay}(x::Flex{OPOP,Q,C}) = ClOp(x.lo, x.hi)

opclosed{Q<:Qualia,C<:Clay}(x::Flex{CLCL,Q,C}) = OpCl(prevFloat(x.lo), x.hi)
opclosed{Q<:Qualia,C<:Clay}(x::Flex{CLOP,Q,C}) = OpCl(prevFloat(x.lo), x.hi)
opclosed{Q<:Qualia,C<:Clay}(x::Flex{OPCL,Q,C}) = x
opclosed{Q<:Qualia,C<:Clay}(x::Flex{OPOP,Q,C}) = OpCl(x.lo, x.hi)
