PageExtension 50168 pageextension50168 extends "Job Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Project Manager")
        {
            field("Opportunity No."; Rec."Opportunity No.")
            {
                ApplicationArea = Basic;
            }
            field(Stage; Rec.Stage)
            {
                ApplicationArea = Basic;
            }
        }
    }
}

