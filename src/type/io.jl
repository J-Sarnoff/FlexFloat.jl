const Exactly   = "⌁"
const Inexactly = "~"
const OpenedOpened = "⍿"
const ClosedOpened = "⫯"
const OpenedClosed = "⫰"
const ClosedClosed = "∣"

#                        ClCl          ClOp            OpCl      OpOp
const Postfixes = ( ClosedClosed, ClosedOpened, OpenedClosed, OpenedOpened );
@inline postfixes(loIsOpen::Bool, hiIsOpen::Bool) =
      Postfixes[ one(Int8)+(reinterpret(Int8,loIsOpen)<<1)+hiIsOpen ]

# select characters corresponding to boundries as specified (lo,hi)
#   true for Open, false for Closed
#                     ClCl      ClOp        OpCl      OpOp
const Delimiters = [ ("▪","▪"), ("▪","▫"), ("▫","▪"), ("▫","▫") ];
@inline delimiters(loIsOpen::Bool, hiIsOpen::Bool) =
      Delimiters[ one(Int8)+(reinterpret(Int8,loIsOpen)<<1)+hiIsOpen ]

function show{S<:Sculpt, Q<:Qualia, C<:Clay}(io::IO, x::Flex{S,Q,C})
    tiesym = (Q==INEXACT) ? Inexactly : Exactly
    postfix = postfixes(boundries(S)...)
    delimLo, delimHi = delimiters(boundries(S)...)
    s = (x.lo != x.hi) ? string(delimLo, x.lo, tiesym, x.hi, delimHi) : string(delimLo,x.lo, delimHi)
    print(io, s)
end

function showcompact{S<:Sculpt, Q<:Qualia, C<:Clay}(io::IO, x::Flex{S,Q,C})
    tiesym = (Q==INEXACT) ? Inexactly : Exactly
    postfix = postfixes(boundries(S)...)
    delimLo, delimHi = delimiters(boundries(S)...)
    lo = @sprintf("%0.5g", x.lo)
    hi = @sprintf("%0.5g", x.hi)
    s = (x.lo != x.hi) ? string(lo, tiesym, hi) : string(delimLo, lo, delimHi)
    print(io, s)
end
