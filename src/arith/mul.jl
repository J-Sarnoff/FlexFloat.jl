#=
    There are nine general cases for processing a*b
                   b <= 0    b <0< b    b >= 0
       a <=  0    LteLte      LteZer    LteGte
       a <0< a    ZerLte      ZerZer    ZerGte
       a >=  0    GteLte      GteZer    GteGte
=#

function (*){S<:Sculpt,W<:Sculpt,C<:Clay}(a::Flex{S,C}, b::Flex{W,C})
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
    function ($fn){S<:Sculpt,W<:Sculpt,C<:Clay}(a::Flex{S,C}, b::Flex{W,C})
        aLoIsOpen, aHiIsOpen = boundries(S)
        bLoIsOpen, bHiIsOpen = boundries(W)
        sculpting = boundries( (aLoIsOpen|bLoIsOpen), (aHiIsOpen|bHiIsOpen) )

        lo = (*)(($loa), ($lob), RoundDown)
        hi = (*)(($hia), ($hib), RoundUp)

        Flex{sculpting,C}(lo, hi)
    end
  end
end


(*){S<:Sculpt,C<:Clay}(a::Flex{S,C}, b::C) = (*)(a, Flex{S,C}(b))
(*){S<:Sculpt,C<:Clay}(a::C, b::Flex{S,C}) = (*)(Flex{S,C}(a), b)

(*){S<:Sculpt,C<:Clay,T<:Real}(a::Flex{S,C}, b::T) = (*)(a, Flex{S,C}(convert(C,b)))
(*){S<:Sculpt,C<:Clay,T<:Real}(a::T, b::Flex{S,C}) = (*)(Flex{S,C}(convert(C,a)), b)
