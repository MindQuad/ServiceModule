page 60115 "Building List"
{
    Caption = 'Properties List';
    CardPageID = "Building Card";
    // DataCaptionFields = "Code", Description;
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = Building;
    SourceTableView = SORTING(Code)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Importance = Promoted;
                    Lookup = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Importance = Promoted;
                    Lookup = true;
                    ApplicationArea = All;
                }
                field("Service Item Group Code"; Rec."Service Item Group Code")
                {
                    Caption = 'Category';
                }
                field(Units; Rec.Units)
                {
                }
                field("Sales Units"; Rec."Sales Units")
                {
                }
                field("Active Contracts"; Rec."Active Contracts")
                {
                    Importance = Promoted;
                }
                field("Inactive Contracts"; Rec."Inactive Contracts")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(County; Rec.County)
                {
                }
                field(City; Rec.City)
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
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
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                group("S&ervice Orders")
                {
                    Caption = 'S&ervice Orders';
                    Image = "Order";
                    action("&Item Lines")
                    {
                        ApplicationArea = All;
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Service Item Lines";
                        RunPageLink = "Service Item No." = FIELD("No.");
                        RunPageView = SORTING("Service Item No.");
                    }
                    action("&Service Lines")
                    {
                        ApplicationArea = All;
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Service Line List";
                        RunPageLink = "Service Item No." = FIELD("No.");
                        RunPageView = SORTING("Service Item No.");
                    }
                    action(Contracts)
                    {
                        ApplicationArea = All;
                        Caption = 'Contracts';
                        Image = ServiceAgreement;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Service Contracts";
                        RunPageLink = "Building No." = FIELD(Code);
                        RunPageView = SORTING("Contract Type", "Contract No.");
                    }
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Ser&vice Items")
                {
                    ApplicationArea = All;
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Building No." = FIELD(Code);
                    RunPageView = SORTING("Item No.");
                }
            }
        }
    }
}

