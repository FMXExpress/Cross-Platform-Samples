unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ImgList,
  FMX.Layouts, FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation,
  FMX.Filter.Effects, System.ImageList, FMX.Objects;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Glyph1: TGlyph;
    ImageList1: TImageList;
    FillRGBEffect1: TFillRGBEffect;
    Glyph2: TGlyph;
    FillRGBEffect2: TFillRGBEffect;
    Glyph3: TGlyph;
    FillRGBEffect3: TFillRGBEffect;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    procedure Rectangle1Click(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Rectangle1Click(Sender: TObject);
begin
  FillRGBEffect1.Enabled := not FillRGBEffect1.Enabled;
end;

procedure TForm1.Rectangle2Click(Sender: TObject);
begin
  FillRGBEffect2.Enabled := not FillRGBEffect2.Enabled;
end;

procedure TForm1.Rectangle3Click(Sender: TObject);
begin
  FillRGBEffect3.Enabled := not FillRGBEffect3.Enabled;
end;

end.
