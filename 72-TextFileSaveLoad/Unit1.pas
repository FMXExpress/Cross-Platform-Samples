unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Memo1: TMemo;
    SaveButton: TButton;
    LoadButton: TButton;
    procedure SaveButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  const
    TEST_FILE = 'test.txt';

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TForm1.SaveButtonClick(Sender: TObject);
var
SL: TStringList;
begin

  SL := TStringList.Create;
  try
    SL.Append('Delphi is awesome!');
    SL.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,TEST_FILE));
  finally
    SL.Free;
  end;

end;

procedure TForm1.LoadButtonClick(Sender: TObject);
begin
  if TFile.Exists(TPath.Combine(TPath.GetDocumentsPath,TEST_FILE)) then
    Memo1.Lines.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,TEST_FILE));
end;

end.
