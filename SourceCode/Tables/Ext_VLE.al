tableextension 50108 "VLE EXT" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "EFT Register No."; Integer)
        {
            Caption = 'EFT Register No.';
            TableRelation = "EFT Register";
        }

        field(50001; "EFT Amount Transferred"; Decimal)
        {
            Caption = 'EFT Amount Transferred';
        }
        field(50002; "EFT Bank Account No."; Code[10])
        {
            Caption = 'EFT Bank Account No.';
        }
    }

    var
        myInt: Integer;
}