tableextension 50005 tableextension50005 extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Apply Doc. No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Apply Doc. No." = '' THEN BEGIN
                    "Apply Entries" := FALSE;
                    "Apply to ID" := '';
                    "Apply Amount" := 0;
                    MODIFY;
                    RecPDC.RESET;
                    RecPDC.SETRANGE(RecPDC."Document No.", Rec."Apply Doc. No.");
                    IF NOT RecPDC.FINDSET THEN
                        REPEAT
                            RecPDC."App Amount" += Rec."Apply Amount";
                            RecPDC.MODIFY;
                        UNTIL RecPDC.NEXT = 0;
                    RecPDC."Remaining Amount" := RecPDC."App Amount" + RecPDC.Amount;
                    RecPDC.MODIFY;
                END;
            end;
        }
        field(50001; "Apply Entries"; Boolean)
        {
        }
        field(50002; "Apply to ID"; Code[50])
        {
        }
        field(50003; "Apply Amount"; Decimal)
        {
        }
        field(50004; "PDC Doc No."; Code[20])
        {
        }
    }

    var
        RecPDC: Record "Post Dated Check Line";
}

