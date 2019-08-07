unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Effects, FMX.StdCtrls,
  FMX.Controls.Presentation, Fmx.Bind.Editors, System.ImageList, FMX.ImgList;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Button1: TButton;
    ShadowEffect1: TShadowEffect;
    BindingsList1: TBindingsList;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    ListView1: TListView;
    ImageList1: TImageList;
    LinkListControlToField1: TLinkListControlToField;
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
var
I: Integer;
SL: TStringList;
begin
  SL := TStringList.Create;
  try

    SL.Text := 'Delphi'+#13#10+'is'+#13#10+'awesome!';

    FDMemTable1.BeginBatch();
    for I := 0 to SL.Count-1 do
      begin
        FDMemTable1.AppendRecord([SL[I],0]);
      end;
    FDMemTable1.EndBatch();

    LinkListControlToField1.Active := False;
    LinkListControlToField1.Active := True;

    FDMemTable1.First;
  finally
    SL.Free;
  end;
end;

end.
