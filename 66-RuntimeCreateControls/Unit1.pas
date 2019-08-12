unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView, FMX.ListView.Appearances;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ToolBar: TToolBar;
    TopLabel: TLabel;
    ShadowEffect: TShadowEffect;
    Button: TButton;
    ListView: TListView;
    procedure ButtonClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ButtonClick(Sender: TObject);
var
  LVI: TListViewItem;
begin
  LVI := ListView.Items.Add;
  LVI.Text := 'Delphi is awesome!';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ToolBar := TToolBar.Create(Self);
  ToolBar.Parent := Form1;
  ToolBar.Height := 48;

  TopLabel := TLabel.Create(Self);
  TopLabel.Parent := ToolBar;
  TopLabel.Align := TAlignLayout.Contents;
  TopLabel.StyledSettings := TopLabel.StyledSettings - [TStyledSetting.Style];
  TopLabel.TextSettings.HorzAlign := TTextAlign.Center;
  TopLabel.TextSettings.Font.Style := TopLabel.TextSettings.Font.Style + [TFontStyle.fsBold];
  TopLabel.Text := 'Runtime Create Controls';

  ShadowEffect := TShadowEffect.Create(Self);
  ShadowEffect.Parent := ToolBar;

  Button := TButton.Create(Self);
  Button.Parent := Form1;
  Button.Align := TAlignLayout.Bottom;
  Button.Height := 40;
  Button.Margins.Bottom := 5;
  Button.Margins.Left := 5;
  Button.Margins.Right := 5;
  Button.Margins.Top := 5;
  Button.Text := 'Click Me!';
  Button.OnClick := ButtonClick;

  ListView := TListView.Create(Self);
  ListView.Parent := Form1;
  ListView.Align := TAlignLayout.Client;
end;

end.
