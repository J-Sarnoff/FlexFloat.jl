
abstract RealInterval     <: Real

abstract AbstractBoundary
abstract BoundingState    <: AbstractBoundary
abstract ExactState          <: BoundingState
abstract ClosedState         <: BoundingState
abstract OpenState           <: BoundingState

# singleton types
type Exact  <: ExactState  end; ExactBound  = Exact()
type Closed <: ClosedState end; ClosedBound = Closed()
type Open   <: OpenState   end; OpenBound   = Open()

type FlexibleInterval{L<:BoundingState,H<:BoundingState,F<:AbstractFloat} <: Real
    lo::F
    hi::F
    blo::L
    bhi::H
end

# fi = FlexibleInterval( 0.0f0, 1.0f0, ExactBound, ClosedBound )

