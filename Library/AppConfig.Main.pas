{
Copyright (C) 2006-2020 Matteo Salvi

Website: http://www.salvadorsoftware.com/

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit AppConfig.Main;

{$MODE DelphiUnicode}

interface

uses
  LCLIntf, LCLType, SysUtils, Graphics, Forms, Controls, VirtualTrees, Kernel.Enumerations,
  Classes, AppConfig.Paths, jsonConf,
  Lists.Manager, Database.Manager, Icons.Manager, Kernel.Logger, Dialogs;

type

  { TConfiguration }
  TConfiguration = class
  private
    FSmallHeightNode    : Integer;
    FBigHeightNode      : Integer;
    //General
    FStartWithWindows   : Boolean;
    FShowPanelAtStartUp : Boolean;
    FShowGraphicMenuAtStartUp  : Boolean;
    //Main Form
    FLangID             : String;
    FTVDisableConfirmDelete: Boolean;
    FUseCustomTitle     : Boolean;
    FCustomTitleString  : string;
    FHideTabSearch      : Boolean;
    FSearchAsYouType    : Boolean;
    //Main Form - Position and size
    FHoldSize           : Boolean;
    FAlwaysOnTop        : Boolean;
    //Main Form - Treevew
    FTVBackground       : Boolean;
    FTVBackgroundPath   : string;
    FTVAutoOpClCats     : Boolean; //Automatic Opening/closing categories
    FTVAutoOpCatsDrag   : Boolean;
    FTVFont             : TFont;
    FTVSmallIconSize    : Boolean;
    //MRU
    FMRU                : Boolean;
    FSubMenuMRU         : Boolean;
    FMRUNumber          : Integer;
    //MFU
    FMFU                : Boolean;
    FSubMenuMFU         : Boolean;
    FMFUNumber          : Integer;
    //Backup
    FBackup             : Boolean;
    FBackupNumber       : Integer;
    //Other functions
    FAutorunStartup     : Boolean;
    FAutorunShutdown    : Boolean;
    FCache              : Boolean;
    FScheduler          : Boolean;
    //Execution
    FActionOnExe        : TActionOnExecute;
    FRunSingleClick     : Boolean;
    FConfirmRunCat      : Boolean;
    FAutoCloseProcess   : Boolean;
    //Trayicon
    FTrayIcon           : Boolean;
    FTrayUseCustomIcon  : Boolean;
    FTrayCustomIconPath : string;
    FActionClickLeft    : TTrayiconActionClick;
    FActionClickRight   : TTrayiconActionClick;
    //Graphic Menu
    FGMTheme            : string;
    FGMFade             : Boolean;
    FGMPersonalPicture  : string;
    FGMPositionTop      : Integer;
    FGMPositionLeft     : Integer;
    FGMSmallIconSize    : Boolean;
    FGMAutomaticHideMenu : Boolean;
    FGMShowUserPicture   : Boolean;
    //Right buttons
    FGMBtnDocuments     : string;
    FGMBtnMusic         : string;
    FGMBtnPictures      : string;
    FGMBtnVideos        : string;
    FGMBtnExplore       : string;
    //HotKeys
    FHotKey             : Boolean;
    FWindowHotKey       : Cardinal;
    FGraphicMenuHotKey  : Cardinal;
    FClassicMenuHotkey  : Cardinal;
    //Misc
    FReadOnlyMode         : Boolean;
    FChanged              : Boolean;
    FASuiteState          : TLauncherState;
    FMissedSchedulerTask  : Boolean;
    FAutoExpansionFolder  : Boolean;
    FActionClickMiddle    : TTrayiconActionClick;
    FScanFolderAutoExtractName : boolean;
    FScanFolderFileTypes  : TStringList;
    FScanFolderExcludeNames: TStringList;

    FMainTree: TVirtualStringTree;
    FPaths: TConfigPaths;
    FListManager : TListManager;
    FDBManager : TDBManager;
    FIconsManager: TIconsManager;
    FLogger: TASuiteLogger;
    procedure RestoreSettings(AJSONConfig: TJSONConfig);
    procedure SaveSettings(AJSONConfig: TJSONConfig);
    procedure SetHoldSize(value: Boolean);
    procedure SetAlwaysOnTop(value: Boolean);
    procedure SetTrayIcon(value: Boolean);
    procedure SetTrayUseCustomIcon(value: Boolean);
    procedure SetUseCustomTitle(value: Boolean);
    procedure SetTVAutoOpClCats(value: Boolean);
    procedure SetHideTabSearch(value: Boolean);
    procedure SetShowPanelAtStartUp(value: Boolean);
    procedure SetTVBackground(value: Boolean);
    procedure SetCache(value: boolean);
    procedure SetStartWithWindows(value: boolean);
    procedure SetLangID(value: String);
    procedure SetTVFont(value: TFont);
    procedure SetScheduler(value: Boolean);
    procedure SetGMTheme(value: string);
    procedure SetGMBtnDocuments(Value: string);
    procedure SetGMBtnExplore(Value: string);
    procedure SetGMBtnMusic(Value: string);
    procedure SetGMBtnPictures(Value: string);
    procedure SetGMBtnVideos(Value: string);
    procedure SetBackupNumber(const Value: Integer);
    procedure SetChanged(const Value: Boolean);
    procedure SetBackup(const Value: Boolean);
    procedure SetGraphicMenuHotKey(const Value: Cardinal);
    procedure SetWindowHotKey(const Value: Cardinal);
    procedure SetHotKey(const Value: Boolean);
    procedure SetTVSmallIconSize(const Value: Boolean);
    procedure SetClassicMenuHotkey(const Value: Cardinal);

    function GetMainTree: TVirtualStringTree;
    function GetImportTree: TVirtualStringTree;
    procedure SetASuiteState(const Value: TLauncherState);

  protected
    procedure HandleParam(const Param: string);
  public
    { public declarations }
    constructor Create; overload;
    destructor Destroy; override;

    //TODO: Move all singleton and these classes in a separate class called TASuiteInstance
    property MainTree: TVirtualStringTree read GetMainTree write FMainTree;
    property ImportTree: TVirtualStringTree read GetImportTree;
    property Paths: TConfigPaths read FPaths;
    property ListManager: TListManager read FListManager;
    property DBManager: TDBManager read FDBManager;
    property IconsManager: TIconsManager read FIconsManager;

    property SmallHeightNode: Integer read FSmallHeightNode;
    property BigHeightNode: Integer read FBigHeightNode;

    //General
    property StartWithWindows: Boolean read FStartWithWindows write SetStartWithWindows;
    property ShowPanelAtStartUp: Boolean read FShowPanelAtStartUp write SetShowPanelAtStartUp;
    property ShowGraphicMenuAtStartUp: Boolean read FShowGraphicMenuAtStartUp write FShowGraphicMenuAtStartUp;
    property MissedSchedulerTask: Boolean read FMissedSchedulerTask write FMissedSchedulerTask;
    // Main Form
    property LangID: String read FLangID write SetLangID;
    property UseCustomTitle: Boolean read FUseCustomTitle write SetUseCustomTitle;
    property CustomTitleString : String read FCustomTitleString write FCustomTitleString;
    property HideTabSearch: Boolean read FHideTabSearch write SetHideTabSearch;
    property SearchAsYouType: Boolean read FSearchAsYouType write FSearchAsYouType;
    // Main Form - Position and size
    property HoldSize: Boolean read FHoldSize write SetHoldSize;
    property AlwaysOnTop: Boolean read FAlwaysOnTop write SetAlwaysOnTop;
    // Main Form - Treevew
    property TVBackground: Boolean read FTVBackground write SetTVBackground;
    property TVSmallIconSize: Boolean read FTVSmallIconSize write SetTVSmallIconSize;
    property TVBackgroundPath: String read FTVBackgroundPath write FTVBackgroundPath;
    property TVAutoOpClCats: Boolean read FTVAutoOpClCats write SetTVAutoOpClCats;
    property TVAutoOpCatsDrag: Boolean read FTVAutoOpCatsDrag write FTVAutoOpCatsDrag;
    property TVDisableConfirmDelete: Boolean read FTVDisableConfirmDelete write FTVDisableConfirmDelete;
    property TVFont: TFont read FTVFont write SetTVFont;
    // MRU
    property MRU: Boolean read FMRU write FMRU;
    property SubMenuMRU: Boolean read FSubMenuMRU write FSubMenuMRU;
    property MRUNumber: Integer read FMRUNumber write FMRUNumber;
    // MFU
    property MFU: Boolean read FMFU write FMFU;
    property SubMenuMFU: Boolean read FSubMenuMFU write FSubMenuMFU;
    property MFUNumber: Integer read FMFUNumber write FMFUNumber;
    // Backup
    property Backup: Boolean read FBackup write SetBackup;
    property BackupNumber: Integer read FBackupNumber write SetBackupNumber;
    // Other functions
    property AutorunStartup: Boolean read FAutorunStartup write FAutorunStartup;
    property AutorunShutdown: Boolean read FAutorunShutdown write FAutorunShutdown;
    property Cache: Boolean read FCache write SetCache;
    property Scheduler: Boolean read FScheduler write SetScheduler;
    // Execution
    property ActionOnExe: TActionOnExecute read FActionOnExe write FActionOnExe;
    property RunSingleClick: Boolean read FRunSingleClick write FRunSingleClick;
    property ConfirmRunCat: Boolean read FConfirmRunCat write FConfirmRunCat;
    property AutoCloseProcess: Boolean read FAutoCloseProcess write FAutoCloseProcess;
    // Trayicon
    property TrayIcon: Boolean read FTrayIcon write SetTrayIcon;
    property TrayUseCustomIcon: Boolean read FTrayUseCustomIcon write SetTrayUseCustomIcon;
    property TrayCustomIconPath: String read FTrayCustomIconPath write FTrayCustomIconPath;
    property ActionClickLeft: TTrayiconActionClick read FActionClickLeft write FActionClickLeft;
    property ActionClickMiddle: TTrayiconActionClick read FActionClickMiddle write FActionClickMiddle;
    property ActionClickRight: TTrayiconActionClick read FActionClickRight write FActionClickRight;
    property AutoExpansionFolder: Boolean read FAutoExpansionFolder write FAutoExpansionFolder;
    //Graphic Menu
    property GMTheme: string read FGMTheme write SetGMTheme;
    property GMFade: Boolean read FGMFade write FGMFade;
    property GMSmallIconSize: Boolean read FGMSmallIconSize write FGMSmallIconSize;
    property GMPersonalPicture: string read FGMPersonalPicture write FGMPersonalPicture;
    property GMPositionTop: Integer read FGMPositionTop write FGMPositionTop;
    property GMPositionLeft: Integer read FGMPositionLeft write FGMPositionLeft;
    property GMAutomaticHideMenu: Boolean read FGMAutomaticHideMenu write FGMAutomaticHideMenu;
    property GMShowUserPicture: Boolean read FGMShowUserPicture write FGMShowUserPicture;
    //Right buttons
    property GMBtnDocuments: string read FGMBtnDocuments write SetGMBtnDocuments;
    property GMBtnPictures: string read FGMBtnPictures write SetGMBtnPictures;
    property GMBtnMusic: string read FGMBtnMusic write SetGMBtnMusic;
    property GMBtnVideos: string read FGMBtnVideos write SetGMBtnVideos;
    property GMBtnExplore: string read FGMBtnExplore write SetGMBtnExplore;
    //HotKeys
    property HotKey: Boolean read FHotKey write SetHotKey;
    property WindowHotKey: Cardinal read FWindowHotKey write SetWindowHotKey;
    property GraphicMenuHotKey: Cardinal read FGraphicMenuHotKey write SetGraphicMenuHotKey;
    property ClassicMenuHotkey: Cardinal read FClassicMenuHotkey write SetClassicMenuHotkey;
    // Misc
    property ReadOnlyMode: Boolean read FReadOnlyMode write FReadOnlyMode;
    property Changed: Boolean read FChanged write SetChanged;
    property ASuiteState: TLauncherState read FASuiteState write SetASuiteState;
    property ScanFolderAutoExtractName: boolean read FScanFolderAutoExtractName write FScanFolderAutoExtractName;
    property ScanFolderFileTypes: TStringList read FScanFolderFileTypes write FScanFolderFileTypes;
    property ScanFolderExcludeNames: TStringList read FScanFolderExcludeNames write FScanFolderExcludeNames;

    function CheckReadOnlyMode: Boolean;

    procedure AfterUpdateConfig();
    
    //Update theme paths
    procedure UpdateGMTheme;

    //Database
    procedure LoadList;
    function SaveList(DoBackup: Boolean): Boolean;

    procedure LoadConfig;
    procedure SaveConfig;
  end;

var
  Config: TConfiguration;

implementation

uses
  Forms.Main, DataModules.TrayMenu, Utility.System, Kernel.Consts, Utility.Misc,
  Forms.GraphicMenu, VirtualTree.Methods, Utility.FileFolder, Windows,
  Utility.XML, GraphicMenu.ThemeEngine, Kernel.Scheduler, Forms.ImportList,
  TypInfo, Utility.HotKey, Kernel.ResourceStrings, LCLTranslator, AppConfig.Consts,
  Utility.Conversions;

procedure TConfiguration.AfterUpdateConfig();
begin   
  TVirtualTreeMethods.Create.UpdateItemColor(Config.MainTree);
end;

function TConfiguration.CheckReadOnlyMode: Boolean;
begin
  //Check if ASuite is running from a cd rom
  Result := GetDriveTypeW(PChar(Config.Paths.SuiteDrive)) = DRIVE_CDROM;
  if (Config.ReadOnlyMode) then
  begin
    Config.Cache  := False;
    Config.Backup := False;
    Config.MRU    := False;
  end;
  Config.ReadOnlyMode := Result;
end;

constructor TConfiguration.Create;
var
  I: Integer;
begin
  TScheduler.Create;

  //Node height based of DPI
  FSmallHeightNode := Round((Screen.PixelsPerInch / 96.0) * 18);
  FBigHeightNode   := Round((Screen.PixelsPerInch / 96.0) * 36);

  //Params
  for I := 1 to ParamCount do
    HandleParam(ParamStr(I));

  //Create some classes
  FPaths  := TConfigPaths.Create;
  FLogger := TASuiteLogger.Create(FPaths.SuitePathData);

  TASuiteLogger.Info('Creating Managers', []);
  FListManager  := TListManager.Create;
  FDBManager    := TDBManager.Create;
  FIconsManager := TIconsManager.Create;

  //General
  FStartWithWindows   := False;
  FShowPanelAtStartUp := True;
  FShowGraphicMenuAtStartUp  := False;
  FMissedSchedulerTask := True;

  //Main Form
  FLangID             := 'en';
  FUseCustomTitle     := False;
  FCustomTitleString  := APP_TITLE;
  FHideTabSearch      := False;
  FSearchAsYouType    := True;

  //Main Form - Position and size
  FHoldSize           := False;
  FAlwaysOnTop        := False;

  //Main Form - Treevew
  FTVBackground       := False;
  FTVBackgroundPath   := '';
  FTVSmallIconSize    := True;
  FTVAutoOpClCats     := True;
  FTVAutoOpCatsDrag   := True;
  TVDisableConfirmDelete := False;

  //Treeview Font
  FTVFont             := TFont.Create;
  FTVFont.Name        := 'MS Sans Serif';
  FTVFont.Size        := 8;
  FTVFont.Color       := clWindowText;

  //MRU
  FMRU                := True;
  FSubMenuMRU         := False;
  FMRUNumber          := 11;

  //MFU
  FMFU                := True;
  FSubMenuMFU         := True;
  FMFUNumber          := 11;

  //Backup
  FBackup             := True;
  FBackupNumber       := 5;

  //Other functions
  FAutorunStartup     := True;
  FAutorunShutdown    := True;
  FCache              := True;
  FScheduler          := True;

  //Execution
  FActionOnExe        := aeDefault;
  FRunSingleClick     := False;
  FConfirmRunCat      := True;
  FAutoCloseProcess   := False;

  //Trayicon
  FTrayIcon           := True;
  FTrayUseCustomIcon  := False;
  FTrayCustomIconPath := '';
  FActionClickLeft    := tcShowClassicMenu;
  FActionClickMiddle  := tcNone;
  FActionClickRight   := tcShowGraphicMenu;
  FAutoExpansionFolder := True;

  //Graphic Menu
  FGMTheme            := 'Default';
  FGMFade             := True;
  FGMPersonalPicture  := 'PersonalPicture.png';
  FGMPositionTop      := -1;
  FGMPositionLeft     := -1;
  FGMAutomaticHideMenu := True;
  FGMShowUserPicture   := True;

  //Right buttons
  FGMBtnDocuments     := '%USERPROFILE%\Documents';
  FGMBtnPictures      := '%USERPROFILE%\Pictures';
  FGMBtnMusic         := '%USERPROFILE%\Music';
  FGMBtnVideos        := '%USERPROFILE%\Videos';
  FGMBtnExplore       := '$drive';

  //Misc
  FReadOnlyMode       := False;
  FChanged            := False;
  FASuiteState        := lsStartUp;
  FHotKey             := True;

  //Hotkey
  FWindowHotKey       := 0;
  FGraphicMenuHotKey  := 0;
  FClassicMenuHotkey  := 0;

  //ScanFolder
  FScanFolderAutoExtractName := True;
  FScanFolderFileTypes  := TStringList.Create;
  FScanFolderFileTypes.Add(EXT_LNK);
  FScanFolderFileTypes.Add(EXT_EXE);
  FScanFolderExcludeNames := TStringList.Create;
  FScanFolderExcludeNames.Add('uninstall');
end;

destructor TConfiguration.Destroy;
begin
  inherited Destroy;
  FTVFont.Free;
  FScanFolderFileTypes.Free;
  FScanFolderExcludeNames.Free;
  FPaths.Free;
  FListManager.Destroy;
  FDBManager.Destroy;
  FIconsManager.Destroy;
  FLogger.Free;
end;

procedure TConfiguration.SetASuiteState(const Value: TLauncherState);
begin
  TASuiteLogger.Info('Changed ASuite State (old value %s, new value %s)',
    [GetEnumName(TypeInfo(TLauncherState), Ord(FASuiteState)),
     GetEnumName(TypeInfo(TLauncherState), Ord(Value))]);

  FASuiteState := Value;
end;

function TConfiguration.GetImportTree: TVirtualStringTree;
begin
  Result := nil;
  if Assigned(frmImportList) then
    Result := frmImportList.vstListImp;
end;

function TConfiguration.GetMainTree: TVirtualStringTree;
begin
  Assert(Assigned(FMainTree));
  Result := FMainTree;
end;

procedure TConfiguration.HandleParam(const Param: string);
var
  sName, sValue: string;

  procedure ParseParam(s: string);
  var
    iSplit: Integer;
  begin
    if (s[1] in ['-', '/']) then
    begin
      Delete(s, 1, 1);
      iSplit := Pos('=', s);
      if iSplit <> 0 then
      begin
        sName := Copy(s, 1, iSplit - 1);
        sValue := Copy(s, iSplit + 1, 666);
      end;
    end;
  end;

begin
  TASuiteLogger.Info('Received parameter "%s"', [Param]);
  ParseParam(Param);
  if sName <> '' then
  begin
    if CompareText(sName, 'list') = 0 then
      FPaths.SuitePathList := FPaths.RelativeToAbsolute(RemoveAllQuotes(sValue));
    if CompareText(sName, 'additem') = 0 then
    begin
      //Add new node
      if Assigned(FDBManager) then
        TVirtualTreeMethods.Create.AddNodeByPathFile(FMainTree, nil, RemoveAllQuotes(sValue), amInsertAfter);
    end;
  end;
end;

procedure TConfiguration.LoadList;
var
  sFilePath  : string;
begin
  //TODO: Move this method in proper place
  TASuiteLogger.Info('Finding ASuite SQLite Database', []);
  Assert(Assigned(FMainTree), 'FMainTree is not assigned!');
  try
    //List & Options
    if ExtractFileExt(FPaths.SuitePathList) = EXT_XML then
    begin
      sFilePath := FPaths.SuitePathList;
      FPaths.SuitePathList := ChangeFileExt(FPaths.SuiteFileName, EXT_SQL);
    end;
    if Assigned(FDBManager) then
      FDBManager.Setup(FPaths.SuitePathList);
  finally
    //If exists old list format (xml), use it
    if sFilePath <> '' then
      LoadDatabaseFromXML(sFilePath)
    else //Use new list format (sqlite db)
      FDBManager.LoadData(FMainTree);
  end;
end;

procedure TConfiguration.SetHoldSize(value: Boolean);
begin
  FHoldSize := value;
  if FHoldSize then
  begin
    frmMain.BorderStyle := bsSingle;
    frmMain.BorderIcons := [biSystemMenu, biMinimize];
  end
  else begin
    frmMain.BorderStyle := bsSizeable;
    frmMain.BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  end;
end;

procedure TConfiguration.SaveSettings(AJSONConfig: TJSONConfig);
begin
  try
    AJSONConfig.SetValue(CONFIG_GMTHEME, Self.GMTheme);

    //General
    AJSONConfig.SetValue(CONFIG_STARTWITHWINDOWS, Self.StartWithWindows);
    AJSONConfig.SetValue(CONFIG_SHOWPANELATSTARTUP, Self.ShowPanelAtStartUp);
    AJSONConfig.SetValue(CONFIG_SHOWMENUATSTARTUP, Self.ShowGraphicMenuAtStartUp);
    AJSONConfig.SetValue(CONFIG_MISSEDSCHEDULERTASK, Self.MissedSchedulerTask);

    // Main Form
    AJSONConfig.SetValue(CONFIG_LANGID, Self.LangID);
    AJSONConfig.SetValue(CONFIG_USECUSTOMTITLE, Self.UseCustomTitle);
    AJSONConfig.SetValue(CONFIG_CUSTOMTITLESTRING, Self.CustomTitleString);
    AJSONConfig.SetValue(CONFIG_HIDETABSEARCH, Self.HideTabSearch);
    AJSONConfig.SetValue(CONFIG_SEARCHASYOUTYPE, Self.SearchAsYouType);
    AJSONConfig.SetValue(CONFIG_HOLDSIZE, Self.HoldSize);
    AJSONConfig.SetValue(CONFIG_ALWAYSONTOP, Self.AlwaysOnTop);

    // Main Form - Position and size
    AJSONConfig.SetValue(CONFIG_MAINFORM_LEFT, frmMain.Left);
    AJSONConfig.SetValue(CONFIG_MAINFORM_TOP, frmMain.Top);
    AJSONConfig.SetValue(CONFIG_MAINFORM_WIDTH, frmMain.Width);
    AJSONConfig.SetValue(CONFIG_MAINFORM_HEIGHT, frmMain.Height);

    // Main Form - Treevew
    AJSONConfig.SetValue(CONFIG_TVBACKGROUND, Self.TVBackground);
    AJSONConfig.SetValue(CONFIG_TVBACKGROUNDPATH, Self.TVBackgroundPath);
    AJSONConfig.SetValue(CONFIG_TVSMALLICONSIZE, Self.TVSmallIconSize);
    AJSONConfig.SetValue(CONFIG_TVAUTOOPCLCATS, Self.TVAutoOpClCats);
    AJSONConfig.SetValue(CONFIG_TVAUTOOPCATSDRAG, Self.TVAutoOpCatsDrag);
    AJSONConfig.SetValue(CONFIG_TVDISABLECONFIRMDELETE, Self.TVDisableConfirmDelete);
    AJSONConfig.SetValue(CONFIG_TVFONTNAME, UnicodeString(Self.TVFont.Name));

    // Main Form - TVFont
    AJSONConfig.SetValue(CONFIG_TVFONTSIZE, Self.TVFont.Size);
    AJSONConfig.SetValue(CONFIG_TVFONTCOLOR, ColorToHtml(Self.TVFont.Color));
    AJSONConfig.SetValue(CONFIG_TVFONTSTYLE_BOLD, (fsBold in Self.TVFont.Style));
    AJSONConfig.SetValue(CONFIG_TVFONTSTYLE_ITALIC, (fsItalic in Self.TVFont.Style));
    AJSONConfig.SetValue(CONFIG_TVFONTSTYLE_UNDERLINE, (fsUnderline in Self.TVFont.Style));
    AJSONConfig.SetValue(CONFIG_TVFONTSTYLE_STRIKEOUT, (fsStrikeOut in Self.TVFont.Style));

    // MRU
    AJSONConfig.SetValue(CONFIG_MRU, Self.MRU);
    AJSONConfig.SetValue(CONFIG_SUBMENUMRU, Self.SubMenuMRU);
    AJSONConfig.SetValue(CONFIG_MRUNUMBER, Self.MRUNumber);

    // MFU
    AJSONConfig.SetValue(CONFIG_MFU, Self.MFU);
    AJSONConfig.SetValue(CONFIG_SUBMENUMFU, Self.SubMenuMFU);
    AJSONConfig.SetValue(CONFIG_MFUNUMBER, Self.MFUNumber);

    // Backup
    AJSONConfig.SetValue(CONFIG_BACKUP, Self.Backup);
    AJSONConfig.SetValue(CONFIG_BACKUPNUMBER, Self.BackupNumber);

    // Other functions
    AJSONConfig.SetValue(CONFIG_AUTORUNSTARTUP, Self.AutorunStartup);
    AJSONConfig.SetValue(CONFIG_AUTORUNSHUTDOWN, Self.AutorunShutdown);
    AJSONConfig.SetValue(CONFIG_CACHE, Self.Cache);
    AJSONConfig.SetValue(CONFIG_SCHEDULER, Self.Scheduler);

    // Execution
    AJSONConfig.SetValue(CONFIG_ACTIONONEXE, Integer(Self.ActionOnExe));
    AJSONConfig.SetValue(CONFIG_RUNSINGLECLICK, Self.RunSingleClick);
    AJSONConfig.SetValue(CONFIG_CONFIRMMESSAGECAT, Self.ConfirmRunCat);
    AJSONConfig.SetValue(CONFIG_AUTOCLOSEPROCESS, Self.AutoCloseProcess);

    // Trayicon
    AJSONConfig.SetValue(CONFIG_TRAYICON, Self.TrayIcon);
    AJSONConfig.SetValue(CONFIG_TRAYUSECUSTOMICON, Self.TrayUseCustomIcon);
    AJSONConfig.SetValue(CONFIG_TRAYCUSTOMICONPATH, Self.TrayCustomIconPath);
    AJSONConfig.SetValue(CONFIG_ACTIONCLICKLEFT, Integer(Self.ActionClickLeft));
    AJSONConfig.SetValue(CONFIG_ACTIONCLICKMIDDLE, Integer(Self.ActionClickMiddle));
    AJSONConfig.SetValue(CONFIG_ACTIONCLICKRIGHT, Integer(Self.ActionClickRight));
    AJSONConfig.SetValue(CONFIG_AUTOEXPANSIONFOLDER, Self.AutoExpansionFolder);

    //Graphic Menu
    AJSONConfig.SetValue(CONFIG_GMFADE, Self.GMFade);
    AJSONConfig.SetValue(CONFIG_GMPERSONALPICTURE, Self.GMSmallIconSize);
    AJSONConfig.SetValue(CONFIG_GMSMALLICONSIZE, Self.GMPersonalPicture);
    AJSONConfig.SetValue(CONFIG_GMPOSITIONTOP, Self.GMPositionTop);
    AJSONConfig.SetValue(CONFIG_GMPOSITIONLEFT, Self.GMPositionLeft);
    AJSONConfig.SetValue(CONFIG_GMAUTOHIDEMENU, Self.GMAutomaticHideMenu);
    AJSONConfig.SetValue(CONFIG_GMSHOWUSERPICTURE, Self.GMShowUserPicture);

    //Right buttons
    AJSONConfig.SetValue(CONFIG_GMBTNDOCUMENTS, Self.GMBtnDocuments);
    AJSONConfig.SetValue(CONFIG_GMBTNPICTURES, Self.GMBtnPictures);
    AJSONConfig.SetValue(CONFIG_GMBTNMUSIC, Self.GMBtnMusic);
    AJSONConfig.SetValue(CONFIG_GMBTNVIDEOS, Self.GMBtnVideos);
    AJSONConfig.SetValue(CONFIG_GMBTNEXPLORE, Self.GMBtnExplore);

    //HotKeys
    //TODO: Maybe better use string and not word type (more human reading)
    AJSONConfig.SetValue(CONFIG_HOTKEY, Self.HotKey);
    AJSONConfig.SetValue(CONFIG_WINDOWHOTKEY, Self.WindowHotKey);
    AJSONConfig.SetValue(CONFIG_MENUHOTKEY, Self.GraphicMenuHotKey);
    AJSONConfig.SetValue(CONFIG_CLASSICMENUHOTKEY, Self.ClassicMenuHotkey);

    // Misc
    AJSONConfig.SetValue(CONFIG_SCANFOLDERAUTOEXTRACTNAME, Self.ScanFolderAutoExtractName);
    AJSONConfig.SetValue(CONFIG_SCANFOLDERFILETYPES, Self.ScanFolderFileTypes);
    AJSONConfig.SetValue(CONFIG_SCANFOLDEREXCLUDENAMES, Self.ScanFolderExcludeNames);
  finally
    Self.Changed := False;
  end;
end;

procedure TConfiguration.RestoreSettings(AJSONConfig: TJSONConfig);
var
  nLeft, nTop, nWidth, nHeight: Integer;
begin
  //Get GMTheme before everything (so ASuite know where icons folder)
  Self.GMTheme := AJSONConfig.GetValue(CONFIG_GMTHEME, Self.GMTheme);
  TASuiteLogger.Info('Loaded GraphicMenu theme = ', [Self.GMTheme]);

  //General
  Self.StartWithWindows          := AJSONConfig.GetValue(CONFIG_STARTWITHWINDOWS, Self.StartWithWindows);
  Self.ShowPanelAtStartUp        := AJSONConfig.GetValue(CONFIG_SHOWPANELATSTARTUP, Self.ShowPanelAtStartUp);
  Self.ShowGraphicMenuAtStartUp  := AJSONConfig.GetValue(CONFIG_SHOWMENUATSTARTUP, Self.ShowGraphicMenuAtStartUp);
  Self.MissedSchedulerTask       := AJSONConfig.GetValue(CONFIG_MISSEDSCHEDULERTASK, Self.MissedSchedulerTask);

  // Main Form
  Self.LangID                    := AJSONConfig.GetValue(CONFIG_LANGID, Self.LangID);
  Self.UseCustomTitle            := AJSONConfig.GetValue(CONFIG_USECUSTOMTITLE, Self.UseCustomTitle);
  Self.CustomTitleString         := AJSONConfig.GetValue(CONFIG_CUSTOMTITLESTRING, Self.CustomTitleString);
  Self.HideTabSearch             := AJSONConfig.GetValue(CONFIG_HIDETABSEARCH, Self.HideTabSearch);
  Self.SearchAsYouType           := AJSONConfig.GetValue(CONFIG_SEARCHASYOUTYPE, Self.SearchAsYouType);
  Self.HoldSize                  := AJSONConfig.GetValue(CONFIG_HOLDSIZE, Self.HoldSize);
  Self.AlwaysOnTop               := AJSONConfig.GetValue(CONFIG_ALWAYSONTOP, Self.AlwaysOnTop);

  // Main Form - Position and size
  nLeft   := AJSONConfig.GetValue(CONFIG_MAINFORM_LEFT, frmMain.Left);
  nTop    := AJSONConfig.GetValue(CONFIG_MAINFORM_TOP, frmMain.Top);
  nWidth  := AJSONConfig.GetValue(CONFIG_MAINFORM_WIDTH, frmMain.Width);
  nHeight := AJSONConfig.GetValue(CONFIG_MAINFORM_HEIGHT, frmMain.Height);
  frmMain.SetBounds(nLeft, nTop, nWidth, nHeight);

  // Main Form - Treevew
  Self.TVBackground              := AJSONConfig.GetValue(CONFIG_TVBACKGROUND, Self.TVBackground);
  Self.TVBackgroundPath          := AJSONConfig.GetValue(CONFIG_TVBACKGROUNDPATH, Self.TVBackgroundPath);
  Self.TVSmallIconSize           := AJSONConfig.GetValue(CONFIG_TVSMALLICONSIZE, Self.TVSmallIconSize);
  Self.TVAutoOpClCats            := AJSONConfig.GetValue(CONFIG_TVAUTOOPCLCATS, Self.TVAutoOpClCats);
  Self.TVAutoOpCatsDrag          := AJSONConfig.GetValue(CONFIG_TVAUTOOPCATSDRAG, Self.TVAutoOpCatsDrag);
  Self.TVDisableConfirmDelete    := AJSONConfig.GetValue(CONFIG_TVDISABLECONFIRMDELETE, Self.TVDisableConfirmDelete);

  // Main Form - TVFont
  Self.TVFont.Name               := AJSONConfig.GetValue(CONFIG_TVFONTNAME, UnicodeString(Self.TVFont.Name));
  Self.TVFont.Color              := HtmlToColor(AJSONConfig.GetValue(CONFIG_TVFONTCOLOR, ColorToHtml(Self.TVFont.Color)));
  Self.TVFont.Size               := AJSONConfig.GetValue(CONFIG_TVFONTSIZE, Self.TVFont.Size);
  Self.TVFont.Style              := TFontStyles({byte}AJSONConfig.GetValue(CONFIG_TVFONTSIZE, 0));
  if AJSONConfig.GetValue(CONFIG_TVFONTSTYLE_BOLD, (fsBold in Self.TVFont.Style)) then
     Self.TVFont.Style := Self.TVFont.Style + [fsBold];
  if AJSONConfig.GetValue(CONFIG_TVFONTSTYLE_ITALIC, (fsItalic in Self.TVFont.Style)) then
     Self.TVFont.Style := Self.TVFont.Style + [fsItalic];
  if AJSONConfig.GetValue(CONFIG_TVFONTSTYLE_UNDERLINE, (fsUnderline in Self.TVFont.Style)) then
     Self.TVFont.Style := Self.TVFont.Style + [fsUnderline];
  if AJSONConfig.GetValue(CONFIG_TVFONTSTYLE_STRIKEOUT, (fsStrikeOut in Self.TVFont.Style)) then
     Self.TVFont.Style := Self.TVFont.Style + [fsStrikeOut];
  Self.MainTree.Font.Assign(Self.TVFont);

  // MRU
  Self.MRU                       := AJSONConfig.GetValue(CONFIG_MRU, Self.MRU);
  Self.SubMenuMRU                := AJSONConfig.GetValue(CONFIG_SUBMENUMRU, Self.SubMenuMRU);
  Self.MRUNumber                 := AJSONConfig.GetValue(CONFIG_MRUNUMBER, Self.MRUNumber);

  // MFU
  Self.MFU                       := AJSONConfig.GetValue(CONFIG_MFU, Self.MFU);
  Self.SubMenuMFU                := AJSONConfig.GetValue(CONFIG_SUBMENUMFU, Self.SubMenuMFU);
  Self.MFUNumber                 := AJSONConfig.GetValue(CONFIG_MFUNUMBER, Self.MFUNumber);

  // Backup
  Self.Backup                    := AJSONConfig.GetValue(CONFIG_BACKUP, Self.Backup);
  Self.BackupNumber              := AJSONConfig.GetValue(CONFIG_BACKUPNUMBER, Self.BackupNumber);

  // Other functions
  Self.AutorunStartup            := AJSONConfig.GetValue(CONFIG_AUTORUNSTARTUP, Self.AutorunStartup);
  Self.AutorunShutdown           := AJSONConfig.GetValue(CONFIG_AUTORUNSHUTDOWN, Self.AutorunShutdown);
  Self.Cache                     := AJSONConfig.GetValue(CONFIG_CACHE, Self.Cache);
  Self.Scheduler                 := AJSONConfig.GetValue(CONFIG_SCHEDULER, Self.Scheduler);

  // Execution
  Self.ActionOnExe               := TActionOnExecute(AJSONConfig.GetValue(CONFIG_ACTIONONEXE, Integer(Self.ActionOnExe)));
  Self.RunSingleClick            := AJSONConfig.GetValue(CONFIG_RUNSINGLECLICK, Self.RunSingleClick);
  Self.ConfirmRunCat             := AJSONConfig.GetValue(CONFIG_CONFIRMMESSAGECAT, Self.ConfirmRunCat);
  Self.AutoCloseProcess          := AJSONConfig.GetValue(CONFIG_AUTOCLOSEPROCESS, Self.AutoCloseProcess);

  // Trayicon
  Self.TrayIcon                  := AJSONConfig.GetValue(CONFIG_TRAYICON, Self.TrayIcon);
  Self.TrayUseCustomIcon         := AJSONConfig.GetValue(CONFIG_TRAYUSECUSTOMICON, Self.TrayUseCustomIcon);
  Self.TrayCustomIconPath        := AJSONConfig.GetValue(CONFIG_TRAYCUSTOMICONPATH, Self.TrayCustomIconPath);
  Self.ActionClickLeft           := TTrayiconActionClick(AJSONConfig.GetValue(CONFIG_ACTIONCLICKLEFT, Integer(Self.ActionClickLeft)));
  Self.ActionClickMiddle         := TTrayiconActionClick(AJSONConfig.GetValue(CONFIG_ACTIONCLICKMIDDLE, Integer(Self.ActionClickMiddle)));
  Self.ActionClickRight          := TTrayiconActionClick(AJSONConfig.GetValue(CONFIG_ACTIONCLICKRIGHT, Integer(Self.ActionClickRight)));
  Self.AutoExpansionFolder       := AJSONConfig.GetValue(CONFIG_AUTOEXPANSIONFOLDER, Self.AutoExpansionFolder);

  //Graphic Menu
  Self.GMFade                    := AJSONConfig.GetValue(CONFIG_GMFADE, Self.GMFade);
  Self.GMSmallIconSize           := AJSONConfig.GetValue(CONFIG_GMPERSONALPICTURE, Self.GMSmallIconSize);
  Self.GMPersonalPicture         := AJSONConfig.GetValue(CONFIG_GMSMALLICONSIZE, Self.GMPersonalPicture);
  Self.GMPositionTop             := AJSONConfig.GetValue(CONFIG_GMPOSITIONTOP, Self.GMPositionTop);
  Self.GMPositionLeft            := AJSONConfig.GetValue(CONFIG_GMPOSITIONLEFT, Self.GMPositionLeft);
  Self.GMAutomaticHideMenu       := AJSONConfig.GetValue(CONFIG_GMAUTOHIDEMENU, Self.GMAutomaticHideMenu);
  Self.GMShowUserPicture         := AJSONConfig.GetValue(CONFIG_GMSHOWUSERPICTURE, Self.GMShowUserPicture);

  //Right buttons
  Self.GMBtnDocuments            := AJSONConfig.GetValue(CONFIG_GMBTNDOCUMENTS, Self.GMBtnDocuments);
  Self.GMBtnPictures             := AJSONConfig.GetValue(CONFIG_GMBTNPICTURES, Self.GMBtnPictures);
  Self.GMBtnMusic                := AJSONConfig.GetValue(CONFIG_GMBTNMUSIC, Self.GMBtnMusic);
  Self.GMBtnVideos               := AJSONConfig.GetValue(CONFIG_GMBTNVIDEOS, Self.GMBtnVideos);
  Self.GMBtnExplore              := AJSONConfig.GetValue(CONFIG_GMBTNEXPLORE, Self.GMBtnExplore);

  //HotKeys
  Self.HotKey                    := AJSONConfig.GetValue(CONFIG_HOTKEY, Self.HotKey);
  Self.WindowHotKey              := AJSONConfig.GetValue(CONFIG_WINDOWHOTKEY, Self.WindowHotKey);
  Self.GraphicMenuHotKey         := AJSONConfig.GetValue(CONFIG_MENUHOTKEY, Self.GraphicMenuHotKey);
  Self.ClassicMenuHotkey         := AJSONConfig.GetValue(CONFIG_CLASSICMENUHOTKEY, Self.ClassicMenuHotkey);

  // Misc
  Self.ScanFolderAutoExtractName := AJSONConfig.GetValue(CONFIG_SCANFOLDERAUTOEXTRACTNAME, Self.ScanFolderAutoExtractName);
  AJSONConfig.GetValue(CONFIG_SCANFOLDERFILETYPES, Self.ScanFolderFileTypes, Self.ScanFolderFileTypes);
  AJSONConfig.GetValue(CONFIG_SCANFOLDEREXCLUDENAMES, Self.ScanFolderExcludeNames, Self.ScanFolderExcludeNames);

  Self.AfterUpdateConfig;
end;

procedure TConfiguration.SetHotKey(const Value: Boolean);
begin
  if (FHotKey <> Value) then
  begin
    FHotKey := Value;
    ListManager.HotKeyItemList.RefreshRegs;
  end;
end;

function TConfiguration.SaveList(DoBackup: Boolean): Boolean;
begin
  //TODO: Move this method in proper place
  Result := False;
  if not FReadOnlyMode then
    Result := FDBManager.SaveData(Config.MainTree, DoBackup);
end;

procedure TConfiguration.LoadConfig;
var
  JSONConfig: TJSONConfig;
begin                                                
  TASuiteLogger.Enter('Loading ASuite configuration', Self);

  //if FileExists(SETTINGS_FILENAME) then
  //begin
  //  TASuiteLogger.Info('Found ASuite configuration', []);
    try
      JSONConfig := TJSONConfig.Create(nil);
      JSONConfig.Formatted := True;
      JSONConfig.FormatIndentsize := 4;    
      JSONConfig.Filename := SETTINGS_FILENAME; 
      RestoreSettings(JSONConfig);
    finally
      JSONConfig.Free;
    end;
  //end
  //else   
  //  TASuiteLogger.Info('ASuite Configuration not found', []);
end;

procedure TConfiguration.SaveConfig;  
var
  JSONConfig: TJSONConfig;
begin
  //If settings is changed, insert it else (if it exists) update it
  if Config.Changed then
  begin
    TASuiteLogger.Enter('Saving ASuite Options', Self);
    try
      JSONConfig := TJSONConfig.Create(nil);
      JSONConfig.Formatted := True;
      JSONConfig.FormatIndentsize := 4;
      JSONConfig.Filename := SETTINGS_FILENAME;
      SaveSettings(JSONConfig);
    finally
      JSONConfig.Free;
    end;
  end;
end;

procedure TConfiguration.SetAlwaysOnTop(value: Boolean);
begin
  if FAlwaysOnTop <> value then
  begin
    FAlwaysOnTop := value;
    if FAlwaysOnTop then
      frmMain.FormStyle := fsStayOnTop
    else begin
      ShowMessageEx(msgRestartAsuiteChanges);
      frmMain.FormStyle := fsNormal;
    end;
  end;
end;

procedure TConfiguration.SetBackup(const Value: Boolean);
begin
  FBackup := Value;
  if FBackup then
    FPaths.CheckBackupFolder;
end;

procedure TConfiguration.SetBackupNumber(const Value: Integer);
begin
  if Value < FBackupNumber then
    DeleteOldBackups(Value);
  FBackupNumber := Value;
end;

procedure TConfiguration.SetScheduler(value: Boolean);
begin
  FScheduler := value;
  TScheduler.Create.Timer.Enabled := FScheduler;
end;

procedure TConfiguration.SetTrayIcon(value: Boolean);
begin
  FTrayIcon := value;
  dmTrayMenu.tiTrayMenu.Visible := FTrayIcon;
  if (not(FShowPanelAtStartUp)) and (not(FTrayicon)) then
    FShowPanelAtStartUp := True;
end;

procedure TConfiguration.SetTrayUseCustomIcon(value: Boolean);
var
  sPath: string;
begin
  FTrayUseCustomIcon := value;
  dmTrayMenu.tiTrayMenu.Visible := False;
  sPath := FPaths.RelativeToAbsolute(FTrayCustomIconPath);
  if (FTrayUseCustomIcon) and (FileExists(sPath)) then
    dmTrayMenu.tiTrayMenu.Icon.LoadFromFile(sPath)
  else begin
    sPath := FPaths.RelativeToAbsolute(FPaths.SuitePathCurrentTheme + ICONS_DIR + 'asuite' + EXT_ICO);
    if FileExists(sPath) then
      dmTrayMenu.tiTrayMenu.Icon.LoadFromFile(sPath);
  end;
  //If you can't change trayicon's property visible, it will use old icon
  dmTrayMenu.tiTrayMenu.Visible := FTrayIcon;
end;

procedure TConfiguration.SetUseCustomTitle(value: Boolean);
begin
  FUseCustomTitle := value;
  if (FUseCustomTitle) and (FCustomTitleString <> '') then
    frmMain.Caption := FCustomTitleString
  else
    frmMain.Caption := APP_TITLE;
end;

procedure TConfiguration.SetWindowHotKey(const Value: Cardinal);
begin
  if (FHotKey) then
  begin
    //Unregister hotkey (if actived)
    UnregisterHotKeyEx(frmMain.Handle);
    //Register hotkey
    if (Value <> 0) then
    begin
      if Not(RegisterHotKeyEx(frmMain.Handle, Value)) then
      begin
        ShowMessageEx(msgErrRegWindowHotkey, true);
      end;
    end;
  end;
  FWindowHotKey := Value;
end;

procedure TConfiguration.UpdateGMTheme;
begin
  TASuiteLogger.Info('Change Current Theme path to "%s"', [FPaths.SuitePathMenuThemes + FGMTheme]);
  //Set Paths
  FPaths.SuitePathCurrentTheme := IncludeTrailingBackslash(FPaths.SuitePathMenuThemes + FGMTheme);
  FIconsManager.PathTheme      := FPaths.SuitePathCurrentTheme;
  //Loading icons
  frmMain.SetAllIcons;
  //Refresh GraphicMenu
  if Assigned(frmGraphicMenu) then
    TThemeEngine.Create.LoadTheme;
end;

procedure TConfiguration.SetTVAutoOpClCats(value: Boolean);
begin
  FTVAutoOpClCats := value;
  if FTVAutoOpClCats then
    FMainTree.TreeOptions.AutoOptions := FMainTree.TreeOptions.AutoOptions + [toAutoExpand]
  else
    FMainTree.TreeOptions.AutoOptions := FMainTree.TreeOptions.AutoOptions - [toAutoExpand];
end;

procedure TConfiguration.SetHideTabSearch(value: Boolean);
begin
  FHideTabSearch := value;
  with frmMain do
  begin
    tbSearch.TabVisible    := Not(FHideTabSearch);
    tbList.TabVisible      := Not(FHideTabSearch);
    pcList.ActivePageIndex := 0;
  end;
end;

procedure TConfiguration.SetShowPanelAtStartUp(value: Boolean);
begin
  FShowPanelAtStartUp := value;
end;

procedure TConfiguration.SetTVBackground(value: Boolean);
var
  BackgroundBMP : Graphics.TBitmap;
  BackgroundPNG : TPortableNetworkGraphic;
begin
  FTVBackground := value;
  FMainTree.TreeOptions.PaintOptions := FMainTree.TreeOptions.PaintOptions - [toShowBackground];
  if (FTVBackground) and (FTVBackgroundPath <> '') and
     (FileExists(FPaths.RelativeToAbsolute(FTVBackgroundPath))) then
  begin
    if LowerCase(ExtractFileExt(FPaths.RelativeToAbsolute(FTVBackgroundPath))) <> '.bmp' then
    begin
      BackgroundBMP := Graphics.TBitmap.Create;
      BackgroundPNG := TPortableNetworkGraphic.Create;
      try
        BackgroundPNG.LoadFromFile(FPaths.RelativeToAbsolute(FTVBackgroundPath));
        BackgroundBMP.Assign(BackgroundPNG);
        FMainTree.Background.Bitmap := BackgroundBMP;
      finally
        BackgroundBMP.Free;
        BackgroundPNG.Free;
      end;
    end
    else
      FMainTree.Background.LoadFromFile(FPaths.RelativeToAbsolute(FTVBackgroundPath));
    FMainTree.TreeOptions.PaintOptions := FMainTree.TreeOptions.PaintOptions + [toShowBackground];
  end
  else
    FMainTree.TreeOptions.PaintOptions := FMainTree.TreeOptions.PaintOptions - [toShowBackground];
  FMainTree.Update;
end;

procedure TConfiguration.SetTVFont(value: TFont);
begin
  if FTVFont <> value then
  begin
    FTVFont.Name  := value.Name;
    FTVFont.Style := value.Style;
    FTVFont.Size  := value.Size;
    FTVFont.Color := value.Color;
    FMainTree.Font.Assign(FTVFont);
  end;
end;

procedure TConfiguration.SetTVSmallIconSize(const Value: Boolean);
begin
  //If new value is different than old value, full collapse Tree and get icons
  if FTVSmallIconSize <> Value then
  begin
    FTVSmallIconSize := Value;
    //Change node height and imagelist
    TVirtualTreeMethods.Create.ChangeTreeIconSize(FMainTree, FTVSmallIconSize);
    if FMainTree.HasChildren[FMainTree.RootNode] then
    begin
      FMainTree.FullCollapse;
      TVirtualTreeMethods.Create.ChangeAllNodeHeight(FMainTree, FMainTree.DefaultNodeHeight);
    end;
  end;
end;

procedure TConfiguration.SetCache(value: boolean);
begin
  FCache := value;
  //If disabled, delete all file icon-cache and folders cache
  if Not(FCache) then
    FPaths.RemoveCacheFolders
  else //Else create folders cache
    FPaths.CheckCacheFolders;
end;

procedure TConfiguration.SetChanged(const Value: Boolean);
begin
  FChanged := Value;
end;

procedure TConfiguration.SetClassicMenuHotkey(const Value: Cardinal);
begin
  if (Config.HotKey) then
  begin
    //Unregister hotkey
    UnregisterHotKeyEx(frmCMenuID);
    //Register Menuhotkey
    if (Value <> 0) then
    begin
      if Not(RegisterHotKeyEx(frmCMenuID, Value)) then
        ShowMessageEx(msgErrRegCMHotkey);
    end;
  end;
  FClassicMenuHotKey := Value;
end;

procedure TConfiguration.SetGMBtnDocuments(Value: string);
begin
  if value = '' then
    FGMBtnDocuments := '%USERPROFILE%\Documents'
  else
    FGMBtnDocuments := value;
end;

procedure TConfiguration.SetGMBtnExplore(Value: string);
begin
  if value = '' then
    FGMBtnExplore := '$drive\'
  else
    FGMBtnExplore := value;
end;

procedure TConfiguration.SetGMBtnMusic(Value: string);
begin
  if value = '' then
    FGMBtnMusic := '%USERPROFILE%\Music'
  else
    FGMBtnMusic := value;
end;

procedure TConfiguration.SetGMBtnPictures(Value: string);
begin
  if value = '' then
    FGMBtnPictures := '%USERPROFILE%\Pictures'
  else
    FGMBtnPictures := value;
end;

procedure TConfiguration.SetGMBtnVideos(Value: string);
begin
  if value = '' then
    FGMBtnVideos := '%USERPROFILE%\Videos'
  else
    FGMBtnVideos := value;
end;

procedure TConfiguration.SetGMTheme(value: string);
begin
  if value = '' then
    FGMTheme := 'default'
  else
    FGMTheme := value;
  UpdateGMTheme;
end;

procedure TConfiguration.SetStartWithWindows(value: boolean);
begin
  FStartWithWindows := value;
  if FStartWithWindows then
    SetASuiteAtWindowsStartup
  else
    DeleteASuiteAtWindowsStartup;
end;

procedure TConfiguration.SetLangID(value: String);
begin
  if (value <> '') then
    FLangID := value
  else
    FLangID := 'en';

  SetDefaultLang(value, FPaths.SuitePathLocale);
end;

procedure TConfiguration.SetGraphicMenuHotKey(const Value: Cardinal);
begin
  if (Config.HotKey) then
  begin
    //Unregister hotkey
    UnregisterHotKeyEx(frmGMenuID);
    //Register Menuhotkey
    if (Value <> 0) then
    begin
      if Not(RegisterHotKeyEx(frmGMenuID, Value)) then
        ShowMessageEx(msgErrRegGMHotkey);
    end;
  end;
  FGraphicMenuHotKey := Value;
end;

finalization
  FreeAndNil(Config);

end.
