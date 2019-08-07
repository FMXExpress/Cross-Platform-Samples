unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, System.Threading, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, StrUtils;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    IdTCPClient1: TIdTCPClient;
    Button1: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RanOnce: Boolean;
    Connected: Boolean;
    function TestConnection: Boolean;
    function TestConnectionAsync: Boolean;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
  end;
  const
    BUSY = 1;
    NOT_BUSY = 0;
    InternetHost = 'www.fmxexpress.com'; // change to your own site

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  if RanOnce=False then
    begin
      TestConnectionAsync;
      RanOnce := True;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label2.Text := 'Connected: ' + IfThen(TestConnectionAsync.ToInteger=1,'True','False');
end;

function TForm1.TestConnection: Boolean;
begin
  try
    if IdTCPClient1.Tag = NOT_BUSY then
      begin
        IdTCPClient1.Tag := BUSY;
        IdTCPClient1.ReadTimeout := 6000;
        IdTCPClient1.ConnectTimeout := 6000;
        IdTCPClient1.Port := 80;
        IdTCPClient1.Host := InternetHost;
        IdTCPClient1.Connect;
        IdTCPClient1.Disconnect;
        IdTCPClient1.Tag := NOT_BUSY;
        Result := True;
      end
    else
      begin
        Result := False;
      end;
  except
    IdTCPClient1.Tag := NOT_BUSY;
    Result := False;
  end;
end;

function TForm1.TestConnectionAsync: Boolean;
begin
  TThread.CreateAnonymousThread(procedure
    begin
      Connected := TestConnection;
    end).Start;
  Result := Connected;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle := ApplicationEventsIdle;
end;

end.
