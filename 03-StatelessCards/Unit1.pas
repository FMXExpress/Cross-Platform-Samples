unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Filter.Effects,
  FMX.Objects, FMX.Effects;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    VertScrollBox1: TVertScrollBox;
    Rectangle1: TRectangle;
    Label1: TLabel;
    InvertEffect1: TInvertEffect;
    ShadowEffect1: TShadowEffect;
    Image1: TImage;
    Rectangle2: TRectangle;
    Label2: TLabel;
    InvertEffect2: TInvertEffect;
    ShadowEffect2: TShadowEffect;
    Image2: TImage;
    Rectangle3: TRectangle;
    Label3: TLabel;
    InvertEffect3: TInvertEffect;
    ShadowEffect3: TShadowEffect;
    Image3: TImage;
    FillRGBEffect1: TFillRGBEffect;
    FillRGBEffect2: TFillRGBEffect;
    FillRGBEffect3: TFillRGBEffect;
    ToolBar1: TToolBar;
    Label4: TLabel;
    ShadowEffect4: TShadowEffect;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

end.
