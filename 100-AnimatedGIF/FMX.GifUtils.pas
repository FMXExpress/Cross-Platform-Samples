// https://stackoverflow.com/questions/45285599/how-to-use-animated-gif-in-firemonkey
// http://www.raysoftware.cn/?p=559
unit FMX.GifUtils;

interface

uses                                                                            //connecting fmx modules
  System.Classes, System.SysUtils, System.Types, System.UITypes,
  FMX.Types, FMX.Objects, FMX.Graphics, System.Generics.Collections;

const
  alphaTransparent = $00;    //Every color in a graphic has an alpha channel value to indicate how transparent it is
  GifSignature: array [0 .. 2] of Byte = ($47, $49, $46); // GIF
  VerSignature87a: array [0 .. 2] of Byte = ($38, $37, $61); // 87a
  VerSignature89a: array [0 .. 2] of Byte = ($38, $39, $61); // 89a

  GIF_DISPOSAL_UNSPECIFIED = 0;
  GIF_DISPOSAL_LEAVE = 1;
  GIF_DISPOSAL_BACKGROUND = 2;
  GIF_DISPOSAL_PREVIOUS = 3;

type
  TGifVer = (verUnknow, ver87a, ver89a);

  TInternalColor = packed record
    case Integer of
      0:
        (

{$IFDEF BIGENDIAN}               //RGBA color space
          R, G, B, A: Byte;      //Colors
{$ELSE}
          B, G, R, A: Byte;
{$ENDIF}
        );
      1:
        (Color: TAlphaColor;
        );
  end;

{$POINTERMATH ON}

  PInternalColor = ^TInternalColor;
{$POINTERMATH OFF}

  TGifRGB = packed record
    R: Byte;
    G: Byte;
    B: Byte;
  end;

  TGIFHeader = packed record
    Signature: array [0 .. 2] of Byte; // * Header Signature (always "GIF") */
    Version: array [0 .. 2] of Byte;   // * GIF format version("87a" or "89a") */
    // Logical Screen Descriptor
    ScreenWidth: word; // * Width of Display Screen in Pixels */
    ScreenHeight: word; // * Height of Display Screen in Pixels */
    Packedbit: Byte; // * Screen and Color Map Information */
    BackgroundColor: Byte; // * Background Color Index */
    AspectRatio: Byte; // * Pixel Aspect Ratio */
  end;

  TGifImageDescriptor = packed record
    Left: word; // * X position of image on the display */
    Top: word; // * Y position of image on the display */
    Width: word; // * Width of the image in pixels */
    Height: word; // * Height of the image in pixels */
    Packedbit: Byte; // * Image and Color Table Data Information */
  end;

  TGifGraphicsControlExtension = packed record
    BlockSize: Byte;  // * Size of remaining fields (always 04h) */
    Packedbit: Byte; // * Method of graphics disposal to use */
    DelayTime: word; // * Hundredths of seconds to wait */
    ColorIndex: Byte; // * Transparent Color Index */
    Terminator: Byte; // * Block Terminator (always 0) */
  end;

  TGifReader = class;

  TPalette = TArray<TInternalColor>;

  TGifFrameItem = class;

  TGifFrameList = TObjectList<TGifFrameItem>;
  { TGifReader }

  TGifReader = class(TObject)
  protected
    FHeader: TGIFHeader;
    FPalette: TPalette;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FInterlace: Boolean;
    FBitsPerPixel: Byte;
    FBackgroundColorIndex: Byte;
    FResolution: Byte;
    FGifVer: TGifVer;

  public
    function Read(Stream: TStream; var AFrameList: TGifFrameList): Boolean;
      overload; virtual;
    function Read(FileName: string; var AFrameList: TGifFrameList): Boolean;
      overload; virtual;
    function ReadRes(Instance: THandle; ResName: string; ResType: PChar;
      var AFrameList: TGifFrameList): Boolean; overload; virtual;
    function ReadRes(Instance: THandle; ResId: Integer; ResType: PChar;
      var AFrameList: TGifFrameList): Boolean; overload; virtual;

    function Check(Stream: TStream): Boolean; overload; virtual;
    function Check(FileName: string): Boolean; overload; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Header: TGIFHeader read FHeader;
    property ScreenWidth: Integer read FScreenWidth;
    property ScreenHeight: Integer read FScreenHeight;
    property Interlace: Boolean read FInterlace;
    property BitsPerPixel: Byte read FBitsPerPixel;
    property Background: Byte read FBackgroundColorIndex;
    property Resolution: Byte read FResolution;
    property GifVer: TGifVer read FGifVer;
  end;

  TGifFrameItem = class
    FDisposalMethod: Integer;
    FPos: TPoint;
    FTime: Integer;
    FDisbitmap: TBitmap;
    fBackColor : TalphaColor;
  public
    destructor Destroy; override;
    property Bitmap : TBitmap read FDisbitmap;
  end;

