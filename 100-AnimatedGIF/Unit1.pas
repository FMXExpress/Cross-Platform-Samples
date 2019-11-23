unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.GifUtils, FMX.Objects;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FGifPlayer: TGifPlayer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
var
  LResStream: TResourceStream;
begin
  FGifPlayer := TGifPlayer.Create(Self);
  FGifPlayer.Image := Image1;

  LResStream := TResourceStream.Create(HInstance, 'image', RT_RCDATA);
  FGifPlayer.LoadFromStream(LResStream);
  LResStream.Free;

  FGifPlayer.Play;
end;

end.
