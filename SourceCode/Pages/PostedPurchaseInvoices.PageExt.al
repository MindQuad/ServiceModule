PageExtension 50179 pageextension50179 extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("No.")
        {

            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

