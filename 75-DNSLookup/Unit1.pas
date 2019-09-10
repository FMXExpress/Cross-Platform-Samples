unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdDNSResolver, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ScrollBox,
  FMX.Memo;

type
  TForm1 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    IdDNSResolver1: TIdDNSResolver;
    Button1: TButton;
    Memo1: TMemo;
    Layout1: TLayout;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DNS_Perform_Query(Question: string; var Value: string): integer;
  end;
  const
    C_Break = '================================';

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Threading;

procedure TForm1.Button1Click(Sender: TObject);
var
   Back, explain : string;
   Host: String;
begin
  Host := Edit1.Text;

  TTask.Run(procedure var LIndex: Integer; begin
    for LIndex := 0 to 9 do
      begin
      if (DNS_Perform_Query(Host, Back) = 0 )then begin
             case LIndex of
                  0: //DNS.RequestedRecords := [cA];
                     explain := 'Query Result : IP address of '+Host +' : ';
                  1: //DNS.RequestedRecords := [cNS];
                     explain := 'Query Result : Name Server(s) of '+Host +' : ';
                  2: //DNS.RequestedRecords := [cName];
                     explain := 'Query Result : Alias(es) of '+Host +' : ';
                  3: //DNS.RequestedRecords := [cSOA];
                     explain := 'Query Result : SOA of '+Host +' :'+#13+#10;
                  4: //DNS.RequestedRecords := [cHINFO];
                     explain := 'Query Result : Host information of '+Host +' : '+#13+#10;
                  5: //DNS.RequestedRecords := [cTXT];
                     explain := 'Query Result : TXT info of '+Host +' : ';
                  6: //DNS.RequestedRecords := [cMX];
                     explain := 'Query Result : Mail exchange of '+Host + ' : ';
                  7: //DNS.RequestedRecords := [cMINFO];
                     explain := 'Query Result : Mail server information of '+Host +' : ';
                  8: //DNS.RequestedRecords := [cMG];
                     explain := 'Query Result : Mail group of '+Host +' : ';
                  9: //DNS.RequestedRecords := [cMR];
                     explain := 'Query Result : Mail server alias of '+Host +' : ';
             end;

             TThread.Synchronize(nil,procedure begin
                   Memo1.Lines.Add(explain + Back);
                   Memo1.Lines.Add(C_Break);
             end);
        end
      else
         begin
              case LIndex of
                  0: //DNS.RequestedRecords := [cA];
                     explain := 'Some error happened while querying A Record of '+Host;
                  1: //DNS.RequestedRecords := [cNS];
                     explain := 'Some error happened while querying NS Record of '+Host;
                  2: //DNS.RequestedRecords := [cName];
                     explain := 'Some error happened while querying Alias Record of '+Host;
                  3: //DNS.RequestedRecords := [cSOA];
                     explain := 'Some error happened while querying SOA Record of '+Host;
                  4: //DNS.RequestedRecords := [cHINFO];
                     explain := 'Some error happened while querying HINFO Record of '+Host;
                  5: //DNS.RequestedRecords := [cTXT];
                     explain := 'Some error happened while querying Text Record of '+Host;
                  6: //DNS.RequestedRecords := [cMX];
                     explain := 'Some error happened while querying Mail Exchange Record of '+Host;
                  7: //DNS.RequestedRecords := [cMINFO];
                     explain := 'Some error happened while querying Mail Info Record of '+Host;
                  8: //DNS.RequestedRecords := [cMG];
                     explain := 'Some error happened while querying Mail group Record of '+Host;
                  9: //DNS.RequestedRecords := [cMR];
                     explain := 'Some error happened while querying Mail Alias Record of '+Host;
             end;
             TThread.Synchronize(nil,procedure begin
                 Memo1.Lines.Add(explain + Back);
                 Memo1.Lines.Add(C_Break);
             end);
         end;
    end;
  end);

end;

