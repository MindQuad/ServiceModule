table 50106 "Labor Contract"
{
    Caption = 'Labor Contract';
    //LookupPageID = 33055968;
    //ObsoleteState = Removed;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            OptionCaption = 'Labor Contract,Civil Contract';
            OptionMembers = "Labor Contract","Civil Contract";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);

                "Work Mode" := "Work Mode"::"Primary Job";
            end;
        }
        field(3; "Work Mode"; Option)
        {
            Caption = 'Work Mode';
            OptionCaption = 'Primary Job,Internal Co-work,External Co-work';
            OptionMembers = "Primary Job","Internal Co-work","External Co-work";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);

                IF "Contract Type" = "Contract Type"::"Civil Contract" THEN
                    TESTFIELD("Work Mode", "Work Mode"::"Primary Job")
                ELSE
                    IF "Person No." <> '' THEN BEGIN
                        LaborContract.RESET;
                        LaborContract.SETRANGE("Person No.", "Person No.");
                        LaborContract.SETRANGE("Contract Type", "Contract Type"::"Labor Contract");
                        LaborContract.SETRANGE(Status, Status::Approved);
                        IF "Work Mode" = "Work Mode"::"Internal Co-work" THEN
                            IF LaborContract.ISEMPTY THEN
                                ERROR(Text14704, "Person No.");
                        IF ("Work Mode" = "Work Mode"::"Primary Job") OR ("Work Mode" = "Work Mode"::"External Co-work") THEN
                            IF NOT LaborContract.ISEMPTY THEN
                                ERROR(Text14705, "Person No.");
                    END;
            end;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Contract Type Code"; Code[10])
        {
            Caption = 'Contract Type Code';
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(8; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(10; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Approved,Closed';
            OptionMembers = Open,Approved,Closed;
        }
        field(12; "Person No."; Code[20])
        {
            Caption = 'Person No.';
            TableRelation = Person;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);

                CALCFIELDS("Person Name");

                LaborContractLine.RESET;
                //LaborContractLine.SETRANGE("Contract No.", "No.");
                IF NOT LaborContractLine.ISEMPTY THEN
                    ERROR(Text000, FIELDCAPTION("Person No."));

                VALIDATE("Work Mode");

                IF "Person No." <> xRec."Person No." THEN
                    "Vendor Agreement No." := '';

                IF "Person No." <> '' THEN BEGIN
                    Person.GET("Person No.");
                    Person.TESTFIELD("Vendor No.");
                    "Vendor No." := Person."Vendor No.";
                END ELSE BEGIN
                    "Vendor No." := '';
                    "Vendor Agreement No." := '';
                END;
            end;
        }
        field(13; "Person Name"; Text[100])
        {
            CalcFormula = Lookup(Person."Full Name" WHERE("No." = FIELD("Person No.")));
            Caption = 'Person Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
        }
        field(17; "Uninterrupted Service"; Boolean)
        {
            Caption = 'Uninterrupted Service';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(18; "Insured Service"; Boolean)
        {
            Caption = 'Insured Service';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(19; "Unmeasured Work Time"; Boolean)
        {
            Caption = 'Unmeasured Work Time';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(20; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(21; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(22; "Open Contract Lines"; Integer)
        {
            // CalcFormula = Count("Labor Contract Line" WHERE("Contract No." = FIELD("No."),
            //                                                  Status = CONST(Open)));
            // Caption = 'Open Contract Lines';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(41; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
        }
        field(42; "Vendor Agreement No."; Code[20])
        {
            Caption = 'Vendor Agreement No.';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Contract Type", "Person No.", "Starting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Person No.", "Person Name")
        {
        }
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);

        LaborContractLine.SETRANGE("Contract No.", "No.");
        LaborContractLine.DELETEALL;

        LaborContractTerms.SETRANGE("Labor Contract No.", "No.");
        LaborContractTerms.DELETEALL;
    end;

    trigger OnInsert()
    begin
        HumanResSetup.GET;
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", TODAY, "No.", "No. Series");
        END;

        InitRecord;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Person: Record 50112;
        LaborContract: Record 50106;
        LaborContractLine: Record 50107;
        LaborContractTerms: Record 50108;
        NoSeriesMgt: Codeunit 396;
        Text000: Label 'You cannot change %1 while order lines exist.';
        Text14704: Label 'Primary labor contract is not found for person %1.';
        Text14705: Label 'Primary labor contract already exist for person %1.';


    procedure InitRecord()
    begin
    end;


    procedure AssistEdit(OldLaborContract: Record 50106): Boolean
    begin
        //Win513++
        //WITH LaborContract DO BEGIN
        //Win513--
        COPY(Rec);
        HumanResSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldLaborContract."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := LaborContract;
            EXIT(TRUE);
        END;
        //Win513++
        //END;
        //Win513--
    end;

    local procedure TestNoSeries()
    begin
        HumanResSetup.TESTFIELD("Employee Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        EXIT(HumanResSetup."Employee Nos.");
    end;
}

