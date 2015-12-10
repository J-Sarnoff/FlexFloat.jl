for T in (:CLCL, :CLOP, :OPCL, :OPOP)
   @eval begin
       function (sqrt){Q<:Qualia,C<:Clay}(a::Flex{$T,Q,C})
           lo = (sqrt)(a.lo, RoundDown)
           hi = (sqrt)(a.hi, RoundUp)
           Flex{$T,Q,C}(lo,hi)
       end
   end       
end
