procedure convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,EXACT,C}}, x::Flex{S,INEXACT,C})
   Flex{S,EXACT,C}(widened(x)...)
end

convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,INEXACT,C}}, x::Flex{S,EXACT,C})
   Flex{S,EXACT,C}(widened(x)...)
end

promote_rule{S<:Sculpt, C<:Clay}(::Type{Flex{S,INEXACT,C}}, ::Type{Flex{S,EXACT,C}}) = Flex{S,INEXACT,C}



