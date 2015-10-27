Strict

Public

' Imports:
Import regal.vector

Import polygon

' Interfaces:
' Nothing so far.

' Classes:

' A basic representation of a rectangle polygon.
Class Rect Extends Polygon ' Final
	' Constant variable(s):
	Const PointArraySize:Int			= (4*2) ' X, Y.
	
	Const TopLeft_Position:Int			= 2 ' 0
	Const TopRight_Position:Int			= 0 ' 2
	Const BottomLeft_Position:Int		= 4 ' 4
	Const BottomRight_Position:Int		= 6 ' 6
	
	' Constructor(s):
	Method New()
		' Call the super-class's implementation.
		Super.New(PointArraySize) ' False
		
		InitRect(False)
	End
	
	Method New(TopLeft:Vector2D<Float>, BottomLeft:Vector2D<Float>, BottomRight:Vector2D<Float>, TopRight:Vector2D<Float>)
		' Call the super-class's implementation.
		Super.New(PointArraySize)
		
		' Call the initialization command.
		InitRect(TopLeft, BottomLeft, TopRight, BottomRight, False)
	End
	
	Method New(X:Float, Y:Float, Width:Float, Height:Float)
		' Call the super-class's implementation.
		Super.New(PointArraySize)
		
		' Call the initialization command.
		InitRect(X, Y, Width, Height, False)
	End
	
	Method InitRect:Rect(TopLeft:Vector2D<Float>, BottomLeft:Vector2D<Float>, BottomRight:Vector2D<Float>, TopRight:Vector2D<Float>, Callup:Bool=True)
		InitRect(Callup)
		
		TopLeftX = TopLeft.X
		TopLeftY = TopLeft.Y
		
		TopRightX = TopRight.X
		TopRightY = TopRight.Y
		
		BottomLeftX = BottomLeft.X
		BottomLeftY = BottomLeft.Y
		
		BottomRightX = BottomRight.X
		BottomRightY = BottomRight.Y
		
		' Return this object for the sake of pooling.
		Return Self
	End
	
	Method InitRect:Rect(X:Float, Y:Float, Width:Float, Height:Float, Callup:Bool=True)
		InitRect(Callup)
		
		Self.TopLeftX = X
		Self.TopLeftY = Y
		
		Self.BottomRightX = X+Width
		Self.BottomRightY = Y+Height
		
		Self.BottomLeftX = Self.TopLeftX
		Self.BottomLeftY = Self.BottomRightY
		Self.TopRightX = Self.BottomRightX
		Self.TopRightY = Self.TopLeftY
		
		' Return this object for the sake of pooling.
		Return Self
	End
	
	Method InitRect:Rect(Callup:Bool=True)
		' Call the super-class's initialization command.
		If (Callup) Then Init(PointArraySize)
		
		' Return this object for the sake of pooling.
		Return Self
	End
	
	' Methods:
	Method Resize:Void(Width:Float, Height:Float)
		' Local variable(s):
		Local WDist:Float = Width - (MaximumX - MinimumX)
		Local HDist:Float = Height - (MaximumY - MinimumY)
		
		TopRightX += WDist
		BottomRightX += WDist
		
		BottomLeftY += HDist
		BottomRightY += HDist
		
		Return
	End
	
	Method Resize:Void(Width:Float, Height:Float, X:Float, Y:Float, Center:Bool=False)
		Resize(Width, Height)
		
		' Local variable(s):
		Local MinX:Float, MinY:Float
		Local MaxX:Float, MaxY:Float
		
		MaxX = MaximumX
		MaxY = MaximumY
		MinX = MinimumX
		MinY = MinimumY
		
		TopLeftX = X
		TopLeftY = Y
		
		TopRightX = X+(MaxX-MinX)
		TopRightY = Y
		
		BottomLeftX = X
		BottomLeftY = Y+(MaxY-MinY)
		
		BottomRightX = TopRightX
		BottomRightY = BottomLeftY
		
		If (Center) Then
			MinX = MinimumX
			MinY = MinimumY
			
			MaxX = MaximumX
			MaxY = MaximumY
			
			' Local variable(s):
			Local XMid:Float = (MaxX - MinX) / 2
			Local YMid:Float = (MaxY - MinY) / 2
			
			TopLeftX -= XMid
			TopRightX -= XMid
			BottomLeftX -= XMid
			BottomRightX -= XMid
			
			TopLeftY -= YMid
			TopRightY -= YMid
			BottomLeftY -= YMid
			BottomRightY -= YMid
		Endif
		
		Return
	End
	
	Method SetPosition_Fast:Void(X:Float, Y:Float)
		Local Width:Float = (BottomRightX-TopLeftX)
		Local Height:Float = (BottomRightY-TopLeftY)
		
		Self.TopLeftX = X
		Self.TopLeftY = Y
		
		Self.BottomRightX = X+Width
		Self.BottomRightY = Y+Height
		
		Self.BottomLeftX = Self.TopLeftX
		Self.BottomLeftY = Self.BottomRightY
		Self.TopRightX = Self.BottomRightX
		Self.TopRightY = Self.TopLeftY
		
		Return
	End
	
	' Properties:
	Method Width:Float() Property
		Return (BottomRightX-TopLeftX)
	End
	
	Method Height:Float() Property
		Return (BottomRightY-TopLeftY)
	End
	
	Method MaximumX:Float() Property
		Return BottomRightX
	End
	
	Method MaximumY:Float() Property
		Return BottomRightY
	End
	
	Method MinimumX:Float() Property
		Return TopLeftX
	End
	
	Method MinimumY:Float() Property
		Return TopLeftY
	End
	
	Method X:Float() Property
		Return TopLeftX
	End
	
	Method Y:Float() Property
		Return TopLeftY
	End
	
	Method TopLeftX:Float() Property
		Return Points[TopLeft_Position]
	End
	
	Method TopLeftX:Void(Value:Float) Property
		Points[TopLeft_Position] = Value
		
		Return
	End
	
	Method TopLeftY:Float() Property
		Return Points[TopLeft_Position+1]
	End
	
	Method TopLeftY:Void(Value:Float) Property
		Points[TopLeft_Position+1] = Value
		
		Return
	End
	
	Method TopRightX:Float() Property
		Return Points[TopRight_Position]
	End
	
	Method TopRightX:Void(Value:Float) Property
		Points[TopRight_Position] = Value
		
		Return
	End
	
	Method TopRightY:Float() Property
		Return Points[TopRight_Position+1]
	End
	
	Method TopRightY:Void(Value:Float) Property
		Points[TopRight_Position+1] = Value
		
		Return
	End
	
	Method BottomLeftX:Float() Property
		Return Points[BottomLeft_Position]
	End
	
	Method BottomLeftX:Void(Value:Float) Property
		Points[BottomLeft_Position] = Value
		
		Return
	End
	
	Method BottomLeftY:Float() Property
		Return Points[BottomLeft_Position+1]
	End
	
	Method BottomLeftY:Void(Value:Float) Property
		Points[BottomLeft_Position+1] = Value
		
		Return
	End
	
	Method BottomRightX:Float() Property
		Return Points[BottomRight_Position]
	End
	
	Method BottomRightX:Void(Value:Float) Property
		Points[BottomRight_Position] = Value
		
		Return
	End
	
	Method BottomRightY:Float() Property
		Return Points[BottomRight_Position+1]
	End
	
	Method BottomRightY:Void(Value:Float) Property
		Points[BottomRight_Position+1] = Value
		
		Return
	End
End