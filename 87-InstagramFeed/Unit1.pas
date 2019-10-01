unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.ScrollBox, FMX.Memo, FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageBin, System.ImageList, FMX.ImgList;

type
  TForm1 = class(TForm)
    AddButton: TButton;
    StoryHSB: THorzScrollBox;
    Layout1: TLayout;
    ScrollLeftButton: TButton;
    ScrollRightButton: TButton;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    FeedVSB: TVertScrollBox;
    FeedMT: TFDMemTable;
    StoryMT: TFDMemTable;
    Label2: TLabel;
    CameraButton: TButton;
    ImageList1: TImageList;
    procedure AddButtonClick(Sender: TObject);
    procedure ScrollLeftButtonClick(Sender: TObject);
    procedure ScrollRightButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    RanOnce: Boolean;
  public
    { Public declarations }
    FCircle: Integer;
    FCard: Integer;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  FMX.Objects, uCircle, uCard, FMX.Scene;


procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not RanOnce then
    begin
      RanOnce := True;

      AddButtonClick(Self);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  ScrollLeftButton.Visible := False;
  ScrollRightButton.Visible := False;
{$ENDIF}

  Application.OnIdle := AppIdle;
end;

procedure TForm1.AddButtonClick(Sender: TObject);
var
  LCard: TCardFrame;
  LCircle: TCircleFrame;
  LStream: TStream;
  LScene: TScene;
begin
  StoryMT.First;
  while not StoryMT.Eof do
    begin
      LCircle := TCircleFrame.Create(Self);
      LCircle.Name := 'Circle'+FCircle.ToString;
      LCircle.Align := TAlignLayout.Left;
      LStream := StoryMT.CreateBlobStream(StoryMT.FieldByName('ProfileImage'), bmRead);
      LCircle.ImageCircle.Fill.Bitmap.Bitmap.LoadFromStream(LStream);
      LStream.Free;
      LCircle.Tag := StoryMT.FieldByName('Id').AsInteger;
      LCircle.Label1.Text := StoryMT.FieldByName('Name').AsString;
      LCircle.Label2.Text := StoryMT.FieldByName('Posted').AsString;
      LCircle.Parent := StoryHSB;
      LCircle.Width := Trunc(LCircle.Height*0.8);
      Inc(FCircle);
      StoryMT.Next;
    end;

  FeedMT.First;
  while not FeedMT.Eof do
    begin

      // With TScene Buffering
      LScene := TScene.Create(Self);
      LCard := TCardFrame.Create(Self);
      LCard.Name := 'Card'+FCard.ToString;
      LCard.Align := TAlignLayout.Client;
      LCard.DataMT.DisableControls;
      LCard.DataMT.Append;
      LCard.DataMT.CopyRecord(FeedMT);
      LCard.DataMT.Post;
      LCard.DataMT.EnableControls;
      LCard.Position.Y := 999999999;
      LScene.Height := LCard.Height;
      LCard.Parent := LScene;
      LScene.Align := TAlignLayout.Top;
      LScene.Parent := FeedVSB;

      // Without TScene Buffering
      //LCard := TCardFrame.Create(Self);
      //LCard.Name := 'Card'+FCard.ToString;
      //LCard.Align := TAlignLayout.Top;
      //LCard.DataMT.DisableControls;
      //LCard.DataMT.Append;
      //LCard.DataMT.CopyRecord(FeedMT);
      //LCard.DataMT.Post;
      //LCard.DataMT.EnableControls;
      //LCard.Position.Y := 999999999;
      //LCard.Parent := FeedVSB;

      Inc(FCard);

      FeedMT.Next;
    end;
end;

procedure TForm1.ScrollLeftButtonClick(Sender: TObject);
begin
  StoryHSB.ScrollBy(Trunc(StoryHSB.Height*0.8), 0);
end;

procedure TForm1.ScrollRightButtonClick(Sender: TObject);
begin
  StoryHSB.ScrollBy(-1*Trunc(StoryHSB.Height*0.8), 0);
end;

end.
