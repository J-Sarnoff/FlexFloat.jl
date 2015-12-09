function (+){C<:Clay}(a::Flex{Cl,C}, b::Flex{Cl,C})
    lo = (+)(a.lo, b.lo, RoundDown)
    hi = (+)(a.hi, b.hi, RoundUp)
    Flex{Cl,C}(lo,hi)
end

function (+){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C})
    aLoIsOpen, aHiIsOpen = boundries(S)
    bLoIsOpen, bHiIsOpen = boundries(T)
    cType = boundries(aLoIsOpen|bLoIsOpen, aHiIsOpen|bHiIsOpen)
    
    lo = (+)(a.lo, b.lo, RoundDown)
    hi = (+)(a.hi, b.hi, RoundUp)

    if (aLoIsOpen & bLoIsOpen)
       lo = prevFloat(lo)
    end
    if (aHiIsOpen & bHiIsOpen)
       hi = nextFloat(hi)
    end
       
    cType(lo,hi)
end
