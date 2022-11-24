PageExtension 50300 pageextension50300 extends "Accounting Services Activities"
{
    layout
    {
        addafter("Ongoing Sales Invoices")
        {
            field("PO Received Not Invoiced"; Rec."PO Received Not Invoiced")
            {
                ApplicationArea = Basic;
                DrillDownPageID = "Purchase Order List";
            }
            field("Service Item Woksheet"; Rec."Service Item Woksheet")
            {
                ApplicationArea = Basic;
                DrillDownPageID = "Service Item Worksheet Page";
                Visible = true;
            }
        }
    }
}

