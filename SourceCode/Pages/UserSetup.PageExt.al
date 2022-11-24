PageExtension 50173 pageextension50173 extends "User Setup"
{
    layout
    {
        addafter("Service Resp. Ctr. Filter")
        {
            field("Payroll Access"; Rec."Payroll Access")
            {
                ApplicationArea = Basic;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic;
            }
            field("Employee No"; Rec."Employee No")
            {
                ApplicationArea = Basic;
            }
            field("Show All Employee"; Rec."Show All Employee")
            {
                ApplicationArea = Basic;
            }
            field("Allow Post Expense Claim"; Rec."Allow Post Expense Claim")
            {
                ApplicationArea = Basic;
            }
            field("Admin User"; Rec."Admin User")
            {
                ApplicationArea = All;
            }
        }
        addafter("Time Sheet Admin.")
        {
            field("Document Verification"; Rec."Document Verification")
            {
                ApplicationArea = Basic;
            }
        }
        addbefore("E-Mail")
        {
            // //Win593
            field("FMS Approver"; Rec."FMS Approver")
            {
                Caption = 'FMS Approver';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Admin User field.';
            }
            //Win593
        }
    }
}