TGifPlayer = class(TComponent)
  private
    FImage: TImage;
    FGifFrameList: TGifFrameList;
    FTimer: TTimer;
    FActiveFrameIndex: Integer;
    FSpeedup: Single;
    FScreenHeight: Integer;
    FScreenWidth: Integer;
    procedure SetImage(const Value: TImage);
    procedure TimerProc(Sender: TObject);
    function GetIsPlaying: Boolean;
    procedure SetActiveFrameIndex(const Value: Integer);
    procedure SetSpeedup(const Value: Single);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadFromFile(AFileName: string);
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromResById(Instance: THandle; ResId: Integer;
      ResType: PChar);
    procedure LoadFromResByName(Instance: THandle; ResName: string;
      ResType: PChar);
    procedure Play();
    procedure Pause();
    procedure stop();
    //
    property Image: TImage read FImage write SetImage;
    property IsPlaying: Boolean read GetIsPlaying;
    property Speedup: Single read FSpeedup write SetSpeedup;
    property ActiveFrameIndex: Integer read FActiveFrameIndex
      write SetActiveFrameIndex;
    property ScreenWidth: Integer read FScreenWidth;
    property ScreenHeight: Integer read FScreenHeight;
  end;

implementation

uses
  Math;

function swap16(x: UInt16): UInt16; inline;
begin
  Result := ((x and $FF) shl 8) or ((x and $FF00) shr 8);
end;

function swap32(x: UInt32): UInt32; inline;
begin
  Result := ((x and $FF) shl 24) or ((x and $FF00) shl 8) or
    ((x and $FF0000) shr 8) or ((x and $FF000000) shr 24);
end;

function LEtoN(Value: word): word; overload;
begin
  Result := swap16(Value);
end;

function LEtoN(Value: Dword): Dword; overload;
begin
  Result := swap32(Value);
end;

procedure MergeBitmap(const Source, Dest: TBitmap; SrcRect: TRect;
  DestX, DestY: Integer);
var
  I, J, MoveBytes: Integer;
  SrcData, DestData: TBitmapData;
  lpColorSrc, lpColorDst: PInternalColor;
