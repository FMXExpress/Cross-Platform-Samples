unit wwEmailWithAttachment;
{
 // Copyright (c) 2017 by Woll2Woll Software
  //
  // Methods: wwEmail (Email with attachment for ios, android, and windows)
  //

  procedure wwEmail(
   Recipients: Array of String;
   ccRecipients: Array of String;
   bccRecipients: Array of String;
   Subject, Content,
   AttachmentPath: string;
   mimeTypeStr: string = '');

  // If you require Mapi protocol for windows instead of ole, see the firepower
  // product demos and source
  //
  // In order for this routine to compile and link for iOS, you will need to
  // add the MessageUI framework to your ios sdk
  // The steps are simple, but as follows.
  //
  // 1. Select from the IDE - Tools | Options | SDK Manager
  //
  // 2. Then for your 64 bit platform (and 32 bit if you like) do the following
  //    a) Scroll to the bottom of your Frameworks list and select the last one
  //
  //    b) Click the add button on the right to add a new library refence and
  //       then enter the following data for your entry
  //       Path on remote machine:
  //          $(SDKROOT)/System/Library/Frameworks
  //       File Mask
  //          MessageUI
  //       Path Type
  //          Leave unselected
  //
  // 3. Click the button Update Local File Cache to update your sdk
  //
  // 4. Click the OK Button to close the dialog
  //
  // Now when you compile it should not yield a link error
}
interface

{$SCOPEDENUMS ON}
uses
  System.SysUtils, System.Classes, System.Types, System.Math, System.Generics.Collections,
  System.IOUtils, System.StrUtils,
  {$ifdef mswindows}
  Comobj,
  Winapi.ShellAPI,
  Winapi.Windows,
  Winapi.ActiveX,
  System.Win.registry,
  {$endif}

  {$ifdef macos}
  Macapi.ObjectiveC, Macapi.Helpers,
  Macapi.ObjCRuntime,
  {$ifdef ios}
  iOSapi.AssetsLibrary,
  iOSapi.CocoaTypes, iOSapi.Helpers,
  FMX.Helpers.iOS, iOSapi.MediaPlayer, iOSapi.Foundation, iOSapi.UIKit, iOSapi.CoreGraphics,
  {$else}
  macAPI.CocoaTypes,
  {$endif}
  {$endif}
  System.TypInfo;

type
  TwwEmailAttachmentLocation = (Default, Cache, Files, ExternalDrive, ExternalCache);

procedure wwEmail(
   Recipients: Array of String;
   ccRecipients: Array of String;
   bccRecipients: Array of String;
   Subject, Content,
   AttachmentPath: string;
   mimeTypeStr: string = '');

implementation

{$ifdef android}
uses
   Androidapi.JNI.GraphicsContentViewText,
   Androidapi.JNI.App,
   Androidapi.JNIBridge,
   Androidapi.JNI.JavaTypes,
   Androidapi.Helpers,
   Androidapi.JNI.Net,
   Androidapi.JNI.Os,
   Androidapi.IOUtils;
{$endif}

{$region 'ios'}
{$ifdef ios}

{$IF not defined(CPUARM)}
uses
     Posix.Dlfcn;
{$ENDIF}

const
  libMessageUI = '/System/Library/Frameworks/MessageUI.framework/MessageUI';

type
  MFMessageComposeResult = NSInteger;
  MFMailComposeResult = NSInteger;
  MFMailComposeViewControllerDelegate = interface;

  MFMailComposeViewControllerClass = interface(UINavigationControllerClass)
    ['{B6292F63-0DE9-4FE7-BEF7-871D5FE75362}']
    function canSendMail: Boolean; cdecl;
  end;

  MFMailComposeViewController = interface(UINavigationController)
    ['{5AD35A29-4418-48D3-AB8A-2F114B4B0EDC}']
    function mailComposeDelegate: MFMailComposeViewControllerDelegate; cdecl;
    procedure setMailComposeDelegate(mailComposeDelegate
      : MFMailComposeViewControllerDelegate); cdecl;
    procedure setSubject(subject: NSString); cdecl;
    procedure setToRecipients(toRecipients: NSArray); cdecl;
    procedure setCcRecipients(ccRecipients: NSArray); cdecl;
    procedure setBccRecipients(bccRecipients: NSArray); cdecl;
    procedure setMessageBody(body: NSString; isHTML: Boolean); cdecl;
    procedure addAttachmentData(attachment: NSData; mimeType: NSString;
      fileName: NSString); cdecl;
  end;

  TMFMailComposeViewController = class
    (TOCGenericImport<MFMailComposeViewControllerClass,
    MFMailComposeViewController>)
  end;

  MFMailComposeViewControllerDelegate = interface(IObjectiveC)
    ['{068352EB-9182-4581-86F5-EAFCE7304E32}']
    procedure mailComposeController(controller: MFMailComposeViewController;
      didFinishWithResult: MFMailComposeResult; error: NSError); cdecl;
  end;

  { ***************************************************************************************** }
  TMFMailComposeViewControllerDelegate = class(TOCLocal,
    MFMailComposeViewControllerDelegate)
  private
    MFMailComposeViewController: MFMailComposeViewController;
  public
    constructor Create(aMFMailComposeViewController
      : MFMailComposeViewController);
    procedure mailComposeController(controller: MFMailComposeViewController;
      didFinishWithResult: MFMailComposeResult; error: NSError); cdecl;
  end;

