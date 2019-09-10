unit MyPaintBox;

interface

uses
  System.SysUtils,FMX.Surfaces,FMX.Colors,System.UITypes,System.Types, System.Classes,FMX.Controls,FMX.Graphics, FMX.Types, FMX.Objects, FMX.Platform;

type
  TFunctionDraw=(fdNone,fdPen,fdLine,fdRectangle,fdEllipse,fdFillBgr,fdBitmapStamp,fdPolyLine);
  TMyPaintBox = class(TPaintBox)
  private
    {$IFDEF POSIX}
    ffillBrush : TStrokeBrush;
    {$ENDIF}
    fDrawing:boolean;
    fbmpstamp:TBitmap;
    ffDraw:TFunctionDraw;
    fdrawbmp:TBitmap;
    forigbmp:TBitmap;
    fdrawrect:TRectF;//Paint box size
    pFrom,pTo:TPointF;
    fThickness:Single;
    ffgColor:TAlphaColor;
    fbgColor:TAlphaColor;
    fnofill:boolean;
    fcbrush:TBrush;//Current drawing Brush
    fcstroke:TStrokeBrush;//Current drawing stroke
    MouseMoved: Boolean;
    MouseDowned: Boolean;
    procedure SetForegroundColor(v:TAlphaColor);
    procedure SetBackgroundColor(v:TAlphaColor);
    procedure SetThickness(v:Single);
    procedure SetNoFill(v:boolean);
    procedure SetBitmapStamp(v:TBitmap);
  private
    procedure StartDrawing(startP:TPointF);
    procedure EndDrawing(startP:TPointF);
    procedure DoDraw(vCanvas: TCanvas;const drawall:boolean=true);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ForegroundColor:TAlphaColor read ffgColor write SetForegroundColor;
    property BackgroundColor:TAlphaColor read fbgColor write SetBackgroundColor;
    property Thickness:Single read fThickness write SetThickness;
    property FuncDraw:TFunctionDraw read ffDraw write ffDraw;
    property NoFill:Boolean read fnofill write SetNoFill;
    property BitmapStamp:TBitmap read fbmpstamp write SetBitmapStamp;
  public
    procedure MouseLeave;
    procedure FillColor(color:TAlphaColor);
    procedure SaveToJPEGStream(Stream: TStream);
    procedure SaveToBitmap(B: TBitmap); overload;
    procedure LoadFromBitmap(B: TBitmap);
    procedure SaveToFile(AFileName: String);
    procedure SaveToBitmap(B: TBitmap; Width, Height: Integer); overload;
    procedure StampBitmap(X,Y: Single; B: TBitmap);
    procedure StampText(X,Y: Single; F: TFont; Text: String);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(AFileName: String);
    {$IFDEF POSIX}
    procedure FFillerMod;
    {$ENDIF}
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MyPaintBox', [TMyPaintBox]);
end;

{ TMyPaintBox }

constructor TMyPaintBox.Create(AOwner: TComponent);
begin
  inherited;
  fbmpstamp:=nil;
  Parent:=TFmxObject(AOwner);
  Align:= TAlignLayout.Client;
  ffDraw:=TFunctionDraw.fdPen;
  fnofill:=false;
  fDrawing:=false;
  fThickness:=1;
  pFrom := PointF(-1, -1);
  pTo := PointF(-1, -1);

  fdrawrect:=RectF(0,0,self.Width, self.Height);
  fdrawbmp := TBitmap.Create(Round(Self.Width),Round(Self.Height));
  forigbmp := TBitmap.Create(Round(Self.Width),Round(Self.Height));
  forigbmp.Clear(TAlphaColors.Black);

  SetBackgroundColor(TAlphaColorRec.White);
  SetForegroundColor(TAlphaColorRec.Black);
  FillColor(fbgColor);

  {$IFDEF POSIX}
  FFillerMod;
  {$ENDIF}

end;

