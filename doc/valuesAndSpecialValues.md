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

This should not be used when a task requires the availability of subnormal numbers, e.g.:
  (a) calculating spherical harmonics from a series expansion, or evaluating a polynomial
  of high degree at small values or an unstable polynomial in its regions of instability.
    Most computing uses numerical values within 1e-153 .. 1e+153:  all remain available.
=#

#=
                         Inf(boundry)
                      (+Huge)___(+Huge)
                         ..floats..
                      (+Tiny)___(+Tiny)
                              0
                      (-Tiny)___(-Tiny)
                          ..floats..
                      (-Huge)___(-Huge)
                       -Inf(boundry)

     ±Inf are considered to bound a numerical domain from without
      and bound an encompassing seminumerical domain from within.
     ±Huge are considered to hold all finite values of magnitude
      greater than than the available float of largest magnitude.
     ±Tiny are considered to hold all nonzero values of magnitude
      less than the available float of least magnitude.

     This is set to be much greater than the largest subnormal.

     Testing for these seminumerical values is supported using
     isinf, ishuge, istiny, also isnan. Use them, not others.

     Special case handling of these seminumerical values for
     incorporation inside arithmetic functions is provided
     and is available to externally coded arithemetics.
=#
