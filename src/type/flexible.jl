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

type CLCL <: Sculpt end
type CLOP <: Sculpt end
type OPCL <: Sculpt end
type OPOP <: Sculpt end

abstract Supple{S,C} <: EnhancedFloat  # EnhancedFloat pulls in Real
         #        C parameterizes the internal arithmetic type at work
         #      S paramterizes boundedness as OpOp, ClOp, OpCl or ClCl

immutable Flex{S<:Sculpt, C<:Clay} <: Supple{S,C}
    lo::C
    hi::C
end

@inline Flex{S<:Sculpt, C<:Clay}(::Type{S}, lo::C, hi::C) = Flex{S,C}(lo,hi)
@inline Flex{S<:Sculpt, C<:Clay}(::Type{S}, x::C) = Flex{S,C}(x,x)
@inline function FlexLoHi{S<:Sculpt, C<:Clay}(::Type{S}, lo::C, hi::C)
    lo,hi = minmax(lo,hi)
    Flex{S,C}(lo,hi)
end

ClCl{C<:Clay}(lo::C,hi::C) = Flex(CLCL, lo, hi)
ClOp{C<:Clay}(lo::C,hi::C) = Flex(CLOP, lo, hi)
OpCl{C<:Clay}(lo::C,hi::C) = Flex(OPCL, lo, hi)
OpOp{C<:Clay}(lo::C,hi::C) = Flex(OPOP, lo, hi)

ClCl{C<:Clay}(x::C) = Flex(CLCL, x)
ClOp{C<:Clay}(x::C) = Flex(CLOP, x)
OpCl{C<:Clay}(x::C) = Flex(OPCL, x)
OpOp{C<:Clay}(x::C) = Flex(OPOP, x)

# CC,OC,CO,OO are lo<=hi enforcing versions of ClCl,ClOp,OpCl,OpOp
CC{C<:Clay}(x::C) = Flex(CLCL, x)
CO{C<:Clay}(x::C) = Flex(CLOP, x)
OC{C<:Clay}(x::C) = Flex(OPCL, x)
OO{C<:Clay}(x::C) = Flex(OPOP, x)

CC{C<:Clay}(lo::C,hi::C) = FlexLoHi(CLCL, lo, hi)
function CO{C<:Clay}(lo::C,hi::C) 
   if lo>hi
      Flex(OPCL, hi, lo)
   else
      Flex(CLOP, hi, lo)
   end
end   
function OC{C<:Clay}(lo::C,hi::C) 
   if lo>hi
      Flex(CLOP, hi, lo)
   else
      Flex(OPCL, hi, lo)
   end
end   
OO{C<:Clay}(lo::C,hi::C) = FlexLoHi(OPOP, lo, hi)

