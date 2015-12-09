module FlexFloat

import Base: ==, <, <=, -, +, *, /, %, ^,
             convert, promote_rule, promote_type,
             show, showcompact,
             frexp, ldexp,
             isinteger, isfinite, isreal, isinf, isnan,
             sign, signbit, copysign, flipsign, abs,
             sizeof, reinterpret, # decompose does not import, use Base.decompose
             typemin, typemax, realmin, realmax,
             zero, one,  eps,
             isequal,isless, (!=),(>=),(>),
             sqrt,exp,expm1,log,log1p,
             sin,cos,tan,csc,sec,cot,
             asin,acos,atan,acsc,asec,acot,
             sinh,cosh,tanh,csch,sech,coth,
             asinh,acosh,atanh,acsch,asech,acoth,
             gamma,lgamma,erf,erfinv

export Flex, ClCl, ClOp, OpCl, OpOp, CC, CO, OC, OO,
       Sculpt, Clay, 
       glb, lub, sup, inf,
       dia, rad, mid, mig, mag, dev, abs, dist,
       widen, narrow, open, close,
       boundries, clay, sculpt, value

# provide these modular services
include("module/AdjacentFloat/AdjacentFloat.jl")
using .AdjacentFloat
include("module/RoundFast/RoundFast.jl")
using .RoundFast

include("type/flexible.jl")
include("type/primitive.jl")
include("type/convert.jl")
include("type/interval.jl")

end # module
