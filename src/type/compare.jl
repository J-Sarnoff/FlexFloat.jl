# refs:
#     "Definition of the Arithmetic Operations and Comparison Relations
#        for an Interval Arithmetic Standard" by Gerd Bohlender and Ulrich Kulisch
#     Reliable Computing 15, 2011 pp 41-42
#
#     Computer Arithmetic and Validity (2nd edition) by Ulrich Kulisch (section 7.4, pp242-43)


(==){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo == b.lo) & (a.hi == b.hi))
(!=){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo != b.lo) | (a.hi != b.hi))
(<=){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo <= b.lo) & (a.hi <= b.hi))
(>=){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = ((a.lo >= b.lo) & (a.hi >= b.hi))
(< ){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = (!(a >= b))
(> ){S<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{S,C}) = (!(a <= b))

#=
    if a,b are of differing Sculpt and one boundry value from a and one from b are equal 
    then (a <= b or a >= b) and ( !(a<b) and !(a>b) and !(a==b) )
    
     ⟨1.0, 2.0⟫ <=   ⟨1.0, 2.0⟩ <= ⟪1.0, 2.0 ⟩ ,  ⟪1.0, 2.0⟫
=#
(==){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = false
(!=){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = true
(<=){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = opened(a) < opened(b)
(>=){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = opened(a) > opened(b)
(< ){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = closed(a) < closed(b)
(> ){S<:Sculpt, T<:Sculpt, C<:Clay}(a::Flex{S,C}, b::Flex{T,C}) = closed(a) > closed(b)

