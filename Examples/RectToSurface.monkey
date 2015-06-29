Strict

Public

' Imports:
Import polygon.rect
Import matrix2d
Import matrix2d.geometry

Import mojo

' Classes:
Class Application Extends App Final
	' Constructor(s):
	Method OnCreate:Int()
		M = New Matrix2D()
		R = New Rect()
		
		' Return the default response.
		Return 0
	End
	
	' Methods:
	Method OnUpdate:Int()
		RectangleToSurface(M, R, MouseX(), MouseY(), 64.0, 64.0, Millisecs()/10, 32.0, 32.0) ' 32.0, 32.0
		
		M.Reset()
		
		' Return the default response.
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		
		R.Draw()
		
		' Return the default response.
		Return 0
	End
	
	' Fields:
	Field M:Matrix2D
	Field R:Rect
End

' Functions:
Function Main:Int()
	' Start the application.
	New Application()
	
	' Return the default response.
	Return 0
End