;JUST REMAP THE KEY
APPSKEY:
DEL:
DOWN:
END:
ESC:
F1:
F2:
F3:
F4:
F5:
F6:
F7:
F8:
F9:
F10:
F11:
F12:
HOME:
INS:
LBUTTON:
LEFT:
MBUTTON:
MEDIA_NEXT:
MEDIA_PLAY_PAUSE:
MEDIA_PREV:
MEDIA_STOP:
PGDN:
PGUP:
RBUTTON:
RIGHT:
UP:
XBUTTON1:
XBUTTON2:
 	SendInput {Blind}{%A_ThisLabel%}
	return

SPACE:
	SendPlay {Space}
	return

CUT:
	SendInput ^x
	return

COPY:
	SendInput ^c
	return

PASTE:
	SendInput ^v
	return

CLICKPASTE:
	Click
	SendInput ^v
	return

UNDO:
	SendInput ^z
	return

REDO:
	SendInput ^y
	return

WINR:
	SendInput #r
	return

MOUSE_SCREEN:
	CoordMode Mouse, Screen
MOUSE_WIN:
	MouseMove 10, 10, 0
	return

MOUSE_UP_LEFT:
	Move(-1,-1)
	return

MOUSE_UP:
	Move(0,-1)
	return

MOUSE_UP_RIGHT:
	Move(1,-1)
	return

MOUSE_LEFT:
	Move(-1,0)
	return

MOUSE_RIGHT:
	Move(1,0)
	return

MOUSE_DOWN_LEFT:
	Move(-1,1)
	return

MOUSE_DOWN:
	Move(0,1)
	return

MOUSE_DOWN_RIGHT:
	Move(1,1)
	return

;Moves the mouse X, Y blocks relative to current position.
Move(X, Y) {
	offset := 5

	CoordMode Mouse, Screen
	MouseGetPos mX, mY
	newX := mX + X*offset
	newY := mY + Y*offset
	;May work better than MouseMove on multi-monitor systems.
	DllCall("SetCursorPos", int, newX, int, newY)
}