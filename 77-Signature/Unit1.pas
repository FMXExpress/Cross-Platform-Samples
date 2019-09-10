unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, MyPaintBox, FMX.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Layout1: TLayout;
    Line1: TLine;
    Label2: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FSignBox: TMyPaintBox;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FSignBox.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,'signature.png'));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSignBox := TMyPaintBox.Create(Self);
  FSignBox.Parent := Self;
  FSignBox.SendToBack;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSignBox.DisposeOf;
end;

end.
