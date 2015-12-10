
The exponent part of a Float64 is an 11-bit field adjacent to the sign bit (b63, the most significant bit),
the exponent occupies b52..b62.  We appropriate b62, the second most significant bit, to become the e-bit.

This reduces by one the number bits available to represent the exponent field, from 11 bits to 10 bits.
We want to preserve the widest practicable availability of reciprocal values, so the 10th exponent bit
may be considered as if it were an exponent-sign bit will be as a signbit.  In actuality, the exponent
field is biased, it counts from zero upward; to use the exponent field, first subtract the bias.
  ( A binary exponent of 1025 indicates the significand is multiplied by 2^(1025-1023) == 2^(2) == 4. )

There are two special exponents: all bits clear (all zeros) and all bits set to one. With the exception
of two values (-0.0, +0.0), those exponents signal special values and non-normal numbers. Consequently,
they are not available for use with normal numbers.  10 bits allows 0..1023, but 1023 is all one bits
so it is not available, and 0 is all zero bits so it is not available except to represent ±0.0.

===========================

In an unrestricted manner, we have available exponent field values 1..1022 (and ±0.0).
So we may have 1022/2 = 511 reciprocal exponent pairs: (±1, ±2, .., ±510, ±511) and ±0.0.

The augmented floating point value of largest magnitude is ldexp(prevfloat(1.0),511) ≊ 6.7039e+153.
The reciprocal value is ldexp(nextfloat(0.5), -510) ≊ 1.4917e-154, and will serve as our least value.
(There is one smaller value but its reciprocal is not available, so we consider that value non-normal.)

Thus we find this the necessary exponent mapping:  -1023..1023 -> -511..511 (we want the central values).
Using 0..1022 with a bias of 511 gives us the values we want:  0-511 .. 1022-511 == -511..511, inclusive.

=============================

Obtaining the central values ±(1.5e-154 .. 6.7e+153) requires recoginzing and collaping all normal values
that are outside of this central range.  Normal values of magnitude >= ldexp(1.0,511) collapse as ±Huge,
normal values of magnitude <= ldexp(0.5,-510) collapse as ±Tiny.  We might use ldexp(0.5,-510) for Tiny
(it is available, its reciprocal is not); but doing that does not get us a unique representation for Huge.
It is important that Tiny,Huge compare appropriately:  |Tiny| < |central range| < |Huge|.  To make that
happen, we need to narrow the central range.  While it is sufficient to reduce the range by a single value
at either end, it is efficient to reduce the exponent range by one at either end:

                                 5.967e-154     central range    1.676e+153
                      ldexp(prevfloat(1.0), -509) ...0.0... ldexp(nextfloat(0.5),510)
                      ldexp(prevfloat(1.0), -508) ...0.0... ldexp(nextfloat(0.5),509)

  Tiny  <= ldexp(prevfloat(prevfloat(1.0)), -509)            Huge >= ldexp(nextfloat(nextfloat(0.5)),510)
  TinyAsValue == ldexp(0.5,-509)                <reciprocals>          HugeAsValue == ldexp(0.5,511)

  Tiny if exponent(Float64) <= -509                          Huge if exponent(Float64) >= 510
