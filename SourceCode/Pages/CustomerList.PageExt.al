PageExtension 50150 pageextension50150 extends "Customer List"
{
    layout
    {

        //Unsupported feature: Property Modification (Name) on "Contact(Control 34)".


        modify("Responsibility Center")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Location Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter(Name)
        {
            field(Unit; Rec.Unit)
            {
                ApplicationArea = Basic;
            }
            field(Building; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
            }

            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(County; Rec.County)
            {
                ApplicationArea = Basic;
                Caption = 'Emirate';
            }
        }
        moveafter("Building Name"; "Name 2")
    }
    actions
    {

        //Unsupported feature: Property Insertion (Visible) on ""C&ontact"(Action 60)".

        addafter("C&ontact")
        {
            action(Contact)
            {
                ApplicationArea = Basic;
                Caption = 'Contact';
                Image = ContactPerson;
                Promoted = true;
                PromotedIsBig = false;
                RunObject = Page "Contact List";
                RunPageLink = "No." = field("Primary Contact No.");
            }
            action("Interaction Log Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Interaction Log Entries';
                Image = InteractionLog;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Interaction Log Entries";
                RunPageLink = "Contact No." = field("Primary Contact No.");
            }
        }
        addafter(ReportCustomerDetailedAging)
        {
            action("Aged Units Report")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Units Report';
                Image = Report2;
                RunObject = Report "Aged Units Report";
            }
            action("AU/NZ Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Units Report';
                Image = Report2;
                RunObject = Report "AU/NZ Statement";

            }
        }
    }
}

