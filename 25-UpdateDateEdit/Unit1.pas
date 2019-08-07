unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  FMX.DateTimeCtrls, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.StdCtrls, FMX.Effects,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Label2: TLabel;
    BehindEdit1: TEdit;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    DateEdit1: TDateEdit;
    LinkControlToField1: TLinkControlToField;
    procedure DateEdit1Change(Sender: TObject);
    procedure BehindEdit1Validate(Sender: TObject; var Text: string);
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

procedure TForm1.DateEdit1Change(Sender: TObject);
begin
  BehindEdit1.Text := DateEdit1.Text;
  TLinkObservers.ControlChanged(BehindEdit1);
end;


procedure TForm1.BehindEdit1Validate(Sender: TObject; var Text: string);
var
  LValue: TDateTime;
begin
  LValue := StrToDateTime(Text);
  if LValue<>DateEdit1.DateTime then
    DateEdit1.DateTime := StrToDateTime(Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BehindEdit1.Text := DateTimeToStr(Now);
end;

end.
