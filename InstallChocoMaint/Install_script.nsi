;�������� ���� ������ ���������� 
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles


; myprog.nsi
;
; ��� ��������� ������������� myprog � ������� \Program Files\mp
;------------------------------------------------------------------------

; ��� ������������
Name "ChocoMaint"
; ������� Name ������������� ��� ������������. ��� - ��� ������ ��� 
; ��������, �������� 'MyApp' ��� 'CrapSoft MyApp'.
;------------------------------------------------------------------------
; ���� ��� ������. ��� ��� ����� ����� ��� �����������.
OutFile "ChocoMaint_Setup.exe"

;------------------------------------------------------------------------
; ������� InstallDir ���������� ���������� ��� ��������� ���������. ����
; ������������ � ���������� $INSTDIR. ���� ����� ������������� ���� 
; ���������. ���������� $PROGRAMFILES ���������� 
; ���� � �������� Program files
InstallDir "$PROGRAMFILES\ChocoMaint"
;------------------------------------------------------------------------
; �������� ����� ������� ��� ����������, � ������� ����� ���������������
; ��������� (��� ��������� ��������� ������ ���� ����� ��������� 
; �������������). mp - �������, ���� ��������������� ���������
InstallDirRegKey HKLM SOFTWARE\ChocoMaint "Install_Dir"
;------------------------------------------------------------------------
; ���� ������������ ������ ��������� �������� ��� ���������. Myprog - 
; ��� �������, ������������ �������� Name.
Section "ChocoMaint (required)"
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
  File "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\ChocoMaint.exe"

  File "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\ChocoMaint.exe.config"



;------------------------------------------------------------------------
  ; �������� ���� ����������� � ������. mp - �������, 
  ; ���� ��������������� ���������
  WriteRegStr HKLM SOFTWARE\ChocoMaint "Install_Dir" "$INSTDIR"
;------------------------------------------------------------------------
; �������� ����� ������������� ��� Windows. Myprog - ��� �������, 
; ������������ �������� Name. ����� "������ ��������" �������������. ���
; ���������� ������������ � ������ ������������� ��������, ����� �� 
; ��������� ������ ���������� -> ��������� � �������� ��������
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMaint" "DisplayName" " ChocoMaint (������ ��������)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMaint" "UninstallString" '"$INSTDIR\uninstall.exe"'
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
  CreateDirectory "$SMPROGRAMS\ChocoMaint"

  ; � ���� �������� ������� ������ � ������� ������� CreateShortCut:
  ; ����� Uninstall - �������������
  CreateShortCut "$SMPROGRAMS\ChocoMaint\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0

  ; ����� myprog - ���������
  CreateShortCut "$SMPROGRAMS\ChocoMaint\ChocoMaint.lnk" "$INSTDIR\ChocoMaint.exe" "" "$INSTDIR\ChocoMaint.exe" 0
  ; ���������� $DESKTOP ���������� ���� � �������� �����, �.�. ��
  ; ������� ����� �� ������� �����. 
  CreateShortCut "$DESKTOP\ChocoMaint.lnk" "$INSTDIR\ChocoMaint.exe" "" "$INSTDIR\ChocoMaint.exe" 0


SectionEnd
;------------------------------------------------------------------------
; �������������. ��� ���������� ��������� ��� �������� ���������
UninstallText "��������� myprog ����� ������� � ������ ����������. ������� Uninstall, ����� ����������." "������� ��������� ��:"
;------------------------------------------------------------------------
; ������ �������������
Section "Uninstall"
  
  ; ������� ����� �� �������
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMaint"

  DeleteRegKey HKLM SOFTWARE\ChocoMaint

  ; ������� ����� � �������������
  Delete $INSTDIR\makensisw.exe
  Delete $INSTDIR\uninstall.exe

  ; ������� ������: ��������� ������� � ���� ����\��������� (myprog).
  ; *.* - ��� ������, ��� �� ���������� �������� ����� ������� ��� �����
  Delete "$SMPROGRAMS\ChocoMaint\*.*"
  RMDir "$SMPROGRAMS\ChocoMaint"       ; ������� ������� myprog �� ���� ���������
  Delete "$DESKTOP\ChocoMaint.lnk"     ; ������� ����� � �������� �����

  ; ������� �������������� �����
  RMDir /r "$PROGRAMFILES\ChocoMaint"
  ; /r - � ���� ���������� ������� ���������, ���� ���� �� �� ������.
  
SectionEnd
; ���������� - �������� ���� �����.
