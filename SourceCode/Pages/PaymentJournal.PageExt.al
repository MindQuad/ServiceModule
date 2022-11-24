PageExtension 50182 pageextension50182 extends "Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Check Date"; Rec."Check Date")
            {
                ApplicationArea = Basic;
            }
            field("Check No."; Rec."Check No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = Basic;
            }
            field("Check No"; Rec."Check No")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

