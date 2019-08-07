unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.ImageList, FMX.ImgList, FMX.TabControl, FMX.StdCtrls, FMX.Effects,
  FMX.Controls.Presentation, Unit2, Unit4, Unit3;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    MaterialOxfordBlueSB: TStyleBook;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    SecondFrame1: TSecondFrame;
    ThirdFrame1: TThirdFrame;
    FirstFrame1: TFirstFrame;
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
  Unit5;

end.
