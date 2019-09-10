unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Effects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Button1: TButton;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Memo2: TMemo;
    NetHTTPClient1: TNetHTTPClient;
    NetHTTPClient2: TNetHTTPClient;
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
  System.Threading;

procedure TForm1.Button1Click(Sender: TObject);
var
LTasks: array of ITask;
begin

  SetLength(LTasks,2);

  LTasks[0] := TTask.Create(procedure var LMS: TMemoryStream; begin
    LMS := TMemoryStream.Create;
    try
      NetHTTPClient1.Get('https://www.fmxexpress.com/',LMS);
      TThread.Synchronize(nil,procedure begin
        Memo1.Lines.LoadFromStream(LMS);
      end);
    finally
      LMS.Free;
    end;
  end);
  LTasks[0].Start;

  LTasks[1] := TTask.Create(procedure var LMS: TMemoryStream; begin
    LMS := TMemoryStream.Create;
    try
      NetHTTPClient2.Get('http://www.firemonkeyx.com/',LMS);
      TThread.Synchronize(nil,procedure begin
        Memo2.Lines.LoadFromStream(LMS);
      end);
    finally
      LMS.Free;
    end;
  end);
  LTasks[1].Start;

  TTask.Run(procedure begin
     TTask.WaitForAll(LTasks);

     Label1.Text := 'Complete!';
  end);
end;

end.
