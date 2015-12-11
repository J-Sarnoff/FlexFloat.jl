import Main.Distributions:cdf,pdf,quantile
typealias Dist Main.Distributions.Distribution{Main.Distributions.Univariate,Main.Distributions.Continuous}


# quash ambiguity
cdf{S<:Sculpt, Q<:Qualia, C<:Clay}(d::Main.Distributions.Triweight, x::Flex{S,Q,C}) = ErrorException("Not Implemented")
pdf{S<:Sculpt, Q<:Qualia, C<:Clay}(d::Main.Distributions.AbstractMixtureModel{Main.Distributions.Univariate, Main.Distributions.Continuous}, x::FlexFloat.Flex{S,Q,C})= ErrorException("Not Implemented")
pdf{S<:Sculpt, Q<:Qualia, C<:Clay}(d::Main.Distributions.Triweight, x::Flex{S,Q,C}) = ErrorException("Not Implemented")
 

@inline negabs(x::Clay) = -abs(x)

   for (fn) in (:cdf,) # increasing functions
       @eval begin
           function ($fn){S<:Sculpt, Q<:Qualia, C<:Clay}(d::Dist, x::Flex{S,Q,C})
               loIsOpen, hiIsOpen = boundries(S)
               if loIsOpen
                   with_rounding(C, RoundDown) do
                       lo = ($fn)(d, x.lo)
                   end
               else
                   lo = ($fn)(d, x.lo)
               end
               if hiIsOpen
                   with_rounding(C, RoundUp) do
                       hi = ($fn)(d, x.hi)
                   end
               else
                   hi = ($fn)(d, x.hi)
               end

               if lo>hi
                 loIsOpen, hiIsOpen = hiIsOpen, loIsOpen
                 # swap x.lo,x.hi inline
                 if loIsOpen
                     with_rounding(C, RoundDown) do
                         lo = ($fn)(d, x.hi)
                     end
                 else
                     lo = ($fn)(d, x.hi)
                 end
                 if hiIsOpen
                     with_rounding(C, RoundUp) do
                         hi = ($fn)(d, x.lo)
                     end
                 else
                     hi = ($fn)(d, x.lo)
                 end
               end

               Flex{CLCL,Q,C}(minmax(lo,hi)...)
           end
       end
   end

   for (fn) in (:pdf,) # increasing functions (pdf(-x) == pdf(x), pdf(-x) increases)
       @eval begin
           function ($fn){S<:Sculpt, Q<:Qualia, C<:Clay}(d::Dist, x::Flex{S,Q,C})
               loIsOpen, hiIsOpen = boundries(S)
               if loIsOpen
                   with_rounding(C, RoundDown) do
                       lo = ($fn)(d, negabs(x.lo))
                   end
               else
                   lo = ($fn)(d, negabs(x.lo))
               end
               if hiIsOpen
                   with_rounding(C, RoundUp) do
                       hi = ($fn)(d, negabs(x.hi))
                   end
               else
                   hi = ($fn)(d, negabs(x.hi))
               end

               if lo>hi
                 loIsOpen, hiIsOpen = hiIsOpen, loIsOpen
                 # swap x.lo,x.hi inline
                 if loIsOpen
                     with_rounding(C, RoundDown) do
                         lo = ($fn)(d, x.hi)
                     end
                 else
                     lo = ($fn)(d, x.hi)
                 end
                 if hiIsOpen
                     with_rounding(C, RoundUp) do
                         hi = ($fn)(d, x.lo)
                     end
                 else
                     hi = ($fn)(d, x.lo)
                 end
               end

               Flex{CLCL,Q,C}(minmax(lo,hi)...)
           end
       end
   end

# the implementation of quantile is not ok with directed rounding on 01-Dec-2015
#      roundingDn(quantile(Normal(),0.95) > roundingNearest(Normal(),0.95)
#  and roundingUp(quantile(Normal(),0.95) > roundingNearest(Normal(),0.95)

 for (fn) in (:quantile,) # increasing functions
       @eval begin
           function ($fn){S<:Sculpt, Q<:Qualia, C<:Clay}(d::Dist, x::Flex{S,Q,C})
               loIsOpen, hiIsOpen = boundries(S)
               if loIsOpen
                   loNearest = ($fn)(d, x.lo)
                   with_rounding(C, RoundDown) do
                       lo = min(($fn)(d, x.lo), loNearest)
                   end
               else
                   lo = ($fn)(d, x.lo)
               end
               if hiIsOpen
                   hiNearest = ($fn)(d, x.hi)
                   with_rounding(C, RoundUp) do
                       hi = max(($fn)(d, x.hi), hiNearest)
                   end
               else
                   hi = ($fn)(d, x.hi)
               end

               if lo>hi
                 loIsOpen, hiIsOpen = hiIsOpen, loIsOpen
                 # swap x.lo,x.hi inline
                 if loIsOpen
                     with_rounding(C, RoundDown) do
                         lo = ($fn)(d, x.hi)
                     end
                 else
                     lo = ($fn)(d, x.hi)
                 end
                 if hiIsOpen
                     with_rounding(C, RoundUp) do
                         hi = ($fn)(d, x.lo)
                     end
                 else
                     hi = ($fn)(d, x.lo)
                 end
               end

               Flex{CLCL,Q,C}(minmax(lo,hi)...)
           end
       end
   end
