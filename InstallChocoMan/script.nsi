; myprog.nsi
;
; ��� ��������� ������������� myprog � ������� \Program Files\mp
;------------------------------------------------------------------------

; ��� ������������
Name "ChocoMain"
; ������� Name ������������� ��� ������������. ��� - ��� ������ ��� 
; ��������, �������� 'MyApp' ��� 'CrapSoft MyApp'.
;------------------------------------------------------------------------
; ���� ��� ������. ��� ��� ����� ����� ��� �����������.
OutFile "ChocoMain_Setup.exe"
;------------------------------------------------------------------------
; ������� InstallDir ���������� ���������� ��� ��������� ���������. ����
; ������������ � ���������� $INSTDIR. ���� ����� ������������� ���� 
; ���������. ���������� $PROGRAMFILES ���������� 
; ���� � �������� Program files
InstallDir "$PROGRAMFILES\ChocoMain"
;------------------------------------------------------------------------
; �������� ����� ������� ��� ����������, � ������� ����� ���������������
; ��������� (��� ��������� ��������� ������ ���� ����� ��������� 
; �������������). mp - �������, ���� ��������������� ���������
InstallDirRegKey HKLM SOFTWARE\ChocoMain "Install_Dir"
;------------------------------------------------------------------------
; ���� ������������ ������ ��������� �������� ��� ���������. Myprog - 
; ��� �������, ������������ �������� Name.
Section "ChocoMain (required)"
;------------------------------------------------------------------------
  SectionIn RO
  ; ��� ������� ���������� ��� ��������� (��. InstType) �������� �������.
;------------------------------------------------------------------------
  ; ���������� ���� ��� ���������� ���������.
  SetOutPath $INSTDIR
;------------------------------------------------------------------------
  ; ��������� �������������� ������, ������� ����� ���������������
  ; �������������. ������� File ���������� ���� � ����� ��� ��������
  File /r "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\_templates"   
  ; �������� /r ��������, ��� ������� DATA ����� ������������ ������ �  
  ; ������������ � ��� �������
  File "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\ChocoMain.exe"

  File "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\ChocoMain.exe.config"

;------------------------------------------------------------------------
  ; �������� ���� ����������� � ������. mp - �������, 
  ; ���� ��������������� ���������
  WriteRegStr HKLM SOFTWARE\ChocoMain "Install_Dir" "$INSTDIR"
;------------------------------------------------------------------------
; �������� ����� ������������� ��� Windows. Myprog - ��� �������, 
; ������������ �������� Name. ����� "������ ��������" �������������. ���
; ���������� ������������ � ������ ������������� ��������, ����� �� 
; ��������� ������ ���������� -> ��������� � �������� ��������
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMain" "DisplayName" " ChocoMain (������ ��������)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMain" "UninstallString" '"$INSTDIR\uninstall.exe"'
;------------------------------------------------------------------------
  WriteUninstaller "uninstall.exe"
  ; ����������� ������������� (� ������������� - ����) ��� �������������
  ; �������� File �����.
;------------------------------------------------------------------------
SectionEnd
; ��� ������� ��������� ������� �������� ������
;------------------------------------------------------------------------
; ������ ����� (����� ���� ��������� �������������). ������� ������
Section "Start Menu Shortcuts"

  ; ������� CreateDirectory ������� ������� �� ���������� ����.
  ; ���������� $SMPROGRAMS ���������� ���� � ������ ���� ���� -> 
  ; ���������, �.�. �� ������� ������� myprog � ���� ���� -> ���������
  CreateDirectory "$SMPROGRAMS\ChocoMain"

  ; � ���� �������� ������� ������ � ������� ������� CreateShortCut:
  ; ����� Uninstall - �������������
  CreateShortCut "$SMPROGRAMS\ChocoMain\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0

  ; ����� myprog - ���������
  CreateShortCut "$SMPROGRAMS\ChocoMain\ChocoMain.lnk" "$INSTDIR\ChocoMain.exe" "" "$INSTDIR\ChocoMain.exe" 0
  ; ���������� $DESKTOP ���������� ���� � �������� �����, �.�. ��
  ; ������� ����� �� ������� �����. 
  CreateShortCut "$DESKTOP\ChocoMain.lnk" "$INSTDIR\ChocoMain.exe" "" "$INSTDIR\ChocoMain.exe" 0


SectionEnd
;------------------------------------------------------------------------
; �������������. ��� ���������� ��������� ��� �������� ���������
UninstallText "��������� myprog ����� ������� � ������ ����������. ������� Uninstall, ����� ����������." "������� ��������� ��:"
;------------------------------------------------------------------------
; ������ �������������
Section "Uninstall"
  
  ; ������� ����� �� �������
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMain"

  DeleteRegKey HKLM SOFTWARE\ChocoMain

  ; ������� ����� � �������������
  Delete $INSTDIR\makensisw.exe
  Delete $INSTDIR\uninstall.exe

  ; ������� ������: ��������� ������� � ���� ����\��������� (myprog).
  ; *.* - ��� ������, ��� �� ���������� �������� ����� ������� ��� �����
  Delete "$SMPROGRAMS\ChocoMain\*.*"
  RMDir "$SMPROGRAMS\ChocoMain"       ; ������� ������� myprog �� ���� ���������
  Delete "$DESKTOP\ChocoMain.lnk"     ; ������� ����� � �������� �����

  ; ������� �������������� �����
  RMDir /r "$PROGRAMFILES\ChocoMain"
  ; /r - � ���� ���������� ������� ���������, ���� ���� �� �� ������.
  
SectionEnd
; ���������� - �������� ���� �����.
