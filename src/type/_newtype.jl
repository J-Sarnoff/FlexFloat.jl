
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

type FlexibleInterval{LoState,HiState} <: Real
    lo::Real
    hi::Real
end

# fi = FlexibleIterval{LoState,HiState}(1.0,2.0)
# FlexibleInterval{Exact,Closed}(1.0, 2.0)
