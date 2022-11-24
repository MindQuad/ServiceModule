PageExtension 50174 pageextension50174 extends "G/L Entries Preview"
{
    layout
    {
        addafter("VAT Amount")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = Basic;
            }
            field("Check Date"; Rec."Check Date")
            {
                ApplicationArea = Basic;
            }
            field("Check No."; Rec."Check No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

