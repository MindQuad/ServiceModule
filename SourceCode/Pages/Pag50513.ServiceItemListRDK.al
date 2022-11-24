page 50513 "Service Item List RDK"
{
    ApplicationArea = Service;
    Caption = 'Unit List';
    CardPageID = "Service Item Card";
    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Service Item";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies a description of this item.';
                }
                field("Unit Purpose"; Rec."Unit Purpose")
                {
                    ApplicationArea = Basic;
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = Basic;
                    Lookup = true;
                }
                field("Building Name"; Rec."Building Name")
                {
                    ApplicationArea = Basic;
                }
                field("Occupancy Status"; Rec."Occupancy Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Occupancy Status field.';
                }
                field("No. of Bedrooms"; Rec."No. of Bedrooms")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Bedrooms field.';
                }
                field("No. of Bathrooms"; Rec."No. of Bathrooms")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Bathrooms field.';
                }
                field("No. of Master Bedroom"; Rec."No. of Master Bedroom")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Master Bedroom field.';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Subtype; Rec.Subtype)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SubType field.';
                }
                field(Parking; Rec.Parking)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parking field.';
                }
                field(Balcony; Rec.Balcony)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balcony field.';
                }
                field(Floor; Rec.Floor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Floor field.';
                }
                field(Size; Rec.Size)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Area field.';
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Direction field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the customer who owns this item.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information.';
                }
                field("Study Room"; Rec."Study Room")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Study Room field.';
                }
                field("Store Room"; Rec."Store Room")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store Room field.';
                }
                field("Maid Room"; Rec."Maid Room")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maid Room field.';
                }
            }
        }
    }

    var
        ResourceSkill: Record "Resource Skill";
        SkilledResourceList: Page "Skilled Resource List";
}
