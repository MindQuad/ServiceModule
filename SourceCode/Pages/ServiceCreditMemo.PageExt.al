PageExtension 50283 pageextension50283 extends "Service Credit Memo"
{
    layout
    {
        addafter("Document Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Salesperson Code")
        {
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = Basic;
            }
            field("Defferal Code"; Rec."Defferal Code")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Payment Terms Code"; "Payment Method Code")


    }
}