begin

  With Dest do
  begin
    if Map(TMapAccess.Write, DestData) then
      try
        if Source.Map(TMapAccess.Read, SrcData) then
          try
            if SrcRect.Left < 0 then
            begin
              Dec(DestX, SrcRect.Left);
              SrcRect.Left := 0;
            end;
            if SrcRect.Top < 0 then
            begin
              Dec(DestY, SrcRect.Top);
              SrcRect.Top := 0;
            end;
            SrcRect.Right := Min(SrcRect.Right, Source.Width);
            SrcRect.Bottom := Min(SrcRect.Bottom, Source.Height);
            if DestX < 0 then
            begin
              Dec(SrcRect.Left, DestX);
              DestX := 0;
            end;
            if DestY < 0 then
            begin
              Dec(SrcRect.Top, DestY);
              DestY := 0;
            end;
            if DestX + SrcRect.Width > Width then
              SrcRect.Width := Width - DestX;
            if DestY + SrcRect.Height > Height then
              SrcRect.Height := Height - DestY;

            if (SrcRect.Left < SrcRect.Right) and (SrcRect.Top < SrcRect.Bottom)
            then
            begin
              MoveBytes := SrcRect.Width * SrcData.BytesPerPixel;
              for I := 0 to SrcRect.Height - 1 do
              begin
                lpColorSrc := SrcData.GetPixelAddr(SrcRect.Left,
                  SrcRect.Top + I);
                lpColorDst := DestData.GetPixelAddr(DestX, DestY + I);
                for J := 0 to SrcRect.Width - 1 do
                  if lpColorSrc[J].A <> 0 then
                  begin
                    lpColorDst[J] := lpColorSrc[J];
                  end;
              end;
            end;
          finally
            Source.Unmap(SrcData);
          end;
      finally
        Unmap(DestData);
      end;
  end;

end;

{ TGifReader }

function TGifReader.Read(FileName: string;
  var AFrameList: TGifFrameList): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := Read(fs, AFrameList);
  except

  end;
  fs.DisposeOf;
end;

function TGifReader.ReadRes(Instance: THandle; ResName: string; ResType: PChar;
  var AFrameList: TGifFrameList): Boolean;
var
  res: TResourceStream;
begin
  res := TResourceStream.Create(HInstance, ResName, ResType);
  Result := Read(res, AFrameList);
  res.DisposeOf;
end;

function TGifReader.ReadRes(Instance: THandle; ResId: Integer; ResType: PChar;
  var AFrameList: TGifFrameList): Boolean;
var
  res: TResourceStream;
begin
  res := TResourceStream.CreateFromID(HInstance, ResId, ResType);
  Result := Read(res, AFrameList);
  res.DisposeOf;
end;

function TGifReader.Read(Stream: TStream;
  var AFrameList: TGifFrameList): Boolean;
