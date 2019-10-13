unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Xml.xmldom, Xml.XMLIntf, FMX.StdCtrls, Xml.XMLDoc, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Effects,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, Xml.omnixmldom, Xml.adomxmldom, FMX.Layouts,
  System.ImageList, FMX.ImgList, FMX.Objects, FireDAC.Stan.StorageBin,
  FMX.MultiView, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.Threading, FMX.Grid.Style,
  Fmx.Bind.Grid, Data.Bind.Grid, FMX.ScrollBox, FMX.Grid, FMX.TabControl,
  FMX.Edit, Data.Bind.Controls, Fmx.Bind.Navigator;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    XMLDocument1: TXMLDocument;
    RefreshButton: TButton;
    FeedBS: TBindSourceDB;
    BindingsList1: TBindingsList;
    FeedVSB: TVertScrollBox;
    ImageList1: TImageList;
    ProfileCircle: TCircle;
    ProfileLabel: TLabel;
    MultiView1: TMultiView;
    ListView1: TListView;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    NetHTTPClient1: TNetHTTPClient;
    MenuButton: TButton;
    StringGrid1: TStringGrid;
    LinkGridToDataSourceFeedBS: TLinkGridToDataSource;
    TabControl1: TTabControl;
    FeedTab: TTabItem;
    EditTab: TTabItem;
    StateFDMemTable: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkPropertyToFieldVisible: TLinkPropertyToField;
    LinkPropertyToFieldVisible2: TLinkPropertyToField;
    DoneButton: TButton;
    LinkPropertyToFieldVisible3: TLinkPropertyToField;
    BackButton: TButton;
    LinkPropertyToFieldVisible4: TLinkPropertyToField;
    Label2: TLabel;
    NameEdit: TEdit;
    Label3: TLabel;
    URLEdit: TEdit;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    BindNavigator1: TBindNavigator;
    procedure FormCreate(Sender: TObject);
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure BackButtonClick(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure NameEditChange(Sender: TObject);
    procedure URLEditChange(Sender: TObject);
  private
    { Private declarations }
    FRanOnce: Boolean;
    FCard: Integer;
    FTasks: array of ITask;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    function MD5(const AString: String): String;
    procedure DownloadFeed(const AName, AURL: String);
    procedure ImportFeed(const AName, AFilename: String);
    procedure LoadFeeds;
  public
    { Public declarations }
    procedure RefreshFeeds;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  Unit2, uCard, FMX.Scene, Soap.XSBuiltIns, IdGlobalProtocols, System.IOUtils,
  IdHash, IdHashMessageDigest, System.StrUtils, System.DateUtils;


function TForm1.MD5(const AString: String): String;
var
  LHash: TIdHashMessageDigest5;
begin
  LHash := TIdHashMessageDigest5.Create;
  try
    Result := LHash.HashStringAsHex(AString);
  finally
    LHash.Free;
  end;
end;

procedure TForm1.NameEditChange(Sender: TObject);
begin
  TLinkObservers.ControlChanged(NameEdit);
end;

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not FRanOnce then
    begin
      FRanOnce := True;

      DataModule1.InitializeDatabase;

      RefreshFeeds;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FeedBS.DataSet := DataModule1.FDTable1;

  Application.OnIdle := AppIdle;
end;

procedure TForm1.DoneButtonClick(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(0);
end;

procedure TForm1.DownloadFeed(const AName, AURL: String);
begin
  FTasks := FTasks + [TTask.Create(procedure var LNet: TNetHTTPClient; LStream: TMemoryStream; LFileAge: TDateTime; begin
     FileAge(TPath.Combine(TPath.GetDocumentsPath,MD5(AURL) + '.xml'), LFileAge);
     if HoursBetween(LFileAge,Now)>1 then
       begin
         LNet := TNetHTTPClient.Create(nil);
         LStream := TMemoryStream.Create;
         try
           LNet.Get(AURL,LStream);
           LStream.Position := 0;
           LStream.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,MD5(AURL) + '.xml'));
         finally
           LStream.Free;
           LNet.Free;
         end;
       end;

     TThread.Synchronize(nil, procedure begin
       if TFile.Exists(TPath.Combine(TPath.GetDocumentsPath,MD5(AURL) + '.xml'))=True then
         ImportFeed(AName, TPath.Combine(TPath.GetDocumentsPath,MD5(AURL) + '.xml'));
     end);
  end)];
  FTasks[High(FTasks)].Start;
end;

procedure TForm1.RefreshButtonClick(Sender: TObject);
begin
  RefreshFeeds;
end;

procedure TForm1.RefreshFeeds;
begin

  FTasks := [];

  FDMemTable1.First;
  while not FDMemTable1.Eof do
    begin
      DownloadFeed(FDMemTable1.FieldByName('Name').AsString, FDMemTable1.FieldByName('URL').AsString);

      FDMemTable1.Next;
    end;

  TTask.Run(procedure begin
    TTask.WaitForAll(FTasks,60000);
    LoadFeeds;
  end);

end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  StateFDMemTable.Locate('Page',VarArrayOf([TabControl1.TabIndex]));
end;

