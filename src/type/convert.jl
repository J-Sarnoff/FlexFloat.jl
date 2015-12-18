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


# to eliminate ambiguity
function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Bool}, x::Flex{S,Q,C})
   lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
   lo = lo != zero(C)
   hi = hi != zero(C)
   if lo == hi
      lo
   else
      false
   end
end

for T in (:Int64, :Int32, :Int16)
    @eval begin
        function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{$T}, x::Flex{S,Q,C})
           lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
           lo = trunc($T,trunc(lo))
           hi = trunc($T,trunc(hi))
           if lo == hi
              lo
           else
              trunc($T, trunc(mostRepresentativeValue(x.lo,x.hi)))
           end
        end
    end
end

# to eliminate ambiguity
function convert{S<:Sculpt,Q<:Qualia,C<:Clay}(::Type{Integer}, x::Flex{S,Q,C})
   lo,hi = (Q==CLCL) ? value(x) : value(opened(x))
   lo = trunc(Integer,lo)
   hi = trunc(Integer,hi)
   if lo == hi
      lo
   else
      trunc(Integer, trunc(mostRepresentativeValue(x.lo,x.hi)))
   end
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
       convert{C<:Clay}(::Type{Flex{$S,$Q,C}}, lo::C, hi::C) = Flex{$S,$Q,C}(minmax(lo,hi)...)
       ($fn){C<:Clay}(fp::C) = Flex{$S,$Q,C}(fp,fp)
       ($fn){C<:Clay}(lo::C, hi::C) = Flex{$S,$Q,C}(minmax(lo,hi)...)
   end
end

# see cvtQualia.jl to access conversion logic when qualia differ


# promoting to a third type

for C in (:Float64, :Float32)
  for (S,T,U) in ((:Flex{CLCL,EXACT,(C)},:Flex{CLOP,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{CLOP,EXACT,(C)},:Flex{CLCL,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{CLCL,EXACT,(C)},:Flex{OPCL,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{OPCL,EXACT,(C)},:Flex{CLCL,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{CLCL,EXACT,(C)},:Flex{OPOP,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{OPOP,EXACT,(C)},:Flex{CLCL,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{CLOP,EXACT,(C)},:Flex{OPCL,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{OPCL,EXACT,(C)},:Flex{CLOP,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{CLOP,EXACT,(C)},:Flex{OPCL,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{OPCL,EXACT,(C)},:Flex{CLOP,INEXACT,(C)}, :Flex{CLCL,INEXACT,(C)}),
                  (:Flex{CLOP,EXACT,(C)},:Flex{OPOP,INEXACT,(C)}, :Flex{CLOP,INEXACT,(C)}),
                  (:Flex{OPOP,EXACT,(C)},:Flex{CLOP,INEXACT,(C)}, :Flex{CLOP,INEXACT,(C)})
                  )
     @eval begin
       convert(::Type{$U}, x::($S)) = ($U)(x.lo,x.hi)
       promote_rule{::Type{$S},::Type{$T}} = ($U)
     end
   end  
end

