PageExtension 50273 pageextension50273 extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Notify On Success")
        {
            field("PDC Batch For Cash"; Rec."PDC Batch For Cash")
            {
                ApplicationArea = Basic;
            }
            field("Post Dated Check Batch"; Rec."Post Dated Check Batch")
            {
                ApplicationArea = All;
            }
            field("Post Dated Check Template"; Rec."Post Dated Check Template")
            {
                ApplicationArea = All;
            }
        }
    }
}

