PageExtension 50167 pageextension50167 extends "Resource List"
{
    layout
    {
        modify("Price/Profit Calculation")
        {
            Visible = false;
        }
        modify("Profit %")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            Visible = false;
        }

        modify("Search Name")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        addafter("Resource Group No.")
        {
            field("Job Title"; Rec."Job Title")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

