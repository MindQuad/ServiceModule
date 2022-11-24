page 50505 "Shares Journal Line"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SaveValues = true;
    SourceTable = "Shares Journal Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = all;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = all;
                }
                field("Share No."; Rec."Share No.")
                {
                    ApplicationArea = all;
                }
                field("Shares Number from"; Rec."Shares Number from")
                {
                    ApplicationArea = all;
                }
                field("Shares Number to"; Rec."Shares Number to")
                {
                    ApplicationArea = all;
                }
                field("No. of Shares"; Rec."No. of Shares")
                {
                    ApplicationArea = all;
                }
                field(NAV; Rec.NAV)
                {
                    ApplicationArea = all;
                }
                field("Shares Value"; Rec."Shares Value")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Post")
            {
                ApplicationArea = All;
                Caption = 'Post';
                Promoted = true;
                PromotedCategory = Process;
                Image = Post;

                trigger OnAction()
                begin
                    Rec.PostSharesEntry();
                end;
            }
        }
    }
}