tanh(x::Float64, ::Type{RoundingMode{:Nearest}}) = 
   sinh(x, RoundingMode{:Nearest}) / cosh(x, RoundingMode{:Nearest})

function tanh(x::Float64, ::Type{RoundingMode{:Down}})
   t = sinh(x, RoundingMode{:Nearest})
   c = cosh(x, RoundingMode{:Nearest})
   with_rounding(Float64, RoundDown) do
       t = t/c
   end
   t
end
function tanh(x::Float64, ::Type{RoundingMode{:Up}})
   t = sinh(x, RoundingMode{:Nearest})
   c = cosh(x, RoundingMode{:Nearest})
   with_rounding(Float64, RoundUp) do
       t = t/c
   end
   t
end

for (fn, invfn) in ((:csc,:sin),(:sec,:cos),(:cot,:tan))
    @eval begin
        function ($fn)(x::Float64, ::Type{RoundingMode{:Up}})
            y= $(invfn)(x, RoundingMode{:Nearest})
            with_rounding(Float64, RoundDown) do
               y = 1.0 / y
            end
            y
        end    
        function ($fn)(x::Float64, ::Type{RoundingMode{:Down}})
            y= $(invfn)(x, RoundingMode{:Nearest})
            with_rounding(Float64, RoundUp) do
               y = 1.0 / y
            end
            y
        end    
        function ($fn)(x::Float64, ::Type{RoundingMode{:Nearest}})
            y = $(invfn)(x, RoundingMode{:Nearest})
            z = $(fn)(y)
            s = sign(y-z)
            if s < 0.0
               with_rounding(Float64, RoundDown) do
                   y = 1.0 / y
               end
            elseif x > 1.0
               with_rounding(Float64, RoundUp) do
                   y = 1.0 / y
               end
            else
               y = 1.0 / y
            end
            y
        end    
     
    end
end
