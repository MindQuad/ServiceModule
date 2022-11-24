PageExtension 50169 pageextension50169 extends "Job List"
{
    layout
    {
        addafter("% Invoiced")
        {
            field(Stage; Rec.Stage)
            {
                ApplicationArea = Basic;
            }
        }
    }
}