procedure TForm1.URLEditChange(Sender: TObject);
begin
  TLinkObservers.ControlChanged(URLEdit);
end;

procedure TForm1.BackButtonClick(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(0);
end;

function StripHTML(AHTMLString: String): string;
var
  LBegin, LEnd, LLength: Integer;
begin

  LBegin := AHTMLString.IndexOf('<');

  while (LBegin > -1) do
    begin
      LEnd := AHTMLString.IndexOf('>');
      LLength := LEnd - LBegin + 1;
      AHTMLString := AHTMLString.Remove(LBegin, LLength);
      LBegin := AHTMLString.IndexOf('<');
    end;

  Result := AHTMLString.Replace(#10,'',[rfReplaceAll]).Substring(0,256);
end;

procedure TForm1.ImportFeed(const AName, AFilename: String);
var
LXMLDocument: TXMLDocument;
LStartItemNode: IXMLNode;
LNode: IXMLNode;
LTitle, LDesc, LLink, LAuthor, LGuid: String;
begin
  LXMLDocument := TXMLDocument.Create(Self);
  LXMLDocument.DOMVendor := XMLDocument1.DOMVendor;
  LXMLDocument.FileName := AFilename;
  LXMLDocument.Active := True;
  LStartItemNode := LXMLDocument.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item') ;
  LNode := LStartItemNode;
  repeat
    LTitle := LNode.ChildNodes['title'].Text;
    LLink := LNode.ChildNodes['link'].Text;
    LDesc := LNode.ChildNodes['description'].Text;
    LGuid := IfThen(LNode.ChildNodes['guid'].Text<>'',LNode.ChildNodes['guid'].Text,LNode.ChildNodes['link'].Text);
    if LNode.ChildNodes.FindNode('dc:creator')<>nil then
      LAuthor := LNode.ChildNodes['dc:creator'].Text
    else
      LAuthor := 'Author';

    if VarIsNull(FeedBS.DataSet.Lookup('Guid', VarArrayOf([LGuid]),'Id')) then
      FeedBS.DataSet.AppendRecord([nil,StrInternetToDateTime(LNode.ChildNodes['pubDate'].Text),LTitle,LLink,LDesc,LAuthor,LGuid,AName]);
    LNode := LNode.NextSibling;
  until LNode = nil;

  LXMLDocument.Free;
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  MultiView1.HideMaster;
  TabControl1.GotoVisibleTab(1)
end;

procedure TForm1.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if AItem.ImageIndex<>0 then AItem.ImageIndex := 2;
end;

procedure TForm1.LoadFeeds;
var
  LCard: TCardFrame;
  LStream: TStream;
  LScene: TScene;
  LColor: TAlphaColor;
begin

  FeedBS.DataSet.First;
  while not FeedBS.DataSet.Eof do
    begin

      // With TScene Buffering
      LScene := TScene.Create(Self);
      LCard := TCardFrame.Create(Self);
      LCard.Name := 'Card'+FCard.ToString;
      LCard.Align := TAlignLayout.Client;
      LCard.DataMT.DisableControls;
      LCard.DataMT.Append;

      LCard.TagString := FeedBS.DataSet.FieldByName('Link').AsWideString;

      ProfileLabel.Text := FeedBS.DataSet.FieldByName('Feed').AsWideString.SubString(0,1);
      LStream := LCard.DataMT.CreateBlobStream(LCard.DataMT.FieldByName('ProfileImage'), bmWrite);
      ProfileCircle.MakeScreenshot.SaveToStream(LStream);
      LStream.Free;

      LCard.Rectangle1.Fill.Gradient.Color := $FF00A1A1;
      TAlphaColorRec(LColor).R := Random(128);
      TAlphaColorRec(LColor).G := Random(128);
      TAlphaColorRec(LColor).B := Random(128);
      TAlphaColorRec(LColor).A := $FF;
      LCard.Rectangle1.Fill.Gradient.Color1 := LColor;

      LCard.DataMT.FieldByName('Author').AsWideString := FeedBS.DataSet.FieldByName('Author').AsWideString;
      LCard.DataMT.FieldByName('Name').AsWideString := FeedBS.DataSet.FieldByName('Feed').AsWideString;
      LCard.DataMT.FieldByName('Title').AsWideString := FeedBS.DataSet.FieldByName('Title').AsWideString;
      LCard.DataMT.FieldByName('Description').AsWideString := StripHTML(FeedBS.DataSet.FieldByName('Description').AsWideString);
      LCard.DataMT.FieldByName('Posted').AsWideString := FeedBS.DataSet.FieldByName('DateTime').AsWideString;
      LCard.DataMT.Post;
      LCard.DataMT.EnableControls;
      LScene.Height := LCard.Height;
      LCard.Parent := LScene;
      LScene.Position.Y := 999999999;
      LScene.Align := TAlignLayout.Top;
      TThread.Synchronize(nil, procedure begin
        LScene.Parent := FeedVSB;
      end);

      Inc(FCard);

      FeedBS.DataSet.Next;
    end;

end;

initialization
  Randomize;

end.
