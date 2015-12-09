#=
   IMPORTANT
   
   Julia v0.4.0 does not provide elementary functions that always round to nearest.
   For example:  exp( 0.05489354701373524 ) evaluates 1.0564281487582248
                                            actually  1.0564281487582246 
                                            
   Consequently, the bounds provided below must be expanded to allow for this. 
   
   This file should be used with functions that evaluate to nearest.
   It is part of the release so it is available for use with a library that rounds to nearest.
=#

# functions not exported by CRlibm or available with extraCRlibm.jl
for (fn) in (:acsc, :asec, :acot,
             :csch, :sech, :coth,
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


#=
   functions y=f(x) such that f(x+dx) > f(x) for dx>0 and f(x) defined for -Inf..x..Inf
=#

for (fn) in (:exp, :expm1, :atan, :sinh, :tanh)
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            loIsOpen, hiIsOpen = boundries(S)
            # round to nearest, make sure lo,hi are min(this,that), max(this,that) respectively
            lo, hi = values(x)
            if loIsOpen
                lo = ($fn)(x.lo, RoundDown)
            else
                lo = ($fn)(x.lo, RoundNearest)
            end
            if hiIsOpen
                hi = ($fn)(x.hi, RoundUp)
            else
                hi = ($fn)(x.hi, RoundNearest)
            end
            Flex{ClCl,C}(lo,hi)
        end
    end
end

#=
   functions y=f(x), f(x) defined for -Inf..x..Inf (f(x) may be +/-Inf)
=#

for (fn) in (:sin, :cos, :tan, :csc, :sec, :cot, :cosh)
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            loIsOpen, hiIsOpen = boundries(S)
            lo, hi = values(x)
            if loIsOpen
                lo = ($fn)(lo, RoundDown)
            else
                lo = ($fn)(lo, RoundNearest)
            end
            if hiIsOpen
                hi = ($fn)(hi, RoundUp)
            else
                hi = ($fn)(hi, RoundNearest)
            end
            # given the e.g. periodicity of (fn), it is possible that fn(x.lo) > fn(x.hi)
            if lo>hi
                hiIsOpen, loIsOpen = boundries(S)
                hi, lo = values(x)
                if loIsOpen
                    lo = ($fn)(lo, RoundDown)
                else
                    lo = ($fn)(lo, RoundNearest)
                end
                if hiIsOpen
                    hi = ($fn)(hi, RoundUp)
                else
                    hi = ($fn)(hi, RoundNearest)
                end
            end

            Flex{ClCl,C}(lo,hi)
        end
    end
end

#=
   functions y=f(x) such that f(x+dx) > f(x) for dx>0 and f(x) defined for domainMin..x..Inf
=#

for (fn, domainMin) in ((:sqrt, 0.0), )
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            if x.lo < ($domainMin)
                throw(ErrorException("DomainError: $($fn) expected x.lo>=($($domainMin)), got $(x)."))
            end
            loIsOpen, hiIsOpen = boundries(S)
            lo, hi = values(x)
            if loIsOpen
                with_rounding(C, RoundDown) do
                    lo = ($fn)(lo)
                end     
            else
                with_rounding(C, RoundNearest) do 
                    lo = ($fn)(lo)
                end     
            end
            if hiIsOpen
                with_rounding(C, RoundUp) do
                    hi = ($fn)(hi)
                end     
            else
                with_rounding(C, RoundNearest) do 
                    hi = ($fn)(hi)
                end     
            end
            Flex{ClCl,C}(lo,hi)
        end
    end
end

for (fn, domainMin) in ((:log, 0.0), (:log1p, -1.0))
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            if x.lo < ($domainMin)
                throw(ErrorException("DomainError: $($fn) expected x.lo>=($($domainMin)), got $(x)."))
            end
            loIsOpen, hiIsOpen = boundries(S)
            # round to nearest, make sure lo,hi are min(this,that), max(this,that) respectively
            lo, hi = values(x)
            if loIsOpen
                lo = ($fn)(lo, RoundDown)
            else
                lo = ($fn)(lo, RoundNearest)
            end
            if hiIsOpen
                hi = ($fn)(hi, RoundUp)
            else
                hi = ($fn)(hi, RoundNearest)
            end
            
            Flex{ClCl,C}(lo,hi)
        end
    end
end


#=
   functions y=f(x) such that f(x+dx) > f(x) for dx>0 and f(x) defined for domainMin..x..domainMax
=#

for (fn, domainMin, domainMax) in ((:asin, -1.0, 1.0), (:atanh, -1.0, 1.0), (:erfinv, -1.0, 1.0))
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            if (x.lo < ($domainMin)) | (x.hi > ($domainMax))
                throw(ErrorException("DomainError: $($fn) expected x.lo,x.hi within [($($domainMin),$($domainMax))], got $(x)."))
            end
            loIsOpen, hiIsOpen = boundries(S)
            # round to nearest, make sure lo,hi are min(this,that), max(this,that) respectively
            lo, hi = values(x)
            if loIsOpen
                lo = ($fn)(lo, RoundDown)
            else
                lo = ($fn)(lo, RoundNearest)
            end
            if hiIsOpen
                hi = ($fn)(hi, RoundUp)
            else
                hi = ($fn)(hi, RoundNearest)
            end

            Flex{ClCl,C}(lo,hi)
        end
    end
end

#=
   functions y=f(x) such that f(x+dx) < f(x) for dx>0 and f(x) defined for domainMin..x..domainMax
=#

for (fn, domainMin, domainMax) in ((:acos, -1.0, 1.0),)
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            if (x.lo < ($domainMin)) | (x.hi > ($domainMax))
                throw(ErrorException("DomainError: $($fn) expected x.lo,x.hi within [($($domainMin),$($domainMax))], got $(x)."))
            end
            # function is decreasing, so hi,lo sense is reversed
            hiIsOpen, loIsOpen = boundries(S)
            # round to nearest, make sure lo,hi are min(this,that), max(this,that) respectively
            lo, hi = values(x)
            if loIsOpen
                lo = ($fn)(lo, RoundDown)
            else
                lo = ($fn)(lo, RoundNearest)
            end
            if hiIsOpen
                hi = ($fn)(hi, RoundUp)
            else
                hi = ($fn)(hi, RoundNearest)
            end

            Flex{ClCl,C}(lo,hi)
        end
    end
end

#=
   functions y=f(x) and f(x) defined for -Inf..x..domainLoMax, domainHiMin..x..+Inf
   (there is a region of x where f(x) is undefined between domainLoMax and domainHiMin)
=#
#=
for (fn, domainLoMax, domainHiMin) in ((:acsc, -1.0, 1.0), (:asec, -1.0, 1.0), (:acoth, -1.0, 1.0))
    @eval begin
        function ($fn){S<:Sculpt,C<:Clay}(x::Flex{S,C})
            if (($domainLoMax) < x.lo < ($domainHiMin)) | (($domainLoMax) < x.lo < ($domainHiMin))
                throw(ErrorException("DomainError: $($fn) expected x.lo,x.hi outside [($($domainLoMax),$($domainHiMin))], got $(x)."))
            end
            # function is decreasing, so hi,lo sense is reversed
            loIsOpen, hiIsOpen = boundries(S)
            lo, hi = values(x)
            if loIsOpen
                lo = ($fn)(lo, RoundDown)
            else
                lo = ($fn)(lo, RoundNearest)
            end
            if hiIsOpen
                hi = ($fn)(hi, RoundUp)
            else
                hi = ($fn)(hi, RoundNearest)
            end
            # given the nature of (fn), it is quite possible that fn(x.lo) > fn(x.hi)
            if lo>hi
                hiIsOpen,loIsOpen = boundries(S)
                hi,lo = values(x)
                if loIsOpen
                    lo = ($fn)(lo, RoundDown)
                else
                    lo = ($fn)(lo, RoundNearest)
                end
                if hiIsOpen
                    hi = ($fn)(hi, RoundUp)
                else
                    hi = ($fn)(hi, RoundNearest)
                end
            end
            Flex{ClCl,C}(lo,hi)
        end
    end
end
=#
