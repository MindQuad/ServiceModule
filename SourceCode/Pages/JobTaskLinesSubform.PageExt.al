PageExtension 50286 pageextension50286 extends "Job Task Lines Subform"
{
    layout
    {
        addafter("Job Posting Group")
        {
            field("Cont. Other Posted Deduction"; Rec."Cont. Other Posted Deduction")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Amt. Rcd. Not Invoiced")
        {
            field("Service Report No."; Rec."Service Report No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

