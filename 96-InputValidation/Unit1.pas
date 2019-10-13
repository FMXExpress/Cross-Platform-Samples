unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.EditBox, FMX.NumberBox,
  System.RegularExpressions;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    MaxLenCountLabel: TLabel;
    NumberBox1: TNumberBox;
    Label5: TLabel;
    Edit1: TEdit;
    EmailValidLabel: TLabel;
    procedure Edit2Validating(Sender: TObject; var Text: string);
    procedure Edit1Validate(Sender: TObject; var Text: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Edit1Validate(Sender: TObject; var Text: string);
var
  RegEx: TRegEx;
begin
  RegEx := TRegex.Create('^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-\p{Cyrillic}]+\.[a-zA-Z0-9-.\p{Cyrillic}]*[a-zA-Z0-9\p{Cyrillic}]+$');
  EmailValidLabel.Visible := not RegEx.Match(Text).Success;
end;

procedure TForm1.Edit2Validating(Sender: TObject; var Text: string);
begin
  MaxLenCountLabel.Text := Text.Length.ToString + '/' + Edit2.MaxLength.ToString;
end;

end.
