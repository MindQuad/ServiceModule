PageExtension 50290 pageextension50290 extends "Interaction Log Entries"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Interaction Log Entries"(Page 5076)".

    layout
    {
        modify(Canceled)
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Attempt Failed")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Contact Company Name")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify(Evaluation)
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Cost (LCY)")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Duration (Min.)")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Salesperson Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Segment No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Campaign No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Campaign Entry No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Campaign Response")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Campaign Target")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Opportunity No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("To-do No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Interaction Language Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify(Subject)
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Contact Via")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter("Entry No.")
        {
            field("Service Order Type"; Rec."Service Order Type")
            {
                ApplicationArea = Basic;
            }
            field("Building Code"; Rec."Building Code")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit Description"; Rec."Unit Description")
            {
                ApplicationArea = Basic;
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
        }
        addafter(Date)
        {
            field("Discussion Date"; Rec."Discussion Date")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter(Control1; "Entry No.")
    }
    actions
    {

        //Unsupported feature: Property Insertion (Visible) on "Entry(Action 80)".


        //Unsupported feature: Property Insertion (Visible) on "Filter(Action 11)".


        //Unsupported feature: Property Insertion (Visible) on "ClearFilter(Action 13)".


        //Unsupported feature: Property Insertion (Visible) on ""Co&mments"(Action 83)".


        //Unsupported feature: Property Insertion (Visible) on "Functions(Action 57)".


        //Unsupported feature: Property Insertion (Visible) on ""Create &Interact"(Action 60)".


        //Unsupported feature: Property Insertion (Visible) on "CreateOpportunity(Action 15)".

    }
}

