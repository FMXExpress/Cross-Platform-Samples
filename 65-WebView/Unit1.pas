unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.WebBrowser, System.IOUtils;

type
  // https://stackoverflow.com/questions/30780843/delphi-twebbrowser-wont-run-javascript-from-localhost
  TBrowserEmulationAdjuster = class
    private
        class function GetExeName(): String; inline;
     public const
        // Quelle: https://msdn.microsoft.com/library/ee330730.aspx, Stand: 2017-04-26
        IE11_default   = 11000;
        IE11_Quirks    = 11001;
        IE10_force     = 10001;
        IE10_default   = 10000;
        IE9_Quirks     = 9999;
        IE9_default    = 9000;
        /// <summary>
        /// Webpages containing standards-based !DOCTYPE directives are displayed in IE7
        /// Standards mode. Default value for applications hosting the WebBrowser Control.
        /// </summary>
        IE7_embedded   = 7000;
     public
        class procedure SetBrowserEmulationDWORD(const value: DWORD);
  end;

  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    WebBrowser1: TWebBrowser;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WebBrowser1DidStartLoad(ASender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{$IFDEF MSWINDOWS}
uses
  Windows, Registry;
{$ENDIF}

// https://stackoverflow.com/questions/30780843/delphi-twebbrowser-wont-run-javascript-from-localhost
{$IFDEF MSWINDOWS}
class function TBrowserEmulationAdjuster.GetExeName(): String;
begin
    Result := TPath.GetFileName( ParamStr(0) );
end;

class procedure TBrowserEmulationAdjuster.SetBrowserEmulationDWORD(const value: DWORD);
const registryPath = 'Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION';
var
    registry:   TRegistry;
    exeName:   String;
begin
    exeName := GetExeName();

    registry := TRegistry.Create(KEY_SET_VALUE);
    try
       registry.RootKey := HKEY_CURRENT_USER;
       Win32Check( registry.OpenKey(registryPath, True) );
       registry.WriteInteger(exeName, value)
    finally
       registry.Destroy();
    end;
end;
{$ENDIF}

procedure TForm1.Button1Click(Sender: TObject);
begin
  WebBrowser1.LoadFromStrings('<html><head><meta http-equiv="X-UA-Compatible" content="IE=edge" /></head><body><div style="text-align:center;"><a href="#CallBack">Click me!</a></div></body></html>','about:blank');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  WebBrowser1.LoadFromStrings('<html><head><meta http-equiv="X-UA-Compatible" content="IE=edge" /></head><body></body></html>','about:blank');
  WebBrowser1.EvaluateJavaScript('alert("me");');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  TBrowserEmulationAdjuster.SetBrowserEmulationDWORD(TBrowserEmulationAdjuster.IE11_Quirks);
{$ENDIF}
end;

procedure TForm1.WebBrowser1DidStartLoad(ASender: TObject);
begin
  if WebBrowser1.URL.IndexOf('#')>-1 then
    begin
      Label1.Text := WebBrowser1.URL.Split(['#'])[1];
    end;
end;

end.
