#=   FlexFloat Typeology    =#

abstract Art


# C is Clay  , the base or substructural concrete type 
# Q is Qualia, the manner of enhancement as abstract type
# S is Sculpt, the art unfolding, qualia as dynamism guiding dispatch
#
abstract EnhancedFloat{C, S, Q} <: Real

#=
   These Sculpts are as intervals,
      bounded about lo and hi, covering amidst lo and hi.
      
   Each boundry either is Closed(Cl) or it is Open(Op).
   
      A Closed boundry does include its bounding value.
        A Closed boundry is considered complete at its bounding value.
      An Open boundry does not include its bounding value.
        An Open boundry is considered complete before its bounding value
        (above with an open lower bound, below with an open upper bound).
       
      Open upper bounds are treated as inclusively reaching from
         prevfloat(bounding value) outward, approching arbitrarily
         close to its bounding value.  Open bounds are given logic
         to support participation with the coinciding real value
         span [nextfloat(bounding value) for open lower bounds].
=#

abstract Sculpt <: Art

                         #   explicatively        traditionally
                         #
abstract CLCL <: Sculpt  #    [.......]             [.....]
abstract OPOP <: Sculpt  #     ).....(              (.....)
abstract OPCL <: Sculpt  #     )......]             (.....]
abstract CLOP <: Sculpt  #    [......(              [.....)

#=
   These Qualia are as bistable states,
      each boundry either is exact or it is inexact.
      If both boundries are exact, the interval is exact.
      If either boundry is inexact, the interval is inexact.
=#
abstract Qualia  <: Art

abstract EXACT   <: Qualia
abstract INEXACT <: Qualia

abstract Supple{S<:Sculpt, Q<:Qualia}

#= Clay is extensible with Union{} =#    typealias Clay AbstractFloat

immutable Flex{S, Q, C<:Clay} <: Supple{S, Q}
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

