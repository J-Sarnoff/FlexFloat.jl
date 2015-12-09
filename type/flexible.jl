#=  the Type realization underlying all FlexFloat computation  =#

typealias Clay AbstractFloat # was Union{Float64,Float32}, other types can be added

abstract EnhancedFloat <: Real

#=
          Sculpts are as intervals,
          bounded about lo and hi, covering amidst lo and hi.
            Each boundry either is Closed(Cl) or it is Open(Op).
            e.g. ClOp(lo,hi) has a closed lower bound, and a open upper bound.
=#
abstract Sculpt <: EnhancedFloat

type ClCl <: Sculpt end
type ClOp <: Sculpt end
type OpCl <: Sculpt end
type ClCl <: Sculpt end

abstract Supple{S,C} <: EnhancedFloat  # EnhancedFloat pulls in Real
         #        C parameterizes the internal arithmetic type at work
         #      S paramterizes boundedness as OpOp, ClOp, OpCl or ClCl

immutable Flex{S<:Sculpt, C<:Clay} <: Supple{S,C}
    lo::C
    hi::C
end

@inline function Flex{S<:Sculpt, C<:Clay}(::Type{S}, lo::C, hi::C)
    lo,hi = minmax(lo,hi)
    Flex{S,C}(lo,hi)
end
@inline Flex{S<:Sculpt, C<:Clay}(::Type{S}, x::C) = Flex{S,C}(x,x)

ClCl{C<:Clay}(lo::C,hi::C) = Flex(::Type{ClCl}, lo::C, hi::C)
ClOp{C<:Clay}(lo::C,hi::C) = Flex(::Type{ClOp}, lo::C, hi::C)
OpCl{C<:Clay}(lo::C,hi::C) = Flex(::Type{OpCl}, lo::C, hi::C)
OpOp{C<:Clay}(lo::C,hi::C) = Flex(::Type{OpOp}, lo::C, hi::C)

