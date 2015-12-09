
Flex{S<:Sculpt}(::Type{S}, lo::Real, hi::Real) = Flex(S, convert(Float64,lo), convert(Float64,hi))
Flex{S<:Sculpt}(::Type{S}, x::Real) = Flex(S, convert(Float64,x), convert(Float64,x))

function FlexLoHi{S<:Sculpt}(::Type{S}, lo::Real, hi::Real)
    low  = convert(Float64,lo)
    high = convert(Float64,hi)
    low,high = minmax(lo,hi)
    Flex{S,Float64}(lo,hi)
end    

ClCl(lo::Real,hi::Real) = Flex(CLCL, lo, hi)
ClOp(lo::Real,hi::Real) = Flex(CLOP, lo, hi)
OpCl(lo::Real,hi::Real) = Flex(OPCL, lo, hi)
OpOp(lo::Real,hi::Real) = Flex(OPOP, lo, hi)

ClCl(x::Real) = Flex(CLCL, x)
ClOp(x::Real) = Flex(CLOP, x)
OpCl(x::Real) = Flex(OPCL, x)
OpOp(x::Real) = Flex(OPOP, x)

# CC,OC,CO,OO are lo<=hi enforcing versions of ClCl,ClOp,OpCl,OpOp
CC(x::Real) = Flex(CLCL, x)
CO(x::Real) = Flex(CLOP, x)
OC(x::Real) = Flex(OPCL, x)
OO(x::Real) = Flex(OPOP, x)

CC(lo::Real,hi::Real) = FlexLoHi(CLCL, lo, hi)
function CO(lo::Real,hi::Real) 
   low = convert(Float64, lo)
   high = convert(Float64, hi)
   if low>high
      Flex(OPCL, high, low)
   else
      Flex(CLOP, low, high)
   end
end   
function OC(lo::Real,hi::Real) 
   low = convert(Float64, lo)
   high = convert(Float64, hi)
   if low>high
      Flex(CLOP, high, low)
   else
      Flex(OPCL,low, high)
   end
end   
OO(lo::Real,hi::Real) = FlexLoHi(OPOP, lo, hi)


convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,C}}, x::C) = Flex(S,x,x)
promote_rule{S<:Sculpt,C<:Clay}(::Type{Flex{S,C}}, ::Type{C}) = Flex{S,C}

function convert{S<:Sculpt,C<:Clay,T<:Union{Integer,AbstractFloat}}(::Type{Flex{S,C}}, x::T)
    fp = convert(C, x)
    Flex(S, fp, fp)
end
promote_rule{S<:Sculpt,C<:Clay,T<:Union{Integer,AbstractFloat}}(::Type{Flex{S,C}}, ::Type{T}) = Flex{S,C}
