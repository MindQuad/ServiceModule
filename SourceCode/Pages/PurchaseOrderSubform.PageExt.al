PageExtension 50271 pageextension50271 extends "Purchase Order Subform"
{
    layout
    {
        modify("Line Amount")
        {
            ApplicationArea = All;
            Editable = false;
        }

        addafter("Unit of Measure Code")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Line No.")
        {
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

