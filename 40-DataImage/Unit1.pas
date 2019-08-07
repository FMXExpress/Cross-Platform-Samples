unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.StdCtrls, FMX.Effects,
  FMX.Controls.Presentation, FMX.Filter.Effects, FMX.Objects,
  FireDAC.Stan.StorageBin;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    MaterialOxfordBlueSB: TStyleBook;
    ImageControl1: TImageControl;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    OpenDialog1: TOpenDialog;
    procedure ImageControl1Change(Sender: TObject);
    procedure ImageControl1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ImageControl1Change(Sender: TObject);
begin
  TLinkObservers.ControlChanged(ImageControl1);
end;

procedure TForm1.ImageControl1Click(Sender: TObject);
begin
{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  if OpenDialog1.Execute then
    begin
      ImageControl1.LoadFromFile(OpenDialog1.FileName);
    end;
{$ENDIF}
end;

end.
