PageExtension 50241 pageextension50241 extends "Service Contract Subform"
{
    layout
    {
        modify("Service Item No.")
        {
            ApplicationArea = All;
            Caption = 'Unit No.';
        }

        //Unsupported feature: Property Insertion (Visible) on ""Serial No."(Control 2)".


        //Unsupported feature: Property Insertion (Visible) on ""Item No."(Control 8)".

        modify("Line Value")
        {
            ApplicationArea = All;
            Caption = 'Line Value';
        }
        modify("Line Discount %")
        {
            ApplicationArea = All;
            Caption = 'Line Discount %';
        }
        modify("Line Discount Amount")
        {
            ApplicationArea = All;
            Caption = 'Line Discount Amount';
        }
        modify("Line Amount")
        {
            ApplicationArea = All;
            Caption = 'Line Amount';
        }

        //Unsupported feature: Property Insertion (Visible) on ""Service Period"(Control 22)".

        modify("Starting Date")
        {
            ApplicationArea = All;
            Editable = true;
        }
        modify("Contract Expiration Date")
        {
            ApplicationArea = All;
            Caption = 'Contract Expiration Date';
        }

        //Unsupported feature: Property Insertion (Visible) on ""New Line"(Control 18)".


        //Unsupported feature: Code Modification on ""Service Item No."(Control 10).OnLookup".

        //trigger "(Control 10)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ServContractMgt.LookupServItemNo(Rec);
        IF xRec.GET("Contract Type","Contract No.","Line No.") THEN;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        ServContractMgt.LookupServItemNo(Rec);
        IF xRec.GET("Contract Type","Contract No.","Line No.") THEN;
        */
        //end;
        addafter(Credited)
        {
            field(Deposit; Rec.Deposit)
            {
                ApplicationArea = Basic;
            }
            field(Commission; Rec.Commission)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("New Line")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        moveafter(Description; "Service Period")
        moveafter("Service Period"; "Starting Date")
        moveafter("Contract Expiration Date"; "Line Value")
    }
}