destructor TMyPaintBox.Destroy;
begin

  if (assigned(fcbrush)) then
    fcbrush.DisposeOf;
  if (assigned(fcstroke)) then
    fcstroke.DisposeOf;
  if (assigned(fdrawbmp)) then
    fdrawbmp.DisposeOf;
  if (assigned(forigbmp)) then
    forigbmp.DisposeOf;
  if assigned(fbmpstamp) then
    fbmpstamp.DisposeOf;

  {$IFDEF POSIX}
  if assigned ( ffillBrush ) then
    FreeAndNil ( ffillBrush );
  {$ENDIF}
  inherited;
end;

procedure TMyPaintBox.DoDraw(vCanvas: TCanvas; const drawall: boolean);
var
  r,rd: TRectF;
begin
  if (drawall) then self.Canvas.DrawBitmap(fdrawbmp,fdrawrect,fdrawrect,1);
  if (ffdraw=TFunctionDraw.fdNone) or (not fdrawing) then exit;

  r:=TRectF.Create(pFrom,pTo,True);
  with vCanvas do
  begin
    BeginScene();
    case ffdraw of
      {$IFDEF MSWINDOWS}
      TFunctionDraw.fdPen:begin
        DrawLine(pFrom,pTo,1,fcstroke);
      end;
      {$ENDIF}
      TFunctionDraw.fdLine:begin
        DrawLine(pFrom,pTo,1,fcstroke);
      end;
      TFunctionDraw.fdRectangle:begin
        if not fnofill then
          FillRect(r,0,0,[TCorner.TopLeft],1,fcbrush);
        DrawRect(r,0,0,[TCorner.TopLeft],1,fcstroke);
      end;
      TFunctionDraw.fdEllipse:begin
        if not fnofill then
          FillEllipse(r,1,fcbrush);
        DrawEllipse(r,1,fcstroke);
      end;
      TFunctionDraw.fdFillBgr:begin
        Clear(fbgColor);
      end;
      TFunctionDraw.fdBitmapStamp:
        if (assigned(fbmpstamp)) then begin
          r:=TRectF.Create(PointF(0,0),fbmpstamp.Width,fbmpstamp.Height);
          rd:=TRectF.Create(PointF(pTo.X-(fbmpstamp.Width/2),pTo.Y-(fbmpstamp.Height/2)),fbmpstamp.Width,fbmpstamp.Height);
          DrawBitmap(fbmpstamp,r,rd,1);
        end;
    end;
    EndScene;
  end;
  forigbmp.Assign(fdrawbmp);
end;

procedure TMyPaintBox.StampBitmap(X,Y: Single; B: TBitmap);
var
r,rd:TRectF;
begin
  with fdrawbmp.Canvas do
  begin
  BeginScene();
    if (assigned(B)) then
     begin
      r:=TRectF.Create(PointF(0,0),B.Width,B.Height);
      rd:=TRectF.Create(PointF(X-(B.Width/2),Y-(B.Height/2)),B.Width,B.Height);
      DrawBitmap(B,r,rd,1);
     end;
  EndScene;
  end;
  forigbmp.Assign(fdrawbmp);
  {$IFDEF POSIX}
  InvalidateRect(fdrawrect);
  {$ENDIF}
end;

procedure TMyPaintBox.StampText(X,Y: Single; F: TFont; Text: String);
var
r:TRectF;
begin
  with fdrawbmp.Canvas do
  begin
  BeginScene();
    if (Text<>'') then
     begin
      r:=TRectF.Create(PointF(X-525,Y-25),1000,10);
      //rd:=TRectF.Create(PointF(X-(B.Width/2),Y-(B.Height/2)),B.Width,B.Height);
      //DrawBitmap(B,r,rd,1);

      Font.Assign( F );
      // flip foreground and background colors
      Fill.Assign( fcstroke );
      Stroke.Assign( fcbrush );
      FillText(r,Text, False, 1, [], TTextAlign.Center );

     end;
  EndScene;
  end;
  forigbmp.Assign(fdrawbmp);
  {$IFDEF POSIX}
  InvalidateRect(fdrawrect);
  {$ENDIF}
