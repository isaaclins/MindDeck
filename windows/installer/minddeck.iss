#ifndef MyAppVersion
  #define MyAppVersion "0.1.0-beta.1"
#endif
#ifndef ArtifactSuffix
  #define ArtifactSuffix "dev"
#endif
#ifndef MyAppSource
  #define MyAppSource "..\..\build\windows\x64\runner\Release"
#endif
#ifndef MyAppOutput
  #define MyAppOutput "..\..\release"
#endif

[Setup]
AppId={{77E043F3-BF83-496A-A4C2-138431BFDACD}
AppName=MindDeck
AppVersion={#MyAppVersion}
AppPublisher=MindDeck
AppPublisherURL=https://isaaclins.com/MindDeck/
AppSupportURL=https://github.com/isaaclins/MindDeck/issues
DefaultDirName={localappdata}\Programs\MindDeck
DefaultGroupName=MindDeck
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\minddeck.exe
OutputDir={#MyAppOutput}
OutputBaseFilename=minddeck-windows-{#ArtifactSuffix}-unsigned-setup
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
WizardStyle=modern

[Files]
Source: "{#MyAppSource}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\MindDeck"; Filename: "{app}\minddeck.exe"
Name: "{autodesktop}\MindDeck"; Filename: "{app}\minddeck.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Registry]
Root: HKCU; Subkey: "Software\Classes\minddeck"; ValueType: string; ValueName: ""; ValueData: "URL:MindDeck Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\minddeck"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKCU; Subkey: "Software\Classes\minddeck\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\minddeck.exe,0"
Root: HKCU; Subkey: "Software\Classes\minddeck\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\minddeck.exe"" ""%1"""

[Run]
Filename: "{app}\minddeck.exe"; Description: "Launch MindDeck"; Flags: nowait postinstall skipifsilent
