RoundFast.jl Fast directed rounding for inline arithmetic, very fast with hardware fma.

I used https://github.com/johnmyleswhite/Benchmarks.jl for relative timing.

With addition and subtraction, I get better than 10x speedup.

With multiply, divide, sqrt, I get 2x speedup without hardware fma. Using hardware that supports fma directly, the speedup should be similar to addition.

using RoundFast

for a,b floating point values, op in {+,-,*,/,sqrt,square} and rounding a rounding mode:

(the rounding modes are RoundNearest, RoundUp, RoundDown, RoundToZero, RoundFromZero)

value = (op)(a,b,rounding) c = (+)(a,b,RoundDown)

Note that this offers RoundFromZero for Floats, while Julia v0.4 does not.
