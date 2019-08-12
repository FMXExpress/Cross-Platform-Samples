unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.DApt, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.ListView,
  FireDAC.Comp.Client, FireDAC.Phys.SQLiteVDataSet, FireDAC.Comp.DataSet,
  FireDAC.Comp.UI, FMX.Edit, FMX.Layouts, FMX.ListBox;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    TabControl1: TTabControl;
    ListTab: TTabItem;
    EditTab: TTabItem;
    ListView1: TListView;
    AddButton: TButton;
    BackButton: TButton;
    ListItemsTab: TTabItem;
    Label2: TLabel;
    Edit1: TEdit;
    SaveButton: TButton;
    MasterFDMemTable: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ListBox1: TListBox;
    DetailFDMemTable: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    procedure AddButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ListBox1ChangeCheck(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
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

procedure TForm1.AddButtonClick(Sender: TObject);
begin
  Form1.Tag := TabControl1.TabIndex;
  TabControl1.GotoVisibleTab(2);
end;

procedure TForm1.BackButtonClick(Sender: TObject);
begin
  case TabControl1.TabIndex of
    1: TabControl1.GotoVisibleTab(0);
    2: case Form1.Tag of
         0: TabControl1.GotoVisibleTab(0);
         1: TabControl1.GotoVisibleTab(1);
       end;
  end;
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  case Form1.Tag of
    0:
      begin
        MasterFDMemTable.Append;
        MasterFDMemTable.FieldByName('Title').AsString := Edit1.Text;
        MasterFDMemTable.Post;
        LinkListControlToField1.Active := False;
        LinkListControlToField1.Active := True;
      end;
    1:
      begin
        DetailFDMemTable.AppendRecord([nil,MasterFDMemTable.FieldByName('Id').AsInteger,Edit1.Text,False]);
        LinkListControlToField2.Active := False;
        LinkListControlToField2.Active := True;
      end;
  end;
  Edit1.Text := '';
  TabControl1.GotoVisibleTab(Form1.Tag);
end;

procedure TForm1.ListBox1ChangeCheck(Sender: TObject);
begin
  if DetailFDMemTable.Locate('Id',VarArrayOf([TListBoxItem(Sender).ImageIndex])) then
    begin
      DetailFDMemTable.Edit;
      DetailFDMemTable.FieldByName('Done').AsBoolean := ListBox1.Selected.IsChecked;
      DetailFDMemTable.Post;
    end;
end;

procedure TForm1.ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
var
  I: Integer;
begin
  DetailFDMemTable.Filtered := False;
  DetailFDMemTable.Filter := 'ListId = ' + MasterFDMemTable.FieldByName('Id').AsString;
  DetailFDMemTable.Filtered := True;

  I := 0;
  DetailFDMemTable.First;
  while not DetailFDMemTable.Eof do
    begin
      ListBox1.ListItems[I].IsChecked := DetailFDMemTable.FieldByName('Done').AsBoolean;
      Inc(I);
      DetailFDMemTable.Next;
    end;
  TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0: begin
      AddButton.Visible := True;
      BackButton.Visible := False;
    end;
    1: begin
      AddButton.Visible := True;
      BackButton.Visible := True;
    end;
    2: begin
      AddButton.Visible := False;
      BackButton.Visible := True;
      DelayedSetFocus(Edit1);
    end;
  end;
end;

end.
