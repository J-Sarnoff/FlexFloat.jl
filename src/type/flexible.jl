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


for (Fn,fn,S) in ((:ClCl,:clcl,:CLCL),(:ClOp,:clop,:CLOP),(:OpCl,:opcl,:OPCL),(:OpOp,:opop,:OPOP))
    @eval begin
        ($Fn){C<:Clay}(fp::C) = Flex{$S,EXACT,C}(fp,fp)
        ($fn){C<:Clay}(fp::C) = Flex{$S,INEXACT,C}(fp,fp)
        function ($Fn){C<:Clay}(lo::C,hi::C)
            lo,hi = minmax(lo,hi)
            Flex{$S,EXACT,C}(lo,hi)
        end
        function ($fn){C<:Clay}(lo::C,hi::C)
            lo,hi = minmax(lo,hi)
            Flex{$S,INEXACT,C}(lo,hi)
        end
        # convert other types to be Clay
                function ($Fn)(fp::Real)
            fq = convert(Float64,fp)
            Flex{$S,EXACT,Float64}(fq,fq)
        end
        function ($fn)(fp::Real)
            fq = convert(Float64,fp)
            Flex{$S,INEXACT,Float64}(fq,fq)
        end
        function ($Fn)(lo::Real,hi::Real)
            low = convert(Float64, lo)
            hig = convert(Float64, hi)
            low,hig = minmax(low,hig)
            Flex{$S,EXACT,Float64}(low,hig)
        end
        function ($fn)(lo::Real,hi::Real)
            low = convert(Float64, lo)
            hig = convert(Float64, hi)
            low,hig = minmax(low,hig)
            Flex{$S,INEXACT,Float64}(low,hig)
        end
    end
end
