{
  This file is part of TScene component.
  Copyright (c) 2017 Eugene Kryukov

  The contents of this file are subject to the Mozilla Public License Version 2.0 (the "License");
  you may not use this file except in compliance with the License. You may obtain a copy of the
  License at http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
  KIND, either express or implied. See the License for the specific language governing rights and
  limitations under the License.
}

unit FMX.Scene;

{$SCOPEDENUMS ON}

interface

uses
  System.Classes, System.Math, System.SysUtils, System.Generics.Collections, System.Types, System.UITypes,
  System.Messaging, FMX.Types, FMX.Controls, FMX.Graphics, FMX.Platform;

type

  TCustomScene = class;

  TBufferedScene = class(TFMXObject, IScene, IAlignRoot, IContent)
  private class var
    FScreenService: IFMXScreenService;
  private
    [Weak] FScene: TCustomScene;
    FBuffer: TBitmap;
    FWidth: Integer;
    FHeight: Integer;
    FControls: TControlList;
    FUpdateRects: array of TRectF;
    FLastWidth, FLastHeight: single;
    FDisableAlign: Boolean;
    FScaleChangedId: Integer;
    { IScene }
    procedure AddUpdateRect(R: TRectF);
    function GetUpdateRectsCount: Integer;
    function GetUpdateRect(const Index: Integer): TRectF;
    function GetObject: TFmxObject;
    function GetCanvas: TCanvas;
    function GetSceneScale: Single;
    function LocalToScreen(P: TPointF): TPointF;
    function ScreenToLocal(P: TPointF): TPointF;
    procedure ChangeScrollingState(const AControl: TControl; const Active: Boolean);
    procedure DisableUpdating;
    procedure EnableUpdating;
    function GetStyleBook: TStyleBook;
    procedure SetStyleBook(const Value: TStyleBook);
    { IAlignRoot }
    procedure Realign;
    procedure ChildrenAlignChanged;
    { IContent }
    function GetParent: TFmxObject;
    function GetChildrenCount: Integer;
    procedure Changed;
    procedure Invalidate;
    procedure UpdateBuffer;
  protected
    procedure ScaleChangedHandler(const Sender: TObject; const Msg: System.Messaging.TMessage); virtual;
    procedure DrawTo;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    function ObjectAtPoint(P: TPointF): IControl;
  public
    constructor Create(const AScene: TCustomScene); reintroduce;
    destructor Destroy; override;
    procedure SetSize(const AWidth, AHeight: Integer);
    property Buffer: TBitmap read FBuffer;
    property Scene: TCustomScene read FScene;
  end;

  TCustomScene = class(TControl)
  private
    FScene: TBufferedScene;
  protected
    procedure Paint; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    {$IF CompilerVersion >= 32}
    procedure DoResized; override;
    {$ELSE}
    procedure Resize; override;
    {$ENDIF}
    function ObjectAtPoint(P: TPointF): IControl; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TScene = class(TCustomScene)
  published
    property Align;
    property Anchors;
    property ClipChildren;
    property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Locked;
    property Height;
    property HitTest;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    { Events }
    property OnApplyStyleLookup;
    property OnPainting;
    property OnPaint;
    property OnResize;
    {$IF CompilerVersion >= 32}
    property OnResized;
    {$ENDIF}
    { Drag and Drop events }
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    { Mouse events }
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

procedure Register;

implementation

uses
  FMX.Forms, FMX.Text;

procedure Register;
begin
  RegisterComponents('TScene', [TScene]);
end;

type
  TOpenControl = class(TControl);

{ TBufferedScene }

constructor TBufferedScene.Create(const AScene: TCustomScene);
begin
  inherited Create(nil);
  if FScreenService = nil then
    TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, FScreenService);
  FScene := AScene;
  FWidth := Round(AScene.Width);
  FHeight := Round(AScene.Height);
  FBuffer := TBitmap.Create;
  UpdateBuffer;
  FControls := TControlList.Create;
  FControls.Capacity := 10;
  FScaleChangedId := TMessageManager.DefaultManager.SubscribeToMessage(TScaleChangedMessage, ScaleChangedHandler);
