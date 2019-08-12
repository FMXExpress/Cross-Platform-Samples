unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, FMX.ListView, FMX.StdCtrls, FMX.Effects,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    ListView1: TListView;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Button1: TButton;
    procedure ListView1PullRefresh(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    RanOnce: Boolean;
  public
    { Public declarations }
    procedure RefreshData;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
  end;
  const
    BUSY = 1;
    NOT_BUSY = 0;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.RefreshData;
begin
  if RESTRequest1.Tag = NOT_BUSY then
    begin
      RESTRequest1.Tag := BUSY;
      Label1.Text := 'Loading...';
      FDMemTable1.DisableControls;
      RESTRequest1.ExecuteAsync(
        procedure
          begin
            Label1.Text := 'Complete!';
            RESTRequest1.Tag := NOT_BUSY;
            FDMemTable1.EnableControls;
            LinkListControlToField1.Active := False;
            LinkListControlToField1.Active := True;
          end,
        True,
        True,
        procedure (Sender: TObject)
          begin
            Label1.Text := 'Error!';
            RESTRequest1.Tag := NOT_BUSY;
            FDMemTable1.EnableControls;
          end);
    end;
end;

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not RanOnce then
    begin
      RanOnce := True;

      RefreshData;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  RefreshData;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle := AppIdle;
  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
     Button1.Visible := False;
  {$ENDIF}
end;

procedure TForm1.ListView1PullRefresh(Sender: TObject);
begin
  RefreshData;
end;

end.
