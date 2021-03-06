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

unit Forms.ScanFolder;

{$MODE DelphiUnicode}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, VirtualTrees, ComCtrls, DefaultTranslator, ShellCtrls,
  ImgList, StrUtils, FileUtil, Thread.FindFiles;

type

  { TfrmScanFolder }

  TfrmScanFolder = class(TForm)
    btnScan: TButton;
    btnCancel: TButton;
    pnlFilters: TPanel;
    
    vstShell: TShellTreeView;
    grpFileTypes: TGroupBox;
    btnTypesDelete: TButton;
    btnTypesAdd: TButton;
    edtTypes: TEdit;
    grpExclude: TGroupBox;
    edtExclude: TEdit;
    btnExcludeAdd: TButton;
    btnExcludeDelete: TButton;
    vstTypes: TVirtualStringTree;
    vstExclude: TVirtualStringTree;
    ilExtIcons: TImageList;
    grpGeneralSettings: TGroupBox;
    chkExtractName: TCheckBox;
    pbScan: TProgressBar;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure vstGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: AnsiString);
    procedure vstGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure btnTypesAddClick(Sender: TObject);
    procedure btnTypesDeleteClick(Sender: TObject);
    procedure btnExcludeDeleteClick(Sender: TObject);
    procedure btnExcludeAddClick(Sender: TObject);
    procedure edtTypesChange(Sender: TObject);
    procedure edtExcludeChange(Sender: TObject);
    procedure vstShellGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure vstTypesRemoveFromSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vstTypesAddToSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vstExcludeAddToSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vstExcludeRemoveFromSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure btnScanClick(Sender: TObject);
    procedure vstFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FListNode: PVirtualNode;
    FThreadFindFiles: TFindFiles;

    procedure FileFound(AFilePath: String);
    procedure PopulateStringList(AListView: TVirtualStringTree; AStringList: TStringList);
    procedure PopulateVSTListView(AListView: TVirtualStringTree; AStringList: TStringList; AIsExtension: Boolean);
    function GetExtImage(AExtension: string): Integer;
    procedure AddItem(AListView: TVirtualStringTree; AText: string);

    procedure LoadSettings;
    procedure SaveSettings;
    procedure SearchEnd(ATotalFiles: Integer; ATime: Cardinal);
    procedure SetupThreadFinder;
    procedure ThreadTerminate(Sender: TObject);
  public
    { Public declarations }
    class procedure Execute(AOwner: TComponent);
  end;

var
  frmScanFolder: TfrmScanFolder;

implementation

uses
  AppConfig.Main, Kernel.Types, ShellApi, Kernel.Logger, Kernel.Consts,
  DataModules.Icons, NodeDataTypes.Base, VirtualTree.Methods, Kernel.Enumerations,
  Utility.FileFolder, NodeDataTypes.Files, Utility.Misc, Kernel.ResourceStrings;

{$R *.lfm}

procedure TfrmScanFolder.btnCancelClick(Sender: TObject);
begin
  if Assigned(FThreadFindFiles) then
  begin
    if MessageDlg((msgCancelScanFolder), mtWarning, [mbYes,mbNo], 0) = mrYes then
    begin
      FThreadFindFiles.Stop;
      btnCancel.Caption := msgCancel;
    end;
  end
  else
    Close;
end;

procedure TfrmScanFolder.btnExcludeAddClick(Sender: TObject);
begin
  if edtExclude.Text <> '' then
  begin
    AddItem(vstExclude, LowerCase(edtExclude.Text));
    edtExclude.Clear;
  end;
end;

procedure TfrmScanFolder.btnExcludeDeleteClick(Sender: TObject);
var
  Node: PVirtualNode;
begin
  Node := vstExclude.GetFirstSelected;
  if Assigned(Node) then
  begin
    vstExclude.DeleteNode(Node);
    edtExclude.Clear;
  end;
end;

procedure TfrmScanFolder.btnScanClick(Sender: TObject);
var
  ListNodeData : TvBaseNodeData;
