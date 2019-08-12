unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation;

type
  TForm3 = class(TForm)
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses
  Unit1, Unit2;

procedure TForm3.Button1Click(Sender: TObject);
begin
  Form2.Show;
  Form3.Hide;
end;

end.
