unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.StdCtrls, FMX.Effects,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Chart1: TChart;
    Series1: TPieSeries;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Chart1.Series[0].Clear;
  Chart1.Series[0].Add(50,'Delphi');
  Chart1.Series[0].Add(10,'is');
  Chart1.Series[0].Add(40,'Awesome!');
  Chart1.Series[0].Add(50,'Delphi');
  Chart1.Series[0].Add(10,'is');
  Chart1.Series[0].Add(40,'Awesome!');
end;

end.
