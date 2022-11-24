PageExtension 50262 pageextension50262 extends "Approval Entries"
{
    procedure SetfiltersSC(TableId: Integer; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetCurrentkey("Table ID", "Document Type", "Document No.");
            Rec.SetRange("Table ID", TableId);
            // SETRANGE("Document Type",DocumentType);
            if DocumentNo <> '' then
                Rec.SetRange("Document No.", DocumentNo);
            Rec.FilterGroup(0);
        end;
    end;
}

