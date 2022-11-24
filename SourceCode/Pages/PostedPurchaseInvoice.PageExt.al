PageExtension 50176 pageextension50176 extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Order No.")
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

