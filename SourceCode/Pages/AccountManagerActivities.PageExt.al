PageExtension 50253 pageextension50253 extends "Account Manager Activities"
{
    layout
    {
        addafter("OCR Completed")
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

