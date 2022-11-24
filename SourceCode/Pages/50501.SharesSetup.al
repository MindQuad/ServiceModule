page 50501 "Shares Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Shares Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
                field("G/L A/C for Shares Investment"; Rec."G/L A/C for Shares Investment")
                {
                    ApplicationArea = All;
                }
                field("Bal. A/C for Shares Investment"; Rec."Bal. A/C for Shares Investment")
                {
                    ApplicationArea = All;
                }
                field("Journal Template for Entry"; Rec."Journal Template for Entry")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch for Entry"; Rec."Journal Batch for Entry")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generate Shares Journal")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.GenerateSharesJournal();
                end;
            }
        }
    }

    var
        myInt: Integer;
}