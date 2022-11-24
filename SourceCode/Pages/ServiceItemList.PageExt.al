PageExtension 50238 pageextension50238 extends "Service Item List"
{
    Caption = 'Unit List';
    layout
    {
        modify("No.")
        {
            ApplicationArea = All;
            //Unsupported feature: Property Insertion (Lookup) on ""No."(Control 39)".

            Caption = 'No.';
        }

        //Unsupported feature: Property Insertion (Lookup) on "Description(Control 22)".

        addafter(Description)
        {
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
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Caption = 'Unit Code';
            }
            field("Occupancy Status"; Rec."Occupancy Status")
            {
                ApplicationArea = Basic;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
            field(Subtype; Rec.Subtype)
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
        addafter("Item No.")
        {
            field("Unit City"; Rec."Unit City")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Installation Date")
        {
            field("Potential Rent/Year"; Rec."Potential Rent/Year")
            {
                ApplicationArea = Basic;
            }
            field("Last Vacant Date"; Rec."Last Vacant Date")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addfirst("&Service Item")
        {
            action(Attributes)
            {
                ApplicationArea = Basic;
                Caption = 'Attributes';
                Image = Category;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Item Attribute Value Editor";
                RunPageLink = "No." = field("Item No.");
                Scope = Repeater;
                ToolTip = 'View or edit the Attributes';
            }
            action(FilterByAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Filter by Attributes';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedOnly = true;
                ToolTip = 'Find items that match specific attributes.';

                trigger OnAction()
                var
                    TempFilteredItem: Record Item temporary;
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                begin
                end;
            }
            action(ClearAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Clear Attributes Filter';
                Image = RemoveFilterLines;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedOnly = true;
                ToolTip = 'Remove the filter for specific item attributes.';
            }
        }
    }
}