end;

procedure TMyPaintBox.EndDrawing(startP: TPointF);
begin
  if (not fdrawing) then exit;
  pTo := PointF(startP.X,startP.Y);
  DoDraw(fdrawbmp.Canvas,false);

  fdrawing:=false;
  pFrom := PointF(-1, -1);
  pTo := PointF(-1, -1);
end;

procedure TMyPaintBox.FillColor(color: TAlphaColor);
begin
  with fdrawbmp.Canvas do
  begin
    BeginScene();
    Clear(color);
    EndScene;
  end;
end;

procedure TMyPaintBox.Resize;
//var
//  B: TBitmap;
begin
  if Assigned(fdrawbmp) then
  begin
//    B := TBitmap.Create;
//    B.Assign(fdrawbmp);
    fdrawrect := RectF(0, 0, self.Width, self.Height);
    fdrawbmp.SetSize(Trunc(self.Width),Trunc(self.Height));
    fdrawbmp.Clear(TAlphaColors.Black);
    fdrawbmp.Canvas.BeginScene();
      // switch to scale draw instead of cutting the changed space
    fdrawbmp.Canvas.DrawBitmap(forigbmp, forigbmp.BoundsF, fdrawbmp.BoundsF, 1, False);
    //  fdrawbmp.Canvas.DrawBitmap(B,B.BoundsF,B.BoundsF,1,True);
    fdrawbmp.Canvas.EndScene;
//    B.DisposeOf;
  end;
  {$IFDEF POSIX}
  InvalidateRect(fdrawrect);
  {$ENDIF}
end;

procedure TMyPaintBox.MouseLeave;
begin
  if (MouseDowned = False) then
  begin
    if (not fdrawing) then
    begin
      //StartDrawing(PointF(X, Y));
    end;
  end;
  if (MouseMoved = False) then
  begin
    {$IFDEF MSWINDOWS}
    //pTo := PointF(X, Y);
    InvalidateRect(fdrawrect);
    case ffdraw of
      TFunctionDraw.fdPen: //if (pFrom<>pTo) then
      begin
      DoDraw(fdrawbmp.Canvas,false);
        pFrom:=pTo;
      end;
    end;
    {$ENDIF}
  end;
  MouseMoved := False;
  MouseDowned := False;
  fdrawing := False;

  //EndDrawing(PointF(X, Y));
  {$IFDEF POSIX}
  InvalidateRect(fdrawrect);
  {$ENDIF}
end;

procedure TMyPaintBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  inherited;
  if (not fdrawing) then
  begin
    StartDrawing(PointF(X, Y));
  end;
  MouseDowned := True;
end;

procedure TMyPaintBox.MouseMove(Shift: TShiftState; X, Y: Single);
{$IFDEF POSIX}
var
Radius       : Single;
xDir, yDir   : Single;
Dx, Dy       : Single;
Ratio        : Single;
MoveX, MoveY : Single;
{$ENDIF}
begin
  inherited;
  if (not fdrawing) then exit;

  case ffdraw of
    TFunctionDraw.fdFillBgr: Exit;
  end;

