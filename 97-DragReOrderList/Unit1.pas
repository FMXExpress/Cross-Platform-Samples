unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, FMX.Platform, FMX.Effects, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


//https://stackoverflow.com/questions/34510144/delphi-listview-drag-drop-entire-row
procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
   LData: TDragObject;
   LSvc: IFMXDragDropService;
   LImg: TBitmap;
begin
  if Assigned(ListBox1.ItemByPoint(X, Y)) and TPlatformServices.Current.SupportsPlatformService(IFMXDragDropService, LSvc) then
    begin
      LData.Source := ListBox1.ItemByPoint(X, Y);
      LImg := ListBox1.ItemByPoint(X, Y).MakeScreenshot;
      LSvc.BeginDragDrop(Self, LData, LImg);
    end;
end;

end.
