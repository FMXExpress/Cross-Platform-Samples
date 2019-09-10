unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IdContext,
  IdCustomHTTPServer, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdHTTPServer, FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation,
  IdServerInterceptLogEvent, FMX.ScrollBox, FMX.Memo, IdIntercept,
  IdServerInterceptLogBase;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    IdHTTPServer1: TIdHTTPServer;
    Button1: TButton;
    Button2: TButton;
    IdServerInterceptLogEvent1: TIdServerInterceptLogEvent;
    Memo1: TMemo;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IdServerInterceptLogEvent1LogString(
      ASender: TIdServerInterceptLogEvent; const AText: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  IdHTTPServer1.Active := True;
  Memo1.Lines.Append('Server active!');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  IdHTTPServer1.Active := False;
  Memo1.Lines.Append('Server inactive!');
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := 'Delphi is awesome!';
end;

procedure TForm1.IdServerInterceptLogEvent1LogString(
  ASender: TIdServerInterceptLogEvent; const AText: string);
begin
  TThread.Synchronize(nil,procedure begin
    Memo1.Lines.Append(AText);
  end);
end;

end.
