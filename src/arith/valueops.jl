signbit{S<:Sculpt,C<:Clay}(a::Flex{S,C}) = (signbit(a.lo),signbit(a.hi))
sign{S<:Sculpt,C<:Clay}(a::Flex{S,C}) = (sign(a.lo),sign(a.hi))

function copysign{S<:Sculpt,C<:Clay}(a::Flex{S,C}, b::Real)
    lo = copysign(a.lo,b)
    hi = copysign(a.hi,b)
    lo <= hi ? (S)(lo,hi) : (negate(S))(hi,lo)
end

function flipsign{S<:Sculpt,C<:Clay}(a::Flex{S,C}, b::Real)
    lo = flipsign(a.lo,b)
    hi = flipsign(a.hi,b)
    lo <= hi ? (S)(lo,hi) : (negate(S))(hi,lo)
end

frexp{S<:Sculpt,C<:Clay}(a::Flex{S,C}) = (frexp(a.lo),frexp(a.hi))
ldexp{S<:Sculpt,C<:Clay,I<:Union{Int32,Int64}}(::Type{S},a::Tuple{Tuple{C,I},Tuple{C,I}}) = 
   (S)(ldexp(a[1][1],a[1][2]),ldexp(a[2][1],a[2][2]))
ldexp{C<:Clay,I<:Union{Int32,Int64}}(a::Tuple{Tuple{C,I},Tuple{C,I}}) = 
   (ClCl)(ldexp(a[1][1],a[1][2]),ldexp(a[2][1],a[2][2]))
