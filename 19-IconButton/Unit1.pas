unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Effects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FValue: Integer;
    procedure UpdateLabel(AValue: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.UpdateLabel(AValue: Integer);
begin
  Label2.Text := AValue.ToString;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Dec(FValue);
  UpdateLabel(FValue);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Inc(FValue);
  UpdateLabel(FValue);
end;

end.
