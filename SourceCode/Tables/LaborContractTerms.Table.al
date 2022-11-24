table 50108 "Labor Contract Terms"
{
    Caption = 'Labor Contract Terms';

    fields
    {
        field(1; "Labor Contract No."; Code[20])
        {
            Caption = 'Labor Contract No.';
            TableRelation = "Labor Contract";
        }
        field(2; "Element Code"; Code[20])
        {
            Caption = 'Element Code';
            TableRelation = "Payroll Element";

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
                PayrollElement.GET("Element Code");
                Description := COPYSTR(PayrollElement.Description, 1, MAXSTRLEN(Description));
                "Posting Group" := PayrollElement."Payroll Posting Group";
                "Salary Indexation" := PayrollElement."Use Indexation";


            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(5; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(7; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "Payroll Posting Group";

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(9; Percent; Decimal)
        {
            Caption = 'Percent';

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
                IF Percent <> 0 THEN BEGIN
                    LaborContractLine.RESET;
                    LaborContractLine.SETRANGE("Contract No.", "Labor Contract No.");
                    LaborContractLine.SETRANGE("Operation Type", "Operation Type");
                    LaborContractLine.SETRANGE("Supplement No.", "Supplement No.");
                    LaborContractLine.FINDFIRST;

                    Position.GET(LaborContractLine."Position No.");
                    Position.TESTFIELD("Base Salary Element Code");
                    Position.TESTFIELD("Base Salary Amount");
                    Amount := Position."Base Salary" * Percent / 100;
                END;
            end;
        }
        field(10; "Time Activity Code"; Code[10])
        {
            Caption = 'Time Activity Code';


            trigger OnValidate()
            begin
                CheckLaborContractStatus;
                IF TimeActivity.GET("Time Activity Code") THEN
                    IF "Element Code" = '' THEN
                        "Element Code" := TimeActivity.Code1;
            end;
        }
        field(11; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Payroll Element,Vacation Accrual';
            OptionMembers = "Payroll Element","Vacation Accrual";

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(12; "Supplement No."; Code[10])
        {
            Caption = 'Supplement No.';
        }
        field(13; "Operation Type"; Option)
        {
            Caption = 'Operation Type';
            OptionCaption = 'Hire,Transfer,Combination,Dismissal';
            OptionMembers = Hire,Transfer,Combination,Dismissal;
        }
        field(14; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                CheckLaborContractStatus;
            end;
        }
        field(15; "Salary Indexation"; Boolean)
        {
            Caption = 'Salary Indexation';
        }
        field(16; "Depends on Salary Element"; Code[20])
        {
            Caption = 'Depends on Salary Element';
            TableRelation = "Payroll Element" WHERE(Type = CONST(Wage));
        }
    }

    keys
    {
        key(Key1; "Labor Contract No.", "Operation Type", "Supplement No.", "Line Type", "Element Code")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CheckLaborContractStatus;
    end;

    trigger OnInsert()
    begin
        CheckLaborContractStatus;
    end;

    var
        PayrollElement: Record "Payroll Element";
        TimeActivity: Record "Time Activity";
        LaborContract: Record 50106;
        LaborContractLine: Record 50107;
        Position: Record 50110;


    procedure CheckLaborContractStatus()
    var
        LaborContractLine: Record 50107;
    begin
        LaborContract.GET("Labor Contract No.");
        IF LaborContract.Status = LaborContract.Status::Closed THEN
            LaborContract.FIELDERROR(Status);

        IF LaborContractLine.GET("Labor Contract No.", "Operation Type", "Supplement No.") THEN
            IF LaborContractLine.Status = LaborContractLine.Status::Approved THEN
                IF LaborContractLine."Operation Type" <> LaborContractLine."Operation Type"::Combination THEN
                    LaborContractLine.FIELDERROR(Status);
    end;


}

