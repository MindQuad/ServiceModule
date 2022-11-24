PageExtension 50287 pageextension50287 extends "Job Planning Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

