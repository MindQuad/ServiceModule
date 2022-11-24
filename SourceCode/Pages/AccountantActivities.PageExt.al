PageExtension 50254 pageextension50254 extends "Accountant Activities"
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

