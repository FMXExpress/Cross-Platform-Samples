unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.FMXUI.Wait, FMX.StdCtrls, Data.DB,
  FireDAC.Comp.Client, FMX.Effects, FMX.Controls.Presentation,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.ScrollBox, FMX.Grid, Data.Bind.Controls, FMX.Layouts, Fmx.Bind.Navigator;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FRanOnce: Boolean;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  Unit2;

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not FRanOnce then
    begin
      FRanOnce := True;

      DataModule1.InitializeDatabase;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BindSourceDB1.DataSet := DataModule1.FDTable1;

  Application.OnIdle := AppIdle;
end;

end.