{$IFDEF POSIX}
  Radius := fThickness / 2;
{$ENDIF}

  pTo := PointF(X, Y);
  InvalidateRect(fdrawrect);
  case ffdraw of
    TFunctionDraw.fdPen:
    begin
    {$IFDEF POSIX}
      if ( pFrom.Round <> pTo.Round ) then
        begin
         { Direction detection from pFrom to pTo }
         { to adjust start center                }

         IF pTo.Y >= pFrom.Y THEN yDir := -1 ELSE yDir := 1;
         IF pTo.X >= pFrom.X THEN xDir := -1 ELSE xDir := 1;

         { Quantify movement }

         Dx := ABS ( pTo.X - pFrom.X );
         Dy := ABS ( pTo.Y - pFrom.Y );

         IF ABS ( Dy ) > ABS ( Dx ) THEN
           Begin
                Ratio   := ABS ( Radius / Dy * Dx );
                MoveY   := Radius  * yDir;
                pFrom.Y := pFrom.Y + MoveY;
                MoveX   := Ratio   * xDir;
                pFrom.X := pFrom.X + MoveX;
           End
         ELSE
           Begin
                Ratio   := ABS ( Radius / Dx * Dy );
                MoveX   := Radius  * xDir;
                pFrom.X := pFrom.X + MoveX;
                MoveY   := Ratio   * yDir;
                pFrom.Y := pFrom.Y + MoveY;
           End;

         fdrawbmp.Canvas.BeginScene ();
            fdrawbmp.Canvas.DrawLine ( pFrom, pTo, 1, ffillBrush );
         fdrawbmp.Canvas.EndScene;

         { Direction detection end of line }
         { to adjust end of line center    }

         IF pTo.Y >= pFrom.Y THEN yDir := -1 ELSE yDir := 1;
         IF pTo.X >= pFrom.X THEN xDir := -1 ELSE xDir := 1;

         { Quantify movement }

         Dx := ABS ( pTo.X - pFrom.X );
         Dy := ABS ( pTo.Y - pFrom.Y );

         IF ABS ( Dy ) > ABS ( Dx ) THEN
           Begin
                Ratio   := ABS ( Radius / Dy * Dx );
                MoveY   := Radius * yDir;
                pFrom.Y := pTo.Y  + MoveY;
                MoveX   := Ratio  * xDir;
                pFrom.X := pTo.X  + MoveX;
           End
         ELSE
           Begin
                Ratio   := ABS ( Radius / Dx * Dy );
                MoveX   := Radius * xDir;
                pFrom.X := pTo.X  + MoveX;
                MoveY   := Ratio  * yDir;
                pFrom.Y := pTo.Y  + MoveY;
           End;
        end;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
	      DoDraw(fdrawbmp.Canvas,false);
	      pFrom:=pTo;
      {$ENDIF}
    end;
    TFunctionDraw.fdBitmapStamp: //if (pFrom<>pTo) then
    begin
      DoDraw(fdrawbmp.Canvas,false);
      pFrom:=pTo;
    end;
  end;
  MouseMoved := True;
end;

procedure TMyPaintBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if (MouseDowned = False) then
  begin
    if (not fdrawing) then
    begin
      StartDrawing(PointF(X, Y));
    end;
  end;
  if (MouseMoved = False) then
  begin
    {$IFDEF MSWINDOWS}
    pTo := PointF(X, Y);
    InvalidateRect(fdrawrect);
    case ffdraw of
      TFunctionDraw.fdPen: //if (pFrom<>pTo) then
      begin
      DoDraw(fdrawbmp.Canvas,false);
        pFrom:=pTo;
      end;
    end;
    {$ENDIF}
  end;
  MouseMoved := False;
  MouseDowned := False;

  EndDrawing(PointF(X, Y));
  {$IFDEF POSIX}
  InvalidateRect(fdrawrect);
  {$ENDIF}

end;

procedure TMyPaintBox.Paint;
begin
  inherited;
  if (csDesigning in ComponentState) then exit;
  DoDraw(self.Canvas);
end;

procedure TMyPaintBox.SaveToJPEGStream(Stream: TStream);
var
  Surf: TBitmapSurface;
  saveParams : TBitmapCodecSaveParams;
begin
  Surf := TBitmapSurface.Create;
  try
    Surf.Assign(fdrawbmp);
    saveparams.Quality:=93; // <-- always stops here with an AV error
    TBitmapCodecManager.SaveToStream(Stream, Surf, '.jpg',@saveParams);
  finally
    Surf.Free;
  end;
end;

procedure TMyPaintBox.SaveToStream(Stream: TStream);
begin
  try
    fdrawbmp.SaveToStream(Stream);
  finally
  end;
end;

procedure TMyPaintBox.SaveToFile(AFileName: String);
begin
  try
    fdrawbmp.SaveToFile(AFileName);
  finally
  end;
end;

