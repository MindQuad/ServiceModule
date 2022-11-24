PageExtension 50160 pageextension50160 extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Line No.")
        {
            field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }

        }
    }
}

