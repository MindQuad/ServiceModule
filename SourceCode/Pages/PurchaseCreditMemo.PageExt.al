PageExtension 50164 pageextension50164 extends "Purchase Credit Memo"
{
    layout
    {
        addafter("No.")
        {
            field(Category; Rec.Category)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Expected Receipt Date")
        {
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = Basic;
            }
            field("End Date"; Rec."End Date")
            {
                ApplicationArea = Basic;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Assigned User ID")
        {
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = Basic;
                MultiLine = true;
            }
            field(Details; Rec.Details)
            {
                ApplicationArea = Basic;
                MultiLine = true;
            }
        }
    }
}

