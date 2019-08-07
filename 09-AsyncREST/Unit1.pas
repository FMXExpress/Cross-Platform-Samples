unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.StdCtrls,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.ScrollBox,
  FMX.Grid, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.ObjectScope, FMX.Effects,
  FMX.Controls.Presentation, FMX.Memo, FireDAC.Stan.StorageJSON;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    Button1: TButton;
    Memo1: TMemo;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;

  RESTRequest1.ExecuteAsync(
    procedure
      begin
        Label1.Text := 'Complete!';
        Memo1.Lines.Append('Userid: ' + FDMemTable1.FieldByName('Userid').AsString);
        Memo1.Lines.Append('id: ' + FDMemTable1.FieldByName('id').AsString);
        Memo1.Lines.Append('title: ' + FDMemTable1.FieldByName('title').AsWideString);
        Memo1.Lines.Append('body: ' + FDMemTable1.FieldByName('body').AsWideString);
      end,
    True,
    True,
    procedure (Sender: TObject)
      begin
        Label1.Text := 'Error!';
      end);
end;

end.
