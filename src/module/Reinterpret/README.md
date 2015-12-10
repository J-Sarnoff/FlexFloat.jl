# Reinterpret
extends reinterpret to work more generally with Unsigned, Signed, AbstractFloat

```julia
julia> reinterpret(Signed,1.0)
4607182418800017408

julia> reinterpret(AbstractFloat,ans)
1.0

julia> reinterpret(Signed,Float32(1.0))
1065353216

julia> reinterpret(AbstractFloat,ans)
1.0f0
```
