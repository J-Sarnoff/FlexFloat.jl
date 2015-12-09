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

@inline Flex{S<:Sculpt, C<:Clay}(::Type{S}, lo::C, hi::C) = Flex{S,C}(lo,hi)
@inline Flex{S<:Sculpt, C<:Clay}(::Type{S}, x::C) = Flex{S,C}(x,x)
@inline function FlexLoHi{S<:Sculpt, C<:Clay}(::Type{S}, lo::C, hi::C)
    lo,hi = minmax(lo,hi)
    Flex{S,C}(lo,hi)
end

ClCl{C<:Clay}(lo::C,hi::C) = Flex(ClCl, lo, hi)
ClOp{C<:Clay}(lo::C,hi::C) = Flex(ClOp, lo, hi)
OpCl{C<:Clay}(lo::C,hi::C) = Flex(OpCl, lo, hi)
OpOp{C<:Clay}(lo::C,hi::C) = Flex(OpOp, lo, hi)

ClCl{C<:Clay}(x::C) = Flex(ClCl, x)
ClOp{C<:Clay}(x::C) = Flex(ClOp, x)
OpCl{C<:Clay}(x::C) = Flex(OpCl, x)
OpOp{C<:Clay}(x::C) = Flex(OpOp, x)

# CC,OC,CO,OO are lo<=hi enforcing versions of ClCl,ClOp,OpCl,OpOp
CC{C<:Clay}(x::C) = Flex(ClCl, x)
CO{C<:Clay}(x::C) = Flex(ClOp, x)
OC{C<:Clay}(x::C) = Flex(OpCl, x)
OO{C<:Clay}(x::C) = Flex(OpOp, x)

CC{C<:Clay}(lo::C,hi::C) = FlexLoHi(ClCl, lo::C, hi::C)
function CO{C<:Clay}(lo::C,hi::C) 
   if lo>hi
      Flex(OpCl, hi, lo)
   else
      Flex(ClOp, hi, lo)
   end
end   
function OC{C<:Clay}(lo::C,hi::C) 
   if lo>hi
      Flex(ClOp, hi, lo)
   else
      Flex(OpCl, hi, lo)
   end
end   
OO{C<:Clay}(lo::C,hi::C) = FlexLoHi(OpOp, lo::C, hi::C)

sculpt{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = S
clay{S<:Sculpt, C<:Clay}(x::Flex{S,C})   = C
value{S<:Sculpt, C<:Clay}(x::Flex{S,C})  = (lo,hi)

# each boundry is closed(false) or Open (true)
boundries{C<:Clay}(x::Flex{ClCl,C}) = (false,false)
boundries{C<:Clay}(x::Flex{ClOp,C}) = (false,true)
boundries{C<:Clay}(x::Flex{OpCl,C}) = (true,false)
boundries{C<:Clay}(x::Flex{OpOp,C}) = (true,true)

const Boundries = [ClCl, OpCl, ClOp, OpOp]
boundries{B<:Bool}(lo::B,hi::B) = Boundries[ 1+lo+(hi<<1) ]
