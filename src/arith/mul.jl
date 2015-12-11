#=
    There are nine general cases for processing a*b
                   b <= 0    b <0< b    b >= 0
       a <=  0    LteLte      LteZer    LteGte
       a <0< a    ZerLte      ZerZer    ZerGte
       a >=  0    GteLte      GteZer    GteGte
=#

function (*){S<:Sculpt,W<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Flex{W,Q,C})
    z = zero(C)
    if     a.hi <= z
       if     b.hi <= z
           mulLteLte(a,b)
       elseif b.lo >= z
           mulLteGte(a,b)
       else   # b straddles 0
           mulLteZer(a,b)
       end
    elseif a.lo >= z
       if     b.hi <= z
           mulGteLte(a,b)
       elseif b.lo >= z
           mulGteGte(a,b)
       else   # b straddles 0
           mulGteZer(a,b)
       end
    else   # a straddles 0
       if     b.hi <= z
           mulZerLte(a,b)
       elseif b.lo >= z
           mulZerGte(a,b)
       else   # b straddles 0
           mulZerZer(a,b)
       end
    end
end

for (fn,loa,lob,hia,hib) in [ (:mulLteLte, :(a.hi), :(b.hi), :(a.lo), :(b.lo)),
                              (:mulLteGte, :(a.lo), :(b.hi), :(a.hi), :(b.lo)),
                              (:mulLteZer, :(a.lo), :(b.hi), :(a.lo), :(b.lo)),
                              (:mulGteLte, :(a.hi), :(b.lo), :(a.lo), :(b.hi)),
                              (:mulGteGte, :(a.lo), :(b.lo), :(a.hi), :(b.hi)),
                              (:mulGteZer, :(a.hi), :(b.lo), :(a.hi), :(b.hi)),
                              (:mulZerLte, :(a.hi), :(b.lo), :(a.lo), :(b.lo)),
                              (:mulZerGte, :(a.lo), :(b.hi), :(a.hi), :(b.hi)),
                            ]
  @eval begin
    function ($fn){S<:Sculpt,W<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Flex{W,Q,C})
        aLoIsOpen, aHiIsOpen = boundries(S)
        bLoIsOpen, bHiIsOpen = boundries(W)
        sculpting = boundries( (aLoIsOpen|bLoIsOpen), (aHiIsOpen|bHiIsOpen) )

        lo = (*)(($loa), ($lob), RoundDown)
        hi = (*)(($hia), ($hib), RoundUp)

        Flex{sculpting,Q,C}(lo, hi)
    end
  end
end


(*){S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::C) = (*)(a, Flex{S,Q,C}(b))
(*){S<:Sculpt,Q<:Qualia,C<:Clay}(a::C, b::Flex{S,Q,C}) = (*)(Flex{S,Q,C}(a), b)

(*){S<:Sculpt,Q<:Qualia,C<:Clay}(a::Bool, b::Flex{S,Q,C}) = a ? b : Flex{S,Q,C}(0.0) # quash ambig notice
(*){S<:Sculpt,Q<:Qualia,C<:Clay,T<:Real}(a::Flex{S,Q,C}, b::T) = (*)(a, Flex{S,Q,C}(convert(C,b)))
(*){S<:Sculpt,Q<:Qualia,C<:Clay,T<:Real}(a::T, b::Flex{S,Q,C}) = (*)(Flex{S,Q,C}(convert(C,a)), b)

(*){S<:Sculpt,T<:Sculpt,Q<:Qualia,R<:Qualia,C<:Clay,D<:Clay}(a::Flex{S,Q,C}, b::Flex{T,R,D} = (*)(promote(a,b)...)
