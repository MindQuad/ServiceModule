PageExtension 50237 pageextension50237 extends "Service Orders"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Service Orders"(Page 9318)".

    layout
    {
        modify("Ship-to Code")
        {
            Visible = false;
        }

        addafter("No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Order Time")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Service Time (Hours)")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
            field("Reference No."; Rec."Reference No.")
            {
                ApplicationArea = Basic;
            }

            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = Basic;
            }
            field("Service Report No."; Rec."Service Report No.")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Reference No."; "Assigned User ID")
        addafter(Description)
        {
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = All;
            }

            field("From Portal"; Rec."From Portal")
            {
                ApplicationArea = All;
            }
            field("Type of Ticket"; Rec."Type of Ticket")
            {
                ApplicationArea = All;
            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("W&arehouse")
        {
            action("Help Ticket Details")
            {
                ApplicationArea = Basic;
                Caption = 'Help Ticket Details';
                Image = Report2;
                RunObject = Report "Help Ticket Details";//WIn292
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Rec.SetRange("FMS SO", true);
    end;
}

