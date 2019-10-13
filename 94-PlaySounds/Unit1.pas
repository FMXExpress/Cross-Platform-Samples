unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, AudioManager;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    LoadButton: TButton;
    OpenDialog1: TOpenDialog;
    PlayButton: TButton;
    procedure LoadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlayButtonClick(Sender: TObject);
  private
    { Private declarations }
    FAudio: TAudioManager;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAudio.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FAudio := TAudioManager.Create;
end;

procedure TForm1.LoadButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      if TFile.Exists(OpenDialog1.FileName) then
        FAudio.AddSound(OpenDialog1.FileName);
    end;
end;

procedure TForm1.PlayButtonClick(Sender: TObject);
begin
  if FAudio.SoundsCount>0 then
    FAudio.PlaySound(FAudio.SoundsCount-1);
end;

end.
