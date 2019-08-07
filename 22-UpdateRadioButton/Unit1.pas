unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.StdCtrls, FMX.Layouts,
  Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Effects,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Label2: TLabel;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Layout1: TLayout;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    LinkPropertyToFieldIsChecked: TLinkPropertyToField;
    LinkPropertyToFieldIsChecked2: TLinkPropertyToField;
    LinkPropertyToFieldIsChecked3: TLinkPropertyToField;
    procedure RadioButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  if Sender=RadioButton1 then
    begin
       if not TRadioButton(Sender).IsChecked then
         begin
           FDMemTable1.Edit;
           FDMemTable1.FieldByName('Value').AsString := 'Delphi';
           FDMemTable1.Post;
         end;
    end
  else if Sender=RadioButton2 then
    begin
       if not TRadioButton(Sender).IsChecked then
         begin
           FDMemTable1.Edit;
           FDMemTable1.FieldByName('Value').AsString := 'Is';
           FDMemTable1.Post;
         end;
    end
  else if Sender=RadioButton3 then
    begin
       if not TRadioButton(Sender).IsChecked then
         begin
           FDMemTable1.Edit;
           FDMemTable1.FieldByName('Value').AsString := 'Awesome';
           FDMemTable1.Post;
         end;
    end;
end;

end.
