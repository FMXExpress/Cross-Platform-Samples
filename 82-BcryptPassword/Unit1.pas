unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Layout1: TLayout;
    Edit1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Edit2: TEdit;
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

uses
  System.StrUtils, Bcrypt;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit2.Text := HashPassword(Edit1.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Label1.Text := IfThen(CheckPassword(Edit1.Text,Edit2.Text).ToInteger=0,'No match!','Match!');
end;

end.
