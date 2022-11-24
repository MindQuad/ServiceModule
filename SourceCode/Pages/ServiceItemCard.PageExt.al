PageExtension 50313 pageextension50313 extends "Service Item Card"
{
    layout
    {
        //Unsupported feature: Property Insertion (Visible) on ""Item Description"(Control 12)".
        modify(Shipping)
        {
            Caption = 'Details';
        }

        addafter("No.")
        {
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Caption = 'Unit Code';
                Editable = false;
            }
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Building Name field.';
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field(Block; Rec.Block)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Block field.';
            }
        }
        addafter("Item Description")
        {
            //Win593
            field("Unit Description"; Rec."Unit Description")
            {
                Caption = 'Primary/Secondary';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Description field.';

            }
            field("Primary Unit No."; Rec."Primary Unit No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Primary Unit No. field.';
                Editable = Rec."Unit Description" <> Rec."Unit Description"::"Primary Unit";
            }

            field("Unit Purpose"; Rec."Unit Purpose")
            {
                //Win593++
                ApplicationArea = Basic;

                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Rec."Unit Purpose" = Rec."Unit Purpose"::"Saleable Unit" then begin
                        Item.Init();
                        Item.Insert(true);
                        Item.Description := Rec."Unit No.";
                        Item.Type := Item.Type::"Inventory";
                        Item.Validate("Base Unit of Measure", 'PCS');
                        Item.Validate("Sales Unit of Measure", 'PCS');
                        Item.Validate("Gen. Prod. Posting Group", 'MISC');
                        Item.Validate("Inventory Posting Group", 'RESALE');
                        Item.Modify(true);
                        Rec.Validate("Item No.", Item."No.");
                        CurrPage.Update();
                    end;
                end;
                //Win593--
            }

        }

        moveafter("Service Item Group Code"; "Service Price Group Code")
        addafter("Search Description")
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = Basic;
            }
            field("Blocked for"; Rec."Blocked for")
            {
                ApplicationArea = Basic;
            }
            field("Blocked for Name"; Rec."Blocked for Name")
            {
                ApplicationArea = Basic;
            }
            field("Blocked Date"; Rec."Blocked Date")
            {
                ApplicationArea = Basic;
            }
            field("Occupancy Status"; Rec."Occupancy Status")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("Last Vacant Date"; Rec."Last Vacant Date")
            {
                ApplicationArea = Basic;
            }
            field("Potential Rent/Year"; Rec."Potential Rent/Year")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Customer)
        {
            group(Maintenance)
            {
                Caption = 'Maintenance';
                Visible = false;

                field("Study Room"; Rec."Study Room")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Last Time Modified"; Rec."Last Time Modified")
                {
                    ApplicationArea = Basic;
                }
            }
        }

        addafter("Service Contracts")
        {
            field("Payment Plan Code"; Rec."Payment Plan Code")
            {
                ApplicationArea = Basic;
                Caption = 'Payment Plan';
            }
            field("Planned Rate"; Rec."Planned Rate")
            {
                ApplicationArea = basic;
                Caption = 'Planned Rate';
            }
        }
        addafter("Installation Date")
        {
            field("Minimum Price"; Rec."Minimum Price")
            {
                ApplicationArea = Basic;
            }
            field("Receivable Account"; Rec."Receivable Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receivable Account field.';
            }
            field("Tax Code"; Rec."Tax Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tax Code field.';
            }
            field("PMS Unit Type"; Rec."PMS Unit Type")
            {
                ApplicationArea = Basic;
            }

            field("View"; Rec."View")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the View field.';
            }

            group(Other)
            {
                Caption = 'Other';

            }
        }
        addafter(Detail)
        {

            group("Property Details")
            {
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
                field(Floor; Rec.Floor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Floor field.';
                }
                field("No. of Master Bedroom"; Rec."No. of Master Bedroom")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Master Bedroom field.';
                }
                field(Balcony; Rec.Balcony)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balcony field.';
                }
                field("Maid Room"; Rec."Maid Room")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maid Room field.';
                }
                field("Store Room"; Rec."Store Room")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store Room field.';
                }
                field("Sqr Feet"; Rec."Sqr Feet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sqr.Ft. field.';
                }
                field("Sqr Meter"; Rec."Sqr Meter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sqr.Mtr. field.';
                }

            }

            group("Other Details")
            {
                Caption = 'Other Details';
                field("BUT Meter Number"; Rec."BUT Meter Number")
                {
                    ApplicationArea = All;
                }
                field("Electric & Water No."; Rec."Electric & Water No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Electric & Water No. field.';
                }
                field("Chiller No."; Rec."Chiller No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chiller No. field.';
                }
                field("GAS No."; Rec."GAS No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GAS No. field.';
                }
                field("DEWA Premise No."; Rec."DEWA Premise No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DEWA Premise No. field.';
                }

            }
        }
        addfirst(FactBoxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
            }
            part(ItemAttributesFactbox; "Item Attributes Factbox")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attributes';
                Visible = false;
            }
        }
        moveafter("Service Item Group Code"; Status)
        moveafter("Search Description"; Customer)
        moveafter("Serial No."; Shipping)
        addafter("Preferred Resource")
        {
            field("Unit Status"; Rec."Unit Status")
            {
                ApplicationArea = basic;
            }
            field("Car Parking No."; Rec."Car Parking No.")
            {
                ApplicationArea = basic;
            }
            field(Code; Rec.Code)
            {
                ApplicationArea = basic;
            }
        }
        addafter(Description)
        {
            field("Unit Type"; Rec."Unit Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Type field.';
            }
        }
    }

    actions
    {
        addafter("&Components")
        {
            action("Mapped Fixed Assets")
            {
                ApplicationArea = All;
                Caption = 'Mapped Fixed Asset';
                Image = FixedAssets;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FixedAssetPage: Page "Fixed Asset Mapping";
                    FixedAssetTable: Record "Fixed Asset";
                begin
                    FixedAssetPage.SetServiceItem(Rec);
                    FixedAssetTable.Reset();
                    FixedAssetTable.SetFilter(FixedAssetTable."Mapped against Service Item", '%1|%2', '', Rec."No.");
                    FixedAssetPage.SetTableView(FixedAssetTable);
                    FixedAssetPage.RunModal();
                end;
            }
        }
    }
    //Unsupported feature: Code Insertion on "OnAfterGetCurrRecord".

    trigger OnAfterGetCurrRecord()
    begin
        Rec."Potential Rent/Year" := 60000;
        Rec."Last Vacant Date" := 20200908D;

        //Win593
        PrimaryUnitNoEditable := Rec."Unit Description" <> Rec."Unit Description"::"Primary Unit";
        //Win593
    end;

    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    UpdateShipToCode;
    */
    //end;
    //>>>> MODIFIED CODE:
    begin
        UpdateShipToCode;
        Rec."Potential Rent/Year" := 60000;
        Rec."Last Vacant Date" := 20200908D;
    end;

    procedure UpdateShipToCode()
    begin
        IF Rec."Ship-to Code" = '' THEN BEGIN
            Rec."Ship-to Name" := Rec.Name;
            Rec."Ship-to Address" := Rec.Address;
            Rec."Ship-to Address 2" := Rec."Address 2";
            Rec."Ship-to Post Code" := Rec."Post Code";
            Rec."Ship-to City" := Rec.City;
            Rec."Ship-to Phone No." := Rec."Phone No.";
            Rec."Ship-to Contact" := Rec.Contact;
        END ELSE
            Rec.CALCFIELDS(
              "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", "Ship-to Post Code", "Ship-to City",
              "Ship-to County", "Ship-to Country/Region Code", "Ship-to Contact", "Ship-to Phone No.");
    end;

    var
        PrimaryUnitNoEditable: Boolean;
}

