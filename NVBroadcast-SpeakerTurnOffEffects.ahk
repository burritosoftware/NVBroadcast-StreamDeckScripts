#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

SetTitleMatchMode(2)

; Relaunch with UI Access to block mouse and keyboard inputs
if (!A_IsCompiled && !InStr(A_AhkPath, "_UIA")) {
  newPath := RegExReplace(A_AhkPath, "U?(32|64)?\.exe$", (A_Is64bitOS ? "64" : "32") "_UIA.exe")
  if FileExist(newPath) {
      Run(StrReplace(DllCall("GetCommandLine", "Str"), A_AhkPath, newPath))
      ExitApp
  } else {
      MsgBox "Error: UIA executable not found: " newPath
      ExitApp
  }
}

; Define the path to the NVIDIA Broadcast tray icon and checkmark
trayIconImage := "Reference-TrayIconLight.png"
trayIconImageAlt := "Reference-TrayIconDark.png"
checkmarkImage := "Reference-CheckLight.png"
checkmarkImageAlt := "Reference-CheckDark.png"

; Temporarily block input
BlockInput true

; Store the current mouse position
CoordMode "Mouse", "Screen"
MouseGetPos &originalX, &originalY
CoordMode "Mouse", "Client"

; First, check if the tray icon (light or dark version) is already visible
foundX := 0, foundY := 0
if !ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, trayIconImage)
    && !ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, trayIconImageAlt) {  
  ; If tray icon is not visible, open the overflow menu
  if !WinExist("ahk_class TopLevelWindowForOverflowXamlIsland") {
      Send("#b")
      Sleep(1)
      Send("{Enter}")

      ; Wait for the system tray window to appear (max 5 seconds)
      if !WinWait("ahk_class TopLevelWindowForOverflowXamlIsland", , 5) {
          BlockInput false
          MsgBox("System tray overflow did not appear!")
          ExitApp
      }
  }

    ; Retry finding the tray icon after opening the overflow menu
  startTime := A_TickCount
  while !ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, trayIconImage)
        && !ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, trayIconImageAlt) {
      if (A_TickCount - startTime > 5000) {  ; Timeout after 5 seconds
          BlockInput  false
          MsgBox("Tray icon not found within 5 seconds!")
          ExitApp
      }
  }
}

; Move to the found image location and right-click
MouseMove(foundX, foundY)
Click("Right")

; Wait for the right-click menu window to appear and become active (max 5 seconds)
if WinWait("ahk_class Chrome_WidgetWin_1 ahk_exe NVIDIA Broadcast.exe", "", 5) {
    WinWaitActive("ahk_class Chrome_WidgetWin_1 ahk_exe NVIDIA Broadcast.exe", "", 2)  ; Ensure it's fully interactive
} else {
    BlockInput false
    MsgBox("Right-click menu did not appear!")
    ExitApp
}

; Press Up two times to select Speaker
Send("{Up 2}")

; Check if the checkmark (light or dark version) exists
checkX := 0, checkY := 0
if ImageSearch(&checkX, &checkY, 0, 0, A_ScreenWidth, A_ScreenHeight, checkmarkImage)
    || ImageSearch(&checkX, &checkY, 0, 0, A_ScreenWidth, A_ScreenHeight, checkmarkImageAlt) {
    ; If any checkmark is found, press Enter to turn it off
    Send("{Enter}")
} else {
    ; Otherwise, skip pressing Enter and close window
    Send("{Esc}")
}

; Restore the original mouse position
CoordMode "Mouse", "Screen"
MouseMove(originalX, originalY)

; Unblock input
BlockInput false