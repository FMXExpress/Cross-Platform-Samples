unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Layouts, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.ImageList, FMX.ImgList, FMX.ListView, FMX.StdCtrls, FMX.MultiView,
  FMX.Effects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    MaterialOxfordBlueSB: TStyleBook;
    MultiView1: TMultiView;
    Button1: TButton;
    ListView1: TListView;
    BindingsList1: TBindingsList;
    ImageList1: TImageList;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
    MultiView1.ControlType := TControlType.Platform;
  {$ELSE}
    MultiView1.ControlType := TControlType.Styled;
  {$ENDIF}
end;

end.
