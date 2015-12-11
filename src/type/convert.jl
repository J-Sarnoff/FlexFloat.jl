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

function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Tuple{C,C}}, x::Flex{S,Q,C})
   lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
   lo = convert(C,lo)
   hi = convert(C,hi)
   (lo,hi)
end

function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Array{C,1}}, x::Flex{S,Q,C})
   lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
   lo = convert(C,lo)
   hi = convert(C,hi)
   [lo,hi]
end

function convert{S<:Sculpt,Q<:Qualia,C<:Clay,R<:Real}(::Type{R}, x::Flex{S,Q,C})
   lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
   lo = convert(R,lo)
   hi = convert(R,hi)
   if lo == hi
      lo
   else  
       mostRepresentativeValue(lo,hi)
   end
end


for (fn,S) in ( (:ClCl,:CLCL), (:ClOp,:CLOP), (:OpCl,:OPCL), (:OpOp,:OPOP),
                (:clcl,:CLCL), (:clop,:CLOP), (:opcl,:OPCL), (:opop,:OPOP) )
   @eval begin
       ($fn){T<:($S),Q<:Qualia,C<:Clay}(x::Flex{T,Q,C}) = x
   end
end

for (fn,Q,S) in ( (:ClCl,:INEXACT,:CLCL), (:ClOp,:INEXACT,:CLOP), (:OpCl,:INEXACT,:OPCL), (:OpOp,:INEXACT,:OPOP),
                  (:clcl,:EXACT,:CLCL), (:clop,:EXACT,:CLOP), (:opcl,:EXACT,:OPCL), (:opop,:EXACT,:OPOP) )
   @eval begin
       convert{C<:Clay}(::Type{Flex{$S,$Q,C}}, fp::C) = Flex{$S,$Q,C}(fp,fp)
       convert{C<:Clay}(::Type{Flex{$S,$Q,C}}, lo::C, hi::C) = Flex{$S,$Q,C}(minimax(lo,hi)...)
       ($fn){T<:($S),P<:($Q),C<:Clay}(fp::C) = Flex{T,P,C}(fp,fp)
       ($fn){T<:($S),P<:($Q),C<:Clay}(lo::C, hi::C) = Flex{T,P,C}(minimax(lo,hi)...)
   end
end

# see cvtQualia.jl to access conversion logic when qualia differ
