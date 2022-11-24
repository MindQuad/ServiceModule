PageExtension 50163 pageextension50163 extends "Purchase Invoice"
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
        addafter(Status)
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

