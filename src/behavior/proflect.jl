#=

    project stationary quantitude and reflect projection into stationed quantity
=#

typealias Float AbstractFloat

@inline iscommon{F<:Float}(fp::F) = (isfinite(fp) && !(fp==zero(F)))

function project{F<:Float}(fp::F)
    if iscommon(fp)
       if fp <= AsTiny(F)
           TinyProjected(F)
       elseif fp >= AsHuge(F)
           HugeProjected(F)
       else
           pushout(fp)
       end
    else  # ±0.0 ±Inf or NaN
       fp
    end
end    

@inline function pushout{F<:Float}(fp::F)
   stationedExponent = get_exponent(fp) - Bias(F)
   reinterpret(F,put_exponent(fp, stationedExponent))
end

function reflect{F<:Float}(fp::F)
    fp = clr_ebit(fp)
    if iscommon(fp)
       if fp <= TinyProjected(F)
           Tiny(F)
       elseif fp >= HugeProjected(F)
           Huge(F)
       else
           pullback(fp)
       end
    else # ±0.0 or ±Inf or NaN
        fp
    end
end

@inline function pullback{F<:Float}(fp::F)
   stationaryExponent = get_exponent(fp) + Bias(F)
   reinterpret(F,put_exponent(fp, stationaryExponent))
end

