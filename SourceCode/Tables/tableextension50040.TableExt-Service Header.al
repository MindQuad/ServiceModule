tableextension 50040 tableextension50040 extends "Service Header"
{
    // WIN-438 : Added new function to update Location Code on all Service line if location is changed.
    fields
    {
        modify("Location Code")
        {
            Description = 'WIN-438';

            trigger OnAfterValidate()
            begin
                ServLineLocationValidation();
            end;
        }

        field(200; "Work Description"; Text[250])
        {
            Caption = 'Work Description';
        }
        field(50000; "Defferal Code"; Code[10])
        {
            TableRelation = "Deferral Template"."Deferral Code";

            trigger OnValidate()
            begin
                IF "First Partial Invoice" = TRUE THEN
                    ERROR('Deferral code cannot be applied to First Partila Invoice of the Contract');
            end;
        }
        field(50001; "First Partial Invoice"; Boolean)
        {
        }
        field(50002; "Type of Ticket"; Option)
        {
            OptionCaption = 'Normal,Check In,Check Out,Recovery';
            OptionMembers = Normal,"Check In","Check Out",Recovery;
        }
        field(50003; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(50004; "Building No."; Code[20])
        {
            TableRelation = Building;

            trigger OnValidate()
            begin
                //WIN325
                IF (Rec."Building No." <> xRec."Building No.") THEN
                    IF Rec."Building No." = '' THEN BEGIN
                        VALIDATE("Unit No.", '');
                        VALIDATE("Service Item No.", '');
                    END;

                RecBuilding.RESET;
                RecBuilding.SETRANGE(RecBuilding.Code, Rec."Building No.");
                IF RecBuilding.FINDFIRST THEN
                    "Building Name" := RecBuilding.Description;
            end;
        }
        field(50005; "Unit No."; Code[20])
        {
            TableRelation = "Service Item"."Unit No." WHERE("Building No." = FIELD("Building No."));

            trigger OnLookup()
            begin
                //WIN325
                /*
                TESTFIELD("Building No.");
                ServItem.RESET;
                ServItem.SETRANGE("Building No.","Building No.");
                //ServItem.SETRANGE("Unit Purpose",ServItem."Unit Purpose"::"Rental Unit");
                IF PAGE.RUNMODAL(0,ServItem)= ACTION::LookupOK THEN BEGIN
                  VALIDATE("No.",ServItem."No.");
                END;
                */

            end;

            trigger OnValidate()
            begin

                //WIN325

                IF (Rec."Unit No." <> xRec."Unit No.") THEN
                    IF "Unit No." <> '' THEN BEGIN
                        ServItem1.RESET;
                        ServItem1.SETRANGE("Building No.", "Building No.");
                        ServItem1.SETRANGE("No.", "No.");
                        //ServItem1.SETRANGE("Unit Purpose",ServItem1."Unit Purpose"::"Rental Unit");
                        IF ServItem1.FINDSET THEN BEGIN
                            VALIDATE("Service Item No.", ServItem1."No.");
                            VALIDATE("Unit No.", ServItem1."No.");
                        END
                        ELSE BEGIN
                            VALIDATE("Service Item No.", '');
                            VALIDATE("Unit No.", '');
                        END
                    END ELSE BEGIN
                        VALIDATE("Service Item No.", '');
                        VALIDATE("Unit No.", '');
                    END;


            end;
        }
        field(50006; "Service Item No."; Code[20])
        {
            TableRelation = "Service Item"."No." WHERE("Building No." = FIELD("Building No."));

            trigger OnValidate()
            begin

                //WIN325
                IF (Rec."Service Item No." <> xRec."Service Item No.") THEN BEGIN
                    IF "Service Item No." <> '' THEN BEGIN
                        IF ServItem.GET("Service Item No.") THEN BEGIN
                            ServItem.TESTFIELD("Building No.");
                            ServItem.TESTFIELD("No.");
                            "Building No." := ServItem."Building No.";
                            "Unit No." := ServItem."Unit No.";
                            IF ServItem."Customer No." <> '' THEN BEGIN
                                VALIDATE("Customer No.", ServItem."Customer No.");
                                MODIFY;
                                COMMIT;
                            END;
                        END;
                    END ELSE
                        CLEAR("Unit No.");
                    CreateServiceOrderLines; //WIN325
                END;
            end;
        }
        field(50007; "Service Report No."; Code[20])
        {
            Caption = 'Service Report No.';
        }
        field(50008; "External Document No."; Text[50])
        {
        }
        field(50009; "Reference No."; Text[50])
        {
        }
        field(50010; "Created By"; Code[50])
        {
        }
        field(50011; "Creation date"; Date)
        {
        }
        field(50012; "Building Name"; Text[50])
        {
            CalcFormula = Lookup(Building.Description WHERE(Code = FIELD("Building No.")));
            FieldClass = FlowField;
        }
        field(50013; "Completion Date"; Date)
        {
        }
        field(50021; "Probability %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Probability %';
            DecimalPlaces = 0 : 0;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50022; "Expected Order Inflow"; DateFormula)
        {
            Caption = 'Expected Order Inflow';
        }
        field(50023; "Followup Date"; Date)
        {
            Caption = 'Followup Date';
        }
        field(50024; "Decision Date"; Date)
        {
            Caption = 'Decision Date';
        }
        field(50025; Competition; Text[30])
        {
            Caption = 'Competition';
        }
        field(50026; "Competitor Price"; Decimal)
        {
            Caption = 'Competitor Price';
        }
        field(50027; "Filed Date"; Date)
        {
            Caption = 'Filed Date';
        }
        field(50028; "Filed User ID"; Code[50])
        {
            Caption = 'Filed User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50029; "Quote valid until"; Text[30])
        {
            Caption = 'Quote valid until';
        }
        field(50059; "VAT Prod. Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(50200; "Additional Work Description"; Text[250])
        {
            Caption = 'Additional Work Description';
        }
        field(50201; "Penalty Exist"; Boolean)
        {
            Description = 'RealEstateCr';
        }
        field(50202; "Penalty Amount"; Decimal)
        {
            Description = 'RealEstateCr';
        }

        field(60000; "From Portal"; Boolean)
        {
            Caption = 'From Portal';
            Editable = false;
        }
        field(60001; "Scheduled Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Scheduled Date';
        }
        field(60002; "Scheduled From Time"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Scheduled From Time';
        }
        field(60003; "Scheduled To Time"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Scheduled To Time';
        }
        //Win593
        field(60004; "Supervisor Remark"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Supervisor Remark';
        }
        field(60005; "FMS SO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'FMS SO';
            Editable = false;
        }
        field(60006; Category; Code[20])
        {
            TableRelation = "Issued Category";
        }

        field(60007; "Sub-Category"; Code[20])
        {
            TableRelation = "Issued Sub-Category" where("Main Category" = field(Category));
        }

        //Win593
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ServSetup.GET ;
    IF "No." = '' THEN BEGIN
      TestNoSeries;
    #4..21
    IF GETFILTER("Contact No.") <> '' THEN
      IF GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") THEN
        VALIDATE("Contact No.",GETRANGEMIN("Contact No."));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..24

    // To Capture Creation By and Creation Date
    "Created By" := USERID;
    "Creation date" := TODAY;
    */
    //end;

    procedure SetWorkDescription(NewWorkDescription: Text)
    var
    //TempBlob: Record "99008535" temporary;
    begin
        //wins.201808161711
        /*
        CLEAR("Work Description");
        IF NewWorkDescription = '' THEN
          EXIT;
        TempBlob.Blob := "Work Description";
        TempBlob.WriteAsText(NewWorkDescription,TEXTENCODING::Windows);
        "Work Description" := TempBlob.Blob;
        MODIFY;
        */

    end;

    procedure GetWorkDescription(): Text
    var
        //TempBlob: Record "99008535" temporary;
        CR: Text[1];
    begin
        //wins.201808161711
        /*
        CALCFIELDS("Work Description");
        IF NOT "Work Description".HASVALUE THEN
          EXIT('');
        CR[1] := 10;
        TempBlob.Blob := "Work Description";
        EXIT(TempBlob.ReadAsText(CR,TEXTENCODING::Windows));
        */

    end;

    local procedure "-------------------------------------"()
    begin
    end;

    procedure CreateServiceOrderLines()
    var
        lServOrdLine: Record 5901;
        lServItem: Record 5940;
        lText001: Label 'Lines already exists.If you change Service Item, lines will be deleted and recreated. Do you want to change the Service Item No.?';
    begin
        //WIN325
        lServOrdLine.RESET;
        lServOrdLine.SETRANGE("Document Type", "Document Type");
        lServOrdLine.SETRANGE("Document No.", "No.");
        IF lServOrdLine.FINDFIRST THEN
            IF CONFIRM(lText001) THEN
                lServOrdLine.DELETEALL
            ELSE
                EXIT;
        COMMIT;
        IF "Service Item No." = '' THEN
            EXIT;
        lServItem.GET("Service Item No.");
        lServOrdLine.VALIDATE("Document Type", "Document Type");
        lServOrdLine.VALIDATE("Document No.", "No.");
        lServOrdLine.VALIDATE("Line No.", 10000);
        lServOrdLine.VALIDATE("Customer No.", "Customer No.");
        lServOrdLine."Service Item No." := "Service Item No.";
        //lServOrdLine.VALIDATE(lServOrdLine."Base Amount to Adjust",lServItem."Sales Unit Price");
        lServOrdLine.INSERT;
        lServOrdLine.VALIDATE("Service Item No.");
        lServOrdLine.MODIFY;
    end;

    procedure CheckApprovalStatus()
    begin
        IF "Document Type" = "Document Type"::Order THEN
            TESTFIELD("Approval Status", "Approval Status"::Open);
    end;

    local procedure ServLineLocationValidation(): Boolean
    begin
        ServLine.RESET;
        ServLine.SETRANGE("Document Type", "Document Type");
        ServLine.SETRANGE("Document No.", "No.");
        //ServLine.SETRANGE(Type,ServLine.Type::Item);
        ServLine.SETFILTER(Type, '%1|%2|%3', ServLine.Type::Item, ServLine.Type::"G/L Account", ServLine.Type::Resource);
        IF ServLine.FINDSET THEN
            REPEAT
                ServLine.VALIDATE(ServLine."Location Code", "Location Code");
                ServLine.MODIFY;
            UNTIL ServLine.NEXT = 0;
    end;

    var
        ServItem: Record 5940;
        ServItem1: Record 5940;
        RecBuilding: Record 50005;
        SerHdr: Record 5900;
        SerLine: Record 5901;
        ServLine: Record "Service Line";
}

