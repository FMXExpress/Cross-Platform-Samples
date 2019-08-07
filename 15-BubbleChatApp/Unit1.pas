unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation, FMX.Effects, FMX.Edit,
  System.Math;

type
  TForm1 = class(TForm)
    VSB: TVertScrollBox;
    Layout1: TLayout;
    Button2: TButton;
    Image1: TImage;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Edit1: TEdit;
    Image2: TImage;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddMessage(const AText: String; AAlignLayout: TAlignLayout; ACalloutPosition: TCalloutPosition);
    procedure FriendMessage(const S: String);
    procedure YourMessage(const S: String);
    procedure LabelPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AddMessage(const AText: String; AAlignLayout: TAlignLayout; ACalloutPosition: TCalloutPosition);
var
CR: TCalloutRectangle;
L: TLabel;
TmpImg: TCircle;
begin
  CR := TCalloutRectangle.Create(Self);
  CR.Parent := VSB;
  CR.Align := TAlignLayout.Top;
  CR.CalloutPosition := ACalloutPosition;
  CR.Margins.Top := 10;
  CR.Margins.Bottom := 10;
  CR.Margins.Left := 5;
  CR.Height := 75;
  CR.XRadius := 25;
  CR.YRadius := CR.XRadius;
  CR.Position.Y := 999999;
  CR.Fill.Kind := TBrushKind.None;
  CR.Stroke.Color := TAlphaColorRec.White;

  L := TLabel.Create(Self);
  L.Parent := CR;
  L.Align := TAlignLayout.Client;
  L.Text := AText;
  L.Margins.Right := 15;
  L.Margins.Left := 5;
  L.Width := CR.Width-20;

  L.WordWrap := True;
  L.AutoSize := True;
  L.OnPaint := LabelPaint;

  TmpImg := TCircle.Create(Self);
  TmpImg.Parent := CR;
  TmpImg.Align := AAlignLayout;
  TmpImg.Fill.Kind := TBrushKind.Bitmap;
  case AAlignLayout of
    TAlignLayout.Left: TmpImg.Fill.Bitmap.Bitmap.Assign(Image1.Bitmap);
    TAlignLayout.Right: TmpImg.Fill.Bitmap.Bitmap.Assign(Image2.Bitmap);
  end;
  TmpImg.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  TmpImg.Width := 75;
  TmpImg.Margins.Left := 15;
  TmpImg.Margins.Right := 15;
  TmpImg.Margins.Top := 15;
  TmpImg.Margins.Bottom := 15;

  VSB.ScrollBy(0,-95);
end;

procedure TForm1.FriendMessage(const S: String);
begin
  AddMessage(S, TAlignLayout.Left, TCalloutPosition.Left);
end;

procedure TForm1.YourMessage(const S: String);
begin
  AddMessage(S, TAlignLayout.Right, TCalloutPosition.Right);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  YourMessage(Edit1.Text);
  //Edit1.Text := '';
  FriendMessage('A quick brown fox jumped over the yellow log running away from the pink dog and ran down the lane.');
end;

procedure TForm1.LabelPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  {if TLabel(Sender).Tag=0 then
    begin
      TCalloutRectangle(TLabel(Sender).Parent).Height := Max(TLabel(Sender).Height,75);
      TLabel(Sender).Tag := 1;
    end;}
end;

end.
