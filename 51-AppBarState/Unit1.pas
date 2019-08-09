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
    Label4: TLabel;
    ShadowEffect4: TShadowEffect;
    StateFDMemTable: TFDMemTable;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    BackButton: TButton;
    AddButton: TButton;
    RemoveButton: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldVisible: TLinkPropertyToField;
    LinkPropertyToFieldVisible2: TLinkPropertyToField;
    LinkPropertyToFieldVisible3: TLinkPropertyToField;
    LinkPropertyToFieldTabIndex: TLinkPropertyToField;
    SaveButton: TButton;
    TabItem4: TTabItem;
    LinkPropertyToFieldVisible4: TLinkPropertyToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Layout1: TLayout;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    LinkControlToField8: TLinkControlToField;
    procedure TabControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  StateFDMemTable.Locate('Page',VarArrayOf([TabControl1.TabIndex]));
end;

end.
