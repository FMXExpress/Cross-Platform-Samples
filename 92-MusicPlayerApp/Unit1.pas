unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.StdCtrls, FMX.Layouts,
  FMX.Filter.Effects, FMX.Objects, FMX.Media, FMX.Effects,
  FMX.Controls.Presentation, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.Edit, FireDAC.Stan.StorageBin, System.ImageList,
  FMX.ImgList, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.MultiView, FMX.TabControl;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    MediaPlayer1: TMediaPlayer;
    MainImage: TImage;
    BackgroundImage: TImage;
    GaussianBlurEffect1: TGaussianBlurEffect;
    Layout1: TLayout;
    Layout2: TLayout;
    SongLabel: TLabel;
    ArtistLabel: TLabel;
    Layout3: TLayout;
    TrackBar1: TTrackBar;
    TrackTimeLabel: TLabel;
    SpeedButton1: TSpeedButton;
    FDMemTable1: TFDMemTable;
    Timer1: TTimer;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldBitmap: TLinkPropertyToField;
    LinkPropertyToFieldBitmap2: TLinkPropertyToField;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    PrevButton: TButton;
    PlayButton: TButton;
    NextButton: TButton;
    FileEdit: TEdit;
    LinkControlToField1: TLinkControlToField;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    ImageList1: TImageList;
    Layout4: TLayout;
    Layout5: TLayout;
    PlayListButton: TButton;
    MultiView1: TMultiView;
    ListView1: TListView;
    LinkListControlToField1: TLinkListControlToField;
    Glyph1: TGlyph;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    VertScrollBox1: TVertScrollBox;
    Label2: TLabel;
    ArtistEdit: TEdit;
    Label3: TLabel;
    SongEdit: TEdit;
    CoverImageControl: TImageControl;
    Label4: TLabel;
    FilePathEdit: TEdit;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    OpenDialog1: TOpenDialog;
    AddSaveButton: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure PrevButtonClick(Sender: TObject);
    procedure FileEditChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CoverImageControlChange(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FilePathEditClick(Sender: TObject);
    procedure AddSaveButtonClick(Sender: TObject);
    procedure TrackBar1Tracking(Sender: TObject);
    procedure ListView1ButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Threading, System.Math;

procedure TForm1.AddSaveButtonClick(Sender: TObject);
begin
  if AddSaveButton.StyleLookup='additembutton' then
    begin
      FDMemTable1.Append;
      MediaPlayer1.Clear;
      TabControl1.GotoVisibleTab(1);
      AddSaveButton.StyleLookup := 'donetoolbutton';
    end
  else
    begin
      AddSaveButton.StyleLookup := 'additembutton';
      TabControl1.GotoVisibleTab(0);
    end;
end;

procedure TForm1.FileEditChange(Sender: TObject);
begin
  if MediaPlayer1.State = TMediaState.Playing then
    begin
      MediaPlayer1.Stop;
      Glyph1.ImageIndex := 1;
    end;
end;

procedure TForm1.FilePathEditClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      FilePathEdit.Text := OpenDialog1.FileName;
      TLinkObservers.ControlChanged(FilePathEdit);
    end;
end;

procedure TForm1.CoverImageControlChange(Sender: TObject);
begin
  TLinkObservers.ControlChanged(CoverImageControl);
end;

procedure TForm1.ListView1ButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
  MultiView1.HideMaster;
  TabControl1.GotoVisibleTab(1);
  AddSaveButton.StyleLookup := 'donetoolbutton';
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  PlayButtonClick(Self);
end;

procedure TForm1.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if AItem.ImageIndex<>1 then AItem.ImageIndex := 1;
end;

procedure TForm1.NextButtonClick(Sender: TObject);
begin
  PlayButtonClick(Self);
  FDMemTable1.Next;
  PlayButtonClick(Self);
end;

procedure TForm1.PlayButtonClick(Sender: TObject);
begin
  if MediaPlayer1.State = TMediaState.Playing then
    begin
      MediaPlayer1.Stop;
      Glyph1.ImageIndex := 1;
    end
  else
    begin
      MediaPlayer1.Clear;
      MediaPlayer1.FileName := FileEdit.Text;
      TrackBar1.Min := MediaPlayer1.CurrentTime;
      TrackBar1.Max := MediaPlayer1.Duration;
      MediaPlayer1.Play;
      Glyph1.ImageIndex := 2;
    end;
end;

procedure TForm1.PrevButtonClick(Sender: TObject);
begin
  PlayButtonClick(Self);
  FDMemTable1.Prior;
  PlayButtonClick(Self);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  MediaPlayer1.Volume := IfThen(MediaPlayer1.Volume<>0,0,100);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if TabControl1.ActiveTab=TabItem1 then
    begin
      if FDMemTable1.State <> dsEdit then FDMemTable1.Edit;
      // the math here is incorrect and may also need to depend on the platform
      FDMemTable1.FieldByName('Duration').AsString := FormatDateTime('nn:ss',(MediaPlayer1.Duration div 32300000) / SecsPerDay);
      FDMemTable1.FieldByName('CurrentTime').AsString := FormatDateTime('nn:ss',(MediaPlayer1.CurrentTime div 32300000) / SecsPerDay);
      TrackBar1.Value := MediaPlayer1.CurrentTime;
      FDMemTable1.Post;
    end;
end;

procedure TForm1.TrackBar1Tracking(Sender: TObject);
begin
  if FDMemTable1.State <> dsEdit then
    MediaPlayer1.CurrentTime := Trunc(TrackBar1.Value);
end;

end.