end;

destructor TBufferedScene.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TScaleChangedMessage, FScaleChangedId);
  DeleteChildren;
  FreeAndNil(FControls);
  FBuffer.Free;
  inherited;
end;

procedure TBufferedScene.AddUpdateRect(R: TRectF);
begin
  if csDestroying in ComponentState then
    Exit;

  SetLength(FUpdateRects, Length(FUpdateRects) + 1);
  FUpdateRects[High(FUpdateRects)] := R;

//  FScene.Repaint;
  R.TopLeft := FScene.LocalToAbsolute(R.TopLeft);
  R.BottomRight := FScene.LocalToAbsolute(R.BottomRight);
  FScene.RepaintRect(R);
end;

procedure TBufferedScene.ChangeScrollingState(const AControl: TControl; const Active: Boolean);
begin
end;

procedure TBufferedScene.ChildrenAlignChanged;
begin

end;

procedure TBufferedScene.DisableUpdating;
begin
end;

procedure TBufferedScene.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if AObject is TControl then
  begin
    TControl(AObject).SetNewScene(Self);

    TOpenControl(AObject).RecalcOpacity;
    TOpenControl(AObject).RecalcAbsolute;
    TOpenControl(AObject).RecalcUpdateRect;
    TOpenControl(AObject).RecalcHasClipParent;
    TOpenControl(AObject).RecalcEnabled;

    FControls.Add(TControl(AObject));

    if TControl(AObject).Align = TAlignLayout.None then
      TControl(AObject).Repaint
    else
      Realign;
  end;
end;

procedure TBufferedScene.DoRemoveObject(const AObject: TFmxObject);
begin
  inherited;
  if AObject is TControl then
  begin
    if FControls <> nil  then
      FControls.Remove(TControl(AObject));
    TControl(AObject).SetNewScene(nil);
  end;
end;

procedure TBufferedScene.Invalidate;
begin
  AddUpdateRect(TRectF.Create(0, 0, FWidth, FHeight));
end;

procedure TBufferedScene.DrawTo;
var
  I, J: Integer;
  R: TRectF;
  CallOnPaint, AllowPaint: Boolean;
  Control: TControl;
begin
//  AddUpdateRects;
//    PrepareForPaint;

  if Length(FUpdateRects) > 0 then
  begin
    if FBuffer.Canvas.BeginScene(@FUpdateRects) then
    try
      FBuffer.Canvas.Clear(0);

      if FControls <> nil then
        for I := 0 to FControls.Count - 1 do
        begin
          Control := FControls[I];
          if Control.Visible or Control.ShouldTestMouseHits then
          begin
            if Control.UpdateRect.IsEmpty then
              Continue;
            AllowPaint := False;
            if Control.InPaintTo then
              AllowPaint := True;
            if not AllowPaint then
            begin
              R := UnionRect(Control.ChildrenRect, Control.UpdateRect);
              for J := 0 to High(FUpdateRects) do
                if IntersectRect(FUpdateRects[J], R) then
                begin
                  AllowPaint := True;
                  Break;
                end;
            end;
            if AllowPaint then
              TOpenControl(Control).PaintInternal;
          end;
        end;
    finally
      FBuffer.Canvas.EndScene;
    end;
    SetLength(FUpdateRects, 0);
  end;
end;

procedure TBufferedScene.EnableUpdating;
begin
end;

function TBufferedScene.GetCanvas: TCanvas;
begin
  Result := FBuffer.Canvas;
end;

function TBufferedScene.GetObject: TFmxObject;
begin
  Result := Self;
end;

function TBufferedScene.GetSceneScale: Single;
begin
  Result := FBuffer.BitmapScale;
end;

function TBufferedScene.GetStyleBook: TStyleBook;
begin
  if FScene.Scene <> nil then
    Result := FScene.Scene.StyleBook
  else
    Result := nil;
end;

