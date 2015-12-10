const Exactly   = "⌁"
const Inexactly = "~"
const Simply    = "˳"
const Flexably = "⍿"
const OpenAbove = "⫯"
const OpenBelow = "⫰"

#                     ClCl      ClOp     OpCl      OpOp
const Postfixes = [ Simply, OpenAbove, OpenBelow, Flexably ];
@inline postfixes(loIsOpen::Bool, hiIsOpen::Bool) =
      Postfixes[ one(Int8)+(reinterpret(Int8,loIsOpen)<<1)+hiIsOpen ]

# select characters corresponding to boundries as specified (lo,hi)
#   true for Open, false for Closed
#                     ClCl      ClOp        OpCl      OpOp
const Delimiters = [ ("⟨","⟩"), ("⟨","⟫"), ("⟪","⟩"), ("⟪","⟫") ];

#                     ClCl      ClOp        OpCl      OpOp
#const Delimiters = [ (Flexable, Flexable), (Flexable, OpenAbove), (OpenBelow, Flexable), (OpenBelow,OpenAbove) ];

@inline delimiters(loIsOpen::Bool, hiIsOpen::Bool) =
      Delimiters[ one(Int8)+(reinterpret(Int8,loIsOpen)<<1)+hiIsOpen ]

function show{S<:Sculpt, Q<:Qualia, C<:Clay}(io::IO, x::Flex{S,Q,C})
    tiesym = (Q==INEXACT) ? Inexactly : Exactly
    postfix = postfixes(boundaries(S))
    delimLo, delimHi = delimiters(boundries(S)...)
    s = (x.lo != x.hi) ? string(x.lo, tiesym, x.hi) : string(x.lo, postfix)
    print(io, s)
end

function showcompact{S<:Sculpt, Q<:Qualia, C<:Clay}(io::IO, x::Flex{S,Q,C})
    tiesym = (Q==INEXACT) ? Inexactly : Exactly
    postfix = postfixes(boundaries(S))
    delimLo, delimHi = delimiters(boundries(S)...)
    lo = @sprintf("%0.5g", x.lo)
    hi = @sprintf("%0.5g", x.hi)
    s = (x.lo != x.hi) ? string(lo, Flexably, hi) : string(lo, postfix)
    print(io, s)
end
