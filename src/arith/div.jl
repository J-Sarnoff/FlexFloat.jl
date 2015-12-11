#=
    There are six general cases for processing a/b (when b excludes 0)
    and six special cases (where the denominator includes 0 as a bound)
    and two exceptional cases (where the denominator is 0 or straddles 0)
                  b <= 0       b >= 0
       a <=  0    LteLte       LteGte
       a <0< a    ZerLte       ZerGte
       a >=  0    GteLte       GteGte
=#


function (/){S<:Sculpt,W<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Flex{W,Q,C})
    z = zero(C)
    if ((b.lo < z) & (b.hi > z))
      divisorContainsZero(a,b)
   elseif a.hi <= z
       if     b.hi <= z
           divLteLte(a,b)
       else # b.lo.fp >= z
           divLteGte(a,b)
       end
   elseif a.lo >= z
       if     b.hi <= z
           divGteLte(a,b)
       else # b.lo >= 0
           divGteGte(a,b)
       end
   else   # a straddles 0
       if     b.hi <= z
           divZerLte(a,b)
       else # b.lo >= 0
           divZerGte(a,b)
       end
   end
end

for (fn,loa,lob,hia,hib) in [ (:divLteLte, :(a.hi), :(b.lo), :(a.lo), :(b.hi)),
                              (:divLteGte, :(a.lo), :(b.lo), :(a.hi), :(b.hi)),
                              (:divGteLte, :(a.hi), :(b.hi), :(a.lo), :(b.lo)),
                              (:divGteGte, :(a.lo), :(b.hi), :(a.hi), :(b.lo)),
                              (:divZerLte, :(a.hi), :(b.hi), :(a.lo), :(b.hi)),
                              (:divZerGte, :(a.lo), :(b.lo), :(a.hi), :(b.lo)),
                            ]
  @eval begin
    function ($fn){S<:Sculpt,W<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Flex{W,Q,C})
        aLoIsOpen, aHiIsOpen = boundries(S)
        bLoIsOpen, bHiIsOpen = boundries(W)
        cType = boundries( (aLoIsOpen|bLoIsOpen), (aHiIsOpen|bHiIsOpen) )

        lo = (/)(($loa), ($lob), RoundDown)
        hi = (/)(($hia), ($hib), RoundUp)

        Flex{cType,Q,C}(lo, hi)
    end
  end
end

function divisorContainsZero{S<:Sculpt,W<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Flex{W,Q,C})
    throw(ErrorException("Divisor contains zero: $(a) / $(b)"))
end

(/){S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::C) = (/)(a, Flex{S,Q,C}(b))
(/){S<:Sculpt,Q<:Qualia,C<:Clay}(a::C, b::Flex{S,Q,C}) = (/)(Flex{S,Q,C}(a), b)

(/){S<:Sculpt,Q<:Qualia,C<:Clay,T<:Real}(a::Flex{S,Q,C}, b::T) = (/)(a, Flex{S,Q,C}(convert(C,b)))
(/){S<:Sculpt,Q<:Qualia,C<:Clay,T<:Real}(a::T, b::Flex{S,Q,C}) = (/)(Flex{S,Q,C}(convert(C,a)), b)

(/){S<:Sculpt,T<:Sculpt,Q<:Qualia,R<:Qualia,C<:Clay,D<:Real}(a::Flex{S,Q,C}, b::Flex{T,R,D) = (/)(promote(a,b)...)
