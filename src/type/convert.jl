
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


convert{C<:Clay}(::Type{Flex{CLCL,C}}, x::Flex{CLOP,C}) = closed(x)
convert{C<:Clay}(::Type{Flex{CLCL,C}}, x::Flex{OPCL,C}) = closed(x)
convert{C<:Clay}(::Type{Flex{CLCL,C}}, x::Flex{OPOP,C}) = closed(x)
convert{C<:Clay}(::Type{Flex{CLCL,C}}, x::Flex{OPCL,C}) = closed(x)
convert{C<:Clay}(::Type{Flex{CLCL,C}}, x::Flex{CLOP,C}) = closed(x)
convert{C<:Clay}(::Type{Flex{CLCL,C}}, x::Flex{OPOP,C}) = closed(x)
convert{C<:Clay}(::Type{Flex{CLOP,C}}, x::Flex{OPCL,C}) = clopened(x)
convert{C<:Clay}(::Type{Flex{CLOP,C}}, x::Flex{CLCL,C}) = clopened(x)
convert{C<:Clay}(::Type{Flex{CLOP,C}}, x::Flex{OPOP,C}) = clopened(x)
convert{C<:Clay}(::Type{Flex{OPCL,C}}, x::Flex{CLOP,C}) = opclosed(x)
convert{C<:Clay}(::Type{Flex{OPCL,C}}, x::Flex{CLCL,C}) = opclosed(x)
convert{C<:Clay}(::Type{Flex{OPCL,C}}, x::Flex{OPOP,C}) = opclosed(x)

promote_rule{C<:Clay}(::Type{Flex{CLCL,C}}, ::Type{Flex{CLOP,C}}) = Flex{CLCL,C}
promote_rule{C<:Clay}(::Type{Flex{CLCL,C}}, ::Type{Flex{OPCL,C}}) = Flex{CLCL,C}
promote_rule{C<:Clay}(::Type{Flex{CLCL,C}}, ::Type{Flex{OPOP,C}}) = Flex{CLCL,C}
promote_rule{C<:Clay}(::Type{Flex{CLOP,C}}, ::Type{Flex{OPCL,C}}) = Flex{CLCL,C}
promote_rule{C<:Clay}(::Type{Flex{CLOP,C}}, ::Type{Flex{OPOP,C}}) = Flex{CLOP,C}
promote_rule{C<:Clay}(::Type{Flex{OPCL,C}}, ::Type{Flex{OPOP,C}}) = Flex{OPCL,C}

#=
promote_rule(::Type{CLCL}, ::Type{CLOP}) = CLCL
promote_rule(::Type{CLCL}, ::Type{OPCL}) = CLCL
promote_rule(::Type{CLOP}, ::Type{OPCL}) = CLCL
promote_rule(::Type{CLCL}, ::Type{OPOP}) = CLCL
promote_rule(::Type{CLOP}, ::Type{OPOP}) = CLOP
promote_rule(::Type{OPCL}, ::Type{OPOP}) = OPCL
=#

convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,C}}, hi::C, lo::C) = Flex(S,hi,lo)
convert{S<:Sculpt,C<:Clay}(::Type{S}, hi::C, lo::C) = convert(Flex{S,C},hi,lo)

convert{S<:Sculpt,C<:Clay}(::Type{Flex{S,C}}, x::C) = Flex(S,x,x)
convert{S<:Sculpt,C<:Clay}(::Type{S}, x::C) = convert(Flex{S,C},x)

#=
function convert{S<:Sculpt,C<:Clay,T<:Union{Integer,AbstractFloat}}(::Type{Flex{S,C}}, x::T)
    fp = convert(C, x)
    Flex(S, fp, fp)
end
convert{S<:Sculpt,T<:Union{Integer,AbstractFloat}}(::Type{S}, x::T) = convert(Flex{S,Float64}, convert(Float64,x))
promote_rule{S<:Sculpt,C<:Clay,T<:Union{Integer,AbstractFloat}}(::Type{Flex{S,C}}, ::Type{T}) = Flex{S,C}
promote_rule{S<:Sculpt,T<:Union{Integer,AbstractFloat}}(::Type{S}, ::Type{T}) = Flex{S,Float64}
=#

function convert{S<:Sculpt,C<:Clay,T<:Real}(::Type{Flex{S,C}}, x::T)
    fp = convert(C, x)
    Flex(S, fp, fp)
end
convert{S<:Sculpt}(::Type{S}, x::S) = x # quiet ambig notice
function convert{S<:Sculpt,C<:Clay,T<:Real}(::Type{S}, x::T)
    fp = convert(Float64, x)
    Flex(S, fp, fp)
end

# coverting to a single floating point value
# unfortunately this is needed to interoperate with other types
function convert{S<:Sculpt,C<:Clay}(::Type{C}, x::Flex{S,C})
    if (x.lo == x.hi)
       x.lo
    else
      y = opened(x)
      if (y.lo == y.hi)
         y.lo
      else
         mid(y)
      end
    end
end    
    

