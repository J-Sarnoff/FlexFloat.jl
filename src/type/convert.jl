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
   lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
   lo = convert(C,lo)
   hi = convert(C,hi)
   (lo,hi)
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


for (fn) in (:ClCl, :ClOp, :OpCl, :OpOp, :clcl, :clop, :opcl, :clcl)
   @eval begin
       ($fn){S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = ($fn)(x.lo,x.hi)
   end
end

# see foryouruse.jl to access conversion logic when qualia differ
