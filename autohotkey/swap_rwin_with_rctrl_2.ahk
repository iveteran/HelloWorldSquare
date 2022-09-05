; Swap Option<->Command (Ctrl<->Win) in Boot Camp. Disable with Ctrl+F6. Only swaps right ctrl, use left ctrl for Ctrl+Alt+Del

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#InstallKeybdHook
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; swap right command/windows key with right ctrl
RWin::
    Send, {RCtrl Down}
    Keywait RWin
    Send, {RCtrl Up}
Return
RCtrl::
    Send, {RWin Down}
    Keywait RCtrl
    Send, {RWin Up}
Return

^F6::Suspend