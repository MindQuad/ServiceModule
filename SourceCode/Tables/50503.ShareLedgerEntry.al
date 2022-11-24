table 50503 "Shares Ledger Entry"
{
    Caption = 'Shares Ledger Entry';
    DrillDownPageID = "Shares Ledger Entry";
    LookupPageID = "Shares Ledger Entry";


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Share No."; Code[20])
        {
            Caption = 'Share No.';
            TableRelation = Share;
        }
        field(3; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Purchase,Sales';
            OptionMembers = "Purchase","Sales";
        }
        field(4; "Transaction Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Shares Number from"; Code[20])
        {
            Caption = 'Shares number from';
        }
        field(6; "Shares Number to"; Code[20])
        {
            Caption = 'Shares number to';
        }
        field(7; "No. of Shares"; Decimal)
        {
            Caption = 'No. of Shares';
        }
        field(8; "NAV"; Decimal)
        {
            Caption = 'NAV';
        }
        field(9; "Shares Value"; Decimal)
        {
            Caption = 'Shares Value';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.")
        {
        }
    }
}