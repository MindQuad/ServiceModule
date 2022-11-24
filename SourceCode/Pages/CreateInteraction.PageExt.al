PageExtension 50266 pageextension50266 extends "Create Interaction"
{
    layout
    {
        modify(Description)
        {
            ApplicationArea = All;
            Caption = 'Notes';

            //Unsupported feature: Property Modification (Name) on "Description(Control 27)".

        }


        moveafter("Wizard Contact Name"; Date)

        modify(Date)
        {
            ApplicationArea = Basic;
            Enabled = false;
        }
        addafter(Description)
        {
            field(AdditionalNotes; Rec.Notes)
            {
                ApplicationArea = Basic;
                Caption = 'Additional Notes';
                MultiLine = true;
            }
        }
        addafter("Language Code")
        {
            field("Discussion Date"; Rec."Discussion Date")
            {
                ApplicationArea = Basic;
            }
            field("Building Code"; Rec."Building Code")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field("Unit Description"; Rec."Unit Description")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("<Rent Amount1>"; Rec."Rent Amount")
            {
                ApplicationArea = Basic;
                Caption = '<Rent Amount1>';
                Visible = false;
            }
            field("Rent Amount"; Rec."Rent Amt")
            {
                ApplicationArea = Basic;
                Caption = 'Rent Amount';
            }
            field("Occupancy Status"; Rec."Occupancy Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Occupancy Status field.';
            }
        }
        addafter(General)
        {
            part("Service Item List RDK"; "Service Item List RDK")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        Building: Record 50005;
        Unit: Record "Service Item";
}

