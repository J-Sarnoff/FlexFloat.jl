
@inline eftRound{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:ToZero}) = 
     (((signbit(hi)==signbit(lo)) | (lo==zero(T))) ? hi : nextNearerToZero(hi))

@inline eftRound{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:FromZero}) = 
    (((signbit(hi)!=signbit(lo)) | (lo == zero(T))) ? hi : nextAwayFromZero(hi))

@inline eftRound{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Up}) = 
    (((signbit(lo) | (lo == zero(T)))) ? hi : nextFloat(hi))

@inline eftRound{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Down}) = 
    (((signbit(lo) & (lo != zero(T)))) ? prevFloat(hi) : hi)

@inline eftRound{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Nearest}) = 
    (hi)