var
  mailComposeDelegate: TMFMailComposeViewControllerDelegate;

constructor TMFMailComposeViewControllerDelegate.Create
  (aMFMailComposeViewController: MFMailComposeViewController);
begin
  inherited Create;
  MFMailComposeViewController := aMFMailComposeViewController;
end;

// /Callback function when mail completes
procedure TMFMailComposeViewControllerDelegate.mailComposeController
  (controller: MFMailComposeViewController;
  didFinishWithResult: MFMailComposeResult; error: NSError);
var
  aWindow: UIWindow;
begin
  aWindow := TiOSHelper.SharedApplication.keyWindow;
  if Assigned(aWindow) and Assigned(aWindow.rootViewController) then
    aWindow.rootViewController.dismissModalViewControllerAnimated
      (True { animated } );
  MFMailComposeViewController.release;
  MFMailComposeViewController := nil;
end;

procedure wwEmail(
   Recipients: Array of String;
   ccRecipients: Array of String;
   bccRecipients: Array of String;
   Subject, Content,
   AttachmentPath: string;
   mimeTypeStr: string = '');
var
  MailController: MFMailComposeViewController;
  attachment: NSData;
  fileName: string;
  mimeType: NSString;
  //controller: UIViewController;
  Window: UIWindow;
  nsRecipients, nsccRecipients, nsbccRecipients: NSArray;

  function ConvertStringArrayToNSArray(InArray: Array of String): NSArray;
  var
    LRecipients: Array of Pointer;
    i: integer;
  begin
    SetLength(LRecipients, length(InArray));
    for i:= low(InArray) to high(InArray) do
       LRecipients[i]:= (StrToNSStr(InArray[i]) as ILocalObject).GetObjectID;
    Result := TNSArray.Wrap(TNSArray.OCClass.arrayWithObjects(
      @LRecipients[0], Length(LRecipients)));
    MailController.setToRecipients(Result);
  end;

begin
  fileName := AttachmentPath;

  MailController := TMFMailComposeViewController.Wrap
    (TMFMailComposeViewController.Alloc.init);
  mailComposeDelegate := TMFMailComposeViewControllerDelegate.Create(MailController);
  MailController.setMailComposeDelegate(mailComposeDelegate);
  MailController.setSubject(StrToNSStr(Subject));
  MailController.setMessageBody(StrToNSStr(Content), false);

  if length(Recipients)>0 then
  begin
    nsRecipients:= ConvertStringArrayToNSArray(Recipients);
    MailController.setToRecipients(nsRecipients);
  end;

  if length(ccRecipients)>0 then
  begin
    nsccRecipients:= ConvertStringArrayToNSArray(ccRecipients);
    MailController.setCcRecipients(nsccRecipients);
  end;

  if length(bccRecipients)>0 then
  begin
    nsbccRecipients:= ConvertStringArrayToNSArray(bccRecipients);
    MailController.setBccRecipients(nsbccRecipients);
  end;

  if fileName <> '' then
  begin
    attachment := TNSData.Wrap(TNSData.Alloc.initWithContentsOfFile
      (StrToNSStr(fileName)));
    try
      if mimeTypeStr = '' then
        mimeTypeStr := 'text/plain';
      mimeType := StrToNSStr(mimeTypeStr);
      MailController.addAttachmentData(attachment, mimeType,
        StrToNSStr(TPath.GetFileName(fileName))); // shorten form
    finally
      attachment.release;
    end;
  end;

  Window := TiOSHelper.SharedApplication.keyWindow;
  if (Window <> nil) and (Window.rootViewController <> nil) then
    Window.rootViewController.presentModalViewController(MailController, True);
end;

{$IF defined(CPUARM)}
 procedure LibMessageUIFakeLoader; cdecl; external libMessageUI;
{$ELSE}

var iMessageUIModule: THandle;

initialization
iMessageUIModule := dlopen(MarshaledAString(libMessageUI), RTLD_LAZY);

finalization
dlclose(iMessageUIModule);

{$ENDIF}
{$endif}
{$endregion}

{$region 'android'}
{$ifdef android}
procedure wwEmail(Recipients: Array of String; ccRecipients: Array of String;
  bccRecipients: Array of String; subject, Content, AttachmentPath: string;
  mimeTypeStr: string = '');
