unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.StdCtrls, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ListView, FMX.Effects, FMX.Controls.Presentation, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  FireDAC.Stan.StorageBin, System.ImageList, FMX.ImgList;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    ListView1: TListView;
    FDMemTable1: TFDMemTable;
    Button1: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    ImageList1: TImageList;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils, Math, System.Threading;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FDMemTable1.AppendRecord(['Delphi is awesome!',RandomRange(0,4)]);
  LinkListControlToField1.Active := False;
  LinkListControlToField1.Active := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FDMemTable1.Delete;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDMemTable1.ResourceOptions.PersistentFileName := TPath.Combine(TPath.GetDocumentsPath,'data.fds');
  FDMemTable1.ResourceOptions.Persistent := True;
  FDMemTable1.Open;
end;

initialization
  Randomize;

end.
