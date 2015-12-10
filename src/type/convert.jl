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

@inline function convert{S<:Sculpt,Q<:Qualia,C<:Clay,R<:Real}(::Type{Tuple{R,R}}, x::Flex{S,Q,C})
   lo,hi = values(closed(x))
   lo = convert(R,lo)
   hi = convert(R,hi)
   (lo,hi)
end

convert{S<:Sculpt,Q<:Qualia,C<:Clay,R<:Real}(::Type{Vector{R}}, x::Flex{S,Q,C}) = [convert(Tuple{R,R}, x)...]

function convert{S<:Sculpt,Q<:Qualia,C<:Clay,R<:Real}(::Type{R}, x::Flex{S,Q,C})
   lo,hi = convert(Tuple{R,R}, x)
   if lo == hi
      lo
   else  
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
end



# see foryouruse.jl to access conversion logic when qualia differ
