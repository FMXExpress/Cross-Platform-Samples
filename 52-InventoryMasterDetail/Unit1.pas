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
    ListView1: TListView;
    ListView2: TListView;
    RoomsFDMemTable: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    ItemsFDMemTable: TFDMemTable;
    DataSource1: TDataSource;
    ImageControl1: TImageControl;
    Label1: TLabel;
    Edit1: TEdit;
    VertScrollBox1: TVertScrollBox;
    Label2: TLabel;
    Memo1: TMemo;
    ImageControl2: TImageControl;
    VertScrollBox2: TVertScrollBox;
    Label3: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Memo2: TMemo;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    BindSourceDB3: TBindSourceDB;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkListControlToField2: TLinkListControlToField;
    OpenDialog1: TOpenDialog;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure TabControl1Change(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure ImageControl2Click(Sender: TObject);
    procedure ImageControl1Click(Sender: TObject);
    procedure ListView2ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure RemoveButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure ImageControl1Change(Sender: TObject);
    procedure ImageControl2Change(Sender: TObject);
    procedure ListView1ButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
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
  case TabControl1.TabIndex of
    0: begin
         TabControl1.GotoVisibleTab(2);
         RoomsFDMemTable.Append;
         RoomsFDMemTable.Post;
       end;
    1: begin
         TabControl1.GotoVisibleTab(3);
         ItemsFDMemTable.Append;
         ItemsFDMemTable.Post;
       end;
  end;
end;

procedure TForm1.BackButtonClick(Sender: TObject);
begin
  case TabControl1.TabIndex of
    1: begin
         TabControl1.GotoVisibleTab(0);
       end;
    2: begin
         TabControl1.GotoVisibleTab(0);
       end;
    3: begin
         TabControl1.GotoVisibleTab(1);
       end;
  end;
end;

procedure TForm1.ImageControl1Change(Sender: TObject);
begin
  TLinkObservers.ControlChanged(ImageControl1);
end;

procedure TForm1.ImageControl1Click(Sender: TObject);
begin
{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  if OpenDialog1.Execute then
    begin
      ImageControl1.Bitmap.LoadFromFile(OpenDialog1.FileName);
    end;
{$ENDIF}
end;

procedure TForm1.ImageControl2Change(Sender: TObject);
begin
  TLinkObservers.ControlChanged(ImageControl2);
end;

procedure TForm1.ImageControl2Click(Sender: TObject);
begin
{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  if OpenDialog1.Execute then
    begin
      ImageControl2.Bitmap.LoadFromFile(OpenDialog1.FileName);
    end;
{$ENDIF}
end;

procedure TForm1.ListView1ButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
  TabControl1.GotoVisibleTab(2);
end;

procedure TForm1.ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
 if ItemObject.ClassName<>'TListItemTextButton' then
   begin
     TabControl1.GotoVisibleTab(1);
   end;
end;

procedure TForm1.ListView2ItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
  TabControl1.GotoVisibleTab(3);
end;

procedure TForm1.RemoveButtonClick(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0: RoomsFDMemTable.Delete;
    1: ItemsFDMemTable.Delete;
  end;
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  case TabControl1.TabIndex of
    2: begin
         TabControl1.GotoVisibleTab(0);
       end;
    3: begin
         TabControl1.GotoVisibleTab(1);
       end;
  end;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  StateFDMemTable.Locate('Page',VarArrayOf([TabControl1.TabIndex]));
end;

end.
