table 50504 "Shares Journal Line"
{
    Caption = 'Shares Journal Line';
    // DrillDownPageID = "Customer Ledger Entries";
    // LookupPageID = "Customer Ledger Entries";

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Purchase,Sales';
            OptionMembers = "Purchase","Sales";
        }
        field(2; "Transaction Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Share No."; Code[20])
        {
            Caption = 'Share No.';
            TableRelation = Share;
        }
        field(4; "Shares Number from"; Code[20])
        {
            Caption = 'Shares number from';
        }
        field(5; "Shares Number to"; Code[20])
        {
            Caption = 'Shares number to';
        }
        field(6; "No. of Shares"; Decimal)
        {
            Caption = 'No. of Shares';
            //*WIN586 03082022*
            trigger OnValidate()
            begin
                "Shares Value" := "No. of Shares" * NAV;
            end;
            //*WIN586*

        }
        field(7; "NAV"; Decimal)
        {
            Caption = 'NAV';
            //*WIN586 03082022*
            trigger OnValidate()
            begin
                "Shares Value" := "No. of Shares" * NAV;
            end;
            //*WIN586*

        }
        field(8; "Shares Value"; Decimal)
        {
            Caption = 'Shares Value';
            Editable = false;//*WIN586 03082022*
        }
    }
    keys
    {
        key(Key1; "Transaction Type", "Share No.")
        {
            Clustered = true;
        }
    }

    procedure PostSharesEntry()
    var
        SharesLedgerEntry: Record "Shares Ledger Entry";
    begin
        SharesLedgerEntry.Init();
        SharesLedgerEntry."Transaction Type" := Rec."Transaction Type";
        SharesLedgerEntry."Transaction Date" := Rec."Transaction Date";
        SharesLedgerEntry."Share No." := Rec."Share No.";
        SharesLedgerEntry."Shares Number from" := Rec."Shares Number from";
        SharesLedgerEntry."Shares Number to" := Rec."Shares Number to";
        SharesLedgerEntry.NAV := Rec.NAV;

        if Rec."Transaction Type" = Rec."Transaction Type"::Purchase then begin
            SharesLedgerEntry."Shares Value" := Rec."Shares Value";
            SharesLedgerEntry."No. of Shares" := Rec."No. of Shares";
        end
        else begin
            SharesLedgerEntry."Shares Value" := -Rec."Shares Value";
            SharesLedgerEntry."No. of Shares" := -Rec."No. of Shares";
        end;

        SharesLedgerEntry.Insert();

        Rec.Delete();
    end;
}