begin             
  SaveSettings;

  TASuiteLogger.Info('Start scanning folders to search files', []);
  if vstTypes.HasChildren[vstTypes.RootNode] then
  begin
    if Assigned(vstShell.Selected) then
    begin
      TASuiteLogger.Info('Path: %s', [vstShell.Selected.GetTextPath]);

      pbScan.Style := pbstMarquee;
      pbScan.Position := 0;

      btnScan.Enabled := False;
      btnCancel.Caption := msgStop;

      FThreadFindFiles := TFindFiles.Create;
      SetupThreadFinder;

      Config.MainTree.BeginUpdate;
      //Add parent node named as Form's caption
      FListNode := TVirtualTreeMethods.Create.AddChildNodeEx(Config.MainTree, nil, amInsertAfter, vtdtCategory);
      ListNodeData := TVirtualTreeMethods.Create.GetNodeItemData(FListNode, Config.MainTree);
      ListNodeData.Name := Self.Caption + ' - ' + vstShell.Selected.GetTextPath;

      FThreadFindFiles.Start;
    end
    else begin
      ShowMessageEx(msgErrScanFolderEmptyPath, True);
    end;
  end
  else
    ShowMessageEx(msgErrScanFolderMissingTypes, True);
end;

procedure TfrmScanFolder.btnTypesAddClick(Sender: TObject);
var
  str: string;
begin
  //TODO lazarus: Use regexp to validate the entry (only allowed ".ext")
  if edtTypes.Text <> '' then
  begin
    str := LowerCase(edtTypes.Text);
    AddItem(vstTypes, str);
    edtTypes.Clear;
  end;
end;

procedure TfrmScanFolder.btnTypesDeleteClick(Sender: TObject);
var
  Node: PVirtualNode;
begin
  Node := vstTypes.GetFirstSelected;
  if Assigned(Node) then
  begin
    vstTypes.DeleteNode(Node);
    edtTypes.Clear;
  end;
end;

procedure TfrmScanFolder.edtExcludeChange(Sender: TObject);
begin
  btnExcludeAdd.Enabled := edtExclude.Text <> '';
end;

procedure TfrmScanFolder.vstShellGetImageIndex(Sender: TObject; Node: TTreeNode
  );
begin
  if Node.Level = 0 then
    Node.ImageIndex := Config.IconsManager.GetIconIndex('disk')
  else
    Node.ImageIndex := Config.IconsManager.GetIconIndex('folder');

  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TfrmScanFolder.edtTypesChange(Sender: TObject);
begin
  btnTypesAdd.Enabled := edtTypes.Text <> '';
end;

class procedure TfrmScanFolder.Execute(AOwner: TComponent);
var
  frm: TfrmScanFolder;
begin
  TASuiteLogger.Info('Opening form ScanFolder', []);

  frm := TfrmScanFolder.Create(AOwner);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmScanFolder.AddItem(AListView: TVirtualStringTree; AText: string);
var
  Node: PVirtualNode;
  NodeData: PScanFolderData;
begin
  //Useless *, so I removed it - 14/08/2020
  {
  if AIsExtension then
  begin
    //Add . or * if user forget it
    if AText[1] <> EXT_PATH_MASK then
      AText := EXT_PATH_MASK + AText;
  end;
  }
  //Add item in ListView
  Node := AListView.AddChild(nil);
  NodeData := AListView.GetNodeData(Node);
  NodeData.Text := AText;
  NodeData.ImageIndex := GetExtImage(AText);
end;

procedure TfrmScanFolder.FormCreate(Sender: TObject);
begin
  FThreadFindFiles := nil;

  LoadSettings;

  vstShell.Images := dmImages.ilSmallIcons;
end;

procedure TfrmScanFolder.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Ord(Key) = VK_RETURN then
    btnScanClick(Sender)
  else
    if Ord(Key) = VK_ESCAPE then
      btnCancelClick(Sender);
end;

procedure TfrmScanFolder.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not Assigned(FThreadFindFiles);
end;

function TfrmScanFolder.GetExtImage(AExtension: string): Integer;
var
  FileInfo: TSHFILEINFOW;
  Icon: TIcon;
begin
  Result := -1;
  Icon := TIcon.Create;
  try
    //Get index
    if SHGetFileInfoW(PChar(AExtension), 0, FileInfo, SizeOf(TSHFileInfo), SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES) <> 0 then
    begin
      Icon.Handle := FileInfo.hIcon;
      Result := ilExtIcons.AddIcon(Icon);
    end;
  finally
    Icon.Free;
  end;
end;

procedure TfrmScanFolder.LoadSettings;
begin
  chkExtractName.Checked := Config.ScanFolderAutoExtractName;
  PopulateVSTListView(vstTypes, Config.ScanFolderFileTypes, True);
  PopulateVSTListView(vstExclude, Config.ScanFolderExcludeNames, False);
end;

procedure TfrmScanFolder.PopulateVSTListView(AListView: TVirtualStringTree; AStringList: TStringList; AIsExtension: Boolean);
var
  I: Integer;
