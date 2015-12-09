# select characters corresponding to boundries as specified (lo,hi)
#   true for Open, false for Closed
#                     ClCl      ClOp        OpCl      OpOp
const Delimiters = [ ("⟨","⟩"), ("⟨","⟫"), ("⟪","⟩"), ("⟪","⟫") ];
@inline delimiters(loIsOpen::Bool, hiIsOpen::Bool) =
      Delimiters[ one(Int8)+(reinterpret(Int8,loIsOpen)<<1)+hiIsOpen ]

function show{S<:Sculpt, C<:Clay}(io::IO, x::Flex{S,C})
    delimLo, delimHi = delimiters(boundries(S)...)
    s = (x.lo != x.hi) ? string(x.lo, ", ", x.hi) : string(x.lo)
    print(io, string(delimLo, s, delimHi))
end

function showcompact{S<:Sculpt, C<:Clay}(io::IO, x::Flex{S,C})
    delimLo, delimHi = delimiters(boundries(S)...)
    lo = @sprintf("%0.4g", x.lo)
    hi = @sprintf("%0.5g", x.hi)
    s = (x.lo != x.hi) ? lo : string(lo, ", ", hi)
    print(io, string(delimLo, s, delimHi))
end
