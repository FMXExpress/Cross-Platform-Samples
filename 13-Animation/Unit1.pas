unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    ActivityCircle: TCircle;
    ActivityArc: TArc;
    ActivityFloatAni: TFloatAnimation;
    ClipCircle: TCircle;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
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
