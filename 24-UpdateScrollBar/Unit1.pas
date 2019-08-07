unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, FireDAC.Stan.StorageJSON,
  Data.Bind.Components, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation,
  FMX.Edit;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Label2: TLabel;
    ScrollBar1: TScrollBar;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    Edit1: TEdit;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure ScrollBar1Change(Sender: TObject);
    procedure Edit1Validate(Sender: TObject; var Text: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Edit1Validate(Sender: TObject; var Text: string);
var
  LValue: Single;
begin
  LValue := Text.ToSingle;
  if LValue<>ScrollBar1.Value then
    ScrollBar1.Value := Text.ToSingle;
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Edit1.Text := ScrollBar1.Value.ToString;
  TLinkObservers.ControlChanged(Edit1);
end;

end.
