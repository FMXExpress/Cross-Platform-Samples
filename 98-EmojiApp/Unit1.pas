unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation,
  FMX.Layouts, FMX.TabControl;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    NextButton: TButton;
    Memo1: TMemo;
    EmojiLabel: TLabel;
    EmojiEdit: TEdit;
    Layout1: TLayout;
    PriorButton: TButton;
    CurrentCharLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ScreenshotButton: TButton;
    SaveDialog1: TSaveDialog;
    procedure NextButtonClick(Sender: TObject);
    procedure PriorButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure ScreenshotButtonClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentChar: Integer;
    procedure UpdateCharacter;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Math, Character;


// https://stackoverflow.com/questions/32020126/detecting-and-retrieving-codepoints-and-surrogates-from-a-delphi-string
function MyCharNext(P: PChar): PChar;
begin
  Result := P;
  if Result <> nil then
  begin
    Result := StrNextChar(Result);
    while GetUnicodeCategory(Result^) = TUnicodeCategory.ucCombiningMark do
      Result := StrNextChar(Result);
  end;
end;

function GetElementAtIndex(S: String; StrIdx : Integer): String;
var
  pStart, pEnd: PChar;
begin
  Result := '';
  if (S = '') or (StrIdx < 0) then Exit;
  pStart := PChar(S);
  while StrIdx > 1 do
  begin
    pStart := MyCharNext(pStart);
    if pStart^ = #0 then Exit;
    Dec(StrIdx);
  end;
  pEnd := MyCharNext(pStart);
  {$POINTERMATH ON}
  SetString(Result, pStart, pEnd-pStart);
end;

procedure TForm1.UpdateCharacter;
begin
  EmojiLabel.Text := GetElementAtIndex(Memo1.Lines.Text,FCurrentChar);
  EmojiEdit.Text := EmojiLabel.Text + ' ';
  CurrentCharLabel.Text := FCurrentChar.ToString;
end;

procedure TForm1.PriorButtonClick(Sender: TObject);
begin
  FCurrentChar := Max(FCurrentChar-1,0);
  UpdateCharacter;
end;

procedure TForm1.ScreenshotButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    begin
      EmojiLabel.MakeScreenshot.SaveToFile(SaveDialog1.FileName);
    end;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0: Memo1.Visible := False;
    1: Memo1.Visible := True;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCurrentChar := Random(Trunc(Memo1.Lines.Text.Length/2));
  UpdateCharacter;
end;

procedure TForm1.NextButtonClick(Sender: TObject);
begin
  FCurrentChar := Min(FCurrentChar+1,Trunc(Memo1.Lines.Text.Length/2));
  UpdateCharacter;
end;

initialization
  Randomize;

end.
