pageextension 50060 "RDK Dispatch Board" extends "Dispatch Board"
{
    layout
    {
        addafter("Service Zone Code")
        {

            field("Scheduled Date"; Rec."Scheduled Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scheduled Date field.';
            }
            field("Scheduled From Time"; Rec."Scheduled From Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scheduled From Time field.';
            }
            field("Scheduled To Time"; Rec."Scheduled To Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scheduled To Time field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}