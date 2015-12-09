
sculpt{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = S
clay{S<:Sculpt, C<:Clay}(x::Flex{S,C})   = C
value{S<:Sculpt, C<:Clay}(x::Flex{S,C})  = (lo,hi)

# each boundry is closed(false) or Open (true)
# get boundries from Sculpt
boundries{C<:Clay}(x::Flex{ClCl,C}) = (false,false)
boundries{C<:Clay}(x::Flex{ClOp,C}) = (false,true)
boundries{C<:Clay}(x::Flex{OpCl,C}) = (true,false)
boundries{C<:Clay}(x::Flex{OpOp,C}) = (true,true)
# get Sculpt from boundries
const Boundries = [ClCl, OpCl, ClOp, OpOp]
boundries{B<:Bool}(lo::B,hi::B) = Boundries[ one(Int8)+reinterpret(Int8,lo)+(reinterpret(Int8,hi)<<1) ]

#=
    Closed bounds are reached but Not Exceeded.
    Open bounds are approached but Not Reached.
    
    cover(Flex)   gives the ClCl inclusion of Flex
    uncover(Flex) gives the OpOp inclusion of Flex
=#

cover{S<:Sculpt,C<:Clay}(x::Flex{S,C}) = ClCl(x.lo, x.hi)

uncover{C<:Clay}(x::Flex{ClCl,C}) = OpOp(prevFloat(x.lo), nextFloat(x.hi))
uncover{C<:Clay}(x::Flex{ClOp,C}) = OpOp(prevFloat(x.lo), x.hi)
uncover{C<:Clay}(x::Flex{OpCl,C}) = OpOp(x.lo, nextFloat(x.hi))
uncover{C<:Clay}(x::Flex{OpOp,C}) = x

