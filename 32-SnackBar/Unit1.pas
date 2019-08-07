unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Button1: TButton;
    Label2: TLabel;
    FloatAnimation1: TFloatAnimation;
    SnackButton: TButton;
    procedure SnackButtonClick(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  Layout1.Visible := False;
end;

procedure TForm1.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled := False;
end;

procedure TForm1.SnackButtonClick(Sender: TObject);
begin
  Rectangle1.Height := 0;
  Layout1.Visible := True;
  FloatAnimation1.Enabled := True;
end;

end.
