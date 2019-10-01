program InstagramFeed;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uCircle in 'uCircle.pas' {CircleFrame: TFrame},
  uCard in 'uCard.pas' {CardFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
