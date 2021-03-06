module FlexFloat

             #  more is imported than is overloaded
import Base: -, +, *, /, %, ^,
             convert, promote_rule, promote_type, r_promote, 
             show, showcompact, string, parse,
             frexp, ldexp,
             isinteger, isfinite, isreal, isinf, isnan,
             sign, signbit, copysign, flipsign, abs,
             decompose,
             sizeof, reinterpret,
             typemin, typemax, realmin, realmax,
             zero, one,  eps,
             sizeof, reinterpret,
             isequal,isless, (!=),(>=),(>),(<=),(<),(==),             
             trunc, round, floor, ceil,
             fld, rem, mod, mod1, rem1, fld1, 
             min, max, minmax,
             sqrt,exp,expm1,log,log1p,
             sin,cos,tan,csc,sec,cot,
             asin,acos,atan,acsc,asec,acot,
             sinh,cosh,tanh,csch,sech,coth,
             asinh,acosh,atanh,acsch,asech,acoth,
             gamma,lgamma,erf,erfinv,
             start, next, done


export Flex64, Flux64,
       ClCl, ClOp, OpCl, OpOp,
       clcl, clop, opcl, opop,
       widened, narrowed, opened, closed,
       glb, lub, supremum, infimum,
       dia, rad, mid, mig, mag, dev, abs, dist,
       value, isexact, isinexact,
       isclosedclosed, isclosedopen, isopenclosed, isopenopen,
       showmidpointradius, showmidrad

# provide these modular services
include("module/AdjacentFloat/AdjacentFloat.jl")
using .AdjacentFloat
include("module/RoundFast/RoundFast.jl")
using .RoundFast
include("module/Reinterpret/Reinterpret.jl")
using .Reinterpret

typealias Float AbstractFloat

include("type/flexible.jl")
include("type/primitive.jl")
include("type/convert.jl")
include("type/interval.jl")
include("type/compare.jl")
include("type/distill.jl")
include("type/cvtqualia.jl")
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