var
  LDescriptor: TGifImageDescriptor;
  LGraphicsCtrlExt: TGifGraphicsControlExtension;
  LIsTransparent: Boolean;
  LGraphCtrlExt: Boolean;
  LFrameWidth: Integer;
  LFrameHeight: Integer;
  LLocalPalette: TPalette;
  LScanLineBuf: TBytes;

  procedure ReadPalette(Stream: TStream; Size: Integer; var APalette: TPalette);
  Var
    RGBEntry: TGifRGB;
    I: Integer;
    c: TInternalColor;
  begin
    SetLength(APalette, Size);
    For I := 0 To Size - 1 Do
    Begin
      Stream.Read(RGBEntry, SizeOf(RGBEntry));
      With APalette[I] do
      begin
        R := RGBEntry.R or (RGBEntry.R shl 8);
        G := RGBEntry.G or (RGBEntry.G shl 8);
        B := RGBEntry.B or (RGBEntry.B shl 8);
        A := $FF;
      end;
    End;
  end;

  function ProcHeader: Boolean;
  var
    c: TInternalColor;
  begin
    Result := False;
    With FHeader do
    begin
      if (CompareMem(@Signature, @GifSignature, 3)) and
        (CompareMem(@Version, @VerSignature87a, 3)) or
        (CompareMem(@Version, @VerSignature89a, 3)) then
      begin
        FScreenWidth := FHeader.ScreenWidth;
        FScreenHeight := FHeader.ScreenHeight;

        FResolution := Packedbit and $70 shr 5 + 1;
        FBitsPerPixel := Packedbit and 7 + 1;
        FBackgroundColorIndex := BackgroundColor;
        if CompareMem(@Version, @VerSignature87a, 3) then
          FGifVer := ver87a
        else if CompareMem(@Version, @VerSignature89a, 3) then
          FGifVer := ver89a;
        Result := True;
      end
      else
        Raise Exception.Create('Unknown GIF image format');        //messagebox if gif wrong
    end;

  end;

  function ProcFrame: Boolean;
  var
    LineSize: Integer;
    LBackColorIndex: Integer;
  begin
    Result := False;
    With LDescriptor do
    begin
      LFrameWidth := Width;
      LFrameHeight := Height;
      FInterlace := ((Packedbit and $40) = $40);
    end;

    if LGraphCtrlExt then
    begin
      LIsTransparent := (LGraphicsCtrlExt.Packedbit and $01) <> 0;
      If LIsTransparent then
        LBackColorIndex := LGraphicsCtrlExt.ColorIndex;
    end
    else
    begin
      LIsTransparent := FBackgroundColorIndex <> 0;
      LBackColorIndex := FBackgroundColorIndex;
    end;
    LineSize := LFrameWidth * (LFrameHeight + 1);
    SetLength(LScanLineBuf, LineSize);

    If LIsTransparent then
    begin
      LLocalPalette[LBackColorIndex].A := alphaTransparent;
    end;

    Result := True;
  end;

  function ReadAndProcBlock(Stream: TStream): Byte;
  var
    Introducer, Labels, SkipByte: Byte;
  begin
    Stream.Read(Introducer, 1);
    if Introducer = $21 then
    begin
      Stream.Read(Labels, 1);
      Case Labels of
        $FE, $FF:
          // Comment Extension block or Application Extension block
          while True do
          begin
            Stream.Read(SkipByte, 1);
            if SkipByte = 0 then
              Break;
            Stream.Seek(Int64( SkipByte), soFromCurrent);
          end;
        $F9: // Graphics Control Extension block
          begin
            Stream.Read(LGraphicsCtrlExt, SizeOf(LGraphicsCtrlExt));
            LGraphCtrlExt := True;
          end;
        $01: // Plain Text Extension block
          begin
            Stream.Read(SkipByte, 1);
            Stream.Seek(Int64( SkipByte), soFromCurrent);
            while True do
            begin
              Stream.Read(SkipByte, 1);
              if SkipByte = 0 then
                Break;
              Stream.Seek(Int64( SkipByte), soFromCurrent);
            end;
          end;
      end;
    end;
    Result := Introducer;
  end;

  function ReadScanLine(Stream: TStream; AScanLine: PByte): Boolean;
  var
    OldPos, UnpackedSize, PackedSize: longint;
    I: Integer;
    Data, Bits, Code: Cardinal;
    SourcePtr: PByte;
    InCode: Cardinal;

    CodeSize: Cardinal;
    CodeMask: Cardinal;
    FreeCode: Cardinal;
    OldCode: Cardinal;
    Prefix: array [0 .. 4096] of Cardinal;
    Suffix, Stack: array [0 .. 4096] of Byte;
    StackPointer: PByte;
    Target: PByte;
    DataComp: TBytes;
    B, FInitialCodeSize, FirstChar: Byte;
    ClearCode, EOICode: word;
  begin
    DataComp := nil;
    try
      try
        Stream.Read(FInitialCodeSize, 1);
        OldPos := Stream.Position;
        PackedSize := 0;
        Repeat
          Stream.Read(B, 1);
          if B > 0 then
          begin
            Inc(PackedSize, B);
            Stream.Seek(Int64(B), soFromCurrent);
            CodeMask := (1 shl CodeSize) - 1;
          end;
        until B = 0;
        SetLength(DataComp, 2 * PackedSize);
        SourcePtr := @DataComp[0];
        Stream.Position := OldPos;
        Repeat
          Stream.Read(B, 1);
          if B > 0 then
          begin
            Stream.ReadBuffer(SourcePtr^, B);
            Inc(SourcePtr, B);
          end;
        until B = 0;

        SourcePtr := @DataComp[0];
        Target := AScanLine;
        CodeSize := FInitialCodeSize + 1;
        ClearCode := 1 shl FInitialCodeSize;
        EOICode := ClearCode + 1;
        FreeCode := ClearCode + 2;
        OldCode := 4096;
        CodeMask := (1 shl CodeSize) - 1;
        UnpackedSize := LFrameWidth * LFrameHeight;
        for I := 0 to ClearCode - 1 do
        begin
          Prefix[I] := 4096;
          Suffix[I] := I;
        end;
        StackPointer := @Stack;
        FirstChar := 0;
        Data := 0;
        Bits := 0;
        while (UnpackedSize > 0) and (PackedSize > 0) do
        begin
          Inc(Data, SourcePtr^ shl Bits);
          Inc(Bits, 8);
          while Bits >= CodeSize do
          begin
            Code := Data and CodeMask;
            Data := Data shr CodeSize;
            Dec(Bits, CodeSize);
            if Code = EOICode then
              Break;
            if Code = ClearCode then
            begin
              CodeSize := FInitialCodeSize + 1;
              CodeMask := (1 shl CodeSize) - 1;
              FreeCode := ClearCode + 2;
              OldCode := 4096;
              Continue;
            end;
            if Code > FreeCode then
              Break;
            if OldCode = 4096 then
            begin
              FirstChar := Suffix[Code];
              Target^ := FirstChar;
              Inc(Target);
              Dec(UnpackedSize);
              OldCode := Code;
              Continue;
            end;
            InCode := Code;
            if Code = FreeCode then
            begin
              StackPointer^ := FirstChar;
              Inc(StackPointer);
              Code := OldCode;
            end;
            while Code > ClearCode do
            begin
              StackPointer^ := Suffix[Code];
              Inc(StackPointer);
              Code := Prefix[Code];
            end;
            FirstChar := Suffix[Code];
            StackPointer^ := FirstChar;
            Inc(StackPointer);
            Prefix[FreeCode] := OldCode;
            Suffix[FreeCode] := FirstChar;
            if (FreeCode = CodeMask) and (CodeSize < 12) then
            begin
              Inc(CodeSize);
              CodeMask := (1 shl CodeSize) - 1;
            end;
            if FreeCode < 4096 then
              Inc(FreeCode);
            OldCode := InCode;
            repeat
              Dec(StackPointer);
              Target^ := StackPointer^;
              Inc(Target);
              Dec(UnpackedSize);
            until StackPointer = @Stack;
          end;
          Inc(SourcePtr);
          Dec(PackedSize);
        end;

      finally
        DataComp := nil;
      end;
    except

    end;
    Result := True;
  end;
  function WriteScanLine(var Img: TBitmap; AScanLine: PByte): Boolean;
  Var
    Row, Col: Integer;
    Pass, Every: Byte;
    P: PByte;
    function IsMultiple(NumberA, NumberB: Integer): Boolean;
    begin
      Result := (NumberA >= NumberB) and (NumberB > 0) and
        (NumberA mod NumberB = 0);
    end;

  var
    PLine: PInternalColor;
    Data: TBitmapData;
  begin
    Result := False;
    P := AScanLine;
    if Img.Map(TMapAccess.Write, Data) then
    begin
      try
        If FInterlace then
        begin
          For Pass := 1 to 4 do
          begin
            Case Pass of
              1:
                begin
                  Row := 0;
                  Every := 8;
                end;
              2:
                begin
                  Row := 4;
                  Every := 8;
                end;
              3:
                begin
                  Row := 2;
                  Every := 4;
                end;
              4:
                begin
                  Row := 1;
                  Every := 2;
                end;
            end;

            Repeat
              PLine := Data.GetScanline(Row);
              for Col := 0 to Img.Width - 1 do
              begin
                PLine[Col] := LLocalPalette[P^];
                Inc(P);
              end;
              Inc(Row, Every);
            until Row >= Img.Height;
          end;
        end
        else
        begin
          for Row := 0 to Img.Height - 1 do
          begin
            PLine := Data.GetScanline(Row);
            for Col := 0 to Img.Width - 1 do
            begin
              PLine[Col] := LLocalPalette[P^];
              Inc(P);
            end;
          end;
        end;
        Result := True;
      finally
        Img.Unmap(Data);
      end;
    end;
  end;

  procedure RenderFrame(const Index : integer; const aFrames : array of TGifFrameItem; const aDisplay : TBitmap);
  var
    I, First, Last: Integer;
  begin
    Last := Index;
    First := Max(0, Last);
    aDisplay.Clear(aFrames[Index].fBackColor);
    while First > 0 do
    begin
      if (fScreenWidth = aFrames[First].Bitmap.Width) and (fScreenHeight = aFrames[First].Bitmap.Height) then
      begin
        if (aFrames[First].FDisposalMethod = GIF_DISPOSAL_BACKGROUND) and (First < Last) then
          Break;
      end;
      Dec(First);
    end;

    for I := First to Last - 1 do
    begin
      case aFrames[I].FDisposalMethod of
        GIF_DISPOSAL_UNSPECIFIED,
        GIF_DISPOSAL_LEAVE:
          begin
            // Copy previous raw frame  onto screen
            MergeBitmap(aFrames[i].Bitmap, aDisplay, aFrames[i].Bitmap.Bounds,
                        aFrames[i].FPos.X, aFrames[i].FPos.Y);
          end;
        GIF_DISPOSAL_BACKGROUND:
          if (I > First) then
          begin
            // Restore background color
            aDisplay.ClearRect(TRectF.Create(aFrames[i].FPos.X, aFrames[i].FPos.Y,
                        aFrames[i].FPos.X + aFrames[i].Bitmap.Width,
                        aFrames[i].FPos.Y + aFrames[i].Bitmap.Height),
                        aFrames[i].fBackColor);
          end;
        GIF_DISPOSAL_PREVIOUS: ; // Do nothing - previous state is already on screen
      end;
    end;
    MergeBitmap(aFrames[Index].Bitmap, aDisplay, aFrames[Index].Bitmap.Bounds, aFrames[Index].FPos.X, aFrames[Index].FPos.Y);
  end;

