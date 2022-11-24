PageExtension 50267 pageextension50267 extends "Customer Templ. Card"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Tenancy Type"; Rec."Tenancy Type")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Customer Price Group")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

