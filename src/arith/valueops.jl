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
   
#= from Julia
`decompose(x)`: non-canonical decomposition of rational values as `num*2^pow/den`.
The decompose function is the point where rational-valued numeric types that support
hashing hook into the hashing protocol. `decompose(x)` should return three integer
values `num, pow, den`, such that the value of `x` is mathematically equal to
    num*2^pow/den
The decomposition need not be canonical in the sense that it just needs to be *some*
way to express `x` in this form, not any particular way – with the restriction that
`num` and `den` may not share any odd common factors. They may, however, have powers
of two in common – the generic hashing code will normalize those as necessary.
Special values:
 - `x` is zero: `num` should be zero and `den` should have the same sign as `x`
 - `x` is infinite: `den` should be zero and `num` should have the same sign as `x`
 - `x` is not a number: `num` and `den` should both be zero
=#

#decompose{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = decompose( mid(x) )

isnan{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (isnan(x.lo) | isnan(x.hi))
isinf{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (isinf(x.lo) | isinf(x.hi))
isfinite{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (isfinite(x.lo) & isfinite(x.hi))


