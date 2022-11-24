pageextension 50001 Extension_CompanyDetails extends "Company Details"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Mobile No.';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Email Address';
            }

        }
        addafter("Post Code")
        {
            field(Emirate; Rec.Emirate)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Emiates';

            }
        }
    }
}
