unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.Ani,
  Data.Bind.Components, Data.Bind.DBScope, System.ImageList, FMX.ImgList,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    ToolBar2: TToolBar;
    Button1: TButton;
    Label2: TLabel;
    ListView1: TListView;
    FDMemTable1: TFDMemTable;
    ImageList1: TImageList;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    FloatAnimation1: TFloatAnimation;
    Label3: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    procedure Button1Click(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Rectangle1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure HideBottomSheet;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if ListView1.Height=0 then
    begin
      Layout1.Visible := True;
      FloatAnimation1.Enabled := True;
    end
  else
    begin
      HideBottomSheet;
    end;
end;

procedure TForm1.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListView1.Height := 0;
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  HideBottomSheet;

  Label3.Text := AItem.Text;
end;

procedure TForm1.Rectangle1Click(Sender: TObject);
begin
  HideBottomSheet;
end;

procedure TForm1.HideBottomSheet;
begin
  ListView1.Height := 0;
  Layout1.Visible := False;
end;

end.
