PageExtension 50292 pageextension50292 extends "Opportunity Card"
{
    layout
    {
        addafter("Segment No.")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

