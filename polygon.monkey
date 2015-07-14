Strict

Public

' Preprocessor related:
#If BRL_GAMETARGET_IMPLEMENTED
	#POLYGON_GRAPHICS = True
	'#POLYGON_MOJO2 = True
#End

#POLYGON_IO_ENABLED = True

' Imports (Public):

' Internal:
Import rect

' External:

' Unofficial:
Import vector

' Official:

#If POLYGON_GRAPHICS And BRL_GAMETARGET_IMPLEMENTED
	#If Not POLYGON_MOJO2
		' Import graphical functionality.
		Import mojo.graphics
	#Else
		Import mojo2.graphics
	#End
#End

'Import brl.pool

' Imports (Private):
Private

' External:
#If POLYGON_IO_ENABLED
	Import brl.stream
#End

Public

' Interfaces:
Interface Polygon_Approximation
	' Methods:
	' Nothing so far.
	
	' Properties:
	Method MaximumX:Float() Property
	Method MaximumY:Float() Property
	Method MinimumX:Float() Property
	Method MinimumY:Float() Property
End

Interface Rectangle_Approximation
	' Methods:
	' Nothing so far.
	
	' Properties:
	
	' These should be assumed as the top-left of the rectangle:
	Method X:Float() Property
	Method Y:Float() Property
	
	Method Width:Float() Property
	Method Height:Float() Property
End

' Classes:

