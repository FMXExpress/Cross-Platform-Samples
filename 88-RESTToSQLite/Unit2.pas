unit Unit2;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  REST.Types, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TDataModule1 = class(TDataModule)
    FDTable1: TFDTable;
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDSQLiteSecurity1: TFDSQLiteSecurity;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    FDQueryDelete: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadDataSet;
    procedure InitializeDatabase;
  end;
  const
    DB_FILENAME = 'photos_sqlite.sdb';
    DB_PASSWORD = 'SQLitePassword';
    DB_ENCRYPTION = 'aes-256';
    DB_TABLE = 'Photos';

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.Threading, System.IOUtils;

procedure TDataModule1.InitializeDatabase;
begin
  FDConnection1.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DB_FILENAME);

  FDTable1.TableName := DB_TABLE;
  if TFile.Exists(FDConnection1.Params.Values['Database'])=True then
    begin
      FDSQLiteSecurity1.Database := FDConnection1.Params.Values['Database'];
    end
  else
    begin
      FDConnection1.Open;
      // initialize table
      try
        FDTable1.FieldDefs.Clear;
        FDTable1.FieldDefs.Assign(FDMemTable1.FieldDefs);
        FDTable1.CreateTable(False);
      finally
        FDConnection1.Close;
      end;
      // encrypt database
      FDSQLiteSecurity1.Database := FDConnection1.Params.Values['Database'];
      FDSQLiteSecurity1.Password := DB_ENCRYPTION + ':' + DB_PASSWORD;
      FDSQLiteSecurity1.SetPassword;
    end;

  FDConnection1.Params.Values['Encrypt'] := DB_ENCRYPTION;
  FDConnection1.Params.Password := DB_PASSWORD;
  FDConnection1.Open;
  FDTable1.IndexFieldNames := FDMemTable1.IndexFieldNames;

  FDMemTable1.LogChanges := False;
  FDMemTable1.FetchOptions.RecsMax := 300000;  //Sample value
  FDMemTable1.ResourceOptions.SilentMode := True;
  FDMemTable1.UpdateOptions.LockMode := lmNone;
  FDMemTable1.UpdateOptions.LockPoint := lpDeferred;
  FDMemTable1.UpdateOptions.FetchGeneratorsPoint := gpImmediate;

  TTask.Run(procedure begin
    FDTable1.Open;
  end);
end;

procedure TDataModule1.LoadDataSet;
begin
    FDQueryDelete.ExecSQL;
    FDTable1.BeginBatch;
    try
      FDTable1.CopyDataSet(FDMemTable1, [coStructure, coRestart, coAppend]);
      FDTable1.IndexFieldNames := '';
      FDTable1.First;
    finally
      FDTable1.EndBatch;
    end;
end;

end.
