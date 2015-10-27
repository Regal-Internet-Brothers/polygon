#Rem
	This was lazily thrown together, but it gets the job done.
#End

Strict

Public

' Imports:
Import regal.polygon

Import mojo

' Functions:
Function Main:Int()
	New Game()
	
	' Return the default response.
	Return 0
End

' Classes:
Class Game Extends App Final
	Const TargetX:Float = 256.0
	Const TargetY:= TargetX
	
	Const TargetWidth:Float = 128.0
	Const TargetHeight:= 64.0 ' TargetWidth
	
	Field Width:Float = 64.0
	Field Height:Float = 64.0
	
	' Methods:
	Method OnRender:Int()
		Cls(205.0, 205.0, 205.0)
		
		SetColor(0.0, 0.0, 255.0)
		SetAlpha(1.0)
		
		DrawRect(TargetX, TargetY, TargetWidth, TargetHeight)
		
		SetColor(205.0, 0.0, 0.0)
		SetAlpha(0.75)
		
		DrawRect(X, Y, Width, Height)
		
		Return 0
	End
	
	Method OnUpdate:Int()
		If (KeyHit(KEY_ESCAPE)) Then
			OnClose()
			
			Return 0
		Endif
		
		X = MouseX()
		Y = MouseY()
		
		If (KeyDown(KEY_EQUALS)) Then
			Width += 0.5
			Height += 0.5
		Endif
		
		If (KeyDown(KEY_MINUS)) Then
			Width -= 0.5
			Height -= 0.5
		Endif
		
		If (KeyDown(KEY_F)) Then
			DebugStop()
		Endif
		
		If (Polygon.QuadContained(X, Y, X+Width, Y+Height, TargetX, TargetY, TargetX+TargetWidth, TargetY+TargetHeight)) Then
			Print("Contained - " + Millisecs())
		Elseif (Polygon.QuadContained(TargetX, TargetY, TargetX+TargetWidth, TargetY+TargetHeight, X, Y, X+Width, Y+Height)) Then
			Print("Target contained. - " + Millisecs())
		Endif
		
		#Rem
		If (Polygon.QuadsIntersecting(X, Y, X+Width, Y+Height, TargetX, TargetY, TargetX+TargetWidth, TargetY+TargetHeight)) Then
			Print("Intersecting - " + Millisecs())
		Endif
		#End
		
		If (Polygon.QuadsOnlyIntersecting(X, Y, X+Width, Y+Height, TargetX, TargetY, TargetX+TargetWidth, TargetY+TargetHeight)) Then
			Print("Only intersecting - " + Millisecs())
		Endif
		
		' Return the default response.
		Return 0
	End
	
	' Fields:
	Field X:Float, Y:Float
End