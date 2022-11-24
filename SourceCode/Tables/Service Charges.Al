table 50013 "Service Charges"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Charge Code';
            TableRelation = "Charge Master";

            trigger OnValidate()
            begin
                ChargeMaster.RESET;
                ChargeMaster.SETRANGE(ChargeMaster."Charge Code", Rec."Charge Code");
                IF ChargeMaster.FINDFIRST THEN BEGIN
                    "Charge Description" := ChargeMaster."Charge Description";
                    "Account Type" := "Account Type"::"G/L Account";
                    "Account No." := ChargeMaster."Bal. Account No.";
                    "Bal. Account Type" := "Bal. Account Type"::Customer;
                    //"Bal. Account No." := "Customer No."; //win04-12-19
                    "Bal. Account No." := ChargeMaster."Bal. Account No.";
                    "Gen. Prod. Posting Group" := ChargeMaster."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group" := ChargeMaster."VAT Prod. Posting Group";
                    // RealEstateCR
                    "Posting Allowed" := ChargeMaster."Posting Allowed";
                    "Allow-to Generate PDC Entry" := ChargeMaster."Allow-to Generate PDC Entry";
                    // RealEstateCR
                    IF "Document No." = '' THEN BEGIN
                        ServMgtSetup.GET;
                        ServMgtSetup.TESTFIELD("Service Charge Nos.");
                        NoSeriesMgt.InitSeries(ServMgtSetup."Service Charge Nos.", xRec."No. Series", 0D, "Document No.", "No. Series");
                    END;
                END;

                ChargeMaster1.RESET;
                ServiceContractHeader.RESET;
                ServiceContractHeader.SETRANGE(ServiceContractHeader."Contract No.", Rec."Service Contract Quote No.");
                IF ServiceContractHeader.FINDFIRST THEN BEGIN
                    IF "Charge Code" = 'VAT' THEN BEGIN
                        IF ServiceContractHeader."Tenancy Type" = ServiceContractHeader."Tenancy Type"::Commercial THEN
                            //"Charge Amount" := -((ServiceContractHeader."Annual Amount" * 5) /100)
                            VALIDATE("Charge Amount", -((ServiceContractHeader."Amount per Period" * 5) / 100))
                        //RecPDCL.Amount := -(ServContractManagement.CalcContractLineAmount("Annual Amount","Starting Date","Expiration Date")) / ServContractHdr."No. of PDC";
                        ELSE
                            IF ServiceContractHeader."Tenancy Type" = ServiceContractHeader."Tenancy Type"::Residential THEN
                                "Charge Amount" := 0;
                    END;
                    IF "Charge Code" = 'PEN' THEN BEGIN
                        //"Charge Amount" := -ServiceContractHeader."Penalty Amount";
                        VALIDATE("Charge Amount", -ServiceContractHeader."Penalty Amount");
                        "Charge Date" := ServiceContractHeader."Termination Date";
                    END;
                    "Dimension Set ID" := ServiceContractHeader."Dimension Set ID";
                END;

            end;

        }
        field(2; "Service Contract Quote No."; Code[20])
        {
            Caption = 'Lease Quote No.';
            Editable = false;
        }
        field(3; "Service Contract No."; Code[20])
        {
            Caption = 'Service Contract No.';
            Editable = false;
        }
        field(4; "Charge Description"; Text[50])
        {
            Caption = 'Charge Description';
        }
        field(5; "Charge Amount"; Decimal)
        {
            Caption = 'Charge Amount';

            trigger OnValidate()
            begin
                "Debit Amount" := 0;
                "Credit Amount" := 0;
                IF "Charge Amount" > 0 THEN
                    "Debit Amount" := "Charge Amount"
                ELSE
                    IF "Charge Amount" < 0 THEN
                        "Credit Amount" := "Charge Amount";
            end;
        }
        field(6; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor;
        }
        field(7; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(8; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
        }
        field(9; Post; Boolean)
        {
            Caption = 'Post';
            Editable = false;
        }
        field(10; Unposted; Boolean)
        {
            Caption = 'Unposted';
        }
        field(11; "Charge Date"; Date)
        {
            Caption = 'Charge Date';
        }
        field(12; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(13; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
        }
        field(14; "Table Line No."; Integer)
        {
            Caption = 'Table Line No.';

        }
        field(15; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(16; "Table Subtype"; Enum "Service Contract Type")
        {
            Caption = 'Table Subtype';
            // OptionMembers = "0","1","2","3";
            // OptionCaption = '0,1,2,3';
        }
        field(17; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionMembers = "Service Contract","Service Header","Service Item",Loaner,"Service Shipment Header","Service Invoice Header","Service Cr.Memo Header";
            OptionCaption = 'Service Contract,Service Header,Service Item,Loaner,Service Shipment Header,Service Invoice Header,Service Cr.Memo Header';
        }
        field(18; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            FieldClass = FlowField;
            CalcFormula = Lookup("Service Contract Header"."Approval Status" WHERE("Contract No." = FIELD("Service Contract Quote No.")));
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(20; "To Post"; Boolean)
        {
            Caption = 'To Post';

            trigger OnValidate()
            begin
                ChargeMaster.GET("Charge Code");
                ChargeMaster.TESTFIELD("Posting Allowed");
            end;
        }
        field(21; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            Editable = false;
        }
        field(22; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            Editable = false;
        }
        field(23; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = ' ,Customer,Vendor,G/L Account';
            OptionMembers = " ",Customer,Vendor,"G/L Account";
        }
        field(24; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor;
        }
        field(25; "Mode of Payment"; Code[10])
        {
            Caption = 'Mode of Payment';
            TableRelation = "Payment Method";
        }
        field(26; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionMembers = " ",Customer,Vendor,"G/L Account";
            OptionCaption = ' ,Customer,Vendor,G/L Account';
        }
        field(27; "Posting Allowed"; Boolean)
        {
            Caption = 'Posting Allowed';
        }
        field(28; "Allow-to Generate PDC Entry"; Boolean)
        {
            Caption = 'Allow-to Generate PDC Entry';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "Table Name", "Table Subtype", "Service Contract Quote No.", "Charge Code", "Table Line No.", "Line No.", "Customer No.", "Service Contract No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

        ChargeMaster: Record "Charge Master";
        ServiceContractHeader: Record "Service Contract Header";
        ChargeMaster1: Record "Charge Master";
        ServMgtSetup: Record "Service Mgt. Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}