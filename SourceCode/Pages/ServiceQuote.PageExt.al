PageExtension 50232 pageextension50232 extends "Service Quote"
{
    layout
    {
        modify(County)
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("FMS SO"; Rec."FMS SO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FMS SO field.';
            }
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Service Item No."; Rec."Service Item No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

