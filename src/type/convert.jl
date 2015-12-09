
Flex{S<:Sculpt}(::Type{S}, lo::Real, hi::Real) = Flex(S, convert(Float64,lo), convert(Float64,hi))
Flex{S<:Sculpt}(::Type{S}, x::Real) = Flex(S, convert(Float64,x), convert(Float64,x))
function FlexLoHi{S<:Sculpt}(::Type{S}, lo::Real, hi::Real)
    low  = convert(Float64,lo)
    high = convert(Float64,hi)
    low,high = minmax(lo,hi)
    Flex{S,Float64}(lo,hi)
end    

ClCl(lo::Real,hi::Real) = Flex(ClCl, lo, hi)
ClOp(lo::Real,hi::Real) = Flex(ClOp, lo, hi)
OpCl(lo::Real,hi::Real) = Flex(OpCl, lo, hi)
OpOp(lo::Real,hi::Real) = Flex(OpOp, lo, hi)

ClCl(x::Real) = Flex(ClCl, x)
ClOp(x::Real) = Flex(ClOp, x)
OpCl(x::Real) = Flex(OpCl, x)
OpOp(x::Real) = Flex(OpOp, x)

# CC,OC,CO,OO are lo<=hi enforcing versions of ClCl,ClOp,OpCl,OpOp
CC(x::Real) = Flex(ClCl, x)
CO(x::Real) = Flex(ClOp, x)
OC(x::Real) = Flex(OpCl, x)
OO(x::Real) = Flex(OpOp, x)

CC(lo::Real,hi::Real) = FlexLoHi(ClCl, lo, hi)
function CO(lo::Real,hi::Real) 
   low = convert(Float64, lo)
   high = convert(Float64, hi)
   if low>high
      Flex(OpCl, high, low)
   else
      Flex(ClOp, low, high)
   end
end   
function OC(lo::Real,hi::Real) 
   low = convert(Float64, lo)
   high = convert(Float64, hi)
   if low>high
      Flex(ClOp, high, low)
   else
      Flex(OpCl,low, high)
   end
end   
OO(lo::Real,hi::Real) = FlexLoHi(OpOp, lo, hi)
