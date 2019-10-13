program NewsReaderApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {DataModule1: TDataModule},
  uCard in 'uCard.pas' {CardFrame: TFrame},
  u_urlOpen in 'u_urlOpen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
