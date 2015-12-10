convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Flex{S,Q,Float64}}, x::Flex{S,Q,C}) = Flex{S,Q,Float64}(convert(Float64,x.lo),convert(Float64,x.hi))

convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Flex{CLCL,Q,C}}, x::Flex{S,Q,C}) = Flex{CLCL,Q,C}(closed(x)...)
convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Flex{CLOP,Q,C}}, x::Flex{S,Q,C}) = Flex{CLCL,Q,C}(clopened(x)...)
convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Flex{OPCL,Q,C}}, x::Flex{S,Q,C}) = Flex{CLCL,Q,C}(opclosed(x)...)
convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Flex{OPOP,Q,C}}, x::Flex{S,Q,C}) = Flex{CLCL,Q,C}(opened(x)...)

function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Flex{S,Q,C}}, lo::Real, hi::Real)
   low = convert(C, lo)
   hig = convert(C, hi)
   low,hig = minmax(low,hig)
   Flex{S,Q,C}(low,hig)
end

function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Array{C,1}}, x::Flex{S,Q,C})
   if Q==CLCL
       lo,hi = (Q==CLCL) ? values(x) : values(opened(x))
   end 
   lo = convert(R,lo)
   hi = convert(R,hi)
   (lo,hi)
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

function convert{S<:Sculpt,Q<:Qualia,C<:Clay,R<:Real}(::Type{R}, x::Flex{S,Q,C})
   if Q==CLCL
       lo,hi = (Q==CLCL) ? values(x) : values(opened(x))
   end 
   lo = convert(R,lo)
   hi = convert(R,hi)
   if lo == hi
      lo
   else  
       domainExtendedLogarithmicMean(lo,hi)
    end
end



# see foryouruse.jl to access conversion logic when qualia differ
