PageExtension 50231 pageextension50231 extends "Service Credit Memo Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Appl.-from Item Entry")
        {
            field("VAT Base Amount"; Rec."VAT Base Amount")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

