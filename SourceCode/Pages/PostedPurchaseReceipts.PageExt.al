PageExtension 50178 pageextension50178 extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

