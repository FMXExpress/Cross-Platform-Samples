unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, Data.Bind.Controls, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.Edit,
  FMX.Layouts, Fmx.Bind.Navigator, FMX.ExtCtrls, FireDAC.Comp.DataSet,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.Objects, FMX.Filter.Effects, FMX.TabControl;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Label2: TLabel;
    BindNavigator1: TBindNavigator;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    NetHTTPClient1: TNetHTTPClient;
    NetHTTPRequest1: TNetHTTPRequest;
    Image1: TImage;
    Layout1: TLayout;
    ProgressBar1: TProgressBar;
    GaussianBlurEffect1: TGaussianBlurEffect;
    LoadTimer: TTimer;
    DownloadTimer: TTimer;
    LoadingTimer: TTimer;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Image2: TImage;
    Label3: TLabel;
    Button1: TButton;
    ShadowEffect1: TShadowEffect;
    Edit1: TEdit;
    LinkControlToField1: TLinkControlToField;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure NetHTTPRequest1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    procedure NetHTTPRequest1RequestError(const Sender: TObject;
      const AError: string);
    procedure LoadTimerTimer(Sender: TObject);
    procedure DownloadTimerTimer(Sender: TObject);
    procedure LoadingTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FRanOnce: Boolean;
    FLoadComplete: Boolean;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure NetHTTPComplete;
    procedure InitializeTable;
  public
    { Public declarations }
  end;
  const
    NOT_BUSY = 0;
    BUSY = 1;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Threading, System.NetEncoding, Unit2;

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not FRanOnce then
    begin
      FRanOnce := True;

      ProgressBar1.Visible := True;
      LoadingTimer.Enabled := True;

      DataModule1.InitializeDatabase;

      DownloadTimer.Enabled := True;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.DownloadTimerTimer(Sender: TObject);
begin
  if DataModule1.FDTable1.Active=True then
    begin
      DownloadTimer.Enabled := False;
      DataModule1.RESTRequest1.ExecuteAsync(procedure
        begin
          // Request complete
          LoadTimer.Enabled := True;
        end,
      True,
      True,
      procedure (Sender: TObject)
        begin
          Label1.Text := 'Failed!';
          DataModule1.FDTable1.IndexFieldNames := '';
          DataModule1.FDTable1.First;
          InitializeTable;
        end);
   end;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if FLoadComplete=True then
    begin
      if NetHTTPRequest1.Tag=NOT_BUSY then
        begin
          NetHTTPRequest1.Tag := BUSY;
          GaussianBlurEffect1.Enabled := True;
          ProgressBar1.Visible := True;
          LoadingTimer.Enabled := True;
          NetHTTPRequest1.URL := 'https://picsum.photos/seed/'+TNetEncoding.Url.Encode(Label2.Text)+'/'+Image1.Width.ToString+'/'+Image1.Height.ToString;
          NetHTTPRequest1.Execute;
        end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BindSourceDB1.DataSet := nil;;

  Application.OnIdle := AppIdle;
end;


procedure TForm1.LoadingTimerTimer(Sender: TObject);
begin
  if ProgressBar1.Value=100 then ProgressBar1.Value := 0;
  ProgressBar1.Value := ProgressBar1.Value+10;
end;

procedure TForm1.InitializeTable;
begin
  BindSourceDB1.DataSet := DataModule1.FDTable1;
  FLoadComplete := True;
  Edit1Change(Self);
end;

procedure TForm1.LoadTimerTimer(Sender: TObject);
begin
  LoadTimer.Enabled := False;
  TTask.Run(procedure begin
    DataModule1.LoadDataSet;
    TThread.Synchronize(nil,procedure begin
      InitializeTable;
    end);
  end);
end;

procedure TForm1.NetHTTPComplete;
begin
  ProgressBar1.Visible := False;
  GaussianBlurEffect1.Enabled := False;
  LoadingTimer.Enabled := False;
  ProgressBar1.Value := 0;
  NetHTTPRequest1.Tag := NOT_BUSY;
end;

procedure TForm1.NetHTTPRequest1RequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin
  Image1.Bitmap.LoadFromStream(AResponse.ContentStream);
  NetHTTPComplete;
end;

procedure TForm1.NetHTTPRequest1RequestError(const Sender: TObject;
  const AError: string);
begin
  Label1.Text := AError;
  NetHTTPComplete;
end;

end.
