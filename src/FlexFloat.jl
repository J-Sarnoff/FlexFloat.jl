module FlexFloat

import Base: ==, <, <=, -, +, *, /, %, ^,
             convert, promote_rule, promote_type,
             show, showcompact, string, parse,
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
       widened, narrowed, opened, closed,
       boundries, clay, sculpt, value,
       glb, lub, supremum, infimum,
       dia, rad, mid, mig, mag, dev, abs, dist

# provide these modular services
include("module/AdjacentFloat/AdjacentFloat.jl")
using .AdjacentFloat
include("module/RoundFast/RoundFast.jl")
using .RoundFast

include("type/flexible.jl")
include("type/primitive.jl")
include("type/convert.jl")
include("type/interval.jl")
include("type/compare.jl")
include("type/io.jl")

include("arith/valueops.jl")
include("arith/add.jl")
include("arith/sub.jl")
include("arith/mul.jl")
include("arith/div.jl")
include("arith/sqrt.jl")


if isdefined(Main, :CRlibm)
  include("math/moreCRlibm.jl")
  include("math/withCRlibm.jl")
else  
  include("math/approxlibm.jl")
end

if isdefined(Main, :Distributions)
    include("math/distributions.jl")
end

end # module
