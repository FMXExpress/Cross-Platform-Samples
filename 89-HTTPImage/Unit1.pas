unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.StdCtrls, FMX.Filter.Effects, FMX.Objects, FMX.Effects,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    NetHTTPClient1: TNetHTTPClient;
    Timer1: TTimer;
    Image1: TImage;
    GaussianBlurEffect1: TGaussianBlurEffect;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Layout1: TLayout;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  const
    NOT_BUSY = 0;
    BUSY = 0;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Threading;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if NetHTTPClient1.Tag=NOT_BUSY then
    begin
      GaussianBlurEffect1.Enabled := True;
      ProgressBar1.Visible := True;
      Timer1.Enabled := True;
      TTask.Run(procedure var LResponse: TMemoryStream; begin
        LResponse := TMemoryStream.Create;
        try
          NetHTTPClient1.Get('https://picsum.photos/seed/'+Random.ToString+'/'+Image1.Width.ToString+'/'+Image1.Height.ToString,LResponse);
          TThread.Synchronize(nil,procedure begin
            Image1.Bitmap.LoadFromStream(LResponse);
          end);
        finally
          LResponse.Free;
          NetHTTPClient1.Tag := NOT_BUSY;

          GaussianBlurEffect1.Enabled := False;
          ProgressBar1.Visible := False;
          Timer1.Enabled := False;
          ProgressBar1.Value := 0;
        end;
      end);
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if ProgressBar1.Value=100 then ProgressBar1.Value := 0;
  ProgressBar1.Value := ProgressBar1.Value+10;
end;

initialization
  Randomize;

end.
