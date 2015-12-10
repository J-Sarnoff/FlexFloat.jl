#=

    absorb behavior into the medium protenaxis

=#

#=
     The most significand bit in the exponent bit field
         is freed from floating point valuation, that
         it may elucidate state or elaborate context.

In all IEEE-754 2008 conformant binary floating point representations, the exponent bit field
is adjacent to the sign bit at the most significant region of the floating point representation.
The most significant bit of the exponent is the second most significant bit in the representation.
This is the bit that is to be freed and made available as annotation, demarcation or connection.
Releasing this bit necessarily halves number of distinct exponents that may be stored and that
reduces the quantity of representable finite values by half.  The resulting, adjusted domain
for these stateful projections of Float64|32 values onto Float64|32 is given with the mapping.

    Most computing uses numerical values within 1e-153 .. 1e+153:  all remain available.

  nomenclature

    An e-bit carrying floating point value is an `augmented` float.
    An augmented float that has its e-bit clear (0b0) is 'situated'.
    An augmented float that has its e-bit set   (0b1) is 'enhanced'.

=#

import Base: sign_mask, exponent_mask, exponent_bias, significand_bits


#=
    The 'e-bit' is the most significant bit of the exponent in an IEEE754-2008 Std Binary float.
    These inline ops are used for direct access and immediate manipulation of the 'e-bit'.
=#

@inline ebit_mask{T<:AbstractFloat}(::Type{T}) =  (sign_mask(T) >> 1)
@inline ebit_filt{T<:AbstractFloat}(::Type{T}) = ~(ebit_mask(T))
@inline ebit_mask{T<:Unsigned}(x::T) = ebit_mask(reinterpret(AbstractFloat,T))
@inline ebit_filt{T<:Unsigned}(x::T) = ebit_mask(reinterpret(AbstractFloat,T))

@inline set_ebit{T<:AbstractFloat}(x::T) = reinterpret(T,(reinterpret(Unsigned,x) | ebit_mask(T)))
@inline clr_ebit{T<:AbstractFloat}(x::T) = reinterpret(T,(reinterpret(Unsigned,x) & ebit_filt(T)))
@inline tst_ebit{T<:AbstractFloat}(x::T) = zero(reinterpret(Unsigned,T)) != (reinterpret(Unsigned,x) & ebit_mask(T))

 enhance{T<:AbstractFloat}(x::T) =  set_ebit(x)  # this is now  enhanced!
 situate{T<:AbstractFloat}(x::T) =  clr_ebit(x)  # this is now  situated!
enhanced{T<:AbstractFloat}(x::T) =  tst_ebit(x)  #      is this enhanced?
situated{T<:AbstractFloat}(x::T) = !tst_ebit(x)  #      is this situated?
