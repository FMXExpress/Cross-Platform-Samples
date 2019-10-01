unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation, FMX.Layouts;

type
  TControlClass = class of TControl;
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    CopyButton: TButton;
    Memo1: TMemo;
    procedure CopyButtonClick(Sender: TObject);
  private
    { Private declarations }
    FControlCount: Integer;
  public
    { Public declarations }
    function SaveControl(AControl: TControl): String;
    procedure LoadControl(AControl: String; ANewControl: TControl);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

function TForm1.SaveControl(AControl: TControl): String;
var
  LMS: TMemoryStream;
  LSS: TStringStream;
  LName: string;
begin
  LName := AControl.Name;
  AControl.Name := '';
  try
    LMS := TMemoryStream.Create;
    try
      LMS.WriteComponent(AControl);
      LMS.Position := 0;
      LSS := TStringStream.Create;
      try
        ObjectBinaryToText(LMS, LSS);
        Result := LSS.DataString;
      finally
        LSS.Free;
      end;
    finally
      LMS.Free;
    end;
  finally
    AControl.Name := LName;
  end;
end;

procedure TForm1.LoadControl(AControl: String; ANewControl: TControl);
var
  LMS: TMemoryStream;
  LSS: TStringStream;
begin
  LMS := TMemoryStream.Create;
  try
    LSS := TStringStream.Create;
    try
      LSS.WriteString(AControl);
      LSS.Position := 0;
      ObjectTextToBinary(LSS, LMS);
      LMS.Position := 0;
      LMS.ReadComponent(ANewControl);
    finally
      LSS.Free;
    end;
  finally
    LMS.Free;
  end;
end;


procedure TForm1.CopyButtonClick(Sender: TObject);
var
  LNewControl: TControl;
begin
  Memo1.Lines.Text := SaveControl(CopyButton);
  LNewControl := TControlClass(CopyButton.ClassType).Create(CopyButton.Owner);
  LoadControl(Memo1.Lines.Text, LNewControl);
  LNewControl.Name := 'NewButton'+FControlCount.ToString;
  Inc(FControlCount);
  Form1.AddObject(LNewControl);
end;

end.
