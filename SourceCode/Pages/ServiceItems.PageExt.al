PageExtension 50239 pageextension50239 extends "Service Items"
{
    layout
    {
        modify("Ship-to Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter("Customer No.")
        {
            //Win513++
            field("Unit Purpose"; Rec."Unit Purpose")
            {
                ApplicationArea = Basic;
            }
            //Win513--
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Occupancy Status"; Rec."Occupancy Status")
            {
                ApplicationArea = Basic;
            }
            field("Service Item Group Code"; Rec."Service Item Group Code")
            {
                ApplicationArea = Basic;
            }
            field("Service Price Group Code"; Rec."Service Price Group Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("L&og")
        {
            action(Attributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic;
                Caption = 'Attributes';
                Image = Category;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Item Attribute Value Editor";
                RunPageLink = "No." = field("Item No.");
                Scope = Repeater;
                ToolTip = 'View or edit the Attributes';
            }
        }
    }
}

