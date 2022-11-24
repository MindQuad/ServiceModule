table 50104 "EFT Register"
{
    Caption = 'EFT Register';
    /* DrillDownPageID = 11615;
    LookupPageID = 11615; */

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "EFT Payment"; Boolean)
        {
            Caption = 'EFT Payment';
        }
        field(3; "File Created"; Date)
        {
            Caption = 'File Created';
        }
        field(4; "Total Amount (LCY)"; Decimal)
        {
            Caption = 'Total Amount (LCY)';
        }
        field(5; Time; Time)
        {
            Caption = 'Time';
        }
        field(6; "File Description"; Text[12])
        {
            Caption = 'File Description';
        }
        field(7; "Bank Account Code"; Code[20])
        {
            Caption = 'Bank Account Code';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        VendLedgerEntry.SETCURRENTKEY("EFT Register No.");
        VendLedgerEntry.SETRANGE("EFT Register No.", "No.");
        IF VendLedgerEntry.FINDFIRST THEN
            ERROR(Text11000, TABLECAPTION, FIELDCAPTION("No."), VendLedgerEntry.TABLECAPTION);
    end;

    var
        VendLedgerEntry: Record 25;
        Text11000: Label 'You cannot delete %1 %2 because there is at least one %3 associated with it.', Comment = '%1=table caption, %2=field value, %3=table caption';
}