function TBufferedScene.GetUpdateRect(const Index: Integer): TRectF;
begin
  Result := FUpdateRects[Index];
end;

function TBufferedScene.GetUpdateRectsCount: Integer;
begin
  Result := Length(FUpdateRects);
end;

function TBufferedScene.LocalToScreen(P: TPointF): TPointF;
begin
  Result := FScene.LocalToScreen(P);
end;

function TBufferedScene.ObjectAtPoint(P: TPointF): IControl;
var
  I: Integer;
  Control: TControl;
  NewObj: IControl;
begin
  if FControls.Count > 0 then
    for I := FControls.Count - 1 downto 0 do
    begin
      Control := FControls[I];
      if not Control.Visible then
        Continue;

      NewObj := IControl(Control).ObjectAtPoint(P);
      if NewObj <> nil then
        Exit(NewObj);
    end;

  Result := nil;
end;

procedure TBufferedScene.ScaleChangedHandler(const Sender: TObject; const Msg: System.Messaging.TMessage);
begin
  UpdateBuffer;
end;

function TBufferedScene.ScreenToLocal(P: TPointF): TPointF;
begin
  Result := FScene.ScreenToLocal(P);
end;

procedure TBufferedScene.Realign;
var
  Padding: TBounds;
begin
  Padding := TBounds.Create(TRectF.Empty);
  try
    AlignObjects(Self, Padding, FWidth, FHeight, FLastWidth, FLastHeight, FDisableAlign);
  finally
    Padding.Free;
  end;
end;

procedure TBufferedScene.UpdateBuffer;
begin
  if FScene.Scene <> nil then
    FBuffer.BitmapScale := FScene.Scene.GetSceneScale
  else
    FBuffer.BitmapScale := FScreenService.GetScreenScale;

  FBuffer.SetSize(Ceil(FWidth * FBuffer.BitmapScale), Ceil(FHeight * FBuffer.BitmapScale));
  Invalidate;
end;

procedure TBufferedScene.SetSize(const AWidth, AHeight: Integer);
begin
  if (FWidth <> AWidth) or (FHeight <> AHeight) then
  begin
    FWidth := AWidth;
    FHeight := AHeight;
    UpdateBuffer;
    Realign;
  end;
end;

procedure TBufferedScene.SetStyleBook(const Value: TStyleBook);
begin
end;

{ IContent }

function TBufferedScene.GetChildrenCount: Integer;
begin
  if Children <> nil then
    Result := Children.Count
  else
    Result := 0;
end;

procedure TBufferedScene.Changed;
begin

end;

function TBufferedScene.GetParent: TFmxObject;
begin
  Result := FScene;
end;

{ TCustomScene }

constructor TCustomScene.Create(AOwner: TComponent);
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    FScene := TBufferedScene.Create(Self);
    FScene.Parent := Self;
    FScene.Stored := False;
  end;
end;

destructor TCustomScene.Destroy;
begin
  if FScene <> nil then
    FScene.DisposeOf;
  inherited;
end;

procedure TCustomScene.DoAddObject(const AObject: TFmxObject);
begin
  if (FScene <> nil) and (AObject <> FScene) then
    FScene.AddObject(AObject)
  else
    inherited;
end;

{$IF CompilerVersion >= 32}
procedure TCustomScene.DoResized;
{$ELSE}
procedure TCustomScene.Resize;
{$ENDIF}
begin
  inherited;
  if FScene <> nil then
    FScene.SetSize(Round(Width), Round(Height));
end;

function TCustomScene.ObjectAtPoint(P: TPointF): IControl;
begin
  Result := nil;
  if FScene <> nil then
    Result := FScene.ObjectAtPoint(P);
  if Result = nil then
    Result := inherited ObjectAtPoint(P);
end;

procedure TCustomScene.Paint;
begin
  if FScene <> nil then
  begin
    FScene.DrawTo;
    Canvas.DrawBitmap(FScene.Buffer, FScene.Buffer.BoundsF, LocalRect, AbsoluteOpacity, True);
  end;
end;

end.

