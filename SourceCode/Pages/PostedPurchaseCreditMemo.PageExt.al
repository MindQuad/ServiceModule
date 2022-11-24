PageExtension 50177 pageextension50177 extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Document Date")
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

