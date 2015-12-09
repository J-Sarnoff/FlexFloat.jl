for T in (:CLCL, :OPOP)
   @eval begin
       function (+){C<:Clay}(a::Flex{$T,C}, b::Flex{$T,C})
           lo = (+)(a.lo, b.lo, RoundDown)
           hi = (+)(a.hi, b.hi, RoundUp)
           Flex{$T,C}(lo,hi)
       end
   end       
end

function (+){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C})
    aLoIsOpen, aHiIsOpen = boundries(S)
    bLoIsOpen, bHiIsOpen = boundries(T)
    sculpting = boundries(aLoIsOpen|bLoIsOpen, aHiIsOpen|bHiIsOpen)
    
    lo = (+)(a.lo, b.lo, RoundDown)
    hi = (+)(a.hi, b.hi, RoundUp)
       
    Flex{sculpting, C}(lo,hi)
end

(+){S<:Sculpt,C<:Clay}(a::Flex{S,C}, b::C) = (+)(a, Flex{S,C}(b))
(+){S<:Sculpt,C<:Clay}(a::C, b::Flex{S,C}) = (+)(Flex{S,C}(a), b)

(+){S<:Sculpt,C<:Clay,T<:Union{AbstractFloat,Integer}}(a::Flex{S,C}, b::T) = (+)(a, Flex{S,C}(convert(C,b)))
(+){S<:Sculpt,C<:Clay,T<:Union{AbstractFloat,Integer}}(a::T, b::Flex{S,C}) = (+)(Flex{S,C}(convert(C,a)), b)
