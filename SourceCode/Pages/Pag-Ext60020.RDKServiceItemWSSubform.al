pageextension 60020 "RDK Service Item WS Subform" extends "Service Item Worksheet Subform"
{
    //Win593
    layout
    {
        addbefore("Unit Price")
        {

            field("Actual Price"; Rec."Actual Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Actual Price field.';
            }
        }
        addafter("Unit Price")
        {

            field("FMS Approved"; Rec."FMS Approved")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FMS Approved field.';
            }
        }
    }
    //Win593
}