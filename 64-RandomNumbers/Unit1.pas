unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  Math, DateUtils;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label2.Text := RandomRange(1000,9999).ToString;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Label2.Text := Random(100).ToString;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Label2.Text := Random.ToString;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  RandSeed := DateTimeToUnix(Now);
end;

initialization
  Randomize;

end.
