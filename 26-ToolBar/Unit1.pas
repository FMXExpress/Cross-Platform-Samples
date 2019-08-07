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
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    RemoveButton: TButton;
    AddButton: TButton;
    Label2: TLabel;
    procedure AddButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
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

procedure TForm1.RemoveButtonClick(Sender: TObject);
begin
  Dec(FValue);
  UpdateLabel(FValue);
end;

procedure TForm1.AddButtonClick(Sender: TObject);
begin
  Inc(FValue);
  UpdateLabel(FValue);
end;

end.