' A basic 2D polygon container.
Class Polygon Implements Polygon_Approximation, Rectangle_Approximation
	' Functions:
	Function Edge:Void(P1:Vector2D<Float>, P2:Vector2D<Float>, Output:Vector2D<Float>)
		Edge(P1.X, P1.Y, P2.X, P2.Y, Output)
		
		Return
	End
	
	Function Edge:Void(P1_X:Float, P1_Y:Float, P2_X:Float, P2_Y:Float, Output:Vector2D<Float>)
		' Copy the first projection to the output vector,
		' then subtract the second projection:
		Output.X = (P1_X - P2_X)
		Output.Y = (P1_Y - P2_Y)
		
		Output.Normalize()
		
		'Output.AsReversePerpendicular()
		Output.AsPerpendicular()
		
		Return
	End
	
	Function RotateAroundPoint:Void(XY:Float[], CX:Float, CY:Float, Angle:Float=0.0, Offset:Int=0)
		Local s:= Sin(Angle)
		Local c:= Cos(Angle)
		
		XY[Offset] -= CX
		XY[Offset+1] -= CY
		
		Local XNew:Float = (XY[Offset] * c - XY[Offset+1] * s)
		Local YNew:Float = (XY[Offset] * s + XY[Offset+1] * c)
		
		XY[Offset] = XNew + CX
		XY[Offset+1] = YNew + CY
		
		Return
	End
	
	Function QuadContained:Bool(TL_X:Float, TL_Y:Float, BR_X:Float, BR_Y:Float, Target_TL_X:Float, Target_TL_Y:Float, Target_BR_X:Float, Target_BR_Y:Float)
		Return ((TL_X >= Target_TL_X And BR_X <= Target_BR_X) And (TL_Y >= Target_TL_Y And BR_Y <= Target_BR_Y))
	End
	
	Function QuadsIntersecting:Bool(TL_X:Float, TL_Y:Float, BR_X:Float, BR_Y:Float, Target_TL_X:Float, Target_TL_Y:Float, Target_BR_X:Float, Target_BR_Y:Float)
		Return (((TL_X > Target_TL_X Or BR_X > Target_TL_X) And TL_X < Target_BR_X) And ((TL_Y > Target_TL_Y Or BR_Y > Target_TL_Y) And TL_Y < Target_BR_Y))
	End
	
	Function QuadsOnlyIntersecting:Bool(TL_X:Float, TL_Y:Float, BR_X:Float, BR_Y:Float, Target_TL_X:Float, Target_TL_Y:Float, Target_BR_X:Float, Target_BR_Y:Float)
		If (QuadsIntersecting(TL_X, TL_Y, BR_X, BR_Y, Target_TL_X, Target_TL_Y, Target_BR_X, Target_BR_Y)) Then
			Return ((Not QuadContained(TL_X, TL_Y, BR_X, BR_Y, Target_TL_X, Target_TL_Y, Target_BR_X, Target_BR_Y)) And (Not QuadContained(Target_TL_X, Target_TL_Y, Target_BR_X, Target_BR_Y, TL_X, TL_Y, BR_X, BR_Y)))
		Endif
		
		' Return the default response.
		Return False
	End
	
	' The X and Y coordinates are assumed as the top-left positions of the rectangles:
	Function RectangleContained:Bool(X:Float, Y:Float, Width:Float, Height:Float, X2:Float, Y2:Float, Width2:Float, Height2:Float)
		Return QuadContained(X, Y, X+Width, Y+Height, X2, Y2, X2+Width2, Y2+Height2)
	End
	
	Function RectanglesIntersecting:Bool(X:Float, Y:Float, Width:Float, Height:Float, X2:Float, Y2:Float, Width2:Float, Height2:Float)
		Return QuadsIntersecting(X, Y, X+Width, Y+Height, X2, Y2, X2+Width2, Y2+Height2)
	End
	
	Function RectanglesOnlyIntersecting:Bool(X:Float, Y:Float, Width:Float, Height:Float, X2:Float, Y2:Float, Width2:Float, Height2:Float)
		Return QuadsOnlyIntersecting(X, Y, X+Width, Y+Height, X2, Y2, X2+Width2, Y2+Height2)
	End
	
	' Simplified overloads:
	Function RectangleContained:Bool(X:Rectangle_Approximation, Y:Rectangle_Approximation)
		Return RectangleContained(X.X, X.Y, X.Width, X.Height, Y.X, Y.Y, Y.Width, Y.Height)
	End
	
	Function RectanglesIntersecting:Bool(X:Rectangle_Approximation, Y:Rectangle_Approximation)
		Return RectanglesIntersecting(X.X, X.Y, X.Width, X.Height, Y.X, Y.Y, Y.Width, Y.Height)
	End
	
	Function RectanglesOnlyIntersecting:Bool(X:Rectangle_Approximation, Y:Rectangle_Approximation)
		Return RectanglesOnlyIntersecting(X.X, X.Y, X.Width, X.Height, Y.X, Y.Y, Y.Width, Y.Height)
	End
	
	' Constructor(s):
	Method New(PointArraySize:Int=0)
		Init(PointArraySize)
	End
	
	Method Init:Polygon(PointArraySize:Int=0)
		CreatePoints(PointArraySize)
		
		' Return this object so it may be pooled.
		Return Self
	End
	
	' This will resize the internal point-array.
	Method CreatePoints:Bool(PointArraySize:Int)		
		If (PointArraySize > 0) Then
			If (Points.Length = 0) Then
				Points = New Float[PointArraySize]
			Else
				Points = Points.Resize(PointArraySize)
			Endif
		Endif
		
		' Return the default response.
		Return True
	End
	
	' Destructor(s):
	Method Free:Polygon()
		Return Reset()
	End
	
	' This will manually reset every vertex to 0.0.
	Method Reset:Polygon()
		For Local I:= 0 Until Points.Length
			Points[I] = 0.0
		Next
		
		' Return this object so it may be pooled.
		Return Self
	End
	
	' Methods:
	Method SetPosition:Void(X:Float, Y:Float)
		Local CX:= Self.CenterX
		Local CY:= Self.CenterY
		
		For Local I:= 0 Until Points.Length Step 2
			Points[I] = X + (CX-Points[I])
			Points[I+1] = Y + (CY-Points[I+1])
		Next
		
		Return
	End
	
	Method Contains:Bool(Target:Polygon_Approximation)
		Return QuadContained(Target.MinimumX, Target.MinimumY, Target.MaximumX, Target.MaximumY, MinimumX, MinimumY, MaximumX, MaximumY)
	End
	
	Method Intersecting:Bool(Target:Polygon_Approximation)
		Return QuadsIntersecting(MinimumX, MinimumY, MaximumX, MaximumY, Target.MinimumX, Target.MinimumY, Target.MaximumX, Target.MaximumY)
	End
	
	' This command is mainly for debugging; it's best not to use this for anything else.
	#If POLYGON_GRAPHICS
		#If Not POLYGON_MOJO2
			Method Draw:Void()
		#Else
			Method Draw:Void(graphics:DrawList)
		#End
				graphics.DrawPoly(Points)
				
				Return
			End
	#End
	
	' I/O related:
	#If POLYGON_IO_ENABLED
		Method Read:Void(S:Stream)
			' Local variable(s):
			Local ArraySize:= (S.ReadShort()*2)
			
			Init(ArraySize)
			
			For Local I:= 0 Until ArraySize
				Points[I] = S.ReadFloat()
			Next
			
			Return
		End
		
		Method Write:Void(S:Stream)
			' Local variable(s):
			Local Points_Length:= Points.Length
			
			S.WriteShort(S, Points_Length/2)
			
			For Local I:= 0 Until Points_Length
				S.WriteFloat(Points[I])
			Next
			
			Return
		End
	#End
	
	' Properties (Public):
	
	' These are basically modified versions of 'Project':
	' (They do not use MinimumX and MinimumY for the sake of speed)
	Method Width:Float() Property
		Local MinX:Float, MaxX:Float
		
		MinX = Points[0]
		MaxX = MinX
		
		For Local Index:= 2 Until Points.Length Step 2
			' Local variable(s):
			Local X:= Points[Index]
			
			If (X < MinX) Then
				MinX = X
			Elseif (X > MaxX) Then
				MaxX = X
			Endif
		Next
		
		Return MaxX - MinX
		'Return MaximumX - MinimumX
	End
	
	Method Height:Float() Property
		Local MinY:Float, MaxY:Float
		
		MinY = Points[1]
		MaxY = MinY
		
		For Local Index:= 3 Until Points.Length Step 2
			' Local variable(s):
			Local Y:= Points[Index]
			
			If (Y < MinY) Then
				MinY = Y
			Elseif (Y > MaxY) Then
				MaxY = Y
			Endif
		Next
		
		Return MaxY - MinY
		'Return MaximumY - MinimumY
	End
	
	Method MaximumX:Float() Property
		' Local variable(s):
		Local MaxX:Float = Points[0]
		
		For Local Index:= 2 Until Points.Length Step 2
			' Local variable(s):
			Local X:= Points[Index]
			
			If (X > MaxX) Then
				MaxX = X
			Endif
		Next
		
		Return MaxX
	End
	
	Method MaximumY:Float() Property
		' Local variable(s):
		Local MaxY:Float = Points[1]
		
		For Local Index:= 3 Until Points.Length Step 2
			' Local variable(s):
			Local Y:= Points[Index]
			
			If (Y > MaxY) Then
				MaxY = Y
			Endif
		Next
		
		Return MaxY
	End
	
	Method MinimumX:Float() Property
		' Local variable(s):
		Local MinX:Float = Points[0]
		
		For Local Index:= 2 Until Points.Length Step 2
			' Local variable(s):
			Local X:= Points[Index]
			
			If (X < MinX) Then
				MinX = X
			Endif
		Next
		
		Return MinX
	End
	
	Method MinimumY:Float() Property
		' Local variable(s):
		Local MinY:Float = Points[1]
		
		For Local Index:= 3 Until Points.Length Step 2
			' Local variable(s):
			Local Y:= Points[Index]
			
			If (Y < MinY) Then
				MinY = Y
			Endif
		Next
		
		Return MinY
	End
	
	Method X:Float() Property
		Return MinimumX
	End
	
	Method Y:Float() Property
		Return MinimumY
	End
	
	Method CenterX:Float() Property
		' Local variable(s):
		Local X:Float
		
		Local Points_Length:= Points.Length
		
		For Local Index:= 0 Until Points_Length Step 2
			X += Points[Index]
		Next
		
		' Return the center point of the polygon.
		Return (X / (Points_Length / 2))
	End
	
	Method CenterY:Float() Property
		' Local variable(s):
		Local Y:Float
		
		Local Points_Length:= Points.Length
		
		For Local Index:= 1 Until Points_Length Step 2
			Y += Points[Index]
		Next
		
		' Return the center point of the polygon.
		Return (Y / (Points_Length / 2))
	End
	
	' Properties (Protected):
	Protected
	
	Method X:Void(Value:Float) Property
		' Reserved for future use.
		
		Return
	End
	
	Method Y:Void(Value:Float) Property
		' Reserved for future use.
		
		Return
	End
	
	Public
	
	' Fields:
	Field Points:Float[]
End

' Functions:
' Nothing so far.