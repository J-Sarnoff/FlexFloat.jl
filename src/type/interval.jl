widened{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C}) = Flex{S,Q,C}(prevFloat(a.lo), nextFloat(a.hi))

function narrowed{S<:Sculpt,Q<:Qualia,C<:Clay}(a::Flex{S,Q,C})
   lo, hi = nextFloat(a.lo), prevFloat(a.hi)
   if (lo > hi)
       a
   else
       Flex{S,Q,C}(lo,hi)
   end
end

# from "Complete Interval Arithmetic and its Implementation on the Computer" by Ulrich W. Kulisch

function glb{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}, y::Flex{S,Q,C})
    lo = min(x.lo,y.lo)
    hi = min(x.hi,y.hi)
    Flex{S,Q,C}(minmax(lo,hi)...)
end

function lub{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}, y::Flex{S,Q,C})
    lo = max(x.lo,y.lo)
    hi = max(x.hi,y.hi)
    Flex{S,Q,C}(minmax(lo,hi)...)
end

# supremum (join, interval [convex] hull) and an infimum (meet, intersection).
function supremum{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}, y::Flex{S,Q,C})
    lo = min(x.lo,y.lo)
    hi = max(x.hi,y.hi)
    Flex{S,Q,C}(minmax(lo,hi)...)
end

function infimum{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}, y::Flex{S,Q,C})
    lo = max(x.lo,y.lo)
    hi = min(x.hi,y.hi)
    Flex{S,Q,C}(minmax(lo,hi)...)
end


# from "Standardized notation in interval analysis", R. B. Kearfott, et. al.
# width(diameter), radius, midpoint, mignitude, magnitude, deviation, absolutevalue

dia{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = (x.hi - x.lo)
rad{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = (x.hi - x.lo)/2
mid{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = (x.lo + x.hi)/2
mig{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) =
   (signbit(x.lo)==signbit(x.hi)) ? min(abs(x.lo), abs(x.hi)) : 0
mag{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = max(abs(x.lo), abs(x.hi))
dev{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = (abs(x.lo) >= abs(x.hi)) ? x.lo : x.hi
abs{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}) = Flex{S,Q,C}(mig(x),mag(x))
dist{S<:Sculpt,Q<:Qualia,C<:Clay}(x::Flex{S,Q,C}, y::Flex{S,Q,C}) = max(abs(x.lo-y.lo), abs(x.hi-y.hi))

for fn in (:widened, :narrowed, :opened, :closed, :glb, :lub, :supremum, :infimum,
           :dia, :rad, :mid, :mig, :mag, :dev, :abs, :dist, :value, :isexact, :isinexact,
           :isclosedclosed, :isclosedopen, :isopenclosed, :isopenopen)
    @eval begin
        @vectorize_1arg Flex ($fn)
    end
end    
