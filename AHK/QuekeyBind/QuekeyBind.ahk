#NoEnv
#SingleInstance FORCE
#Persistent

SetCapsLockState Off
SetCapsLockState AlwaysOff

Menu Tray, Icon, QuekeyBind.icl, 1, 1
Menu Tray, NoStandard
Menu Tray, Add, QuekeyBind, NONE
Menu Tray, Add
Menu Tray, Add, Enable, TOGGLEMODE
Menu Tray, Default, Enable
Menu Tray, Add, Suspend, SUSPEND
Menu Tray, Add
Menu Tray, Add, Reload, RELOAD
Menu Tray, Add, Exit, EXIT

state = -1

*Capslock::ToggleHK(1)
*Capslock UP::ToggleHK(-1)
return


HotkeysSwitch(newState) {
	if (newState == "ON" || newState == "OFF") {
		;START_OF_HOTKEYS
		Hotkey /, SHOWHELP, %newState%		;Show Help
		Hotkey F1, RELOAD, %newState%		;Reload

		Hotkey *Q, XBUTTON1, %newState%		;XButton 1 Click
		Hotkey *W, LBUTTON, %newState%		;Left Click
		Hotkey *E, MOUSE_UP, %newState%		;Move Mouse Up
		Hotkey *R, RBUTTON, %newState%		;Right Click
		Hotkey *T, MBUTTON, %newState%		;Middle Click
		Hotkey Y, REDO, %newState%			;Ctrl+Y
		Hotkey *U, HOME, %newState%			;Home
		Hotkey *I, PGDN, %newState%			;Page Down
		Hotkey *O, PGUP, %newState%			;Page Up
		Hotkey *P, END, %newState%			;End
		Hotkey *[, MEDIA_STOP, %newState%		;Multimedia Stop
		Hotkey *], MEDIA_PLAY_PAUSE, %newState%		;Multimedia Play

		Hotkey *A, XBUTTON2, %newState%		;XButton 2 Click
		Hotkey *S, MOUSE_LEFT, %newState%	;Move Mouse Left
		Hotkey *D, MOUSE_DOWN, %newState%	;Move Mouse Down
		Hotkey *F, MOUSE_RIGHT, %newState%	;Move Mouse Right
		Hotkey G, MOUSE_WIN, %newState%		;Move Mouse to Active Window
		Hotkey ^G, MOUSE_SCREEN, %newState%	;Move Mouse to Primary Screen
		Hotkey *H, LEFT, %newState%			;Left
		Hotkey *J, DOWN, %newState%			;Down
		Hotkey *K, UP, %newState%			;Up
		Hotkey *L, RIGHT, %newState%		;Right
		Hotkey *`;, MEDIA_PREV, %newState%		;Multimedia Previous
		Hotkey *', MEDIA_NEXT, %newState%		;Multimedia Next

		Hotkey Z, UNDO, %newState%			;Ctrl+Z
		Hotkey X, CUT, %newState%			;Ctrl+X
		Hotkey C, COPY, %newState%			;Ctrl+C
		Hotkey V, PASTE, %newState%			;Ctrl+V
		Hotkey B, CLICKPASTE, %newState%	;Click -> Ctrl+V
		Hotkey N, ESC, %newState%			;Esc
		Hotkey M, INS, %newState%			;Insert
		Hotkey *`,, DEL, %newState%			;Delete
		Hotkey ., APPSKEY, %newState%	;Application
		Hotkey Space, STICK, %newState%		;Enable Sticky Mode
		Hotkey ``, CAPSLOCK, %newState%		;Toggle Caps Lock
		;END_OF_HOTKEYS
	}
}

;Change the state of the Hotkeys.
;newState:
;	 0 = Toggle
;	 1 = On
;	-1 = Off
ToggleHK(newState = 0) {
	global state
	if (newState == 0) {
		newState := -1 * state
	}
	if (newState != state) {
		if (newState == 1) {
			HotkeysSwitch("ON")
			Menu Tray, Rename, Enable, Disable
		} else if (newState == -1) {
			HotkeysSwitch("OFF")
			Menu Tray, Rename, Disable, Enable
		} else {
			return
		}
		state := newState
		UpdateMenu()
	}
}

;Updates the Notification Icon's Menu based on state.
UpdateMenu() {
	global state
	if (state == 1) {
		item := "Disable"
		icon := "2"
	} else {
		item := "Enable"
		icon := "1"
	}

	if (A_IsSuspended) {
		mode := "Disable"
		icon := 3
	} else {
		mode := "Enable"
	}

	Menu Tray, %mode%, %item%
	Menu Tray, Icon, QuekeyBind.icl, %icon%, 1
	return
}

;Toggles the Hotkey Modes
TOGGLEMODE:
	if (! A_isSuspended) {
		ToggleHK(0)
	}
	return

;Enters Sticky Mode (Leave Hotkeys on)
STICK:
	KeyWait Space
	KeyWait Capslock
	ToggleHK(1)
	return

;Toggle Capslock state (via Hotkey)
CAPSLOCK:
	if (GetKeyState("Capslock", "T")) {
		SetCapsLockState Off
	} else {
		SetCapsLockState On
	}
	return


NONE:
	return

SUSPEND:
	Suspend
	UpdateMenu()
	Menu, Tray, ToggleCheck, Suspend
	return

RELOAD:
	Reload
	return

EXIT:
	ExitApp
	return

;Shows the help information.
;This information is gathered by reading this file, and parsing the data between
;";START_OF_HOTKEYS" and ";END_OF_HOTKEYS".
SHOWHELP:
		startHK := ";START_OF_HOTKEYS"
		endHK := ";END_OF_HOTKEYS"

		inHotkeys := 0
		results := ""
		Loop, Read, %A_ScriptFullPath%
		{
			line := RegExReplace(A_LoopReadLine, "^\s+|\s+$")

			if (inHotkeys) {
				IfInString line, %endHK%
				{
					inHotkeys := 0
					break
				} else {
					regex := ".*Hotkey (.+), .+, %newState%.*;(\S*)"
					results := results . "`n" . RegExReplace(line, regex, "$1" . A_Tab . "$2")
				}
			} else {
				inHotkeys := InStr(line, startHK, true)
			}
		}
		StringTrimLeft results, results, 1
		MsgBox %results%
		return

#include QueKeyBindDef.ahk