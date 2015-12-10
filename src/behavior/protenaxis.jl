#=

  nomenclature

    An e-bit enfolding floating point value is an 'augmented' float.
    An augmented float that has its e-bit clear (0b0) is 'situated'.
    An augmented float that has its e-bit set   (0b1) is 'enhanced'.

=#

# query state
enhanced{T<:AbstractFloat}(x::T) =  tst_ebit(x)  #      is this enhanced?
situated{T<:AbstractFloat}(x::T) = !tst_ebit(x)  #      is this situated?

# force state
 enhance!{T<:AbstractFloat}(x::T) =  set_ebit(x)  # this is now  enhanced!
 situate!{T<:AbstractFloat}(x::T) =  clr_ebit(x)  # this is now  situated!
 
#=
    Tiny if exponent(Float64) <= -509                         Huge if exponent(Float64) >= 510
    TinyAsValue == ldexp(0.5,-509)        <reciprocals>       HugeAsValue == ldexp(0.5,511)

                            1.19e-153     central range    8.38e+152
      ldexp(prevfloat(prevfloat(1.0)), -508) ...0.0... ldexp(nextfloat(0.5),509)
                                          <reciprocals>
=#

# huge/tiny gathers all finite values larger/smaller (or equal) itself
# huge, tiny before projective transform
Bias(::Type{Float64})   = 511                     # exponent_bias(Float64) >> 1
AsTiny(::Type{Float64}) = 1.1933345169920327e-153 # first inadmissible small magnitude
AsHuge(::Type{Float64}) = 8.379879956214127e152   # first inadmissible large magnitude
                                                  # 1/AsTiny == AsHuge, 1/AsHuge == AsTiny
Tiny(::Type{Float64})   = 2.983336292480083e-154  # collective value representing all smallest normal magnitudes
Huge(::Type{Float64})   = 3.35195198248565e+153   # collective value representing all largest  normal magnitudes
                                                  # 1/Tiny == Huge, 1/Huge == Tiny
# above, reinterpreted before projection
Bias(::Type{UInt64})  = 
Tiny(::Type{UInt64})  = 
Huge(::Type{UInt64})  = 
# above, after projection
TinyProjected(::Type{Float64}) = 
TinyProjected(::Type{UInt64})  = 
HugeProjected(::Type{Float64}) = 
HugeProjected(::Type{UInt64})  = 
