const Approx = "~"
const Intraval = "⧞"
const Flexable = "⍿"
const OpenAbove = "⫯"
const OpenBelow = "⫰"

# select characters corresponding to boundries as specified (lo,hi)
#   true for Open, false for Closed
#                     ClCl      ClOp        OpCl      OpOp
#const Delimiters = [ ("⟨","⟩"), ("⟨","⟫"), ("⟪","⟩"), ("⟪","⟫") ];

#                     ClCl      ClOp        OpCl      OpOp
const Delimiters = [ (Flexable, Flexable), (Flexable, OpenAbove), (OpenBelow, Flexable), (OpenBelow,OpenAbove) ];

@inline delimiters(loIsOpen::Bool, hiIsOpen::Bool) =
      Delimiters[ one(Int8)+(reinterpret(Int8,loIsOpen)<<1)+hiIsOpen ]

function show{S<:Sculpt, Q<:Qualia, C<:Clay}(io::IO, x::Flex{S,Q,C})
    prefix = (Q==INEXACT) ? Approx : ""
    delimLo, delimHi = delimiters(boundries(S)...)
    # s = (x.lo != x.hi) ? string(x.lo, ", ", x.hi) : string(x.lo)
    s = (x.lo != x.hi) ? string(x.lo, Intraval, x.hi) : string(x.lo)
    s = string(prefix, delimLo, s, delimHi)
    print(io, s)
end

function showcompact{S<:Sculpt, Q<:Qualia, C<:Clay}(io::IO, x::Flex{S,Q,C})
    prefix = (Q==INEXACT) ? Approx : ""
    delimLo, delimHi = delimiters(boundries(S)...)
    lo = @sprintf("%0.4g", x.lo)
    hi = @sprintf("%0.5g", x.hi)
    # s = (x.lo != x.hi) ? lo : string(lo, ", ", hi)
    s = (x.lo != x.hi) ? lo : string(lo, Intraval, hi)
    s = string(prefix, delimLo, s, delimHi)
    print(io, s)
end