begin
  AListView.BeginUpdate;
  try
    AListView.Clear;
    for I := 0 to AStringList.Count - 1 do
      AddItem(AListView, LowerCase(AStringList[I]));
  finally
    AListView.EndUpdate;
  end;
end;

procedure TfrmScanFolder.SaveSettings;
begin
  TASuiteLogger.Info('Save ScanFolder settings in TConfig', []);

  Config.ScanFolderAutoExtractName := chkExtractName.Checked;
  PopulateStringList(vstTypes, Config.ScanFolderFileTypes);
  PopulateStringList(vstExclude, Config.ScanFolderExcludeNames);
  Config.Changed := True;
end;

procedure TfrmScanFolder.SearchEnd(ATotalFiles: Integer; ATime: Cardinal);
begin
  TASuiteLogger.Info('Added new %d nodes! Elapsed Search Time = %d ms', [ATotalFiles, ATime]);

  pbScan.Style := pbstNormal;
  pbScan.Position := pbScan.Max;
  ShowMessageFmtEx(msgFoundNumFiles, [ATotalFiles]);

  //Select and expanded ScanFolder node
  Config.MainTree.ClearSelection;
  if Assigned(FListNode) then
  begin
    Config.MainTree.Selected[FListNode] := True;
    Config.MainTree.FocusedNode := FListNode;
  end;

  btnScan.Enabled := True;
  btnCancel.Caption := msgCancel;
  Config.MainTree.EndUpdate;

  Close;
end;

procedure TfrmScanFolder.SetupThreadFinder;
begin
  FThreadFindFiles.Directory := vstShell.Selected.GetTextPath;
  PopulateStringList(vstTypes, FThreadFindFiles.SearchCriteriaFilename);
  PopulateStringList(vstExclude, FThreadFindFiles.SearchExcludeFilename);
  FThreadFindFiles.OnFileFound := FileFound;
  FThreadFindFiles.OnSearchEnd := SearchEnd;
  FThreadFindFiles.OnTerminate := ThreadTerminate;
end;

procedure TfrmScanFolder.ThreadTerminate(Sender: TObject);
begin
  FThreadFindFiles := nil;
end;

procedure TfrmScanFolder.PopulateStringList(AListView: TVirtualStringTree; AStringList: TStringList);
var
  Node: PVirtualNode;
  NodeData: pScanFolderData;
begin
  AStringList.Clear;
  //From VST to StringList
  Node := AListView.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := AListView.GetNodeData(Node);
    AStringList.Add(LowerCase(NodeData.Text));

    Node := AListView.GetNext(Node);
  end;
end;

procedure TfrmScanFolder.FileFound(AFilePath: String);
var
  sFileExt, sShortName: String;
  Node: PVirtualNode;
  NodeData: TvBaseNodeData;
begin
  sFileExt := ExtractFileExt(AFilePath);
  sShortName := ExtractFileName(AFilePath);

  if Assigned(FListNode) then
  begin
    Node := TVirtualTreeMethods.Create.AddChildNodeEx(Config.MainTree, FListNode, amInsertAfter, vtdtFile, False);
    NodeData := TVirtualTreeMethods.Create.GetNodeItemData(Node, Config.MainTree);

    //Name
    if chkExtractName.Checked then
      NodeData.Name := ExtractFileNameEx(AFilePath)
    else
      NodeData.Name := sShortName;

    //Path
    TvFileNodeData(NodeData).PathFile := AFilePath;
  end;
end;

procedure TfrmScanFolder.vstTypesAddToSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnTypesDelete.Enabled := True;
end;

procedure TfrmScanFolder.vstFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData: pScanFolderData;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
    NodeData.Text := '';
end;

procedure TfrmScanFolder.vstTypesRemoveFromSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnTypesDelete.Enabled := False;
end;

procedure TfrmScanFolder.vstExcludeAddToSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnExcludeDelete.Enabled := True;
end;

procedure TfrmScanFolder.vstExcludeRemoveFromSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnExcludeDelete.Enabled := False;
end;

procedure TfrmScanFolder.vstGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  NodeData: pScanFolderData;
begin
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    NodeData := Sender.GetNodeData(Node);
    if Assigned(NodeData) then
      ImageIndex := NodeData.ImageIndex;
  end;
end;

procedure TfrmScanFolder.vstGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: AnsiString);
var
  NodeData: pScanFolderData;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
    CellText := NodeData.Text;
end;

procedure TfrmScanFolder.vstGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(rScanFolderData);
end;

end.
