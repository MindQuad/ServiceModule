PageExtension 50242 pageextension50242 extends "Service Contract Quote Subform"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""Unit of Measure Code"(Control 24)".


        //Unsupported feature: Property Insertion (Visible) on ""Serial No."(Control 2)".


        //Unsupported feature: Property Insertion (Visible) on ""Item No."(Control 20)".

        modify("Line Value")
        {

            //Unsupported feature: Property Modification (Name) on ""Line Value"(Control 12)".
            ApplicationArea = All;
            Caption = 'Contract Annual Value';
        }
        modify("Line Amount")
        {
            ApplicationArea = All;
            //Unsupported feature: Property Modification (Name) on ""Line Amount"(Control 16)".

            Caption = 'Contract Annual Amount';
        }

        //Unsupported feature: Property Insertion (Visible) on ""Service Period"(Control 18)".

        addafter(Description)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Next Planned Service Date")
        {
            field("PDC amount"; Rec."PDC amount")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}

