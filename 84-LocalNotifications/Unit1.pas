unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Notification, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects;

type
  TForm1 = class(TForm)
    NotificationCenter1: TNotificationCenter;
    Button1: TButton;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure NotificationCenter1ReceiveLocalNotification(Sender: TObject;
      ANotification: TNotification);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowNotification(const ATitle, ABody: String; ANumber: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.NotificationCenter1ReceiveLocalNotification(Sender: TObject;
  ANotification: TNotification);
begin
  if NotificationCenter1.Supported=True then
    begin
      NotificationCenter1.CancelAll;
    end;
end;

procedure TForm1.ShowNotification(const ATitle, ABody: String; ANumber: Integer);
var
  LNotification: TNotification;
begin
  if NotificationCenter1.Supported=True then
    begin
      LNotification := NotificationCenter1.CreateNotification;
      try
        LNotification.Title := ATitle;
        LNotification.AlertBody := ABody;
        LNotification.Number := ANumber;
        NotificationCenter1.PresentNotification(LNotification);
      finally
        LNotification.DisposeOf;
        LNotification := nil;
      end;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowNotification('Guess what?', 'Delphi is awesome!',1);
end;

end.
