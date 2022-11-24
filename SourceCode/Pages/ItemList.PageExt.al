PageExtension 50155 pageextension50155 extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter(Description; "Item Category Code")
    }
}

