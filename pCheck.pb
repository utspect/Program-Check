pID.i
programDir.s = "programdir"
programName.s = "programname.exe"

executable.s = programDir + "\" + programName

Procedure.b checkForProcess(FileName.s)
  Protected snap.l , Proc32.PROCESSENTRY32 , dll_kernel32.l
  FileName = GetFilePart( FileName )
  dll_kernel32 = OpenLibrary (#PB_Any, "kernel32.dll")
  If dll_kernel32
    snap = CallFunction (dll_kernel32, "CreateToolhelp32Snapshot",$2, 0)
    If snap
      Proc32\dwSize = SizeOf (PROCESSENTRY32)
      If CallFunction (dll_kernel32, "Process32First", snap, @Proc32)
        While CallFunction (dll_kernel32, "Process32Next", snap, @Proc32)
          ;Debug PeekS(@Proc32\szExeFile,256,#PB_Ascii)
          If PeekS (@Proc32\szExeFile, 256, #PB_Ascii)=FileName
            CloseHandle_ (snap)
            CloseLibrary (dll_kernel32)
            ProcedureReturn #True
          EndIf
        Wend
      EndIf   
      CloseHandle_ (snap)
    EndIf
    CloseLibrary (dll_kernel32)
  EndIf
  ProcedureReturn #False
EndProcedure

While 1
  If checkForProcess(programName)
    Sleep_(100)
  Else
    pID = RunProgram(executable, "", programdir, #PB_Program_Open)
  EndIf
Wend

  
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 32
; Folding = -
; EnableXP
; Executable = pCheck.exe