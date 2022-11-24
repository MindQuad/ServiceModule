tableextension 50055 "Service Item Ext" extends "Service Item"
{
    fields
    {
        field(50000; "Unit Purpose"; Option)
        {

            Caption = 'Unit Purpose';
            OptionCaption = ' ,Saleable Unit,Rental Unit,Common Use';
            OptionMembers = " ","Saleable Unit","Rental Unit","Common Use";
        }
        field(50001; "Payment Plan Code"; Code[20])
        {
            Caption = 'Payment Plan Code';
            TableRelation = "Payment Plan"."Payment Plan Code" WHERE("Service Item No." = FILTER(''));

            trigger OnValidate()
            var

                PaymentPlan: Record "Payment Plan";
                PaymentPlan2: Record "Payment Plan";
            begin
                PaymentPlan.RESET;
                PaymentPlan.SETRANGE(PaymentPlan."Payment Plan Code", "Payment Plan Code");
                IF PaymentPlan.FINDFIRST THEN BEGIN
                    REPEAT
                        PaymentPlan2.INIT;
                        PaymentPlan2."Payment Plan Code" := PaymentPlan."Payment Plan Code";
                        PaymentPlan2."Milestone Code" := PaymentPlan."Milestone Code";
                        PaymentPlan2."Service Item No." := "No.";
                        PaymentPlan2."Milestone Description" := PaymentPlan."Milestone Description";
                        PaymentPlan2."Milestone %" := PaymentPlan."Milestone %";
                        PaymentPlan2."Milestone Amount" := PaymentPlan."Milestone Amount";
                        PaymentPlan2."Invoice Due date Calculation" := PaymentPlan."Invoice Due date Calculation";
                        PaymentPlan2."Revenue Interim Account" := PaymentPlan."Revenue Interim Account";
                        IF PaymentPlan2.INSERT THEN;
                    UNTIL PaymentPlan.NEXT = 0;
                END;

            end;
        }
        field(50002; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';

        }
        field(50003; "No. of Bedrooms"; Option)
        {
            Caption = 'No. of Bedrooms';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10",Studio;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10,Studio';
        }
        field(50004; "No. of Bathrooms"; Option)
        {
            Caption = 'No. of Bathrooms';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';

        }
        field(50005; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = " ",Flat,Villa,Office,"Flat-Office",Penthouse,"Duplex Appt.",Commercial,Retail,Residential;
            OptionCaption = ' ,Flat,Villa,Office,Flat-Office,Penthouse,Duplex Appt.,Commercial,Retail,Residential';
        }
        field(50006; Subtype; Option)
        {
            Caption = 'SubType';
            OptionMembers = " ",Manufacturing,Warehouse,Roof,Facade;
            OptionCaption = ' ,Manufacturing,Warehouse,Roof,Facade';
        }
        field(50007; Parking; Option)
        {
            Caption = 'Parking';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
        }
        field(50008; Balcony; Option)
        {
            Caption = 'Balcony';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
        }
        field(50009; Floor; Text[30])
        {
            Caption = 'Floor';

        }
        field(50010; Size; Decimal)
        {
            Caption = 'Net Area';

            trigger OnValidate()
            begin
                VALIDATE("Job Code");
            end;

        }
        field(50011; "Unit Address"; Text[60])
        {
            Caption = 'Unit Address';

        }
        field(50012; "Unit Address2"; Text[60])
        {
            Caption = 'Unit Address2';

        }
        field(50013; Direction; Text[60])
        {
            Caption = 'Direction';

        }
        field(50014; "Location within building"; Text[60])
        {
            Caption = 'Location within building';

        }
        field(50015; "Building No."; Code[20])
        {
            Caption = 'Building No.';
            TableRelation = Building;

            trigger OnValidate()
            var
                lBuildRec: Record Building;
            Begin
                //WIN325
                IF Rec."Building No." <> xRec."Building No." THEN BEGIN
                    IF "Building No." <> '' THEN BEGIN
                        IF lBuildRec.GET("Building No.") THEN BEGIN
                            "Unit Address" := lBuildRec.Address;
                            "Unit Address2" := lBuildRec."Address 2";
                            "Unit City" := lBuildRec.City;
                            "Unit Post Code" := lBuildRec."Post Code";
                            "Unit Country Code" := lBuildRec."Country/Region Code";
                        END;
                    END;
                END;
                //GetAmenitiesfromBuilding;
            End;
        }
        field(50016; "Maid Room"; Boolean)
        {
            Caption = 'Maid Room';

        }
        field(50017; "Store Room"; Boolean)
        {
            Caption = 'Store Room';
        }
        field(50018; "Study Room"; Boolean)
        {
            Caption = 'Study Room';
        }
        field(50019; "Latest Valuation Amount"; Decimal)
        {
            Caption = 'Latest Valuation Amount';

        }
        field(50020; "No. of Master Bedroom"; Option)
        {
            Caption = 'No. of Master Bedroom';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
        }
        field(50022; "Minimum Price"; Decimal)
        {
            Caption = 'Minimum Price';

            trigger OnValidate()
            begin
                "Min Price change by" := USERID;
                "Min Price change datetime" := CURRENTDATETIME;
            end;

        }
        field(50023; "Job Code"; Code[20])
        {
            Caption = 'Job Code';
            TableRelation = Job;
        }
        field(50024; "Unit Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Unit Country Code" = CONST()) "Post Code" ELSE
            IF ("Unit Country Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Unit Country Code"));
            ValidateTableRelation = false;

        }
        field(50025; "Unit City"; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Unit Country Code" = CONST()) "Post Code".City ELSE
            IF ("Unit Country Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

        }
        field(50026; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
        }
        field(50027; "Unit Country Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        //Win513++
        //field(50028; "Customer Name"; Text[50])
        field(50028; "Customer Name"; Text[100])
        //Win513--
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
        }
        field(50029; "Laundry Room"; Option)
        {
            Caption = 'Laundry Room';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';

        }
        field(50030; "Min Price change datetime"; DateTime)
        {
            Caption = 'Min Price change datetime';

        }
        field(50031; "Min Price change by"; Text[50])
        {
            Caption = 'Min Price change by';
        }
        field(50032; "Prospect Code"; Code[20])
        {
            Caption = 'Prospect Code(Contact)';
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            var

                SalesReceivablesSetup: Record "Sales & Receivables Setup";
            begin
                SalesReceivablesSetup.GET;
            end;

        }
        field(50033; "Asset Type"; Code[10])
        {
            Caption = 'Asset Type';

        }
        field(50034; "Asset Subtype"; Code[10])

        {
            Caption = 'Asset Subtype';
        }
        field(50035; "Asset Component"; Code[10])
        {
            Caption = 'Asset Component';
        }
        field(50036; "Asset Subcomponent"; Code[10])
        {
            Caption = 'Asset Subcomponent';
        }
        field(50037; "Calculated Unit Cost(Job)"; Decimal)
        {
            Caption = 'Calculated Unit Cost(Job)';
            TableRelation = "VAT Product Posting Group";
        }
        field(50038; "Building Name"; Text[50])
        {
            Caption = 'Building Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Building.Description WHERE(Code = FIELD("Building No.")));
        }
        field(50039; "Blocked for"; Code[20])
        {
            Caption = 'Blocked for';
            TableRelation = Contact."No.";

            trigger OnValidate()
            var

                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
                IF "Blocked for" = '' THEN
                    EXIT;
                Cont.GET("Blocked for");
                "Blocked for Name" := Cont.Name;
            end;

            trigger OnLookup()
            var

                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN
                    VALIDATE("Blocked for", Cont."No.");
            end;
        }
        field(50040; "Blocked Date"; Date)
        {
            Caption = 'Blocked Date';
        }
        field(50041; "Blocked for Name"; Text[30])
        {
            Caption = 'Blocked for Name';
        }
        //Win513++
        //field(50042; "Unit Code"; Code[10])
        field(50042; "Unit Code"; Code[20])
        //Win513--
        {
            Caption = 'Unit No.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."No. 2" WHERE("No." = FIELD("Item No.")));
        }
        field(50050; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(50051; "Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
            Editable = false;
        }
        field(50052; "Occupancy Status"; Option)
        {
            Caption = 'Occupancy Status';
            OptionMembers = " ",Vacant,Occupied,Pending;
            OptionCaption = ' ,Vacant,Occupied,Pending';
        }
        field(50053; "Sales Price"; Decimal)
        {
            Caption = 'Sales Price';

        }
        field(50059; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(50060; "DEWA Premise No."; Code[20])
        {
            Caption = 'DEWA Premise No.';
        }
        field(50061; "Potential Rent/Year"; Decimal)
        {
            Caption = 'Potential Rent/Year';
        }
        field(50062; "Last Vacant Date"; Date)
        {
            Caption = 'Last Vacant Date';
        }
        field(50063; "Primary Unit No."; Code[20])
        {
            Caption = 'Primary Unit No.';
            TableRelation = "Service Item"."No.";

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec."No." = Rec."Primary Unit No." then
                    Error(PrimaryUnitNoErr);
            end;
        }
        field(50064; "Unit Description"; Enum "Unit Description")
        {
            Caption = 'Unit Description';
        }
        field(50065; Block; Code[20])
        {
            Caption = 'Block';
        }
        field(50066; "PMS Unit Type"; Option)
        {
            Caption = 'PMS Unit Type';
            OptionMembers = " ","Single Unit";
            OptionCaption = ' ,Single Unit';
        }
        field(50067; "Unit Type"; Option)
        {
            Caption = 'Unit Type';
            OptionMembers = " ","Residential","Commercial";
            OptionCaption = ' ,Residential,Commercial';
        }
        field(50068; View; Text[20])
        {
            Caption = 'View';

        }
        field(50069; "Sqr Feet"; Decimal)
        {
            Caption = 'Sqr.Ft.';

        }
        field(50070; "Sqr Meter"; Decimal)
        {
            Caption = 'Sqr.Mtr.';

        }
        field(50071; "BUT Meter Number"; Code[20])
        {
            Caption = 'BUT Meter Number';
        }
        field(50072; "Electric & Water No."; Code[20])
        {
            Caption = 'Electric & Water No.';
        }
        field(50073; "Chiller No."; Code[20])
        {
            Caption = 'Chiller No.';
        }
        field(50074; "GAS No."; Code[20])
        {
            Caption = 'GAS No.';
        }
        field(50075; "Receivable Account"; Text[50])
        {
            Caption = 'Receivable Account';
        }
        field(50076; "Tax Code"; Code[20])
        {
            Caption = 'Tax Code';
        }
        field(50077; "Planned Rate"; Decimal)
        {
            Caption = 'Planned Rate';
        }
        field(50078; "Unit Status"; Option)
        {
            Caption = 'Unit Status';
            OptionMembers = " ",Leased,Renovation,"Self Use",Sold,Vacant;
            OptionCaption = ' ,Leased,Renovation,Self Use,Sold,Vacant';
        }
        field(50079; Code; Code[20])
        {
            Caption = 'Code';

        }
        field(50080; "Car Parking No."; Text[20])
        {
            Caption = 'Car Parking No.';

        }
        modify("No.")
        {
            Caption = 'Code';
        }
        field(50081; "Municipality Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50082; "Municipality Code"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50083; "Planned Rent"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50084; "Total Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50085; "Selling Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(UnitNo; "Unit No.")
        {

        }
    }
    var
        PrimaryUnitNoErr: Label 'Primary Unit No. must be different than Service Item No.';


}