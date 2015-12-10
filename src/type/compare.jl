# refs:
#     "Definition of the Arithmetic Operations and Comparison Relations
#        for an Interval Arithmetic Standard" by Gerd Bohlender and Ulrich Kulisch
#     Reliable Computing 15, 2011 pp 41-42
#
#     Computer Arithmetic and Validity (2nd edition) by Ulrich Kulisch (section 7.4, pp242-43)


(==){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = ((a.lo == b.lo) & (a.hi == b.hi))
(!=){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = ((a.lo != b.lo) | (a.hi != b.hi))
(<=){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = ((a.lo <= b.lo) & (a.hi <= b.hi))
(>=){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = ((a.lo >= b.lo) & (a.hi >= b.hi))
(< ){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = (!(a >= b))
(> ){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = (!(a <= b))
(isless){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = (a < b)
(isequal){S<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,Q,C}) = (a == b)

#=
    if a,b are of differing Sculpt and one boundry value from each of a and b are equal 
    then (a <= b or a >= b) and ( !(a<b) and !(a>b) and !(a==b) )
    
     ⟨1.0, 2.0⟫ <=   ⟨1.0, 2.0⟩ <= ⟪1.0, 2.0 ⟩ ,  ⟪1.0, 2.0⟫
=#
(==){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = false
(!=){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = true
(<=){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = opened(a) < opened(b)
(>=){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = opened(a) > opened(b)
(< ){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = closed(a) < closed(b)
(> ){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = closed(a) > closed(b)
(isequal){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = false
(isless){S<:Sculpt, T<:Sculpt, Q<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{T,Q,C}) = (a < b)


# see foryouruse.jl to access comparison logic when qualia differ
