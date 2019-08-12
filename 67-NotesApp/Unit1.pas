unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ScrollBox, FMX.Memo,
  FMX.ListView, FMX.TabControl, System.ImageList, FMX.ImgList, FMX.StdCtrls,
  FMX.Objects, FMX.Effects, FMX.Controls.Presentation, FireDAC.Stan.StorageBin;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    NewCircleButton: TCircle;
    Button1: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ListView1: TListView;
    Memo1: TMemo;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    DoneButton: TButton;
    StateFDMemTable: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkPropertyToFieldVisible: TLinkPropertyToField;
    LinkPropertyToFieldVisible2: TLinkPropertyToField;
    procedure NewCircleButtonClick(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
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

procedure DelayedSetFocus(Control: TControl);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize( nil,
         procedure
         begin
           Control.SetFocus;
         end
      );
    end
  ).Start;
end;

procedure TForm1.DoneButtonClick(Sender: TObject);
begin
  TLinkObservers.ControlChanged(Memo1);
  TabControl1.GotoVisibleTab(0);
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.NewCircleButtonClick(Sender: TObject);
begin
  FDMemTable1.AppendRecord(['']);
  LinkListControlToField1.Active := False;
  LinkListControlToField1.Active := True;
  TabControl1.GotoVisibleTab(1);
  DelayedSetFocus(Memo1);
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  StateFDMemTable.Locate('Page',VarArrayOf([TabControl1.TabIndex]));
end;

end.
