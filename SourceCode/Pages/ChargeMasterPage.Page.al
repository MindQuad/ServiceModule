page 50068 "Charge Master Page"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Charge Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account No.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Posting Allowed"; Rec."Posting Allowed")
                {
                    ApplicationArea = All;
                }
                field("Allow-to Generate PDC Entry"; Rec."Allow-to Generate PDC Entry")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

