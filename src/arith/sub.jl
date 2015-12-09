@inline function (-){S<:Sculpt,C<:Clay}(a::Flex{S,C})
   Flex{negate(S), C}(-a.hi, -a.lo)
end