var
  Introducer: Byte;
  ColorTableSize: Integer;
  tmp: TBitmap;
  LFrame: TGifFrameItem;
  FrameIndex: Integer;
  I: Integer;
  LBC : integer;
  LFrames : array of TGifFrameItem;
  rendered : array of TBitmap;
begin
  Result := False;
  if not Check(Stream) then
    Exit;
  AFrameList.Clear;
  FGifVer := verUnknow;
  FPalette := nil;
  LScanLineBuf := nil;
  try

    Stream.Position := 0;
    Stream.Read(FHeader, SizeOf(FHeader));

{$IFDEF BIGENDIAN}
    with FHeader do
    begin
      ScreenWidth := LEtoN(ScreenWidth);
      ScreenHeight := LEtoN(ScreenHeight);
    end;
{$ENDIF}
    if (FHeader.Packedbit and $80) = $80 then
    begin
      ColorTableSize := FHeader.Packedbit and 7 + 1;
      ReadPalette(Stream, 1 shl ColorTableSize, FPalette);
    end;
    if not ProcHeader then
      Exit;

    FrameIndex := 0;
    SetLength(LFrames, 0);
    while True do
    begin
      LLocalPalette := nil;
      Repeat
        Introducer := ReadAndProcBlock(Stream);
      until (Introducer in [$2C, $3B]);
      if Introducer = $3B then
        Break;

      Stream.Read(LDescriptor, SizeOf(LDescriptor));
{$IFDEF BIGENDIAN}
      with FDescriptor do
      begin
        Left := LEtoN(Left);
        Top := LEtoN(Top);
        Width := LEtoN(Width);
        Height := LEtoN(Height);
      end;
{$ENDIF}
      if (LDescriptor.Packedbit and $80) <> 0 then
      begin
        ColorTableSize := LDescriptor.Packedbit and 7 + 1;
        ReadPalette(Stream, 1 shl ColorTableSize, LLocalPalette);
      end
      else
      begin
        LLocalPalette := Copy(FPalette, 0, Length(FPalette));
      end;

      if not ProcFrame then
        Exit;
      LFrame := TGifFrameItem.Create;
      LFrame.FTime := 10 * LGraphicsCtrlExt.DelayTime;
      LFrame.FDisbitmap := TBitmap.Create(LFrameWidth, LFrameHeight);
      LFrame.FPos := Point(LDescriptor.Left, LDescriptor.Top);
      LFrame.FDisposalMethod := 7 and (LGraphicsCtrlExt.Packedbit shr 2);
      if not ReadScanLine(Stream, @LScanLineBuf[0]) then
        Exit;
      if not WriteScanLine(LFrame.FDisbitmap, @LScanLineBuf[0]) then
        Exit;
      if LGraphCtrlExt then
      begin
        LIsTransparent := (LGraphicsCtrlExt.Packedbit and $01) <> 0;
        If LIsTransparent then
          LBC := LGraphicsCtrlExt.ColorIndex
        else
          LBC := FBackgroundColorIndex;
      end
      else
        LBC := FBackgroundColorIndex;
      LFrame.fBackColor := LLocalPalette[LBC].Color;
      Inc(FrameIndex);
      SetLength(LFrames, FrameIndex);
      LFrames[FrameIndex - 1] := LFrame;
    end;
    SetLength(rendered, Length(LFrames));
    for I := 0 to Length(LFrames) - 1 do
    begin
      tmp := TBitmap.Create(FScreenWidth, FScreenHeight);
      RenderFrame(I, LFrames, tmp);
      rendered[i] := tmp;
    end;
    for I := 0 to Length(LFrames) - 1 do
    begin
      LFrames[i].Bitmap.Assign(rendered[i]);
      FreeAndNil(rendered[i]);
      AFrameList.Add(LFrames[i]);
    end;

    Result := True;
  finally
    LLocalPalette := nil;
    LScanLineBuf := nil;
    rendered := nil;
    LFrames := nil;
  end;
