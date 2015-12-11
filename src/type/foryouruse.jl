function convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,EXACT,C}}, x::Flex{S,INEXACT,C})
   Flex{S,EXACT,C}(widened(x)...)
end

function convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,INEXACT,C}}, x::Flex{S,EXACT,C})
   Flex{S,INEXACT,C}(widened(x)...)
end

promote_rule{S<:Sculpt,Q<:Qualia, R<:Qualia, C<:Clay}(::Type{Flex{S,Q,C}}, ::Type{Flex{S,R,C}}) = Flex{S,INEXACT,C}


#=
    Should you want comparisons to be influenced when the comparands differ in qualia,
    define these accordingly. (These, as given below, do not use qualia in comparisons).
=#
(==){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = false
(!=){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = true
(<=){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = opened(a) < opened(b)
(>=){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = opened(a) > opened(b)
(< ){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = closed(a) < closed(b)
(> ){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = closed(a) > closed(b)
(isless){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = (a < b)
(isequal){S<:Sculpt, Q<:Qualia, R<:Qualia, C<:Clay}(a::Flex{S,Q,C}, b::Flex{S,R,C}) = (a == b)

