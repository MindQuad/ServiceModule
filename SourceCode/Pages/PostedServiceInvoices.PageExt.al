PageExtension 50305 pageextension50305 extends "Posted Service Invoices"
{
    layout
    {
        addafter("Document Date")
        {
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
            }
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

