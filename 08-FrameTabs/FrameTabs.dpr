program FrameTabs;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FirstFrame: TFrame},
  Unit3 in 'Unit3.pas' {SecondFrame: TFrame},
  Unit4 in 'Unit4.pas' {ThirdFrame: TFrame},
  Unit5 in 'Unit5.pas' {DataModule5: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule5, DataModule5);
  Application.Run;
end.
