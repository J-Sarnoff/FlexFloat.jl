#=
   The following function wraps a call that ascertains the floating point value
   deemed to be most representative of the valuespan an interval signifies.
   
   If you prefer, you may provide a functional substitute.
=#

function mostRepresentativeValue{S<:Sculpt, Q<:Qualia, C<:Clay}(x::Flex{S,Q,C})
    lo,hi = (Q==CLCL) ? values(x) : values(opened(x))
    domainExtendedLogarithmicMean(lo,hi)
end

function domainExtendedLogarithmicMean{R<:Real}(x::R,y::R)
       lo,hi = minmax(x,y)
       if lo > 0.0
           #=
               using the logarithmic mean to condense the spanned interval into a representative floating point value
           =#
           (hi - lo) / (log(hi) - log(lo))
        else # determine the logarithmic mean indirectly
           if signbit(hi) == signbit(lo)
                abs(hi - lo) / (log(abs(hi)) - log(abs(lo)))  
           else
              lo = abs(hi) / log(abs(lo))
              hi = abs(lo) / log(abs(hi))
              if abs(lo) <= abs(hi)
                 copysign( abs(lo-hi), lo)
              else
                 copysign( abs(lo-hi), hi)
              end
            end
        end    
end
