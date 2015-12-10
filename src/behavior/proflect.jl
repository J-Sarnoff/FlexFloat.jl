#=

    project stationary quantitude and reflect projection into stationed quantity
=#

typealias Float AbstractFloat

function project(fp::Float)
    if isfinite(fp)
       if fp <= AsTiny
           TinyProjected
       elseif fp >= AsHuge
           HugeProjected
       else
           pushout(fp)
       end
    else  # ±Inf or NaN
       fp
    end
end    

@inline function pushout{F<:Float}(fp::F)
   stationedExponent = get_exponent(fp) - Bias(F)
   put_exponent(fp, stationedExponent)
end

function reflect(fp::Float)
    if isfinite(fp)
       if fp <= TinyProjected
           Tiny
       elseif fp >= HugeProjected
           Huge
       else
           pullback(fp)
       end
    else # ±Inf or NaN
        fp
    end
end

@inline function pullback{F<:Float}(fp::F)
   stationaryExponent = get_exponent(fp) + Bias(F)
   put_exponent(fp, stationaryExponent)
end

