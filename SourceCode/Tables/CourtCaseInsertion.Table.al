table 50014 "Court Case Insertion"
{

    fields
    {
        field(1; "Case No."; Code[10])
        {
        }
        field(2; "Building No."; Code[20])
        {
            TableRelation = Building;
        }
        field(3; "Unit No."; Code[20])
        {
            TableRelation = "Service Item";
        }
        field(4; "Tenant No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            var
            // Customer: Record "18";//WIN292
            begin
                CLEAR("Tenant Name");
                IF "Tenant No." = '' THEN
                    EXIT;
                /* Customer.GET("Tenant No.");
                "Tenant Name" := Customer.Name; *///WIN292
            end;
        }
        field(5; "Tenant Name"; Text[50])
        {
        }
        field(6; "Tenant Contract No."; Code[20])
        {
            TableRelation = "Service Contract Header"."Contract No." WHERE("Contract Type" = FILTER(Contract));

            trigger OnValidate()
            var
            /* ServiceContractHeader: Record "5965";
            Customer: Record "18"; *///WIN292
            begin
                CLEAR("Building No.");
                CLEAR("Unit No.");
                CLEAR("Tenant No.");
                CLEAR("Tenant Name");
                IF "Tenant Contract No." = '' THEN
                    EXIT;
                /* ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Contract,"Tenant Contract No.");
                "Building No." := ServiceContractHeader."Building No.";
                "Unit No." := ServiceContractHeader."Unit No.";
                "Tenant No." := ServiceContractHeader."Customer No.";
                IF Customer.GET("Tenant No.") THEN
                  "Tenant Name" := Customer.Name *///WIN292
            end;
        }
        field(7; "Request Start Date"; Date)
        {
        }
        field(8; "Case Status"; Option)
        {
            OptionCaption = ' ,Under Process,Awaiting Judgement,Received Judgement,Eviction,Closed';
            OptionMembers = " ","Under Process","Awaiting Judgement","Received Judgement",Eviction,Closed;
        }
        field(9; Remark; Text[50])
        {
        }
        field(10; "Customer Balance"; Decimal)
        {

            trigger OnValidate()
            begin
                CALCFIELDS("Applied Amount");
                //"Balancing Amount" := "Customer Balance" - "Applied Amount";//WIN292
            end;
        }
        field(11; Link; Text[250])
        {
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "PDC No."; Code[20])
        {

            trigger OnValidate()
            begin
                /* PDC.RESET;
                PDC.SETRANGE(PDC."Document No.", Rec."PDC No.");
                IF PDC.FINDFIRST THEN BEGIN
                    "PDC No." := PDC."Document No.";
                    "Building No." := PDC."Building No.";
                    "Unit No." := PDC."Unit No.";
                    "Tenant No." := PDC."Customer No.";
                    "Tenant Name" := PDC."Customer Name";
                    "Tenant Contract No." := PDC."Contract No.";
                    "Creation Date" := TODAY; */
            END;
            // end;//WIN292
        }
        field(14; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(15; "Apply to ID"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Cust. Ledger Entry"."Apply to ID" WHERE("Apply Doc. No." = FIELD("Case No.")));
            Editable = false;

        }
        field(16; Apply; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Cust. Ledger Entry"."Apply Entries" WHERE("Apply Doc. No." = FIELD("Case No.")));
            Editable = false;

        }
        field(17; "Apply to Doc No."; Code[20])
        {
            Editable = false;
        }
        field(18; "Applied Amount"; Decimal)
        {
            CalcFormula = Sum("Cust. Ledger Entry"."Apply Amount" WHERE("Apply Doc. No." = FIELD("Case No."),
                                                                         "Apply Entries" = FILTER(true)));
            FieldClass = FlowField;
        }
        field(19; "Balancing Amount"; Decimal)
        {
        }
        field(20; "Case Document No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Case No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Case No." = '' THEN BEGIN
            MarketingSetup.GET;
            MarketingSetup.TESTFIELD("Court Case No.");
            NoSeriesMgt.InitSeries(MarketingSetup."Court Case No.", xRec."No. Series", 0D, "Case No.", "No. Series");//WIN292
        END;
    end;

    var
        MarketingSetup: Record 5079;
        NoSeriesMgt: Codeunit 396;
        PDC: Record "Post Dated Check Line";
        PDCNo: Code[10];
        Customer: Record 18;


    procedure GetPDC(PDC1: Record "Post Dated Check Line")
    begin

        INIT;
        /* IF FINDLAST THEN
            "Interaction No." := "Interaction No." + 1
        ELSE
            "Interaction No." := 1; */
        "Case No." := '';
        PDCNo := PDC1."Document No.";
        //VALIDATE("PDC No.",PDCNo);

        INSERT(TRUE);
        VALIDATE("PDC No.", PDCNo);
        MODIFY;

    end; //WIN292


    procedure CreateInteraction()
    var
        TempSegmentLine: Record 5077 temporary;//WIN292
    begin
        TempSegmentLine.CreateInteractionFromCourCases(Rec);//WIN292
    end;

}