end;

function TGifReader.Check(Stream: TStream): Boolean;
var
  OldPos: Int64;
begin
  try
    OldPos := Stream.Position;
    Stream.Read(FHeader, SizeOf(FHeader));
    Result := (CompareMem(@FHeader.Signature, @GifSignature, 3)) and
      (CompareMem(@FHeader.Version, @VerSignature87a, 3)) or
      (CompareMem(@FHeader.Version, @VerSignature89a, 3));
    Stream.Position := OldPos;
  except
    Result := False;
  end;
end;

function TGifReader.Check(FileName: string): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := Check(fs);
  except

  end;
  fs.DisposeOf;
end;

constructor TGifReader.Create;
begin
  inherited Create;

end;

destructor TGifReader.Destroy;
begin

  inherited Destroy;
end;

{ TGifFrameItem }

destructor TGifFrameItem.Destroy;
begin
  if FDisbitmap <> nil then
  begin
    FDisbitmap.DisposeOf;
    FDisbitmap := nil;
  end;
  inherited Destroy;
end;

{ TGifPlayer }

constructor TGifPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGifFrameList := TGifFrameList.Create();
  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.OnTimer := TimerProc;
  FSpeedup := 1.0;
end;

destructor TGifPlayer.Destroy;
begin
  FTimer.Enabled := False;
  FGifFrameList.DisposeOf;
  FGifFrameList := nil;
  inherited Destroy;
