PageExtension 50175 pageextension50175 extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Promised Receipt Date")
        {
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = Basic;
            }
            field("End Date"; Rec."End Date")
            {
                ApplicationArea = Basic;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

