// Derived from the Embarcadero Delphi 10.3.1 RIO PhotoEditorSample which
// is Copyright (c) 2015 Embarcadero Technologies, Inc.
unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Permissions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects, FMX.Filter, FMX.Ani, FMX.Graphics,
  FMX.Controls.Presentation, FMX.ListBox;

type
  TFilterClass = class of TFilter;

  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    ImageContainer: TImage;
    ToolBarBottom: TToolBar;
    ButtonTakePhotoFromCamera: TButton;
    ButtonRemovePhoto: TButton;
    ButtonSendImage: TButton;
    ButtonTakePhotoFromLibrary: TButton;
    LayoutFilterSettings: TLayout;
    ActionList: TActionList;
    ActionTakePhotoFromLibrary: TTakePhotoFromLibraryAction;
    ActionTakePhotoFromCamera: TTakePhotoFromCameraAction;
    ActionShowShareSheet: TShowShareSheetAction;
    ActionClearImage: TAction;
    OpenDialog1: TOpenDialog;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ActionResetEffect: TAction;
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActionResetEffectExecute(Sender: TObject);
    procedure ButtonTakePhotoFromLibraryClick(Sender: TObject);
    procedure ButtonTakePhotoFromCameraClick(Sender: TObject);
    procedure ActionShowShareSheetBeforeExecute(Sender: TObject);
    procedure ActionClearImageExecute(Sender: TObject);
    procedure ListBoxItem7Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure ListBoxItem5Click(Sender: TObject);
    procedure ListBoxItem6Click(Sender: TObject);
    procedure ButtonSendImageClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
  private
    { Private declarations }
    FEffect: TFilter;
    FRawBitmap: TBitmap;
    FPermissionCamera,
    FPermissionReadExternalStorage,
    FPermissionWriteExternalStorage: string;
    procedure DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure DoOnChangedEffectParam(Sender: TObject);
    procedure LoadFilterSettings(Rec: TFilterRec);
    procedure LoadPicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
    procedure TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetEffect(const AFilterName: string);
    procedure UpdateEffect;
  end;
  const
    Attachment = 'attachment.jpg';

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
{$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
  FMX.DialogService,
  System.IOUtils,
  wwEmailWithAttachment;

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRawBitmap := TBitmap.Create(0, 0);
{$IFDEF ANDROID}
  FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
{$ENDIF}
end;

destructor TForm1.Destroy;
begin
  FreeAndNil(FRawBitmap);
  inherited Destroy;
end;

// Optional rationale display routine to display permission requirement rationale to the user
procedure TForm1.DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do
  begin
    if APermissions[I] = FPermissionCamera then
      RationaleMsg := RationaleMsg + 'The app needs to access the camera to take a photo' + SLineBreak + SLineBreak
    else if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg + 'The app needs to load photo files from your device';
  end;

  // Show an explanation to the user *asynchronously* - don't block this thread waiting for the user's response!
  // After the user sees the explanation, invoke the post-rationale routine to request the permissions
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;

procedure TForm1.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  LayoutFilterSettings.Visible := not ActionResetEffect.Checked;
  ActionClearImage.Enabled := not ImageContainer.Bitmap.IsEmpty;
  ActionShowShareSheet.Enabled := not FRawBitmap.IsEmpty;
end;

procedure TForm1.ActionResetEffectExecute(Sender: TObject);
begin
  FreeAndNil(FEffect);
  ImageContainer.Bitmap.Assign(FRawBitmap);
  ActionResetEffect.Checked := True;
end;

procedure TForm1.ActionShowShareSheetBeforeExecute(Sender: TObject);
begin
  ActionShowShareSheet.Bitmap := ImageContainer.Bitmap;
end;

procedure TForm1.ActionClearImageExecute(Sender: TObject);
begin
  FRawBitmap.SetSize(0, 0);
  ImageContainer.Bitmap.SetSize(0, 0);
  ImageContainer.Bitmap.Assign(FRawBitmap);
  ActionResetEffect.Execute;
end;

procedure TForm1.SetEffect(const AFilterName: string);
var
  Rec: TFilterRec;
begin
  ActionResetEffect.Checked := False;
  FreeAndNil(FEffect);
  FEffect := TFilterManager.FilterByName(AFilterName);
  if Assigned(FEffect) then
  begin
    // Create settings
    Rec := FEffect.FilterAttr;
    UpdateEffect;
    LoadFilterSettings(Rec);
  end;
end;


procedure TForm1.ButtonSendImageClick(Sender: TObject);
var
 LFileName: String;
begin
  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
    ActionShowShareSheet.Execute;
  {$ELSE}
    LFileName := TPath.Combine(ExtractFilePath(ParamStr(0)),Attachment);
    ImageContainer.Bitmap.SaveToFile(LFileName);
    wwEmail(['delphi@example.com'], [], [], 'Check out my photo!', 'Delphi is AWESOME!', LFileName);
  {$ENDIF}
end;

procedure TForm1.ButtonTakePhotoFromCameraClick(Sender: TObject);
begin
  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  PermissionsService.RequestPermissions([FPermissionCamera, FPermissionReadExternalStorage, FPermissionWriteExternalStorage], TakePicturePermissionRequestResult, DisplayRationale);
  {$ELSE}
  ActionTakePhotoFromCamera.Execute;
  {$ENDIF}
end;

procedure TForm1.ButtonTakePhotoFromLibraryClick(Sender: TObject);
begin
  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  PermissionsService.RequestPermissions([FPermissionReadExternalStorage, FPermissionWriteExternalStorage], LoadPicturePermissionRequestResult, DisplayRationale);
  {$ELSE}
  if OpenDialog1.Execute then
    begin
      ImageContainer.Bitmap.LoadFromFile(OpenDialog1.FileName);
      FRawBitmap.Assign(ImageContainer.Bitmap);
    end;
  {$ENDIF}
end;

procedure TForm1.DoOnChangedEffectParam(Sender: TObject);
var
  TrackBarTmp: TTrackBar;
begin
  if not (Sender is TTrackBar) then
    Exit;

  TrackBarTmp := Sender as TTrackBar;
  FEffect.ValuesAsFloat[TrackBarTmp.TagString] := TrackBarTmp.Value;
  UpdateEffect;
end;

procedure TForm1.UpdateEffect;
var
  LValue: Boolean;
begin
  ActionListUpdate(nil, LValue);
  if Assigned(FEffect) then
  begin
    FEffect.ValuesAsBitmap['Input'] := FRawBitmap;
    ImageContainer.Bitmap := FEffect.ValuesAsBitmap['Output'];
  end;
end;

procedure TForm1.ListBoxItem1Click(Sender: TObject);
begin
  ActionResetEffect.Execute;
end;

procedure TForm1.ListBoxItem2Click(Sender: TObject);
begin
  SetEffect('GaussianBlur');
end;

procedure TForm1.ListBoxItem3Click(Sender: TObject);
begin
  SetEffect('Pixelate');
end;

procedure TForm1.ListBoxItem4Click(Sender: TObject);
begin
  SetEffect('Wave');
end;

procedure TForm1.ListBoxItem5Click(Sender: TObject);
begin
  SetEffect('Contrast');
end;

procedure TForm1.ListBoxItem6Click(Sender: TObject);
begin
  SetEffect('PaperSketch');
end;

procedure TForm1.ListBoxItem7Click(Sender: TObject);
begin
  SetEffect('Sharpen');
end;

procedure TForm1.LoadFilterSettings(Rec: TFilterRec);
var
  TB: TTrackBar;
  RecValue: TFilterValueRec;
begin
  LayoutFilterSettings.DeleteChildren;
  for RecValue in Rec.Values do
  begin
    if RecValue.ValueType <> TFilterValueType.Float then
      Continue;
    TB := TTrackBar.Create(Self);
    TB.Parent := LayoutFilterSettings;
    TB.Orientation := TOrientation.Vertical;
    TB.Align := TAlignLayout.Left;
    TB.Min := RecValue.Min.AsExtended;
    TB.Max := RecValue.Max.AsExtended;
    TB.Value := RecValue.Value.AsExtended;
    TB.TagString := RecValue.Name;
    TB.Tracking := False;
    TB.OnChange := DoOnChangedEffectParam;
  end;
end;

procedure TForm1.LoadPicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
begin
  // 2 permissions involved: READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 2) and
     (AGrantResults[0] = TPermissionStatus.Granted) and
     (AGrantResults[1] = TPermissionStatus.Granted) then
    ActionTakePhotoFromLibrary.Execute
  else
    TDialogService.ShowMessage('Cannot do photo editing because the required permissions are not granted');
end;

procedure TForm1.TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
begin
  // 3 permissions involved: CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 3) and
     (AGrantResults[0] = TPermissionStatus.Granted) and
     (AGrantResults[1] = TPermissionStatus.Granted) and
     (AGrantResults[2] = TPermissionStatus.Granted) then
    ActionTakePhotoFromCamera.Execute
  else
    TDialogService.ShowMessage('Cannot take picture because the required permissions are not granted');
end;


end.
