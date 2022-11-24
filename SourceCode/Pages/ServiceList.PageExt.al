PageExtension 50276 pageextension50276 extends "Service List"
{

    //Unsupported feature: Property Insertion (DataCaptionExpr) on ""Service List"(Page 5901)".


    //Unsupported feature: Property Insertion (CardPageID) on ""Service List"(Page 5901)".

    layout
    {
        modify("Ship-to Code")
        {
            Visible = false;
        }
        modify(Name)
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
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
            field("Service Order Type"; Rec."Service Order Type")
            {
                ApplicationArea = Basic;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Customer No.")
        {
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Service Report No."; Rec."Service Report No.")
            {
                ApplicationArea = Basic;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = Basic;
            }
            field("Contact No."; Rec."Contact No.")
            {
                ApplicationArea = Basic;
            }
            field("Work Description"; WorkDesc)
            {
                ApplicationArea = Basic;
            }
        }
        moveafter(Status; "No.")
    }

    var
        WorkDesc: Text;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    trigger OnAfterGetRecord()
    begin

        //Work Description
        CLEAR(WorkDesc);
        WorkDesc := Rec.GetWorkDescription;

    end;
}

