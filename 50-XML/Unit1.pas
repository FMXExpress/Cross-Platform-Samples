unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.TabControl, FMX.ScrollBox,
  FMX.Memo, XML.XMLDom, XML.XMLDoc, XML.OmniXmlDom;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    Button1: TButton;
    XMLMemo: TMemo;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    DataMemo: TMemo;
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

uses
   System.IOUtils, XML.XMLIntf;


procedure TForm1.Button1Click(Sender: TObject);
var
  Doc: IXMLDocument;
  Data: IXMLNode;
  Node: IXMLNode;
  I: Integer;
begin
  DataMemo.Lines.Clear;
  XMLMemo.Lines.SaveToFile(TPath.Combine(ExtractFilePath(ParamStr(0)),'data.xml'));
  Doc := LoadXMLDocument(TPath.Combine(ExtractFilePath(ParamStr(0)),'data.xml'));
  Data := Doc.DocumentElement;
  for I := 0 to Data.ChildNodes.Count-1 do
  begin
    DataMemo.Lines.Append(I.ToString);
    Node := Data.ChildNodes[I];
    if Node.LocalName = 'delphi' then
    begin
      DataMemo.Lines.Append(' a -> ' + Node.ChildNodes['a'].Text);
      DataMemo.Lines.Append(' b -> ' + Node.ChildNodes['b'].Text);
      DataMemo.Lines.Append(' c -> ' + Node.ChildNodes['c'].Text);
    end;
  end;
end;

initialization
  DefaultDOMVendor := sOmniXmlVendor;

end.
