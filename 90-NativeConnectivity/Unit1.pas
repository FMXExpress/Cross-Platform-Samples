// Requires the IOS SystemConfiguration framework be added through the Delphi SDK Manager
// https://www.delphiworlds.com/2013/10/adding-other-ios-frameworks-to-the-sdk-manager/
unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, System.Threading, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, StrUtils, DW.Connectivity,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Objects, FMX.Layouts, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    IdTCPClient1: TIdTCPClient;
    Button1: TButton;
    Label2: TLabel;
    Layout1: TLayout;
    Label3: TLabel;
    Circle1: TCircle;
    InternetCircle: TCircle;
    Layout2: TLayout;
    Label4: TLabel;
    Circle2: TCircle;
    WifiCircle: TCircle;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldVisible: TLinkPropertyToField;
    LinkPropertyToFieldVisible2: TLinkPropertyToField;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    FConnectivity: TConnectivity;
  {$ENDIF}
    procedure ConnectivityChangeHandler(Sender: TObject; const AIsConnected: Boolean);
  public
    { Public declarations }
    RanOnce: Boolean;
    Connected: Boolean;
    InternetConnectivity: Boolean;
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

procedure TForm1.ConnectivityChangeHandler(Sender: TObject; const AIsConnected: Boolean);
begin
  FDMemTable1.Edit;
  if AIsConnected then
    begin
      TestConnectionAsync;
    end
  else
    begin
      InternetConnectivity := False;
      FDMemTable1.FieldByName('Internet').AsBoolean := False;
    end;

  if TConnectivity.IsWifiInternetConnection then
    begin
      FDMemTable1.FieldByName('Wifi').AsBoolean := True;
    end
  else
    begin
      FDMemTable1.FieldByName('Wifi').AsBoolean := False;
    end;
  FDMemTable1.Post;
end;

function TForm1.TestConnectionAsync: Boolean;
begin
  TThread.CreateAnonymousThread(procedure
    begin
      {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
      if TConnectivity.IsConnectedToInternet then
        InternetConnectivity := TestConnection
      else
        InternetConnectivity := False;
      {$ELSE}
        InternetConnectivity := TestConnection;
      {$ENDIF}
      TThread.Synchronize(nil, procedure begin
        FDMemTable1.Edit;
        FDMemTable1.FieldByName('Internet').AsBoolean := InternetConnectivity;
        FDMemTable1.Post;
      end);
    end).Start;
  Result := InternetConnectivity;
end;

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

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle := ApplicationEventsIdle;
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    FConnectivity := TConnectivity.Create;
    FConnectivity.OnConnectivityChange := ConnectivityChangeHandler;
  {$ELSE}
    Circle2.Fill.Color := TAlphaColorRec.LtGray;
  {$ENDIF}
end;

end.