end;

function TGifPlayer.GetIsPlaying: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TGifPlayer.LoadFromFile(AFileName: string);
var
  gr: TGifReader;
begin
  gr := TGifReader.Create;
  gr.Read(AFileName, FGifFrameList);
  FScreenWidth := gr.ScreenWidth;
  FScreenHeight := gr.ScreenHeight;
  gr.DisposeOf;
  ActiveFrameIndex := 0;
end;

procedure TGifPlayer.LoadFromResById(Instance: THandle; ResId: Integer;
  ResType: PChar);
var
  gr: TGifReader;
begin
  gr := TGifReader.Create;
  gr.ReadRes(Instance, ResId, ResType, FGifFrameList);
  FScreenWidth := gr.ScreenWidth;
  FScreenHeight := gr.ScreenHeight;
  gr.DisposeOf;
  ActiveFrameIndex := 0;
end;

procedure TGifPlayer.LoadFromResByName(Instance: THandle; ResName: string;
  ResType: PChar);
var
  gr: TGifReader;
begin
  gr := TGifReader.Create;
  gr.ReadRes(Instance, ResName, ResType, FGifFrameList);
  FScreenWidth := gr.ScreenWidth;
  FScreenHeight := gr.ScreenHeight;
  gr.DisposeOf;
  ActiveFrameIndex := 0;