// https://www.pasarkode.com/code-371-dns-resolver.html
function TForm1.DNS_Perform_Query(Question: string; var Value: string): integer;
var
   DNS : TIdDNSResolver;
   continue : word;
   DNS_Server: String;
   Count : integer;

   function DecodeSecToTime(Secs : Cardinal) : string;
   var
      sec, min, hour, day, temp : Cardinal;
   begin
        sec := Secs mod 60;
        temp := (Secs -sec) div 60;
        min := temp mod 60;
        temp := (temp - min) div 60;
        hour := temp mod 24;
        day := (temp - hour) div 24;

        if (day > 0) then
           Result := IntToStr(day) + 'day';
        if (hour > 0) then
           Result := Result + IntToStr(hour) + 'hour';
        if (min > 0) then
           Result := Result + IntToStr(min) + 'min';
        if (sec > 0) then
           Result := Result + IntToStr(sec) + 'sec';
   end;

   function GetDetail(RR : TResultRecord) : string;
   begin
        if (RR is TARecord) then Result := 'IP address = ' + TARecord(RR).IPAddress +#13+#10;
        if (RR is TCNRecord) then Result := 'Name Server = '+ TCNRecord(RR).HostName +#13+#10;;
        if (RR is THINFORecord) then Result := 'CPU =' +THINFORecord(RR).CPU + '; OS= ' +THINFORecord(RR).OS + #13+#10;;
        if (RR is TMINFORecord) then Result := 'Responsible Email is: ' + TMINFORecord(RR).ResponsiblePersonMailbox + #13+#10;;
        if (RR is TMXRecord) then Result := 'Mail Server is: ' + TMXRecord(RR).ExchangeServer + #13+#10;;
        if (RR is TNAMERecord) then Result := 'Name Server = ' + TNAMERecord(RR).HostName + #13+#10;;
        if (RR is TNSRecord) then Result := 'Name Server = ' + TNSRecord(RR).HostName+#13+#10;
        if (RR is TPTRRecord) then Result := 'PTR = ' + TPTRRecord(RR).HostName +#13+#10;
        if (RR is TRDATARecord) then Result := 'IP address = ' + TRDATARecord(RR).IPAddress+#13+#10;
        if (RR is TSOARecord) then begin
           Result := 'Primary Domain Server = ' + TSOARecord(RR).Primary + #13+#10;
           Result := Result + 'ResponsiblePersion mail = ' + TSOARecord(RR).ResponsiblePerson + #13+#10;
           Result := Result + 'Serial = ' + IntToStr(TSOARecord(RR).Serial) + #13+#10;
           Result := Result + 'Refresh = ' + IntToSTr(TSOARecord(RR).Refresh) + ' ('+ DecodeSecToTime(TSOARecord(RR).Refresh)+')' + #13+#10;
           Result := Result + 'Retry = ' + IntToSTr(TSOARecord(RR).Retry) + ' (' +DecodeSecToTime(TSOARecord(RR).Retry) +')'+ #13+#10;
           Result := Result + 'Expire = ' + IntToSTr(TSOARecord(RR).Expire) + ' ('+ DecodeSecToTime(TSOARecord(RR).Expire) + ')' + #13+#10;
           Result := Result + 'default TTL = ' + IntToSTr(TSOARecord(RR).MinimumTTL) + ' (' +DecodeSecToTime(TSOARecord(RR).MinimumTTL)+')';
        end;

        if (RR is TTextRecord) then Result := TTextRecord(RR).Text.Text;
   end;
begin
     DNS := TIdDNSResolver.Create(self);
     // Assign the IP address of the DNS which you want to query
     //(NSLOOKUP Command: >server 168.95.1.1)
     DNS_Server := '1.1.1.1';
     DNS.Host := DNS_Server;

     // Assign query type (NSLOOKUP Command: >set querytype=A)
     //                   (NSLOOKUP Command: >set querytype=NS), etc
     DNS.QueryType := [];
     case 0 of
          0: DNS.QueryType := [qtA];
          1: DNS.QueryType := [qtNS];
          2: DNS.QueryType := [qtName];
          3: DNS.QueryType := [qtSOA];
          4: DNS.QueryType := [qtHINFO];
          5: //DNS.QueryType := [qtTXT];
             begin
                  Memo1.Lines.Append('Because many DNS does not provide RFC 1305 TXT record, we suspend this type!');
                  Value := 'This function is suspended';
                  Result := -2;
                  exit;
             end;
          6: DNS.QueryType := [qtMX];
          7:
            begin
{                 continue := Memo1.Lines.Append('Because many DNS does not provide MINFO, will you still query MINFO record??', mtConfirmation, [mbYes, mbNo], 0);
                 if ( continue = mrYes) then
                    DNS.QueryType := [qtMINFO]
                 else
                     begin
                          Value := 'This function is suspeneded';
                          Result := Code_Suspend;
                          exit;
                     end;  }
            end;
          8: DNS.QueryType := [qtMG];
          9: DNS.QueryType := [qtMR];
     end;

     try
        //DNS.Active := True;
        DNS.WaitingTime := 6000;
        DNS.Resolve(Question);
        Value := '';

        for count := 0 to DNS.QueryResult.Count-1 do begin
            Value := Value + GetDetail(DNS.QueryResult.Items[count]);
        end;

        Result := 0;
     except
           Value := 'Error';
           Result := -1;
           //DNS.Free;
     end;
end;


end.
