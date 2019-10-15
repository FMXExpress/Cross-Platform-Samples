unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, MyPaintBox, FMX.Objects, FMX.Colors,
  FMX.ListBox, FMX.Layouts, FMX.DialogService.Async;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    ScreenshotButton: TButton;
    DragImage: TImage;
    IconsListBox: TListBox;
    PanelMenu: TPanel;
    Rectangle1: TRectangle;
    DrawListBox: TListBox;
    inonedraw: TListBoxItem;
    idrawpen: TListBoxItem;
    idrawline: TListBoxItem;
    idrawrectangle: TListBoxItem;
    idrawlinerectangle: TListBoxItem;
    idrawellipse: TListBoxItem;
    idrawlineellipse: TListBoxItem;
    idrawerase: TListBoxItem;
    idrawfill: TListBoxItem;
    Toolbar: TToolBar;
    ForegroundColorBox: TComboColorBox;
    BackgroundColorBox: TComboColorBox;
    ImageMenu: TImage;
    LineThicknessTB: TTrackBar;
    LineWidthText: TText;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    SaveDialog1: TSaveDialog;
    ListBoxItem9: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BackgroundColorBoxChange(Sender: TObject);
    procedure ForegroundColorBoxChange(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure IconsListBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure IconsListBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ImageMenuClick(Sender: TObject);
    procedure LineThicknessTBChange(Sender: TObject);
    procedure DrawListBoxChange(Sender: TObject);
    procedure DrawListBoxClick(Sender: TObject);
    procedure ListBoxItem1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ScreenshotButtonClick(Sender: TObject);
  private
    { Private declarations }
    FOriginalFGColor: TColor;
    FOriginalBGColor: TColor;
    FPaintBox: TMyPaintBox;
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ListBoxItemMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.BackgroundColorBoxChange(Sender: TObject);
begin
  FPaintBox.BackgroundColor := BackgroundColorBox.Color;
end;

procedure TForm1.DrawListBoxChange(Sender: TObject);
begin
  if Assigned(ImageMenu) then
    ImageMenu.Bitmap := DrawListBox.Selected.ItemData.Bitmap;
  PanelMenu.Visible := False;
  if Assigned(FPaintBox) then
    begin
      FPaintBox.NoFill := False;

      if FOriginalBGColor<>TAlphaColorRec.Null then
        begin
          BackgroundColorBox.Color := FOriginalBGColor;
          FOriginalBGColor := TAlphaColorRec.Null;
        end;

      if FOriginalFGColor<>TAlphaColorRec.Null then
        begin
          ForegroundColorBox.Color := FOriginalFGColor;
          FOriginalFGColor := TAlphaColorRec.Null;
        end;


      case DrawListBox.ItemIndex of
       0: FPaintBox.FuncDraw := TFunctionDraw(DrawListBox.ItemIndex);
       1: FPaintBox.FuncDraw := TFunctionDraw(DrawListBox.ItemIndex);
       2: FPaintBox.FuncDraw := TFunctionDraw(DrawListBox.ItemIndex);
       3: begin
           FPaintBox.FuncDraw := TFunctionDraw(DrawListBox.ItemIndex);
          end;
       4: begin
           FPaintBox.NoFill := True;
           FPaintBox.FuncDraw := TFunctionDraw(3);
          end;
       5: begin
           FPaintBox.FuncDraw := TFunctionDraw(4);
          end;
       6: begin
           FPaintBox.NoFill := True;
           FPaintBox.FuncDraw := TFunctionDraw(4);
          end;
       7: begin
           FOriginalBGColor := BackgroundColorBox.Color;
           FOriginalFGColor := ForegroundColorBox.Color;
           BackgroundColorBox.Color := TAlphaColorRec.Black;
           ForegroundColorBox.Color := TAlphaColorRec.Black;
           FPaintBox.FuncDraw := TFunctionDraw(3);
          end;
       8: FPaintBox.FuncDraw := TFunctionDraw(5);
      end;
    end;
end;

procedure TForm1.DrawListBoxClick(Sender: TObject);
begin
  PanelMenu.Visible := False;
end;

procedure TForm1.ForegroundColorBoxChange(Sender: TObject);
begin
  if Assigned(FPaintBox) then
    FPaintBox.ForegroundColor := ForegroundColorBox.Color;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FPaintBox := TMyPaintBox.Create(Self);
  FPaintBox.Parent := Self;
  FPaintBox.SendToBack;

  FOriginalBGColor := TAlphaColorRec.Null;
  FOriginalFGColor := TAlphaColorRec.Null;

  FPaintBox.ForegroundColor := ForegroundColorBox.Color;
  FPaintBox.BackgroundColor := BackgroundColorBox.Color;
  FPaintBox.Align := TAlignLayout.Client;
  FPaintBox.OnMouseDown := PaintBoxMouseDown;
  FPaintBox.Margins.Top := 10;
  FPaintBox.Margins.Left := 10;
  FPaintBox.Margins.Right := 5;
  FPaintBox.Margins.Bottom := 10;
  LineThicknessTBChange(LineThicknessTB);
  ImageMenu.Bitmap := DrawListBox.Selected.ItemData.Bitmap;
  PanelMenu.BringToFront;
  Toolbar.BringToFront;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FPaintBox.DisposeOf;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if Assigned(FPaintBox) then
    begin
      FPaintBox.MouseLeave;
    end;
end;

procedure TForm1.IconsListBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if Assigned(FPaintBox) then
  begin
    if DragImage.Visible then
     begin
      DragImage.Position.X := X+IconsListBox.Position.X-(DragImage.Width/2);
      DragImage.Position.Y := Y+IconsListBox.Position.Y-(DragImage.Height/2);
     end;
  end;
end;

procedure TForm1.IconsListBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if Assigned(FPaintBox) then
  begin
    TThread.Queue(nil,procedure begin
    if DragImage.Visible=True then
     begin
      if DragImage.Tag=1 then
       begin
         TDialogServiceAsync.InputQuery('Enter your text', ['Text:'], [''],
            procedure(const AResult: TModalResult; const AValues: array of string)
             begin
               case AResult of
                mrOk: begin
                        FPaintBox.StampText(X-IconsListBox.Width,Y,LineWidthText.TextSettings.Font,AValues[0]);
                      end;
               end;
             end);
         DragImage.Tag := 0;
       end
      else
        FPaintBox.StampBitmap(X-IconsListBox.Width,Y,DragImage.Bitmap);
      DragImage.Visible := False;
      FPaintBox.MouseLeave;
     end;
    end);
  end;

end;

procedure TForm1.ImageMenuClick(Sender: TObject);
begin
  PanelMenu.Visible := not PanelMenu.Visible;
end;

procedure TForm1.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if Assigned(FPaintBox) then
  begin
   if PanelMenu.Visible=True then
    begin
      PanelMenu.Visible := False;
    end;
  end;
end;

procedure TForm1.ScreenshotButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    begin
      FPaintBox.SaveToFile(SaveDialog1.FileName);
    end;
end;

procedure TForm1.LineThicknessTBChange(Sender: TObject);
begin
  if Assigned(FPaintBox) then
    FPaintBox.Thickness := TTrackBar(Sender).Value;
end;

procedure TForm1.ListBoxItem1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ListBoxItemMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TForm1.ListBoxItemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(FPaintBox) then
  begin
    DragImage.Bitmap.Assign(TListBoxItem(Sender).ItemData.Bitmap);
    DragImage.Bitmap.Resize(50,50);
    DragImage.Position.X := X+IconsListBox.Position.X-Trunc(DragImage.Bitmap.Width/2);
    DragImage.Position.Y := TListBoxItem(Sender).Position.Y+Y+IconsListBox.Position.Y-Trunc(DragImage.Bitmap.Height/2);
    DragImage.Tag := TListBoxItem(Sender).Tag;
    DragImage.Visible := True;
    DragImage.BringToFront;
  end;
end;

end.
