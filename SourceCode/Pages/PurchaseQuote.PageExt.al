PageExtension 50161 pageextension50161 extends "Purchase Quote"
{
    layout
    {

        //Unsupported feature: Property Deletion (Visible) on ""No."(Control 2)".

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

