unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ImgList,
  FMX.TabControl, FMX.StdCtrls, FMX.Layouts, FMX.Effects,
  FMX.Controls.Presentation, System.ImageList, Math;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    Layout1: TLayout;
    Button1: TSpeedButton;
    Button2: TSpeedButton;
    Button3: TSpeedButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Glyph4: TGlyph;
    Glyph5: TGlyph;
    Glyph6: TGlyph;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ImageList1: TImageList;
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(2);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Button1.Width := Trunc(Layout1.Width/3);
  Button2.Width := Button1.Width;
  Button3.Width := Button1.Width;
end;

end.
