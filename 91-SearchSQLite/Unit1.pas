unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    Edit1: TEdit;
    Button1: TButton;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    RanOnce: Boolean;
  public
    { Public declarations }
    procedure AppIdle(Sender: TObject; var Done: Boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  Unit2;

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not RanOnce then
    begin
      RanOnce := True;

      DataModule1.InitializeDatabase;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BindSourceDB1.DataSet := DataModule1.FDQuerySearch;

  Application.OnIdle := AppIdle;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label1.Visible := not Label1.Visible;
  if Edit1.Visible = False then
    begin
      Edit1.Visible := True;
      DataModule1.DelayedSetFocus(Edit1);
    end
  else
    Edit1.Visible := False;
  DataModule1.SearchDatabase(Edit1.Text);
end;

end.
