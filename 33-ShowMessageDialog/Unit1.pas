unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.DialogService.Async;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    SnackButton: TButton;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    procedure SnackButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.SnackButtonClick(Sender: TObject);
begin
  TDialogServiceAsync.ShowMessage('Delphi is awesome!');
end;

end.
