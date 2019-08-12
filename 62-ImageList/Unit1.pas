unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ImgList, FMX.Effects, FMX.Controls.Presentation,
  System.ImageList, System.Math;

type
  TForm1 = class(TForm)
    ImageList1: TImageList;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Glyph1: TGlyph;
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Glyph1.ImageIndex := Max(0,Glyph1.ImageIndex-1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Glyph1.ImageIndex := Min(4,Glyph1.ImageIndex+1);
end;

end.
