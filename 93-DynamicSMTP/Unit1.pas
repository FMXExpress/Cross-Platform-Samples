unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure IdSMTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdSSLIOHandlerSocketOpenSSLStatusInfo(const AMsg: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Threading, IdMessage, IdEmailAddress;

// Original smtp.gmail.com settings.
// http://www.marcocantu.com/tips/oct06_gmail.html
// OpenSSL libraries.
// https://indy.fulgan.com/SSL/
// Google BadCredentials account fix.
// https://support.google.com/accounts/answer/6010255?hl=en
procedure TForm1.Button1Click(Sender: TObject);
var
LSMTP: TIdSMTP;
LMessage: TIdMessage;
LAddress: TIdEmailAddressItem;
LSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  TTask.Run(procedure begin
    // send
    LSMTP := TIdSMTP.Create(Self);
    LSMTP.OnStatus := IdSMTPStatus;
    LSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
    LSSL.OnStatusInfo := IdSSLIOHandlerSocketOpenSSLStatusInfo;
    LSMTP.IOHandler := LSSL;
    LSSL.SSLOptions.Method := sslvTLSv1;

    LMessage := TIdMessage.Create(nil);
    try
      LAddress := LMessage.Recipients.Add;
      //LAddress.Name := '';
      LAddress.Address := 'example@example.com';
      //LMessage.BccList.Add.Address := '';
      LMessage.From.Name := 'Delphi Is Awesome';
      LMessage.From.Address := 'youremail@gmail.com';
      LMessage.Subject := 'Delphi is awesome!';
      LMessage.Body.Text := 'FireMonkey is a cross platform framework with a single codebase and single UI that deploys to Android, IOS, Macos, Windows, Linux, and HTML5.';

      LSMTP.Host := 'smtp.gmail.com';
      LSMTP.Port := 587;
      LSMTP.Username := 'yourusername';
      LSMTP.Password := 'yourpassword';
      LSMTP.UseTLS := utUseExplicitTLS;
      try
        LSMTP.Connect;
        try
          LSMTP.Send(LMessage);
        finally
          LSMTP.Disconnect
        end;
      except
        on E: Exception do
          begin
            TThread.Synchronize(nil, procedure begin
              Memo1.Lines.Append(E.Message);
            end);
          end;
      end;
    finally
      LMessage.Free;
      LSSL.Free;
      LSMTP.Free;
    end;
  end);
end;

procedure TForm1.IdSMTPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  Memo1.Lines.Append(AStatusText);
end;

procedure TForm1.IdSSLIOHandlerSocketOpenSSLStatusInfo(const AMsg: string);
begin
  Memo1.Lines.Append(AMsg);
end;

end.
