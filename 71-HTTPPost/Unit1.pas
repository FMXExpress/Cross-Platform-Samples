unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Rtti,
  FMX.Grid.Style, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Controls, FMX.Edit, FMX.Layouts,
  Fmx.Bind.Navigator, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ScrollBox, FMX.Grid,
  FMX.Memo, FMX.TabControl, FireDAC.Stan.StorageBin;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    NetHTTPClient1: TNetHTTPClient;
    NetHTTPRequest1: TNetHTTPRequest;
    Button1: TButton;
    StringGrid1: TStringGrid;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    Layout1: TLayout;
    Edit1: TEdit;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Memo1: TMemo;
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
  System.Threading, System.Net.Mime;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TTask.Run(procedure
    var
      LMultipartFormData: TMultipartFormData;
      LMS: TMemoryStream;
    begin

      LMultipartFormData := TMultipartFormData.Create;
      FDMemTable1.DisableControls;
      FDMemTable1.First;
      while not FDMemTable1.Eof do
        begin
          LMultipartFormData.AddField(FDMemTable1.FieldByName('Name').AsString,
                                      FDMemTable1.FieldByName('Value').AsString);
          FDMemTable1.Next;
        end;
      FDMemTable1.EnableControls;

      LMS := TMemoryStream.Create;

      NetHTTPRequest1.Post(Edit1.Text,LMultiPartFormData,LMS);

      TThread.Synchronize(nil, procedure begin
        Memo1.Lines.LoadFromStream(LMS);
        TabControl1.GotoVisibleTab(1)
      end);

      LMS.Free;

      LMultipartFormData.Free;
    end);

end;

end.
