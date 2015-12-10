module Reinterpret

import Base: unbox, box, reinterpret

for (utype,itype,ftype) in ((:UInt16, :Int16, :Float16), (:UInt32, :Int32, :Float32), (:UInt64, :Int64, :Float64))
    @eval begin
        reinterpret(::Type{Signed},   ::Type{$utype}) = ($itype)
        reinterpret(::Type{Signed},   ::Type{$ftype}) = ($itype)
        reinterpret(::Type{Unsigned}, ::Type{$itype}) = ($utype)
        reinterpret(::Type{Unsigned}, ::Type{$ftype}) = ($utype)
        reinterpret(::Type{AbstractFloat}, ::Type{$utype}) = ($ftype)
        reinterpret(::Type{AbstractFloat}, ::Type{$itype}) = ($ftype)
        
        reinterpret(::Type{Signed}, x::($utype))   = box($itype,unbox($utype,x))
        reinterpret(::Type{Signed}, x::($itype))   = x
        reinterpret(::Type{Signed}, x::($ftype))   = box($itype,unbox($ftype,x))

        reinterpret(::Type{Unsigned}, x::($utype)) = x
        reinterpret(::Type{Unsigned}, x::($itype)) = box($utype,unbox($itype,x))

        reinterpret(::Type{AbstractFloat}, x::($utype)) = box($ftype,unbox($utype,x))
        reinterpret(::Type{AbstractFloat}, x::($itype)) = box($ftype,unbox($itype,x))
        reinterpret(::Type{AbstractFloat}, x::($ftype)) = x
    end
end

for (utype,itype) in ((:UInt8, :Int8), (:UInt128, :Int128))
    @eval begin
        reinterpret(::Type{Signed}, x::($utype))   = box($itype,unbox($utype,x))
        reinterpret(::Type{Signed}, x::($itype))   = x
        reinterpret(::Type{Unsigned}, x::($utype)) = x
        reinterpret(::Type{Unsigned}, x::($itype)) = box($utype,unbox($itype,x))
    end
end

end # module
