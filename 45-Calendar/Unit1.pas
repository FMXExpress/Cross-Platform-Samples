unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Calendar,
  FMX.StdCtrls, FMX.Effects, FMX.Controls.Presentation, FMX.ListBox, FMX.Styles.Objects,
  FMX.Objects, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DateUtils, Math;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    AddButton: TButton;
    BackButton: TButton;
    Calendar1: TCalendar;
    FDMemTable1: TFDMemTable;
    procedure Calendar1ApplyStyleLookup(Sender: TObject);
    procedure Calendar1DateSelected(Sender: TObject);
    procedure Calendar1Change(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateCalendar(Sender: TObject);
    procedure CleanListBox(AListBox: TListBox; AIndex: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure TForm1.CleanListBox(AListBox: TListBox; AIndex: Integer);
begin
  if AListBox.ItemByIndex(AIndex).TagObject<>nil then
    begin
      if AListBox.ItemByIndex(AIndex).TagObject is TCircle then
        begin
          TRectangle(AListBox.ItemByIndex(AIndex).TagObject).Free;
          AListBox.ItemByIndex(AIndex).TagObject := nil;
        end;
    end;
end;

procedure TForm1.UpdateCalendar(Sender: TObject);
var
  I: Integer;
  LastMonth: Integer;
  DaysInMonth: Integer;
  StartMonth: Integer;
  EndMonth: Integer;
  LB: TListBox;
  Circle: TCircle;
begin
    LB := TListBox(Calendar1.Controls.Items[0].Controls.Items[0].Controls.Items[3]);

    DaysInMonth := DaysInAMonth(YearOf(Calendar1.DateTime), MonthOfTheYear(Calendar1.DateTime));

    StartMonth := 0;
    EndMonth := 0;
    LastMonth := 1;
    for I := 0 to LB.Count - 1 do
      begin
        if LB.ItemByIndex(I).Text.ToInteger=1 then
         begin
           StartMonth := 1;
           LastMonth := Max(I,1);
         end;

        if (StartMonth=1) AND (EndMonth=0) then
          begin
            if FDMemTable1.Locate('EventDateTime',VarArrayOf([EncodeDate(YearOf(Calendar1.DateTime), MonthOfTheYear(Calendar1.DateTime), LB.ItemByIndex(I).Text.ToInteger)])) then
              begin
                if LB.ItemByIndex(I).TagObject=nil then
                  begin
                    LB.ItemByIndex(I).TagObject := TCircle.Create(LB.ItemByIndex(I));
                    Circle := TCircle(LB.ItemByIndex(I).TagObject);
                    Circle.Parent := LB.ItemByIndex(I);
                    Circle.Align := TAlignLayout.Client;
                    Circle.Fill.Kind := TBrushKind.None;
                    Circle.Stroke.Color := TAlphaColorRec.Red;
                    Circle.Stroke.Thickness := 3;
                    Circle.HitTest := False;
                    Circle.Opacity := 0.5;
                 end;
              end
            else
              begin
                CleanListBox(LB, I);
              end;
          end
        else
          begin
            CleanListBox(LB, I);
          end;

        if (StartMonth=1) AND (LB.ItemByIndex(I).Text.ToInteger=DaysInMonth) then
          begin
            EndMonth := 1;
          end;

      end;
end;

procedure TForm1.AddButtonClick(Sender: TObject);
begin
  FDMemTable1.AppendRecord([Calendar1.Date,'Calendar Record']);
  UpdateCalendar(Self);
end;

procedure TForm1.Calendar1ApplyStyleLookup(Sender: TObject);
begin
  UpdateCalendar(Self);
end;

procedure TForm1.Calendar1Change(Sender: TObject);
begin
  UpdateCalendar(Self);
end;

procedure TForm1.Calendar1DateSelected(Sender: TObject);
begin
  UpdateCalendar(Self);
end;

end.
