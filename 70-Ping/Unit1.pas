unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMXTee.Engine, FMXTee.Procs,
  FMXTee.Chart, FMX.Edit, FMX.Layouts, FMX.ScrollBox, FMX.Memo, FMX.TabControl,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  FMXTee.Series;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    Layout1: TLayout;
    Edit1: TEdit;
    Button1: TButton;
    Chart1: TChart;
    IdIcmpClient1: TIdIcmpClient;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Memo1: TMemo;
    Series1: TBarSeries;
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
begin
  // Requires a RAW socket.
  // Requires root on IOS and Android. Will error with Socket Error #1 without it.
  Chart1.Title.Text[0] := Edit1.Text;
  IdIcmpClient1.Host := Edit1.Text;
  Chart1.Series[0].Clear;
  Memo1.Lines.Append('Pinging '+Edit1.Text+' with 32 bytes of data:');
  TTask.Run(procedure var I: Integer; begin
    for I := 0 to 5 do
      begin
        idICMPClient1.Ping('DelphiIsAwesome! FireMonkey!');
        TThread.Synchronize(nil,procedure begin
          Memo1.Lines.Add('Reply from '+Edit1.Text+':  bytes=' + IntToStr(idICMPClient1.ReplyStatus.BytesReceived) + ' time=' + idICMPClient1.ReplyStatus.MsRoundTripTime.ToString + 'ms TTL='+idICMPClient1.ReplyStatus.TimeToLive.ToString);
          Chart1.Series[0].Add(idICMPClient1.ReplyStatus.MsRoundTripTime,idICMPClient1.ReplyStatus.MsRoundTripTime.ToString + ' ms');
        end);
      end;
  end);
end;

end.
