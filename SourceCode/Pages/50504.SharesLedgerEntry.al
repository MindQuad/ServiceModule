page 50504 "Shares Ledger Entry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Shares Ledger Entry";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Ledger)
            {
                field("Transaction Type"; Rec."Transaction Type")
                { ApplicationArea = All; }
                field("Transaction Date"; Rec."Transaction Date")
                { ApplicationArea = All; }
                field("Share No."; Rec."Share No.")
                { ApplicationArea = All; }
                field("Shares Number from"; Rec."Shares Number from")
                { ApplicationArea = All; }
                field("Shares Number to"; Rec."Shares Number to")
                { ApplicationArea = All; }
                field("No. of Shares"; Rec."No. of Shares")
                { ApplicationArea = All; }
                field(NAV; Rec.NAV)
                { ApplicationArea = All; }
                field("Shares Value"; Rec."Shares Value")
                { ApplicationArea = All; }
            }
        }
    }
}