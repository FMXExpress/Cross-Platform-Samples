unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.BatchMove.Text,
  FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.DataSet, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Comp.UI, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    Button1: TButton;
    FDBatchMove1: TFDBatchMove;
    FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader;
    FDBatchMoveTextWriter1: TFDBatchMoveTextWriter;
    SaveDialog1: TSaveDialog;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  RESTRequest1.ExecuteAsync(
    procedure
      begin
        Label1.Text := 'Complete!';
        SaveDialog1.InitialDir := ExtractFilePath(ParamStr(0));
        if SaveDialog1.Execute then
          begin
            FDBatchMoveTextWriter1.FileName := SaveDialog1.FileName;
            FDBatchMove1.Execute;
            Memo1.Lines.LoadFromFile(FDBatchMoveTextWriter1.FileName);
          end;
      end,
    True,
    True,
    procedure (Sender: TObject)
      begin
        Label1.Text := 'Error!';
      end);
end;

end.
