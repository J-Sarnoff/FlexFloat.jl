#=

  nomenclature

    An e-bit enfolding floating point value is an *augmented* float.
    An augmented float that has its e-bit clear (0b0) is 'situated'.
    An augmented float that has its e-bit set   (0b1) is 'enhanced'.

=#

# query state
enhanced{T<:AbstractFloat}(x::T) =  tst_ebit(x)  #      is this enhanced?
situated{T<:AbstractFloat}(x::T) = !tst_ebit(x)  #      is this situated?
# force state
 enhance!{T<:AbstractFloat}(x::T) =  set_ebit(x)  # this is now  enhanced!
 situate!{T<:AbstractFloat}(x::T) =  clr_ebit(x)  # this is now  situated!
 
