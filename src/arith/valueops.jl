signbit{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}) = (signbit(a.lo),signbit(a.hi))
sign{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}) = (sign(a.lo),sign(a.hi))

function copysign{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Real)
    lo = copysign(a.lo,b)
    hi = copysign(a.hi,b)
    lo <= hi ? (S)(lo,hi) : (negate(S))(hi,lo)
end

function flipsign{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}, b::Real)
    lo = flipsign(a.lo,b)
    hi = flipsign(a.hi,b)
    lo <= hi ? (S)(lo,hi) : (negate(S))(hi,lo)
end

frexp{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}) = (frexp(a.lo),frexp(a.hi))
ldexp{S<:Sculpt,Q<:Qualia,C<:Clay,I<:Union{Int32,Int64}}(::Type{Flex{S,Q,C}},a::Tuple{Tuple{C,I},Tuple{C,I}}) = 
   (Flex{S,Q,C})(ldexp(a[1][1],a[1][2]),ldexp(a[2][1],a[2][2]))
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
decompose{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = decompose(mostRepresentativeValue(x))

isnan{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = (isnan(x.lo) | isnan(x.hi))
isinf{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = (isinf(x.lo) | isinf(x.hi))
isfinite{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = (isfinite(x.lo) & isfinite(x.hi))
issubnormal{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = (issubnormal(x.lo) | issubnormal(x.hi))
isinteger{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C}) = (x.lo==x.hi) && (isinteger(x.lo) & isinteger(x.hi))

