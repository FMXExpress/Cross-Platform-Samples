unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Effects, FMX.Objects, FMX.StdCtrls, FMX.Menus, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Splitter1: TSplitter;
    Image2: TImage;
    Rectangle1: TRectangle;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
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
