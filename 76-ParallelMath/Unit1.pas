unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Effects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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
  System.Threading, System.SyncObjs;

procedure TForm1.Button1Click(Sender: TObject);
var
  LTasks: array of ITask;
  LIndex: Integer;
  LValue: Integer;
begin
  SetLength(LTasks, Edit1.Text.ToInteger);

  for LIndex := 0 to Edit1.Text.ToInteger-1 do
    begin
      LTasks[LIndex] := TTask.Create(procedure begin
        TInterlocked.Add(LValue,1);
      end);
      LTasks[LIndex].Start;
    end;

  TTask.Run(procedure begin
    TTask.WaitForAll(LTasks);
    TThread.Synchronize(nil, procedure begin
      Label1.Text := LValue.ToString;
    end);
  end);
end;

end.
