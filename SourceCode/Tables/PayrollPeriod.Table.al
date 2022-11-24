table 50122 "Payroll Period"
{
    Caption = 'Payroll Period';
    //LookupPageID = 33055853;

    fields
    {
        field(1; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(6; "Period Duration"; Option)
        {
            Caption = 'Period Duration';
            OptionCaption = 'Month,Quarter,Year,User-Defined';
            OptionMembers = Month,Quarter,Year,"User-Defined";
        }
        field(7; Employees; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = FILTER(Active)));
            Caption = 'Employees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Advance Date"; Date)
        {
            Caption = 'Advance Date';
        }
        field(9; "Code1"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; "New Payroll Year"; Boolean)
        {
            Caption = 'New Payroll Year';
        }
        field(50000; Disbursements; Integer)
        {
            //CalcFormula = Count ("Salary Disbursement Header" WHERE ("Payroll Period"=FIELD(Code)));
            Caption = 'Disbursements';
            //FieldClass = FlowField;
        }
        field(50001; "Leave Applications"; Integer)
        {
            //CalcFormula = Count("Leave Application" WHERE (Pay Period=FIELD(Code)));
            //FieldClass = FlowField;
            //TableRelation = "Leave Application";
        }
        field(50002; Accruals; Integer)
        {
            //CalcFormula = Count("Salary Disbursement Header" WHERE (Payroll Period=FIELD(Code),
            //                                                      Document Type=CONST(Accrual)));
            Caption = 'Disbursements';
            //FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code1")
        {
            Clustered = true;
        }
        key(Key2; "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin
        ERROR(Text001, TABLECAPTION);
    end;

    var
        Employee: Record 5200;
        //PayrollStatus: Record "33055798";
        Text001: Label 'You cannot rename the %1.';
        Text003: Label 'You cannot post before %1 because the %2 is already closed. You must re-open the period first.';
        Text004: Label 'You cannot delete the %1 because there is at least one released %2 in this period.';


    procedure ShowError(PostingDate: Date)
    begin
    end;


    procedure PeriodByDate(Date: Date): Code[10]
    var
        PayrollPeriod: Record 50122;
    begin
        PayrollPeriod.RESET;
        PayrollPeriod.SETFILTER("Ending Date", '%1..', Date);
        IF NOT PayrollPeriod.FINDFIRST THEN
            EXIT('');
        IF PayrollPeriod."Starting Date" <= Date THEN
            EXIT(PayrollPeriod.Code1);

        EXIT('');
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure GetMinDate(PayrollPeriod: Record 50122; StartDate: Date): Date
    begin
        IF PayrollPeriod."Starting Date" > StartDate THEN
            EXIT(PayrollPeriod."Starting Date");

        EXIT(StartDate);
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure GetMaxDate(PayrollPeriod: Record 50122; EndDate: Date): Date
    begin
        IF (EndDate = 0D) OR (PayrollPeriod."Ending Date" < EndDate) THEN
            EXIT(PayrollPeriod."Ending Date");

        EXIT(EndDate);
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure CheckPeriodExistence(Date: Date)
    var
        PayrollPeriod: Record 50122;
    begin
        PayrollPeriod.RESET;
        PayrollPeriod.SETFILTER("Ending Date", '%1..', Date);
        PayrollPeriod.FINDFIRST;
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure GetPrevPeriod(var PrevPeriodCode: Code[10]): Boolean
    var
        PayrollPeriod: Record 50122;
    begin
        PayrollPeriod.GET(Code1);
        IF PayrollPeriod.NEXT(-1) = 0 THEN
            EXIT(FALSE);

        PrevPeriodCode := PayrollPeriod.Code1;
        EXIT(TRUE);
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure PeriodStartDateByPeriodCode(PeriodCode: Code[10]): Date
    var
        PayrollPeriod: Record 50122;
    begin
        IF NOT PayrollPeriod.GET(PeriodCode) THEN
            EXIT(0D);
        EXIT(PayrollPeriod."Starting Date");
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure PeriodEndDateByPeriodCode(PeriodCode: Code[10]): Date
    var
        PayrollPeriod: Record 50122;
    begin
        IF NOT PayrollPeriod.GET(PeriodCode) THEN
            EXIT(0D);
        EXIT(PayrollPeriod."Ending Date");
    end;
}

