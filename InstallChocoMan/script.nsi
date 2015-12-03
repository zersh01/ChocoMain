; myprog.nsi
;
; Эта программа устанавливает myprog в каталог \Program Files\mp
;------------------------------------------------------------------------

; Имя инсталлятора
Name "ChocoMain"
; Команда Name устанавливает ИМЯ инсталлятора. Имя - это просто имя 
; продукта, например 'MyApp' или 'CrapSoft MyApp'.
;------------------------------------------------------------------------
; Файл для записи. Это имя будет иметь наш инсталлятор.
OutFile "ChocoMain_Setup.exe"
;------------------------------------------------------------------------
; Команда InstallDir определяет директорию для установки программы. Путь
; записывается в переменную $INSTDIR. Сюда будем устанавливать нашу 
; программу. Переменная $PROGRAMFILES определяет 
; путь к каталогу Program files
InstallDir "$PROGRAMFILES\ChocoMain"
;------------------------------------------------------------------------
; Проверка ключа реестра для директории, в которую будет устанавливаться
; программа (при повторной установке старый ключ будет переписан 
; автоматически). mp - каталог, куда устанавливается программа
InstallDirRegKey HKLM SOFTWARE\ChocoMain "Install_Dir"
;------------------------------------------------------------------------
; Этот ОБЯЗАТЕЛЬНЫЙ раздел описывает материал для установки. Myprog - 
; имя проекта, определенное командой Name.
Section "ChocoMain (required)"
;------------------------------------------------------------------------
  SectionIn RO
  ; Эта команда определяет тип установки (см. InstType) текущего раздела.
;------------------------------------------------------------------------
  ; Установить путь для директории установки.
  SetOutPath $INSTDIR
;------------------------------------------------------------------------
  ; Указываем местоположение файлов, которые будут устанавливаться
  ; инсталлятором. Команда File определяет путь к файлу или каталогу
  File /r "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\_templates"   
  ; параметр /r означает, что каталог DATA будет записываться вместе с  
  ; находящимися в нем файлами
  File "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\ChocoMain.exe"

  File "D:\YandexDisk\backup\Chocolatey\MyProject\VisualStudio\WindowsFormsApplication1\WindowsFormsApplication1\bin\Release\ChocoMain.exe.config"

;------------------------------------------------------------------------
  ; Записать путь инсталляции в реестр. mp - каталог, 
  ; куда устанавливается программа
  WriteRegStr HKLM SOFTWARE\ChocoMain "Install_Dir" "$INSTDIR"
;------------------------------------------------------------------------
; Записать ключи деинсталляции для Windows. Myprog - имя проекта, 
; определенное командой Name. Слова "только удаление" необязательны. Эта
; информация отображается в списке установленных программ, когда вы 
; выбираете Панель управления -> Установка и удаление программ
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMain" "DisplayName" " ChocoMain (только удаление)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMain" "UninstallString" '"$INSTDIR\uninstall.exe"'
;------------------------------------------------------------------------
  WriteUninstaller "uninstall.exe"
  ; Прописывает деинсталлятор (и дополнительно - путь) для определенного
  ; командой File файла.
;------------------------------------------------------------------------
SectionEnd
; Эта команда закрывает текущий открытый раздел
;------------------------------------------------------------------------
; Раздел опций (могут быть отключены пользователем). Создаем ярлыки
Section "Start Menu Shortcuts"

  ; Команда CreateDirectory создает каталог по указанному пути.
  ; Переменная $SMPROGRAMS определяет путь к пункту меню Пуск -> 
  ; Программы, т.е. мы создаем каталог myprog в меню Пуск -> Программы
  CreateDirectory "$SMPROGRAMS\ChocoMain"

  ; В этом каталоге создаем ярлыки с помощью команды CreateShortCut:
  ; Ярлык Uninstall - деинсталляция
  CreateShortCut "$SMPROGRAMS\ChocoMain\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0

  ; Ярлык myprog - программа
  CreateShortCut "$SMPROGRAMS\ChocoMain\ChocoMain.lnk" "$INSTDIR\ChocoMain.exe" "" "$INSTDIR\ChocoMain.exe" 0
  ; Переменная $DESKTOP определяет путь к рабочему столу, т.е. мы
  ; создаем ярлык на рабочем столе. 
  CreateShortCut "$DESKTOP\ChocoMain.lnk" "$INSTDIR\ChocoMain.exe" "" "$INSTDIR\ChocoMain.exe" 0


SectionEnd
;------------------------------------------------------------------------
; Деинсталлятор. Эта информация выводится при удалении программы
UninstallText "Программа myprog будет удалена с вашего компьютера. Нажмите Uninstall, чтобы продолжить." "Удаляем программу из:"
;------------------------------------------------------------------------
; Раздел деинсталляции
Section "Uninstall"
  
  ; Удалить ключи из реестра
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMain"

  DeleteRegKey HKLM SOFTWARE\ChocoMain

  ; Удалить файлы и деинсталлятор
  Delete $INSTDIR\makensisw.exe
  Delete $INSTDIR\uninstall.exe

  ; удалить ярлыки: указываем каталог в меню Пуск\Программы (myprog).
  ; *.* - это значит, что из указанного каталога будут удалены все файлы
  Delete "$SMPROGRAMS\ChocoMain\*.*"
  RMDir "$SMPROGRAMS\ChocoMain"       ; удалить каталог myprog из меню Программы
  Delete "$DESKTOP\ChocoMain.lnk"     ; удалить ярлык с рабочего стола

  ; удалить использованные папки
  RMDir /r "$PROGRAMFILES\ChocoMain"
  ; /r - с этим параметром каталог удаляется, даже если он НЕ пустой.
  
SectionEnd
; Отмучились - исходный файл готов.