end;

procedure TGifPlayer.LoadFromStream(AStream: TStream);
var
  gr: TGifReader;
begin
  gr := TGifReader.Create;
  gr.Read(AStream, FGifFrameList);
  FScreenWidth := gr.ScreenWidth;
  FScreenHeight := gr.ScreenHeight;
  gr.DisposeOf;
  ActiveFrameIndex := 0;
end;

procedure TGifPlayer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FImage then
      FImage := nil;
  end;
end;

procedure TGifPlayer.Pause;
begin
  FTimer.Enabled := False;
end;

procedure TGifPlayer.Play;
begin
  if not IsPlaying then
  begin
    ActiveFrameIndex := FActiveFrameIndex;
    FTimer.Enabled := True;
  end;
end;

procedure TGifPlayer.SetActiveFrameIndex(const Value: Integer);           //
var
  lInterval: Integer;                                                      //the interval between frames
begin
  // if (FActiveFrameIndex <> Value) then
  begin
    FActiveFrameIndex := Value;
    if (FActiveFrameIndex < 0) or (FActiveFrameIndex >= FGifFrameList.Count)
    then
      FActiveFrameIndex := -1;
    if (FActiveFrameIndex >= 0) and (FActiveFrameIndex < FGifFrameList.Count)
    then
    begin
      if FImage <> nil then
      begin
        FImage.Bitmap.Assign(FGifFrameList[FActiveFrameIndex].FDisbitmap);
      end;
      lInterval := FGifFrameList[FActiveFrameIndex].FTime;
      if lInterval = 0 then
        lInterval := 100;
      lInterval := Trunc(lInterval / FSpeedup);
      if lInterval <= 3 then
        lInterval := 3;
      FTimer.Interval := lInterval;
    end
    else
    begin
      FImage.Bitmap.SetSize(0, 0);
      FTimer.Interval := 0;
    end;
  end;
end;

procedure TGifPlayer.SetImage(const Value: TImage);     //appointment image
begin
  FImage := Value;
  if FImage <> nil then
    FImage.FreeNotification(Self);
end;

procedure TGifPlayer.SetSpeedup(const Value: Single);
begin
  if FSpeedup <> Value then
  begin
    FSpeedup := Value;
    if FSpeedup <= 0.001 then          //up speed playing gif
      FSpeedup := 0.001;
  end;
end;

procedure TGifPlayer.stop;         //stop playgif
begin
  Pause;
  FActiveFrameIndex := 0;         //frame=0
end;

procedure TGifPlayer.TimerProc(Sender: TObject);
var
  Interval: Integer;
begin
  if ([csDesigning, csDestroying, csLoading] * ComponentState) <> [] then
    Exit;
  FTimer.Enabled := False;
  if ActiveFrameIndex < (FGifFrameList.Count - 1) then
    ActiveFrameIndex := FActiveFrameIndex + 1
  else
    ActiveFrameIndex := 0;
  FTimer.Enabled := True;
end;

end.
