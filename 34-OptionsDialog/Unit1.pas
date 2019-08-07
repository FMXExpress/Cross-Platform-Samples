unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.DialogService.Async,
  FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation, FMX.Platform;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    SnackButton: TButton;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    procedure SnackButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.SnackButtonClick(Sender: TObject);
var
  ASyncService: IFMXDialogServiceASync;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceAsync, IInterface(ASyncService)) then
    begin
      ASyncService.MessageDialogAsync( 'Do you want to set the time?', TMsgDlgType.mtConfirmation,
                                                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
       procedure(const AResult: TModalResult)
       begin
         case AResult of
           mrYES: begin
                    Label1.Text := DateTimeToStr(Now);
                  end;
           mrNO: begin
                    // do nothing
                 end;
         end;
       end);
    end;
end;

end.
