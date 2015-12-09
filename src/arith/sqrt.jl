for T in (:CLCL, :CLOP, :OPCL, :OPOP)
   @eval begin
       function (sqrt){C<:Clay}(a::Flex{$T,C})
           lo = (sqrt)(a.lo, b.lo, RoundDown)
           hi = (sqrt)(a.hi, b.hi, RoundUp)
           Flex{$T,C}(lo,hi)
       end
   end       
end
