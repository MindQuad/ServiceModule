tableextension 50015 tableextension50015 extends "User Setup"
{
    fields
    {
        field(50000; "Receive PO"; Boolean)
        {
        }
        field(50001; "Document Verification"; Boolean)
        {
        }
        field(90100; "Payroll Access"; Boolean)
        {
            Description = 'Added by Winspire for HR & Payroll Module';
        }
        field(90200; "Employee No"; Code[20])
        {
            Description = 'Added by Winspire for HR & Payroll Module';
            TableRelation = Employee."No.";
        }
        field(90201; "Show All Employee"; Boolean)
        {
            Description = 'Added by Winspire for HR & Payroll Module';
        }
        field(90202; "Allow Post Expense Claim"; Boolean)
        {
        }
        field(50002; "Admin User"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Admin User';
        }
        //Win593
        field(50003; "FMS Approver"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Admin User';
        } //Win593
    }
}

