# from "Complete Interval Arithmetic and its Implementation on the Computer" by Ulrich W. Kulisch

function glb{S<:Sculpt, C<:Clay}(x::Flex{S,C}, y::Flex{S,C})
    lo = min(x.lo,y.lo)
    hi = min(x.hi,y.hi)
    (S)(minmax(lo,hi)...)
end

function lub{S<:Sculpt, C<:Clay}(x::Flex{S,C}, y::Flex{S,C})
    lo = max(x.lo,y.lo)
    hi = max(x.hi,y.hi)
    (S)(minmax(lo,hi)...)
end

function sup{S<:Sculpt, C<:Clay}(x::Flex{S,C}, y::Flex{S,C})
    lo = min(x.lo,y.lo)
    hi = max(x.hi,y.hi)
    (S)(minmax(lo,hi)...)
end

function inf{S<:Sculpt, C<:Clay}(x::Flex{S,C}, y::Flex{S,C})
    lo = max(x.lo,y.lo)
    hi = min(x.hi,y.hi)
    (S)(minmax(lo,hi)...)
end

# from "Standardized notation in interval analysis", R. B. Kearfott, et. al.
# width(diameter), radius, midpoint, mignitude, magnitude, deviation, absolutevalue

dia{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (x.hi - x.lo)
rad{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (x.hi - x.lo)/2
mid{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (x.lo + x.hi)/2
mig{S<:Sculpt, C<:Clay}(x::Flex{S,C}) =
   (signbit(x.lo)==signbit(x.hi)) ? min(abs(x.lo), abs(x.hi)) : 0
mag{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = max(abs(x.lo), abs(x.hi))
dev{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = (abs(x.lo) >= abs(x.hi)) ? x.lo : x.hi
abs{S<:Sculpt, C<:Clay}(x::Flex{S,C}) = Flex{S,C}(mig(x),mag(x))
dist{S<:Sculpt, C<:Clay}(x::Flex{S,C}, y::Flex{S,C}) = max(abs(x.lo-y.lo), abs(x.hi-y.hi))