var
  Intent: JIntent;
  Uri: Jnet_Uri;
  AttachmentFile: JFile;
  i: integer;
  emailAddresses: TJavaObjectArray<JString>;
  fileNameTemp: JString;
  CacheName: string;
  IntentChooser: JIntent;
  ChooserCaption: string;
begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_Send);
  Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);

  emailAddresses := TJavaObjectArray<JString>.Create(length(Recipients));
  for i := Low(Recipients) to High(Recipients) do
    emailAddresses.Items[i] := StringToJString(Recipients[i]);

  Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, emailAddresses);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Content));

  // Just filename portion for android services
  CacheName := GetExternalCacheDir + TPath.DirectorySeparatorChar +
    TPath.GetFileName(AttachmentPath);
  if FileExists(CacheName) then
    Tfile.Delete(CacheName);
  Tfile.Copy(AttachmentPath, CacheName);

  fileNameTemp := StringToJString(CacheName);
  AttachmentFile := TJFile.JavaClass.init(fileNameTemp);

  if AttachmentFile <> nil then // attachment found
  begin
    AttachmentFile.setReadable(True, false);
    Uri := TJnet_Uri.JavaClass.fromFile(AttachmentFile);
    Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM,
      TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));
  end;

  Intent.setType(StringToJString('vnd.android.cursor.dir/email'));

  ChooserCaption := 'Send To';
  IntentChooser := TJIntent.JavaClass.createChooser(Intent,
    StrToJCharSequence(ChooserCaption));
  TAndroidHelper.Activity.startActivityForResult(IntentChooser, 0);

end;
{$endif}
{$endregion}

{$region 'MSWindows'}
{$ifdef MSWINDOWS}

function Succeeded(Res: HResult): Boolean;
begin
  Result := Res and $80000000 = 0;
end;

// Want to Bypass exception so we check this without using the activex unit
function HaveActiveOleObject(const ClassName: string): boolean;
var
  ClassID: TCLSID;
  Unknown: IUnknown;
  oleresult: HResult;
begin
  ClassID := ProgIDToClassID(ClassName);
  oleResult:= GetActiveObject(ClassID, nil, Unknown);
  result:= Succeeded(oleResult);
end;

procedure DisplayMail(Address, ccAddress, bccAddress,
  Subject, Body: string; Attachment: TFileName);
var
  Outlook: OleVariant;
  Mail: Variant;
const
  olMailItem = $00000000;
begin
  if not HaveActiveOleObject('Outlook.Application') then
    Outlook := CreateOleObject('Outlook.Application')
  else
    Outlook:= GetActiveOleObject('Outlook.Application');
  Mail := Outlook.CreateItem(olMailItem);
  Mail.To := Address;
  Mail.BCC:= bccAddress;
  Mail.CC:= ccAddress;
  Mail.Subject := Subject;
  Mail.Body := Body;
  if Attachment <> '' then
    Mail.Attachments.Add(Attachment);
  Mail.Display;
end;

// Attachment seems to only work with Outlook
procedure wwEmail(Recipients: Array of String; ccRecipients: Array of String;
  bccRecipients: Array of String; subject, Content, AttachmentPath: string;
  mimeTypeStr: string = '');
var mailcommand: string;
  Recipient, ccRecipient, bccRecipient: string;

  function GetAddress(AAddresses: Array of String): string;
  var
    LAddress: string;
    Address: string;
  begin
    Address:= '';
    for LAddress in AAddresses do
    begin
      StringReplace(LAddress, ' ', '%20%', [rfReplaceAll, rfIgnoreCase]);
      if Address <> '' then
        Address := Address + ';' + LAddress
      else
        Address := LAddress;
    end;
    result:= Address;
  end;

begin
  // Later should do url encoding for recipients
  Recipient:= GetAddress(Recipients);
  ccRecipient:= GetAddress(ccRecipients);
  bccRecipient:= GetAddress(bccRecipients);

  if (AttachmentPath<>'') then
    DisplayMail(Recipient, ccRecipient, bccRecipient, Subject, Content, AttachmentPath)
  else begin
    mailcommand:= 'mailto:' + Recipient + '?Subject=' + Subject +
       '&Body=' + Content +
       '&Attachment=' + '"' + AttachmentPath + '"';

    ShellExecute(0, 'OPEN', pchar(mailcommand),
      nil, nil, sw_shownormal);
  end

end;


{$endif}
{$endregion}

{$region 'OSX'}

{$ifndef nextgen}
{$ifdef macos}
procedure wwEmail(
   Recipients: Array of String;
   ccRecipients: Array of String;
   bccRecipients: Array of String;
   Subject, Content,
   AttachmentPath: string;
   mimeTypeStr: string = '');
begin
 // Currently does nothing in osx
end;
{$endif}
{$endif}
{$endregion}

end.
