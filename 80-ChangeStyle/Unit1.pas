unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    WedgewoodLightSB: TStyleBook;
    SettingsFDMemTable: TFDMemTable;
    Button1: TButton;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetStyle;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils, System.Math;

procedure TForm1.SetStyle;
begin
  case SettingsFDMemTable.FieldByName('Style').AsInteger of
    0: Form1.StyleBook := MaterialOxfordBlueSB;
    1: Form1.StyleBook := WedgewoodLightSB;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SettingsFDMemTable.Edit;
  SettingsFDMemTable.FieldByName('Style').AsInteger := IfThen(SettingsFDMemTable.FieldByName('Style').AsInteger=0,1,0);
  SettingsFDMemTable.Post;
  SetStyle;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SettingsFDMemTable.ResourceOptions.PersistentFileName := TPath.Combine(TPath.GetDocumentsPath, 'cs_settings.fds');
  SettingsFDMemTable.ResourceOptions.Persistent := True;
  SettingsFDMemTable.Open;

  SetStyle;
end;

end.
