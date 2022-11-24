PageExtension 50234 pageextension50234 extends "Purchase Agent Activities"
{
    layout
    {
        addafter(PartiallyInvoiced)
        {
            field("Released Purchase Orders"; Rec."Released Purchase Orders")
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

