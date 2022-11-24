PageExtension 50307 pageextension50307 extends "Service Contract Quotes"
{
    Caption = 'Lease Quotes';

    layout
    {
        modify(Status)
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify(Description)
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Ship-to Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Ship-to Name")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter(Name)
        {
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Expiration Date")
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = Basic;
            }
            field("Annual Amount"; Rec."Annual Amount")
            {
                ApplicationArea = Basic;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

