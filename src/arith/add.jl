for T in (:CLCL, :OPOP)
   @eval begin
       function (+){Q<:Qualia,C<:Clay}(a::Flex{$T,Q,C}, b::Flex{$T,Q,C})
           lo = (+)(a.lo, b.lo, RoundDown)
           hi = (+)(a.hi, b.hi, RoundUp)
           Flex{$T,Q,C}(lo,hi)
       end
   end       
end

function (+){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C})
    aLoIsOpen, aHiIsOpen = boundries(S)
    bLoIsOpen, bHiIsOpen = boundries(T)
    sculpting = boundries(aLoIsOpen|bLoIsOpen, aHiIsOpen|bHiIsOpen)
    
    lo = (+)(a.lo, b.lo, RoundDown)
    hi = (+)(a.hi, b.hi, RoundUp)
       
    Flex{sculpting, Q, C}(lo,hi)
end

(+){S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::C) = (+)(a, Flex{S,Q,C}(b))
(+){S<:Sculpt,Q<:Qualia,C<:Clay}(a::C, b::Flex{S,Q,C}) = (+)(Flex{S,Q,C}(a), b)

(+){S<:Sculpt,Q<:Qualia,C<:Clay,T<:Real}(a::Flex{S,Q,C}, b::T) = (+)(a, Flex{S,Q,C}(convert(C,b)))
(+){S<:Sculpt,Q<:Qualia,C<:Clay,T<:Real}(a::T, b::Flex{S,Q,C}) = (+)(Flex{S,Q,C}(convert(C,a)), b)

(+){S<:Sculpt,T<:Sculpt,Q<:Qualia,R<:Qualia,C<:Clay,D<:Clay}(a::Flex{S,Q,C}, b::Flex{T,R,D}) = (+)(promote(a,b)...)