procedure TMyPaintBox.LoadFromFile(AFileName: String);
begin
  try
    fdrawbmp.LoadFromFile(AFileName);
  finally
  end;
end;


procedure TMyPaintBox.SaveToBitmap(B: TBitmap);
begin
  try
    B.Assign(fdrawbmp);
  finally
  end;
end;

procedure TMyPaintBox.SaveToBitmap(B: TBitmap; Width, Height: Integer);
begin
	if B.Width = 0 then
  	Exit;
	if fdrawbmp <> nil then
	begin
   B.Assign(fdrawbmp.CreateThumbnail(Width,Height));
	end;
end;


procedure TMyPaintBox.LoadFromBitmap(B: TBitmap);
var
  r, rd: TRectF;
begin
  try
    if assigned(fdrawbmp) then
     begin
      r:=TRectF.Create(PointF(0,0),B.Width,B.Height);
      rd:=TRectF.Create(PointF(0,0),B.Width,B.Height);
      fdrawbmp.Canvas.BeginScene();
      fdrawbmp.Canvas.DrawBitmap(B,r,rd,1);
      fdrawbmp.Canvas.EndScene;
      InvalidateRect(fdrawrect);
     end;
  finally
  end;
end;

procedure TMyPaintBox.LoadFromStream(Stream: TStream);
begin
  fdrawbmp.LoadFromStream(Stream);
  forigbmp.Assign(fdrawbmp);
end;

procedure TMyPaintBox.SetBackgroundColor(v: TAlphaColor);
begin
  if (v=fbgColor) then exit;
  if (assigned(fcbrush)) then
    fcbrush.Free;
  fbgColor:=v;
  fcbrush:=TBrush.Create(TBrushKind.Solid,fbgColor);
end;

procedure TMyPaintBox.SetBitmapStamp(v: TBitmap);
begin
  if not assigned(v) then exit;
  if assigned(fbmpstamp) then
    fbmpstamp.Free;
  fbmpstamp:=TBitmap.Create(0,0);
  fbmpstamp.Assign(v);
end;

procedure TMyPaintBox.SetForegroundColor(v: TAlphaColor);
begin
  if v=ffgColor then exit;
  if assigned(fcstroke) then
    fcstroke.Free;

  ffgColor:=v;

  fcstroke:=TStrokeBrush.Create(TBrushKind.Solid,ffgColor);
  fcstroke.DefaultColor:=ffgColor;
  fcstroke.Thickness:=fThickness;

  {$IFDEF POSIX}
  ffillermod;
  {$ENDIF}
end;

procedure TMyPaintBox.SetNoFill(v: boolean);
begin
  if fnofill <> v then
    fnofill := v;
end;

procedure TMyPaintBox.SetThickness(v: Single);
begin
  if v = fThickness then exit;
  if assigned(fcstroke) then
    fcstroke.Free;

  fThickness := v;

  fcstroke:=TStrokeBrush.Create(TBrushKind.Solid, ffgColor);
  fcstroke.DefaultColor:=ffgColor;
  fcstroke.Thickness:=fThickness;
  fcstroke.Cap := TStrokeCap.Round;

  {$IFDEF POSIX}
  ffillermod;
  {$ENDIF}
end;

procedure TMyPaintBox.StartDrawing(startP: TPointF);
begin
  if (csDesigning in ComponentState) then exit;
  if (fDrawing) or (ffDraw = TFunctionDraw.fdNone) then exit;

  pFrom := PointF(startP.X, startP.Y);
  pTo := PointF(startP.X, startP.Y);
  fDrawing := true;
end;

{$IFDEF POSIX}
procedure TMyPaintBox.FFillerMod;
begin
  if not Assigned(ffillBrush) then
    ffillBrush := TStrokeBrush.Create(TBrushKind.Solid, ffgcolor);

  ffillBrush.Thickness := fThickness;
  ffillBrush.Cap       := TStrokeCap.Round;
  ffillBrush.Join      := TStrokeJoin.Round;
  ffillBrush.Color     := ffgcolor;
End;
{$ENDIF}


end.
