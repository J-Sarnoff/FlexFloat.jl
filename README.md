# FlexFloat.jl
####

#### These are values that stretch preserve accuracy.

The underlying representation is an interval with bounds that may be closed (exact) or open (inexact).  An exact bound takes the floating point value given at that boundry to be a precisely accurate quantity.  Two examples of exact quantities are counts and monetary balances. An inexact bound takes the floating point value given at the lower [higher] boundry to be largest [smallest] possible quantity to be included in the bounding value's span.  An inexact bound bound extendes away from the center of the interval, almost reaching the next lower [higher] floating point value.  Inexact bounds cover a real span that is not fully representable with machine floats -- and from that fact tend to follow results with relatively tight bounds.

The package internals handle all of that without additional guidance.  There are four kinds of intervals:

      (a) both bounds are exact (closed): ClCl(1,2)
      (b) both bounds are inexact (open): OpOp(1,2)
      (c) only the lower bound is exact : ClOp(1,2)
      (d) only the upper bound is exact : OpCl(1,2)

An exact value of 1 is entered as Exact(1).  Exact is a synonym for ClCl.</br>
An interval with exact bounds of zero and one is entered as Exact(0,1).</br>
An inexact value of 3 is entered as Inexact(3).  Inexact is a synonym for OpOp.</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;this indicates any value within the Real range that extends from prevfloat(3) to nextfloat(3) without including either.</br>
The inexact interval Inexact(1,2) indicates any value within the Real range from prevfloat(1) to nextfloat(2), exclusively.

#### Any values may exist in one of two states
###### states 'exact', 'inexact' are exported;  'situated', 'enhanced' are the internal names.

*This capability exists transparently -- apps that do not need it do not see it.*

Each Flex may be [re]assigned either of two states and the statefulness persists unless reassigned.
There is no limit on state changes, nor any requirement that states change.  The state is independant of the kind of interval (ClCl, OpOp, ClOp, OpCl); one may create some logical dependance in code. To simplify use, 

            ClCl(), OpOp(), ClOp(), OpCl() create values in the 'exact' state
            clcl(), opop(), clop(), opcl() create values in the 'inexact' stat
            (titlecase is used with situated values, lowercase with enhanced values)

       Assignment, determination and utilization of statefulness is entirely given to your application.

The file 'src/type/foryouruse.jl' has the comparison and conversion defaults for statefulness.
 



###Quick Guide

```julia
#=
   a closed boundry (an exact bound)  is shown with single angle brackets
   an open boundry (an inexact bound) is shown with double angle brackets

   when the lower bound and the upper bound are equal one number is shown
   when the lower bound and the upper bound are equal, one may use it alone
   
   values in the 'exact' state are tied with '⌁', '~' ties 'inexact' values
=#

julia> opop(1.2345,1.2346), ClCl(1), clcl(1,1), OpOp(1.2,1.2)
(⟪1.2345⌁1.2346⟫,⟨1.0~⟩,⟨1.0⌁⟩,⟪1.2~⟫)

# different sorts of values may be intermixed for arithmetic
julia> a=ClCl(2); b=OpCl(1.5, 2); a-b, a*b, a/b
(⟪0.0~0.5⟩,⟪3.0~4.0⟩,⟪1.0~1.3333333333333335⟩)

```

###And More

```julia

# elementary functions of FlexFloat values

julia> using FlexFloat
julia> exp(OpOp(1.0))
⟨2.7182818284590446, 2.7182818284590455⟩ # diameter: 8.88e-16

# optionally using CRlibm for more accuracy

julia> using CRlibm      # must preceed using FlexFloat
julia> using FlexFloat
julia> exp(OpOp(1.0))
⟨2.718281828459045~2.7182818284590455⟩ # diameter: 4.44e-16

# polynomial evaluation at FlexFloat values

julia> using Polynomials
julia> using FlexFloat
julia> p = Poly([4.0,8,1,-5,-1,1]);
julia> polyval(p, ClOp(2.5, 2.5+eps(2.5))
⟨10.718749999999991, 10.718750000000039⟫

# cdf, pdf, quantile at FlexFloat values
# for continuous univariate distributions

julia> using Distributions  # must preceed using FlexFloat
julia> using FlexFloat
julia> ND=normal();
julia> pdf(ND, ClCl(0.999,0.9995))
⟨0.24209170987131956, 0.24221269516298546⟩
julia> pdf(ND, OpOp(0.999,0.9995))
⟨0.24209170987131953, 0.24221269516298546⟩



```

###### supports
             (==), (!=), (<), (<=), (>=), (>),
             (+), (-), (*), (/),
             sqrt, exp, log,
             sin, cos, tan, csc, sec, cot,
             asin, acos, atan, acsc, asec, acot,
             sinh, cosh, tanh, csch, sech, coth,
             asinh, acosh, atanh, acsch, asech, acoth,
             erf, erfinv

             when the Distributions package is pre-loaded:
                cdf, pdf, quantile for univariate continuous distributions

###### References
(please see doc/References.md for all referenced material and links)

John L. Gustafson, *The End of Error: Unum Computing*</br>
Ulrich Kulisch, *Up-to-date Interval Arithmetic*
