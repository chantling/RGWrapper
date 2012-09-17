;Set Window Title match to lowercase
Opt("WinTitleMatchMode", -3)

Global $EveLocation
Global $RGLocation
Global $Account
Global $RGWrapperConfig = @ScriptDir & "\RGWrapper.ini"
Global $RGPID

;Verify Command line has 1 argument; account login
if ($CmdLine[0] <> 1) Then
   MsgBox(0, "", "Commandline error", "Usage:" & @LF & "RGWrapper.exe <accountname>")
   Exit
EndIf
$Account = $CmdLine[1]


;Read RGWrapper.ini file to find exe locations
if NOT FileExists($RGWrapperConfig) Then
   MsgBox(0, "Configuration Error", "RGWrapper.ini not found.  Must" & @LF & "be in the same directory as RGWrapper.exe")
   Exit
EndIf
$EveLocation=IniRead ($RGWrapperConfig, "Locations", "Eve", "")
if ($EveLocation == "") OR ( NOT FileExists($EveLocation)) Then
   MsgBox(0,"Configuration Error", "Eve executible location not correctly" & @LF & "set in RGWrapper.ini")
   Exit
EndIf
$RGLocation=IniRead ($RGWrapperConfig, "Locations", "RedGuard", @ScriptDir & "\rg.exe")
if NOT FileExists($RGLocation) Then
   MsgBox(0,"Configuration Error", "Redguard executible could not be found")
   Exit
EndIf

;Verify RedGuard is running; if not, start it.  Probably won't save this Eve process from death, but may save any others later
$var = StringSplit($RGLocation, "\")
$RGPID =ProcessExists($var[$var[0]])
if ($RGPID == 0) Then
	if Run($RGLocation) == 0 Then
	  MsgBox(0, "Error Launching RedGuard", "Unable to launch Redguard process")
	  Exit
	Else
		$RGPID =ProcessExists($var[$var[0]])
		if ($RGPID == 0) Then
			MsgBox(0, "Error Launching RedGuard", "Unable to launch Redguard process")
			Exit
		EndIf
	Endif
EndIf

;Check to ensure RG selection window is shown - wait if necessary for RG to inject
$bWindow = false
For $i = 1 to 10
	if WinExists("Red Guard Account Selection", "") Then
		$bWindow = true
		ExitLoop
	EndIf
	Sleep( 1000 )
Next
if ($bWindow == false) Then
	MsgBox(0, "Error Launching Eve", "RG Account Selection window is" & @LF & "not opening.  Unknown error.  Quitting.")
	Exit
EndIf

;Select account passed in on command line
ControlCommand("[CLASS:#32770]", "", "[CLASS:ListBox; INSTANCE:1]", "SelectString", $Account)
;verify proper account selected
if NOT (ControlCommand("[CLASS:#32770]", "", "[CLASS:ListBox; INSTANCE:1]", "GetCurrentSelection") == $Account) Then
   MsgBox(0, "Error Selecting Account", "Couldn't select account " & $Account & @LF & "Account name may be incorrect or RedGuard's" & @LF & "config.ini may not be configured properly")
   Exit
EndIf

;Everything's good so far, click OK
ControlClick ( "[CLASS:#32770]", "", "Button1")

Exit
