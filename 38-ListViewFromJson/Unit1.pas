unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Client,
  Data.Bind.ObjectScope, FMX.ListView, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation,
  System.JSON, Fmx.Bind.Editors, System.Generics.Collections;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Button1: TButton;
    BindingsList1: TBindingsList;
    ListView1: TListView;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    ShadowEffect1: TShadowEffect;
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
  RESTRequest1.ExecuteAsync(
    procedure
      var
        LJSON: TJSONObject;
        I: Integer;
      begin
        Label1.Text := 'Complete!';

        FDMemTable1.BeginBatch();
        LJSON := TJSONObject(TJSONObject.ParseJSONValue(RESTResponse1.Content));
        for I := 0 to LJSON.Count-1 do
          begin
            FDMemTable1.AppendRecord([TJSONPair(LJSON.Pairs[I]).JsonString.ToString, TJSONPair(LJSON.Pairs[I]).JsonValue.ToString]);
          end;
        FDMemTable1.EndBatch();

        LinkListControlToField2.Active := False;
        LinkListControlToField2.Active := True;

        FDMemTable1.First;

      end,
    True,
    True,
    procedure (Sender: TObject)
      begin
        Label1.Text := 'Error!';
      end);
end;

end.
