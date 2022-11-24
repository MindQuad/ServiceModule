PageExtension 50165 pageextension50165 extends "Purchase List"
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
    }
}

