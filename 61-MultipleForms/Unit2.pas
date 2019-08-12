unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.TabControl, FMX.Effects, FMX.Controls.Presentation;

type
  TForm2 = class(TForm)
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  Unit1, Unit3;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form3.Show;
  Form2.Hide;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Form1.Show;
  Form2.Hide;
end;

end.
