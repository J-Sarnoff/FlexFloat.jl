
  These routines return +/-Inf when given +/-Inf.
  And step twice given values of very small magnitude (see paper).

  That differs from nextfloat(-Inf) == -realmax(), prevfloat(Inf) == realmax()
  
  (prevfloat(Inf)==Inf makes more sense to me, and likely is more helpful).
  
  
  Alternatively, converting to [U]Int and adding/subtracting 1,
  returns NaN when given +/-Inf and would add branching. 
  
  ref:
  'Predecessor and Successor In Rounding To Nearest' by Siegried M. Rump
  
  "The routines deliver the exact answer except for a small range near underflow,
   in which case the true result is overestimated by eta [the value added/subtracted below]."
