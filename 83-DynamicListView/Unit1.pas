unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.DBScope, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Button1: TButton;
    ShadowEffect1: TShadowEffect;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  FMX.TextLayout;

procedure TForm1.Button1Click(Sender: TObject);
begin
  RESTRequest1.ExecuteAsync(procedure
    begin
      // Request complete
    end,
  True,
  True,
  procedure (Sender: TObject)
    begin
      Label1.Text := 'Failed!';
    end);
end;

// Function from https://sourceforge.net/p/radstudiodemos/code/HEAD/tree/branches/RADStudio_Berlin/Object%20Pascal/Multi-Device%20Samples/User%20Interface/ListView/VariableHeightItems/
function TForm1.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TForm1.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  Drawable: TListItemText;
  Text: string;
  AvailableWidth: Single;
  TitleHeight, BodyHeight: Integer;
begin
  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;

  Drawable := TListItemText(AItem.View.FindDrawable('Title'));
  Text := Drawable.Text;

  TitleHeight := GetTextHeight(Drawable, AvailableWidth, Text);
  Drawable.Height := TitleHeight;
  Drawable.Width := AvailableWidth;

  Drawable := TListItemText(AItem.View.FindDrawable('Body'));
  Text := Drawable.Text;

  BodyHeight := GetTextHeight(Drawable, AvailableWidth, Text)+20;
  Drawable.PlaceOffset.Y := TitleHeight;
  Drawable.Height := AItem.Height;
  Drawable.Width := AvailableWidth;

  AItem.Height := TitleHeight+BodyHeight;
end;



end.
