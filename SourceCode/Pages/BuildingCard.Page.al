page 50014 "Building Card"
{
    Caption = 'Property Card';
    PageType = Card;
    SourceTable = 50005;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Service Item Group Code"; Rec."Service Item Group Code")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    Visible = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = all;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = all;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = all;
                }
            }
            group(Details)
            {

                Caption = 'Details';
                field("Municipality No."; Rec."Municipality No.")
                {
                    ApplicationArea = all;
                }
                field("Plot No."; Rec."Plot No.")
                {
                    ApplicationArea = all;
                }
                field("Owner code"; Rec."Owner code")
                {
                    ApplicationArea = all;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = all;
                }
                field("Location Link"; Rec."Location Link")
                {
                    ApplicationArea = all;
                    Caption = 'Location';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the item''s general product posting group. It links business transactions made for this item with the general ledger to account for the value of trade with the item.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the inventory posting group. Links business transactions made for the item with an inventory account in the general ledger, to group amounts for that item type.';
                    Visible = false;
                }
            }
            group("Financial Details")
            {
                Caption = 'Financial Details';
                field("Serv. Contract Acc. Gr. Code"; Rec."Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = all;
                    Caption = 'Contract Account Group';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for this item with the general ledger, to account for VAT amounts resulting from trade with the item.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Property")
            {
                Caption = '&Property';
                Image = FixedAssets;
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(50005),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to documents to distribute costs and analyze transaction history.';
                }
                group("P&roperty")
                {
                    Caption = 'P&roperty';
                    Image = User;
                }
                action("&Picture")
                {
                    ApplicationArea = all;
                    Caption = '&Picture';
                    Image = Picture;
                    ToolTip = 'View or add a picture ';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
            }
            group(Service)

            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Ser&vice Units")
                {
                    ApplicationArea = all;
                    Caption = 'Ser&vice Units';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Items";
                    RunPageLink = "Building No." = FIELD(Code);
                    RunPageView = SORTING("Item No.");
                }
                group("S&ervice Orders")
                {
                    Caption = 'S&ervice Orders';
                    Image = "Order";
                    action("&Item Lines")
                    {
                        ApplicationArea = all;
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Service Item Lines";
                        RunPageLink = "Service Item No." = FIELD("No.");
                        RunPageView = SORTING("Service Item No.");
                    }
                    action("&Service Lines")
                    {
                        ApplicationArea = all;
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Service Line List";
                        RunPageLink = "Service Item No." = FIELD("No.");
                        RunPageView = SORTING("Service Item No.");
                    }
                }
                group("Service Shi&pments")
                {
                    Caption = 'Service Shi&pments';
                    Image = Shipment;
                    action("Item Lines")
                    {
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Posted Shpt. Item Line List";
                        RunPageLink = "Service Item No." = FIELD("No.");
                        RunPageView = SORTING("Service Item No.");
                    }
                    action("Service Lines")
                    {
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Posted Serv. Shpt. Line List";
                        RunPageLink = "Service Item No." = FIELD("No.");
                        RunPageView = SORTING("Service Item No.");
                    }
                }
                action(Contracts)
                {
                    Caption = 'Contracts';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Contract List";
                    RunPageLink = "Building No." = FIELD(Code);
                }
                separator("--")
                {
                    Caption = '';
                }


            }

        }

    }

}

