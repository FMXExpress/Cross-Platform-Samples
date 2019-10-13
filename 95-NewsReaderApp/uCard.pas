unit uCard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Controls.Presentation, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ImgList;

type
  TCardFrame = class(TFrame)
    Layout1: TLayout;
    FeedImage: TImage;
    Layout2: TLayout;
    MenuButton: TButton;
    ProfileCircle: TCircle;
    NameLabel: TLabel;
    Layout3: TLayout;
    BookmarkButton: TButton;
    LoveButton: TButton;
    CommentButton: TButton;
    GoButton: TButton;
    DescLabel: TLabel;
    TimeLabel: TLabel;
    DataMT: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldFillBitmapBitmap: TLinkPropertyToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkPropertyToFieldBitmap: TLinkPropertyToField;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    TitleLabel: TLabel;
    LinkPropertyToFieldText6: TLinkPropertyToField;
    LinkPropertyToFieldText5: TLinkPropertyToField;
    Rectangle1: TRectangle;
    procedure LoveButtonClick(Sender: TObject);
    procedure CommentButtonClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure BookmarkButtonClick(Sender: TObject);
    procedure CommentsLabelClick(Sender: TObject);
    procedure ProfileCircleClick(Sender: TObject);
    procedure Rectangle1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  Unit1, u_urlOpen;

procedure TCardFrame.BookmarkButtonClick(Sender: TObject);
begin
  // Bookmark
end;

procedure TCardFrame.CommentButtonClick(Sender: TObject);
begin
  // Comment
end;

procedure TCardFrame.CommentsLabelClick(Sender: TObject);
begin
  // View Comments
end;

procedure TCardFrame.GoButtonClick(Sender: TObject);
begin
  // Go
  TUrlOpen.Open(Self.TagString);
end;

procedure TCardFrame.LoveButtonClick(Sender: TObject);
begin
  // Like
end;

procedure TCardFrame.ProfileCircleClick(Sender: TObject);
begin
  // View Profile
end;

procedure TCardFrame.Rectangle1DblClick(Sender: TObject);
begin
  TUrlOpen.Open(Self.TagString);
end;

end.
