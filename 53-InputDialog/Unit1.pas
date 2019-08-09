unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.TabControl, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.DialogService.Async,
  FireDAC.Stan.StorageBin, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Data.Bind.Components, Data.Bind.DBScope, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
  FMX.Edit;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    AddButton: TButton;
    BindingsList1: TBindingsList;
    ListView1: TListView;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    procedure AddButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AddButtonClick(Sender: TObject);
begin
  TDialogServiceAsync.InputQuery('Add Item', ['Title'], [''],
    procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      case AResult of
        mrOk:
        begin
          FDMemTable1.AppendRecord([AValues[0]]);
          LinkListControlToField1.Active := False;
          LinkListControlToField1.Active := True;
        end;
        mrCancel:
        begin
          // do nothing
        end;
      end;
    end);
end;

end.
