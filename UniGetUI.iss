﻿; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppVersion "3.1.8"
#define MyAppName "UniGetUI"
#define MyAppPublisher "Martí Climent"
#define MyAppURL "https://github.com/marticliment/UniGetUI"
#define MyAppExeName "UniGetUI.exe"

#define public Dependency_Path_NetCoreCheck "InstallerExtras\"
#include "InstallerExtras\CodeDependencies.iss"


[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
UninstallDisplayName="UniGetUI"
AppId={{889610CC-4337-4BDB-AC3B-4F21806C0BDE}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL="https://www.marticliment.com/unigetui/"
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
VersionInfoVersion=3.1.8.0
DefaultDirName="{autopf64}\UniGetUI"
DisableProgramGroupPage=yes
DisableDirPage=no
DirExistsWarning=no
CloseApplications=no
; Remove the following line to run in administrative install mode (install for all users.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=UniGetUI Installer
OutputDir=.     
MinVersion=10.0
SetupIconFile=src\UniGetUI\Assets\Images\icon.ico
UninstallDisplayIcon={app}\UniGetUI.exe
Compression=lzma
SolidCompression=yes
WizardStyle=classic
WizardImageFile=InstallerExtras\INSTALLER.BMP
WizardSmallImageFile=src\UniGetUI\Assets\Images\icon.bmp
DisableWelcomePage=no
AllowUNCPath=no
UsePreviousTasks=yes
UsePreviousPrivileges=yes
UsePreviousAppDir=yes
ChangesEnvironment=yes
RestartIfNeededByRun=no
Uninstallable=IsTaskSelected('regularinstall')


[Languages]
Name: "English"; MessagesFile: "compiler:Default.isl"
Name: "Armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "BrazilianPortuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "Catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "Corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "Czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "Danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "Dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "Finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "French"; MessagesFile: "compiler:Languages\French.isl"
Name: "German"; MessagesFile: "compiler:Languages\German.isl"
Name: "Hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "Icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "Italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "Japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "Korean"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "Norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "Polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "Portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "Russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "Slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "Spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "Turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "Ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl" 

; Include installer's messages
#include "InstallerExtras\CustomMessages.iss"

[InstallDelete]
Type: filesandordirs; Name: "{app}\*.dll";
Type: filesandordirs; Name: "{app}\*.exe";
Type: filesandordirs; Name: "{app}\*.winmd";
Type: filesandordirs; Name: "{app}\Assets\*";

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*.dll";
Type: filesandordirs; Name: "{app}\*.exe";
Type: filesandordirs; Name: "{app}\*.winmd";
Type: filesandordirs; Name: "{app}\Assets\*";

[Code]
procedure InitializeWizard;
begin
  WizardForm.Bevel.Visible := False;
  WizardForm.Bevel1.Visible := True;
end;

procedure TaskKill(FileName: String);
var
  ResultCode: Integer;
begin
    Exec('taskkill.exe', '/f /im ' + '"' + FileName + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

procedure TripleKill(FileName1: String; FileName2: String; FileName3: String);
var
  ResultCode: Integer;
begin
    Exec('taskkill.exe', '/f /im ' + '"' + FileName1 + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
    Exec('taskkill.exe', '/f /im ' + '"' + FileName2 + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);     
    Exec('taskkill.exe', '/f /im ' + '"' + FileName3 + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

function CmdLineParamExists(const Value: string): Boolean;
var
  I: Integer;  
begin
  Result := False;
  for I := 1 to ParamCount do
    if CompareText(ParamStr(I), Value) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;

var CustomExitCode: integer;

procedure ExitProcess(exitCode:integer);
    external 'ExitProcess@kernel32.dll stdcall';

procedure DeinitializeSetup();
begin
    if (CustomExitCode <> 0) then
    begin
        DelTree(ExpandConstant('{tmp}'), True, True, True);
        ExitProcess(0);
    end;
end;

function IsCharValid(Value: Char): Boolean;
begin
  Result := Ord(Value) <= $007F;
end;

function IsDirNameValid(const Value: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(Value) do
    if not IsCharValid(Value[I]) then
      Exit;
  Result := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if (CurPageID = wpSelectDir) and 
    not IsDirNameValid(WizardForm.DirEdit.Text) then
  begin
    Result := False;
    MsgBox('There is an invalid character in the selected install location. ' +
      'Install location cannot contain special characters. ' +
      'Please input a valid path to continue, such as '+ExpandConstant('{commonpf64}')+'\UniGetUI', mbError, MB_OK);
  end;
end;

function InitializeSetup: Boolean;
begin
  try
    if not CmdLineParamExists('/NoVCRedist') then
    begin
      Dependency_AddVC2015To2022;
    end;
    if not CmdLineParamExists('/NoEdgeWebView') then
    begin
      Dependency_AddWebView2;
    end;
    Result := True;
  except
    Result := True;
  end;
end;


[Tasks]
Name: "portableinstall"; Description: "{cm:PortInst}"; GroupDescription: "{cm:InstallType}"; Flags: unchecked exclusive
Name: "regularinstall"; Description: "{cm:RegInst}"; GroupDescription: "{cm:InstallType}"; Flags: exclusive   
Name: "regularinstall\startmenuicon"; Description: "{cm:RegStartMmenuIcon}"; GroupDescription: "{cm:ShCuts}"; 
Name: "regularinstall\desktopicon"; Description: "{cm:RegDesktopIcon}"; GroupDescription: "{cm:ShCuts}";
Name: "regularinstall\chocoinstall"; Description: "{cm:ChocoInstall}"; GroupDescription: "{cm:ShCuts}";

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "WingetUI"; ValueData: """{app}\UniGetUI.exe"" --daemon"; Flags: uninsdeletevalue; Tasks: regularinstall;
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"; ValueType: binary; ValueName: "WingetUI"; ValueData: "03"; Flags: uninsdeletevalue; Tasks: regularinstall; Check: CmdLineParamExists('/NoRunOnStartup');

// Register the unigetui:// deep link
Root: HKA; Subkey: "Software\Classes\unigetui"; ValueType: "string"; ValueData: "URL:UniGetUI Protocol"; Flags: uninsdeletekey; Tasks: regularinstall;
Root: HKA; Subkey: "Software\Classes\unigetui"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""; Tasks: regularinstall;
Root: HKA; Subkey: "Software\Classes\unigetui\DefaultIcon"; ValueType: "string"; ValueData: "{app}\{#MyAppExeName},0"; Tasks: regularinstall;
Root: HKA; Subkey: "Software\Classes\unigetui\shell\open\command"; ValueType: "string"; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: regularinstall;

// Register the .ubundle file type
Root: HKA; Subkey: "Software\Classes\.ubundle"; ValueType: string; ValueData: "UniGetUI.PackageBundle"; Flags: uninsdeletekey; Tasks: regularinstall;
Root: HKA; Subkey: "Software\Classes\UniGetUI.PackageBundle"; ValueType: string; ValueData: {cm:PackageBundleName}; Flags: uninsdeletekey; Tasks: regularinstall;
Root: HKA; Subkey: "Software\Classes\UniGetUI.PackageBundle\DefaultIcon"; ValueType: string; ValueData: "{app}\{#MyAppExeName},0"; Flags: uninsdeletekey; Tasks: regularinstall;
Root: HKA; Subkey: "Software\Classes\UniGetUI.PackageBundle\shell\open\command"; ValueType: string; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey; Tasks: regularinstall;


[Files]
Source: "unigetui_bin\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; BeforeInstall: TripleKill('WingetUI.exe', 'UniGetUI.exe', 'choco.exe');
Source: "unigetui_bin\*"; DestDir: "{app}"; Flags: createallsubdirs ignoreversion recursesubdirs;
Source: "src\UniGetUI.PackageEngine.Managers.Chocolatey\choco-cli\*"; DestDir: "{userpf}\..\UniGetUI\Chocolatey"; Flags: createallsubdirs ignoreversion recursesubdirs uninsneveruninstall; Tasks: regularinstall\chocoinstall; Check: not CmdLineParamExists('/NoChocolatey');
; Source: "InstallerExtras\EnsureWinGet.ps1"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "InstallerExtras\ForceUniGetUIPortable"; DestDir: "{app}"; Tasks: portableinstall


[Icons]
Name: "{autostartmenu}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: regularinstall\startmenuicon
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: regularinstall\desktopicon

[Run]
; Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File -NonInteractive ""{tmp}\EnsureWinGet.ps1"""; StatusMsg: "Ensuring WinGet is properly installed... (this may take a while)"; WorkingDir: {app}; Check: not CmdLineParamExists('/NoWinGet'); Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: runasoriginaluser nowait postinstall; Check: not CmdLineParamExists('/NoAutoStart');
Filename: "{app}\{#MyAppExeName}"; Parameters: "--migrate-wingetui-to-unigetui"; StatusMsg: "Removing old icons...";


[UninstallRun]    
; Remove WingetUI Notification registries
; Filename: "{app}\{#MyAppExeName}"; Parameters: "--uninstall-unigetui"; Flags: skipifdoesntexist runhidden;
Filename: {sys}\taskkill.exe; Parameters: "/f /im WingetUI.exe"; Flags: skipifdoesntexist runhidden;
Filename: {sys}\taskkill.exe; Parameters: "/f /im UniGetUI.exe"; Flags: skipifdoesntexist runhidden;
