(==){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo == b.lo) & (a.hi == b.hi))
(!=){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo != b.lo) | (a.hi != b.hi))
(< ){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo <  b.lo) & (a.hi <  b.hi))
(> ){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo >  b.lo) & (a.hi >  b.hi))
(<=){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo <= b.lo) & (a.hi <= b.hi))
(>=){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo >= b.lo) & (a.hi >= b.hi))

(==){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = false
(!=){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = true
(<=){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = opened(a) < opened(b)
(>=){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = opened(a) > opened(b)
(< ){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = closed(a) < closed(b)
(> ){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = closed(a) > closed(b)

