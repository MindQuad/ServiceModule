PageExtension 50181 pageextension50181 extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = Basic;
            }
            field("Check Date"; Rec."Check Date")
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

