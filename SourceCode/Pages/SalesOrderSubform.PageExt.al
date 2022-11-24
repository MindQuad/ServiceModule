PageExtension 50159 pageextension50159 extends "Sales Order Subform"
{
    layout
    {
        addafter("Line No.")
        {
            field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

