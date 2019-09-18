unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  IdIMAP4, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Layouts, FMX.Edit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, System.Rtti,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, System.ImageList, FMX.ImgList,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Objects, FMX.MultiView,
  Data.Bind.Controls, Fmx.Bind.Navigator;

type
  TForm1 = class(TForm)
    IdSMTP1: TIdSMTP;
    IdIMAP41: TIdIMAP4;
    TabControl1: TTabControl;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    ListView1: TListView;
    Layout1: TLayout;
    Label2: TLabel;
    ImapHostEdit: TEdit;
    Layout2: TLayout;
    Label3: TLabel;
    ImapPortEdit: TEdit;
    Layout3: TLayout;
    Label4: TLabel;
    ImapUserEdit: TEdit;
    Layout4: TLayout;
    Label5: TLabel;
    ImapPassEdit: TEdit;
    Layout5: TLayout;
    Label6: TLabel;
    VertScrollBox1: TVertScrollBox;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Label7: TLabel;
    SmtpHostEdit: TEdit;
    Layout9: TLayout;
    Label8: TLabel;
    SmtpPortEdit: TEdit;
    Layout10: TLayout;
    Label9: TLabel;
    SmtpUserEdit: TEdit;
    Layout11: TLayout;
    Label10: TLabel;
    SmtpPassEdit: TEdit;
    Layout12: TLayout;
    Label11: TLabel;
    SettingsFDMemTable: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    LinkControlToField8: TLinkControlToField;
    RefreshButton: TButton;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    EmailFDMemTable: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    StateFDMemTable: TFDMemTable;
    BindSourceDB3: TBindSourceDB;
    LinkPropertyToFieldVisible: TLinkPropertyToField;
    ImageList1: TImageList;
    VertScrollBox2: TVertScrollBox;
    Layout13: TLayout;
    Label12: TLabel;
    FromEdit: TEdit;
    Layout14: TLayout;
    Label13: TLabel;
    ToEdit: TEdit;
    Layout15: TLayout;
    Label14: TLabel;
    SubjectEdit: TEdit;
    Layout16: TLayout;
    Layout17: TLayout;
    Label16: TLabel;
    SendFromEdit: TEdit;
    Layout18: TLayout;
    Label17: TLabel;
    SendToEdit: TEdit;
    Layout19: TLayout;
    Layout20: TLayout;
    Label19: TLabel;
    SendSubjectEdit: TEdit;
    SendMemo: TMemo;
    BodyMemo: TMemo;
    LinkControlToField9: TLinkControlToField;
    LinkControlToField10: TLinkControlToField;
    LinkControlToField11: TLinkControlToField;
    LinkControlToField12: TLinkControlToField;
    BackButton: TButton;
    LinkPropertyToFieldVisible2: TLinkPropertyToField;
    NewButton: TButton;
    SendButton: TButton;
    LinkPropertyToFieldVisible3: TLinkPropertyToField;
    LinkPropertyToFieldVisible4: TLinkPropertyToField;
    MultiView1: TMultiView;
    Rectangle1: TRectangle;
    AccountCB: TComboBox;
    LinkListControlToField2: TLinkListControlToField;
    MailBoxesListView: TListView;
    MailBoxesFDMemTable: TFDMemTable;
    BindSourceDB4: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    Glyph1: TGlyph;
    BindNavigator1: TBindNavigator;
    MenuButton: TButton;
    Layout21: TLayout;
    SettingsButton: TButton;
    RefreshTimer: TTimer;
    Label15: TLabel;
    Label18: TLabel;
    ImapSSLCB: TComboBox;
    SmtpSSLCB: TComboBox;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkFillControlToField2: TLinkFillControlToField;
    IdIMAP42: TIdIMAP4;
    LoadButton: TButton;
    IdSSLIOHandlerSocketOpenSSL2: TIdSSLIOHandlerSocketOpenSSL;
    IdIMAP43: TIdIMAP4;
    IdSSLIOHandlerSocketOpenSSL3: TIdSSLIOHandlerSocketOpenSSL;
    LinkPropertyToFieldVisible5: TLinkPropertyToField;
    procedure RefreshButtonClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure BackButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AccountCBChange(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure MailBoxesListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LoadButtonClick(Sender: TObject);
    procedure SettingsFDMemTableAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
    RanOnce: Boolean;
    CancelRefresh: Boolean;
    function MD5(const AString: String): String;
  public
    { Public declarations }
    procedure ImapConnect(AIdIMAP4: TIdIMAP4);
    procedure ImapLoadMessage;
    procedure ImapLoadMessages;
    procedure ImapGetMailBoxes;
    procedure FilterByFolder;
    procedure PersistEmailAccount;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
  end;
  const
    NOT_BUSY = 0;
    BUSY = 1;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Threading, System.Math, IdText, IdMessage, IdEmailAddress, IdGlobal,
  IdHash, IdHashMessageDigest, System.IOUtils;


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

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not RanOnce then
    begin
      RanOnce := True;
      if (SettingsFDMemTable.RecordCount>0) and (ImapHostEdit.Text<>'') then
        begin
          TabControl1Change(Self);
          TTask.Run(procedure begin
            ImapGetMailBoxes;
            {TThread.Synchronize(nil, procedure begin
              RefreshTimer.Enabled := True;
            end);}
          end);
        end
      else
        begin
          TabControl1.GotoVisibleTab(0);
        end;
    end;
end;

procedure TForm1.AccountCBChange(Sender: TObject);
begin
  if (SettingsFDMemTable.RecordCount>0) and (ImapHostEdit.Text<>'') then
    begin
      TTask.Run(procedure begin
        ImapGetMailBoxes;
      end);
    end
  else
    begin
      MailBoxesFDMemTable.DisableControls;
      MailBoxesFDMemTable.EmptyDataSet;
      MailBoxesFDMemTable.EnableControls;
    end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CancelRefresh := True;
  CanClose := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle := AppIdle;
  SettingsFDMemTable.ResourceOptions.PersistentFileName := TPath.Combine(TPath.GetDocumentsPath, 'email_settings.fds');
  SettingsFDMemTable.ResourceOptions.Persistent := True;
  SettingsFDMemTable.Open;
end;

procedure TForm1.FilterByFolder;
begin
  EmailFDMemTable.DisableControls;
  EmailFDMemTable.Filtered := False;
  EmailFDMemTable.Filter := 'Folder = ' + QuotedStr(MailBoxesFDMemTable.FieldByName('Name').AsString);
  EmailFDMemTable.Filtered := True;
  EmailFDMemTable.EnableControls;
end;

procedure TForm1.PersistEmailAccount;
begin
  EmailFDMemTable.Close;
  EmailFDMemTable.ResourceOptions.PersistentFileName := TPath.Combine(TPath.GetDocumentsPath, 'email_'+MD5(ImapHostEdit.Text + ImapUserEdit.Text)+'.fds');
  EmailFDMemTable.ResourceOptions.Persistent := True;
  EmailFDMemTable.Open;
  LinkListControlToField1.Active := False;
  LinkListControlToField1.Active := True;
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TabControl1.GotoVisibleTab(2);
  if EmailFDMemTable.FieldByName('Body').AsString = '' then
    ImapLoadMessage;
end;

procedure TForm1.LoadButtonClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  TabControl1.GotoVisibleTab(1);
  TTask.Run(procedure begin
    ImapGetMailBoxes;
  end);
end;

procedure TForm1.MailBoxesListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  MultiView1.HideMaster;
  TabControl1.GotoVisibleTab(1);
  CancelRefresh := True;
  RefreshButtonClick(Self);
end;

procedure TForm1.NewButtonClick(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(3);
  SendFromEdit.Text := SmtpUserEdit.Text;
end;

procedure TForm1.BackButtonClick(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.SettingsButtonClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  TabControl1.GotoVisibleTab(0);
end;

procedure TForm1.SettingsFDMemTableAfterPost(DataSet: TDataSet);
begin
  if (DataSet.FieldByName('ImapHost').AsString<>'') and
     (DataSet.FieldByName('ImapPort').AsString<>'') and
     (DataSet.FieldByName('ImapUser').AsString<>'') and
     (DataSet.FieldByName('ImapPass').AsString<>'') then
       begin
         TThread.Synchronize(nil, procedure begin
           LoadButtonClick(Self);
         end);
       end;
end;

procedure TForm1.ImapConnect(AIdIMAP4: TIdIMAP4);
begin
  AIdIMAP4.Host := ImapHostEdit.Text;
  AIdIMAP4.Port := ImapPortEdit.Text.ToInteger;
  AIdIMAP4.Username := ImapUserEdit.Text;
  AIdIMAP4.Password := ImapPassEdit.Text;
  case ImapSSLCB.ItemIndex of
    -1, 0: AIdIMAP4.UseTLS := utNoTLSSupport;
    1: AIdIMAP4.UseTLS := utUseExplicitTLS;
    2: AIdIMAP4.UseTLS := utUseImplicitTLS;
    3: AIdIMAP4.UseTLS := utUseRequireTLS;
  end;
  AIdIMAP4.Connect;
end;

procedure TForm1.ImapGetMailBoxes;
var
LSL: TStringList;
LIndex: Integer;
begin
  if IdIMAP43.Tag=NOT_BUSY then
    begin
      IdIMAP43.Tag := BUSY;
      ImapConnect(IdIMAP43);
      try
        LSL := TStringList.Create;
        try
          if IdIMAP43.ListMailBoxes(LSL) then
          begin
            MailBoxesFDMemTable.DisableControls;
            try
              MailBoxesFDMemTable.EmptyDataSet;
              for LIndex := 0 to LSL.Count-1 do
                begin
                  MailBoxesFDMemTable.AppendRecord([LSL[LIndex]]);
                end;
            finally
              MailBoxesFDMemTable.EnableControls;
            end;
          end;
        finally
          LSL.Free;
        end;
         TThread.Synchronize(nil, procedure begin
           MailBoxesFDMemTable.Locate('Name', VarArrayOf(['Inbox']));
           LinkListControlToField3.Active := False;
           LinkListControlToField3.Active := True;
           RefreshTimer.Enabled := True;
         end);
      finally
        IdIMAP43.Disconnect;
        IdIMAP43.Tag := NOT_BUSY;
      end;
    end;
end;

procedure TForm1.ImapLoadMessage;
var
  LMessage: TIdMessage;
  LPart: String;
  LPartIndex: Integer;
begin
  if IdIMAP42.Tag=NOT_BUSY then
    begin
      IdIMAP42.Tag := BUSY;
      ImapConnect(IdIMAP42);
      try
        if IdIMAP42.SelectMailBox(MailBoxesFDMemTable.FieldByName('Name').AsString.ToUpper) then
        begin
          LMessage := TIdMessage.Create(nil);
          try
            LPart := '';
            IdIMAP42.UIDRetrieve(EmailFDMemTable.FieldByName('UID').AsString, LMessage);

            EmailFDMemTable.Edit;

            LMessage.MessageParts.CountParts;
            if LMessage.MessageParts.TextPartCount > 0 then
            begin
              for LPartIndex := 0 to LMessage.MessageParts.Count - 1 do
                if LMessage.MessageParts[LPartIndex] is TIdText then
                  LPart := LPart + TIdText(LMessage.MessageParts[LPartIndex]).Body.Text;
              EmailFDMemTable.FieldByName('Body').AsString := LPart;
            end
            else
              EmailFDMemTable.FieldByName('Body').AsString := LMessage.Body.Text;

            EmailFDMemTable.Post;
          finally
            LMessage.Free;
          end;
        end;
      finally
        IdIMAP42.Disconnect;
        IdIMAP42.Tag := NOT_BUSY;
      end;
    end;
end;

procedure TForm1.ImapLoadMessages;
var
  LIndex: Integer;
  LMessage: TIdMessage;
  LSL: TStringList;
  LUID: String;
  LFlags: TIdMessageFlagsSet;
  LFolder: String;
begin
  if IdIMAP41.Tag=NOT_BUSY then
    begin
      IdIMAP41.Tag := BUSY;
      TThread.Synchronize(nil, procedure begin
        RefreshButton.Enabled := False;
      end);

      TThread.Synchronize(nil, procedure begin
        FilterByFolder;
      end);

      ImapConnect(IdIMAP41);
      try
        LFolder := MailBoxesFDMemTable.FieldByName('Name').AsString;
        if IdIMAP41.SelectMailBox(LFolder.ToUpper) then
        begin
            for LIndex := 1 to IdIMAP41.MailBox.RecentMsgs do
            begin
              if CancelRefresh then Break;
              EmailFDMemTable.DisableControls;
              try
                LSL := TStringList.Create;
                LMessage := TIdMessage.Create(nil);
                try
                  if not CancelRefresh then IdIMAP41.GetUID(LIndex, LUID);
                  if VarIsNull(EmailFDMemTable.Lookup('UID',VarArrayOf([LUID]),'UID')) then
                    begin

                      IdIMAP41.RetrieveHeader(LIndex, LMessage);
                      IdIMAP41.RetrieveFlags(LIndex, LFlags);

                      EmailFDMemTable.Append;

                      EmailFDMemTable.FieldByName('UID').AsString := LUID;
                      EmailFDMemTable.FieldByName('DateTime').AsDateTime := LMessage.Date;

                      LMessage.FromList.FillTStrings(LSL);
                      EmailFDMemTable.FieldByName('From').AsString := LSL.Text;
                      LSL.Clear;

                      LMessage.Recipients.FillTStrings(LSL);
                      EmailFDMemTable.FieldByName('To').AsString := LSL.Text;

                      EmailFDMemTable.FieldByName('Subject').AsString := LMessage.Subject;
                      EmailFDMemTable.FieldByName('Status').AsInteger := IfThen(mfSeen in LFlags = True, 0, 1);

                      EmailFDMemTable.FieldByName('Folder').AsString := LFolder;

                      EmailFDMemTable.Post;
                    end;
                finally
                  LMessage.Free;
                  LSL.Free;
                end;

              finally
                TThread.Synchronize(nil, procedure begin
                  if not CancelRefresh then EmailFDMemTable.EnableControls;
                end);
              end;
              if CancelRefresh then
                Break;
            end;
          TThread.Synchronize(nil, procedure begin
            if not CancelRefresh then EmailFDMemTable.First;
          end);
        end;
      finally
        IdIMAP41.Disconnect;
        TThread.Synchronize(nil, procedure begin
          RefreshButton.Enabled := True;
        end);
        IdIMAP41.Tag := NOT_BUSY;
        CancelRefresh := False;
      end;
    end;
end;

procedure TForm1.RefreshButtonClick(Sender: TObject);
begin
  TTask.Run(procedure begin
    ImapLoadMessages;
  end);
end;

procedure TForm1.RefreshTimerTimer(Sender: TObject);
begin
  RefreshTimer.Enabled := False;
  TThread.Synchronize(nil, procedure begin
    if not EmailFDMemTable.Active then
      PersistEmailAccount;

    TTask.Run(procedure begin
      ImapLoadMessages;
    end);
  end);
end;

procedure TForm1.SendButtonClick(Sender: TObject);
var
LMessage: TIdMessage;
LAddress: TIdEmailAddressItem;
begin
  // send
  LMessage := TIdMessage.Create(nil);
  try
    LAddress := LMessage.Recipients.Add;
    //LAddress.Name := '';
    LAddress.Address := SendToEdit.Text;
    //LMessage.BccList.Add.Address := '';
    //LMessage.From.Name := '';
    LMessage.From.Address := SendFromEdit.Text;
    LMessage.Body.Text := SendMemo.Lines.Text;
    LMessage.Subject := SendSubjectEdit.Text;

    IdSMTP1.Host := SettingsFDMemTable.FieldByName('SmtpHost').AsString;
    IdSMTP1.Port := SettingsFDMemTable.FieldByName('SmtpPort').AsInteger;
    IdSMTP1.Username := SettingsFDMemTable.FieldByName('SmtpUser').AsString;
    IdSMTP1.Password := SettingsFDMemTable.FieldByName('SmtpPass').AsString;
    case SmtpSSLCB.ItemIndex of
      -1,0: IdSMTP1.UseTLS := utNoTLSSupport;
      1: IdSMTP1.UseTLS := utUseExplicitTLS;
      2: IdSMTP1.UseTLS := utUseImplicitTLS;
      3: IdSMTP1.UseTLS := utUseRequireTLS;
    end;
    IdSMTP1.Connect;
    try
      IdSMTP1.Send(LMessage);
    finally
      IdSMTP1.Disconnect
    end;
  finally
    LMessage.Free
  end;

  TabControl1.GotoVisibleTab(1);
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  StateFDMemTable.Locate('Page', VarArrayOf([TabControl1.TabIndex]));
end;

end.
