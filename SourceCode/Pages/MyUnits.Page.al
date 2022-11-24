page 50038 "My Units"
{
    Caption = 'My Items';
    PageType = ListPart;
    SourceTable = 9152;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the item numbers that are displayed in the My Item Cue on the Role Center.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies a description of the item.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unit Price';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the item''s unit price.';
                }
                field(Inventory; Rec.Inventory)
                {
                    Caption = 'Inventory';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Item No.");
                RunPageMode = View;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("User ID", USERID);
    end;
}

