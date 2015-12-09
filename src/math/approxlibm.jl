#=
   IMPORTANT
   
   Julia v0.4.0 does not provide elementary functions that always round to nearest.
   For example:  exp( 0.05489354701373524 ) evaluates 1.0564281487582248
                                            actually  1.0564281487582246 
                                            
   Consequently, the bounds provided below must be expanded to allow for this. 
   
   This file should be used with functions that do not always evaluate to nearest.
=#

#=
   functions y=f(x) such that f(x+dx) > f(x) for dx>0 and f(x) defined for -Inf..x..Inf
=#


for (fn) in (:exp, :expm1, :log, :log1p,
             :sin, :cos, :tan, :csc, :sec, :cot,
             :asin, :acos, :atan, :acsc, :asec, :acot,
             :sinh, :cosh, :tanh, :csch, :sech, :coth,
             :asinh, :acosh, :atanh, :acsch, :asech, :acoth,
             :erf, :erfinv)
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            # round to nearest, make sure lo,hi are min(this,that), max(this,that) respectively
            lo, hi = values(x)
            lo = ($fn)(lo)
            hi = ($fn)(hi)
            if lo > hi
               lo,hi = hi,lo
            end
            lo = prevFloat(lo)
            hi = nextFloat(hi)
            
            Flex{ClCl,C}(lo,hi)
        end
    end
end



for (fn, domainMin) in ((:sqrt, 0.0), )
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            if x.lo < ($domainMin)
                throw(ErrorException("DomainError: $($fn) expected x.lo>=($($domainMin)), got $(x)."))
            end
            loIsOpen, hiIsOpen = boundries(S)
            # round to nearest, make sure lo,hi are min(this,that), max(this,that) respectively
            lo, hi = values(x)
            lo = ($fn)(lo)
            hi = ($fn)(hi)
            if loIsOpen
                with_rounding(C, RoundDown) do
                    lo = min(lo, ($fn)(x.lo))
                end
            end
            if hiIsOpen
                with_rounding(C, RoundUp) do
                    hi = max(hi, ($fn)(x.hi))
                end
            end
            Flex{ClCl,C}(lo,hi)
        end
    end
end
