convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,EXACT,C}}, x::Flex{S,INEXACT,C}) = Flex{S,EXACT,C}(widened(x)...)
convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,INEXACT,C}}, x::Flex{S,EXACT,C}) = Flex{S,EXACT,C}(widened(x)...)

