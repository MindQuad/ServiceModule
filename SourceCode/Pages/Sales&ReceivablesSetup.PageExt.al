PageExtension 50272 pageextension50272 extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Notify On Success")
        {
            field("Post Dated Check Template"; Rec."Post Dated Check Template")
            {
                ApplicationArea = Basic;
            }
            field("PDC Batch For Cash"; Rec."PDC Batch For Cash")
            {
                ApplicationArea = Basic;
            }
            field("Post Dated Check Batch"; Rec."Post Dated Check Batch")
            {
                ApplicationArea = Basic;
            }
            field("Incl. PDC in Cr. Limit Check"; Rec."Incl. PDC in Cr. Limit Check")
            {
                ApplicationArea = Basic;
            }
        }
        addlast(General)
        {
            field("Min. Own Contribution %"; Rec."Min. Own Contribution %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Min. Own Contribution % field.';
            }
            field("RDK Loan Interest %"; Rec."RDK Loan Interest %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan Interest % field.';
            }
            field("RDK Loan Account No."; Rec."RDK Loan Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RDK Loan Account No. field.';
            }
            // field("RDK Loan Document No."; Rec."RDK Loan Document No.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the RDK Loan Document No. field.';
            // }
        }
    }
}

