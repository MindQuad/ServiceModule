table 50110 Position
{
    Caption = 'Position';
    /*  DrillDownPageID = 33055981;
     LookupPageID = 33055981;
  */
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                /* IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                END; */
            end;
        }
        field(2; "Job Title Code"; Code[10])
        {
            Caption = 'Job Title Code';
            // TableRelation = "Job Title";

            /*       trigger OnValidate()
                  begin
                      CheckModify;
                      IF JobTitle.GET("Job Title Code") THEN BEGIN
                          JobTitle.TESTFIELD(Type, JobTitle.Type::"Job Title");
                          JobTitle.TESTFIELD(Blocked, FALSE);
                          "Job Title Name" := JobTitle.Name;
                          IF "Budgeted Position No." <> '' THEN BEGIN
                              Position2.GET("Budgeted Position No.");
                              TESTFIELD("Job Title Code", Position2."Job Title Code");
                          END;
                          "Base Salary Element Code" := JobTitle."Base Salary Element Code";
                          VALIDATE("Base Salary", JobTitle."Base Salary Amount");
                          VALIDATE("Category Code", JobTitle."Category Code");
                          VALIDATE("Calendar Code", JobTitle."Calendar Code");
                          VALIDATE("Worktime Norm", JobTitle."Worktime Norm");
                          VALIDATE("Kind of Work", JobTitle."Kind of Work");
                          VALIDATE("Conditions of Work", JobTitle."Conditions of Work");
                          VALIDATE("Calc Group Code", JobTitle."Calc Group Code");
                          VALIDATE("Posting Group", JobTitle."Posting Group");
                          VALIDATE("Statistical Group Code", JobTitle."Statistics Group Code");
                          CopyContractTerms;
                          Calculate;
                      END; */
            // end;
        }
        field(3; "Job Title Name"; Text[50])
        {
            Caption = 'Job Title Name';
            Editable = false;

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(4; "Org. Unit Code"; Code[10])
        {
            Caption = 'Org. Unit Code';
            // TableRelation = "Organizational Unit";

            /*  trigger OnValidate()
             begin
                 CheckModify;
                 HumanResSetup.GET;
                 IF "Org. Unit Code" = '' THEN
                     "Org. Unit Name" := ''
                 ELSE BEGIN
                     OrganizationalUnit.GET("Org. Unit Code");
                     OrganizationalUnit.TESTFIELD(Type, OrganizationalUnit.Type::Unit);
                     IF NOT HumanResSetup."Use Staff List Change Orders" THEN
                         OrganizationalUnit.TESTFIELD(Status, OrganizationalUnit.Status::Approved);
                     OrganizationalUnit.TESTFIELD(Blocked, FALSE);
                     "Org. Unit Name" := OrganizationalUnit.Name;
                     IF ("Starting Date" <> 0D) AND (OrganizationalUnit."Starting Date" > "Starting Date") THEN
                         ERROR(Text002,
                           OrganizationalUnit.TABLECAPTION, OrganizationalUnit.FIELDCAPTION("Starting Date"),
                           TABLECAPTION, FIELDCAPTION("Starting Date"));
                     IF ("Ending Date" <> 0D) AND (OrganizationalUnit."Ending Date" <> 0D) AND
                        (OrganizationalUnit."Ending Date" < "Ending Date")
                     THEN
                         ERROR(Text002,
                           TABLECAPTION, FIELDCAPTION("Starting Date"),
                           OrganizationalUnit.TABLECAPTION, OrganizationalUnit.FIELDCAPTION("Starting Date"));
                     IF "Budgeted Position No." <> '' THEN BEGIN
                         Position2.GET("Budgeted Position No.");
                         TESTFIELD("Job Title Code", Position2."Job Title Code");
                     END;
                     CopyContractTerms;
                 END; */
            //end;
        }
        field(5; "Org. Unit Name"; Text[50])
        {
            Caption = 'Org. Unit Name';
            Editable = false;

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Planned,Approved,Closed';
            OptionMembers = Planned,Approved,Closed;
        }
        field(8; "Parent Position No."; Code[20])
        {
            Caption = 'Parent Position No.';
            TableRelation = Position;

            trigger OnValidate()
            begin

                /*  IF "Parent Position No." <> '' THEN BEGIN
                     IF "No." = "Parent Position No." THEN
                         FIELDERROR("Parent Position No.");
                     Position.GET("Parent Position No.");
                     Level := Position.Level + 1;
                     IF "Org. Unit Code" = '' THEN
                         VALIDATE("Org. Unit Code", Position."Org. Unit Code");
                 END ELSE
                     Level := 0; */
            end;
        }
        field(9; "Filled Rate"; Decimal)
        {
            // CalcFormula = Sum("Employee Job Entry"."Position Rate" WHERE("Position No."=FIELD("No."),
            //                                                               "Starting Date"=FIELD("Date Filter"))); 
            Caption = 'Filled Rate';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(10; Rate; Decimal)
        {
            Caption = 'Rate';
            MinValue = 0;

            /* trigger OnValidate()
            begin
                CheckModify;
                IF NOT "Budgeted Position" THEN
                  IF Rate > 1 THEN
                    ERROR(Text003,FIELDCAPTION(Rate),1);

                Calculate;
            end; */
        }
        field(11; "Base Salary"; Decimal)
        {
            Caption = 'Base Salary';

            trigger OnValidate()
            begin
                //CheckModify;
                // Calculate;
            end;
        }
        field(12; "Additional Salary"; Decimal)
        {
            Caption = 'Additional Salary';

            trigger OnValidate()
            begin
                // CheckModify;
                //Calculate;
            end;
        }
        field(13; "Budgeted Salary"; Decimal)
        {
            Caption = 'Budgeted Salary';

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(14; "Monthly Salary"; Decimal)
        {
            Caption = 'Monthly Salary';
            Editable = false;
        }
        field(15; Note; Text[250])
        {
            Caption = 'Note';
        }
        field(16; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            Editable = false;

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(17; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                /* CheckModify;
                IF OrganizationalUnit.GET("Org. Unit Code") THEN
                  IF ("Starting Date" <> 0D) AND (OrganizationalUnit."Starting Date" > "Starting Date") THEN
                    ERROR(Text002,
                      OrganizationalUnit.TABLECAPTION,OrganizationalUnit.FIELDCAPTION("Starting Date"),
                      TABLECAPTION,FIELDCAPTION("Starting Date")); */
            end;
        }
        field(18; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                /* CheckModify;
                IF OrganizationalUnit.GET("Org. Unit Code") THEN
                  IF ("Ending Date" <> 0D) AND (OrganizationalUnit."Ending Date" <> 0D) AND
                     (OrganizationalUnit."Ending Date" < "Ending Date")
                  THEN
                    ERROR(Text002,
                      TABLECAPTION,FIELDCAPTION("Ending Date"),
                      OrganizationalUnit.TABLECAPTION,OrganizationalUnit.FIELDCAPTION("Ending Date")); */
            end;
        }
        field(19; "Base Salary Element Code"; Code[20])
        {
            Caption = 'Base Salary Element Code';
            //TableRelation = "Payroll Element";

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(20; "Category Code"; Code[10])
        {
            Caption = 'Category Code';
            //TableRelation = "Employee Category";

            trigger OnValidate()
            begin
                /*  CheckModify;
                 CopyContractTerms;
                 Calculate; */
            end;
        }
        field(21; "Opening Reason"; Text[250])
        {
            Caption = 'Opening Reason';

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(22; "Calendar Code"; Code[10])
        {
            Caption = 'Calendar Code';
            TableRelation = "Payroll Calendar";

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(23; "Statistical Group Code"; Code[10])
        {
            Caption = 'Statistical Group Code';
            TableRelation = "Employee Statistics Group";

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(24; "Worktime Norm"; Code[10])
        {
            Caption = 'Worktime Norm';
            //TableRelation = "Worktime Norm";
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(25; "Use Trial Period"; Boolean)
        {
            Caption = 'Use Trial Period';

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(26; "Trial Period Description"; Text[50])
        {
            Caption = 'Trial Period Description';

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(27; "Liability for Breakage"; Option)
        {
            Caption = 'Liability for Breakage';
            OptionCaption = 'None,Team,Personal';
            OptionMembers = "None",Team,Personal;

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(28; "Hire Conditions"; Code[20])
        {
            Caption = 'Hire Conditions';
            // TableRelation = "General Directory".Code WHERE (Type=FILTER(Hire Condition));

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(29; Level; Integer)
        {
            Caption = 'Level';

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(30; "Kind of Work"; Option)
        {
            Caption = 'Kind of Work';
            OptionCaption = ' ,Permanent,Temporary,Seasonal';
            OptionMembers = " ",Permanent,"Temporary",Seasonal;

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(31; "Out-of-Staff"; Boolean)
        {
            Caption = 'Out-of-Staff';

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(32; "Conditions of Work"; Option)
        {
            Caption = 'Conditions of Work';
            OptionCaption = ' ,Regular,Heavy,Unhealthy,Very Heavy,Other';
            OptionMembers = " ",Regular,Heavy,Unhealthy,"Very Heavy",Other;

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(33; "Calc Group Code"; Code[10])
        {
            Caption = 'Calc Group Code';
            TableRelation = "Payroll Calc Group";

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(34; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "Payroll Posting Group";

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(35; "Created By User"; Code[50])
        {
            Caption = 'Created By User';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(36; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(37; "Approved By User"; Code[50])
        {
            Caption = 'Approved By User';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(38; "Closed By User"; Code[50])
        {
            Caption = 'Closed By User';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(39; "Closing Date"; Date)
        {
            Caption = 'Closing Date';
            Editable = false;
        }
        field(40; "Organization Size"; Integer)
        {
            // CalcFormula = Count(Position WHERE (Parent Position No.=FIELD(No.)));
            Caption = 'Organization Size';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(41; "Trial Period Formula"; DateFormula)
        {
            Caption = 'Trial Period Formula';

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(42; "Reopened Date"; Date)
        {
            Caption = 'Reopened Date';
        }
        field(43; "Reopened by User"; Code[50])
        {
            Caption = 'Reopened by User';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(45; "Allow Overdraft"; Boolean)
        {
            Caption = 'Allow Overdraft';
        }
        field(50; "Budgeted Position"; Boolean)
        {
            Caption = 'Budgeted Position';

            trigger OnValidate()
            begin
                // CheckModify;
            end;
        }
        field(51; "Budgeted Position No."; Code[20])
        {
            Caption = 'Budgeted Position No.';
            // TableRelation = Position WHERE (Budgeted Position=CONST(Yes));

            trigger OnValidate()
            begin
                //CheckModify;
            end;
        }
        field(52; "Used Rate"; Decimal)
        {
            //CalcFormula = Sum(Position.Rate WHERE (Budgeted Position No.=FIELD(No.)));
            Caption = 'Used Rate';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(53; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(54; "Base Salary Amount"; Decimal)
        {
            Caption = 'Base Salary Amount';
            Editable = false;
        }
        field(55; "Monthly Salary Amount"; Decimal)
        {
            Caption = 'Monthly Salary Amount';
            Editable = false;
        }
        field(56; "Additional Salary Amount"; Decimal)
        {
            Caption = 'Additional Salary Amount';
            Editable = false;
        }
        field(57; "Budgeted Salary Amount"; Decimal)
        {
            Caption = 'Budgeted Salary Amount';
            Editable = false;
        }
        field(60; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(70; "Future Period Vacat. Post. Gr."; Code[20])
        {
            Caption = 'Future Period Vacat. Post. Gr.';
            TableRelation = "Payroll Posting Group";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Org. Unit Code", "Job Title Code", Status, "Budgeted Position", "Out-of-Staff", "Starting Date")
        {
            SumIndexFields = "Monthly Salary Amount", "Base Salary Amount", "Additional Salary Amount", "Budgeted Salary Amount", Rate;
        }
        key(Key3; "Org. Unit Code", "Job Title Code", "No.")
        {
        }
        key(Key4; "Parent Position No.", "No.")
        {
        }
        key(Key5; "Budgeted Position", "Budgeted Position No.")
        {
            SumIndexFields = "Budgeted Salary", Rate;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Job Title Code", "Job Title Name", "Org. Unit Code", "Org. Unit Name")
        {
        }
    }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin

    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Position: Record 50110;
        Position2: Record 50110;

        //NoSeriesMgt: Codeunit 396;
        Text000: Label 'Do you want really to delete position %1?';
        Text001: Label 'Do you want to approve %1?';
        Text002: Label '%1 %2 should be earlier than %3 %4.', Comment = '%1 = Org. Unit, %2 = Date, %3 = Position, %4 = Date';
        Text003: Label '%1 can exceed %2 for budget positions only.';


    /* procedure AssistEdit(OldPosition: Record 50110): Boolean
    begin
        WITH Position DO BEGIN
          Position := Rec;
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Position Nos.");
          IF NoSeriesMgt.SelectSeries(HumanResSetup."Position Nos.",OldPosition."No. Series","No. Series") THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Position Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Position;
            EXIT(TRUE);
          END;
        END;
    end;

    local procedure TestNoSeries()
    begin
        IF "Budgeted Position" THEN
          HumanResSetup.TESTFIELD("Budgeted Position Nos.")
        ELSE
          HumanResSetup.TESTFIELD("Position Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        IF "Budgeted Position" THEN
          EXIT(HumanResSetup."Budgeted Position Nos.");

        EXIT(HumanResSetup."Position Nos.");
    end;

    [Scope('Internal')]
    procedure CheckModify()
    begin
        IF Status > Status::Planned THEN
          FIELDERROR(Status);
    end;

    [Scope('Internal')]
    procedure Calculate()
    begin
        "Monthly Salary" := "Base Salary" + "Additional Salary";

        "Base Salary Amount" := "Base Salary" * Rate;
        "Additional Salary Amount" := "Additional Salary" * Rate;
        "Monthly Salary Amount" := "Monthly Salary" * Rate;
        "Budgeted Salary Amount" := "Budgeted Salary" * Rate;
    end;

    [Scope('Internal')]
    procedure Approve(IsChangeOrder: Boolean)
    var
        Confirmed: Boolean;
    begin
        IF NOT IsChangeOrder THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Use Staff List Change Orders",FALSE);
        END;

        TESTFIELD(Status,Status::Planned);

        TESTFIELD("Job Title Code");
        TESTFIELD("Org. Unit Code");
        TESTFIELD(Rate);
        TESTFIELD("Base Salary");
        TESTFIELD("Monthly Salary");
        TESTFIELD("Category Code");
        TESTFIELD("Calendar Code");
        TESTFIELD("Calc Group Code");
        TESTFIELD("Posting Group");
        TESTFIELD("Kind of Work");
        TESTFIELD("Conditions of Work");
        TESTFIELD(Rate);
        TESTFIELD("Starting Date");
        IF "Kind of Work" IN ["Kind of Work"::"Temporary","Kind of Work"::Seasonal] THEN
          TESTFIELD("Ending Date");

        IF "Org. Unit Code" <> '' THEN BEGIN
          OrganizationalUnit.GET("Org. Unit Code");
          OrganizationalUnit.TESTFIELD(Type,OrganizationalUnit.Type::Unit);
          IF NOT HumanResSetup."Use Staff List Change Orders" THEN
            OrganizationalUnit.TESTFIELD(Status,OrganizationalUnit.Status::Approved);
          OrganizationalUnit.TESTFIELD(Blocked,FALSE);
        END;

        Confirmed := TRUE;
        IF NOT IsChangeOrder THEN
          IF NOT CONFIRM(Text001,TRUE,"No.") THEN
            Confirmed := FALSE;

        IF Confirmed THEN BEGIN
          Status := Status::Approved;
          "Approved By User" := USERID;
          "Approval Date" := TODAY;
          MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure Reopen(IsChangeOrder: Boolean)
    begin
        IF NOT IsChangeOrder THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Use Staff List Change Orders",FALSE);
        END;

        TESTFIELD(Status,Status::Approved);
        IF "Budgeted Position" THEN BEGIN
          CALCFIELDS("Used Rate");
          TESTFIELD("Used Rate",0);
        END ELSE BEGIN
          CALCFIELDS("Filled Rate");
          TESTFIELD("Filled Rate",0);
        END;
        Status := Status::Planned;
        "Reopened by User" := USERID;
        "Reopened Date" := TODAY;
        MODIFY;
    end;

    [Scope('Internal')]
    procedure Close(IsChangeOrder: Boolean)
    begin
        IF NOT IsChangeOrder THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Use Staff List Change Orders",FALSE);
        END;

        TESTFIELD(Status,Status::Approved);
        IF "Budgeted Position" THEN BEGIN
          CALCFIELDS("Used Rate");
          IF "Used Rate" > 0 THEN BEGIN
            Position2.RESET;
            Position2.SETCURRENTKEY("Budgeted Position","Budgeted Position No.");
            Position2.SETRANGE("Budgeted Position",FALSE);
            Position2.SETRANGE("Budgeted Position No.","No.");
            IF Position2.FINDSET THEN
              REPEAT
                Position2.TESTFIELD(Status,Position2.Status::Closed);
              UNTIL Position2.NEXT = 0;
          END;
        END ELSE BEGIN
          CALCFIELDS("Filled Rate");
          TESTFIELD("Filled Rate",0);
        END;

        Status := Status::Closed;
        "Closed By User" := USERID;
        "Closing Date" := TODAY;
        MODIFY;
    end;

    [Scope('Internal')]
    procedure CopyContractTerms()
    begin
        IF ("Job Title Code" <> '') AND ("Org. Unit Code" <> '') AND ("Category Code" <> '') THEN BEGIN
          DefaultLaborContractTerms.RESET;
          DefaultLaborContractTerms.SETFILTER("Category Code",'%1|%2',"Category Code",'');
          DefaultLaborContractTerms.SETFILTER("Org. Unit Code",'%1|%2',"Org. Unit Code",'');
          DefaultLaborContractTerms.SETFILTER("Job Title Code",'%1|%2',"Job Title Code",'');
          DefaultLaborContractTerms.SETRANGE("Start Date",0D,"Starting Date");
          DefaultLaborContractTerms.SETFILTER("End Date",'%1|%2..',0D,"Ending Date");
          IF DefaultLaborContractTerms.FINDSET THEN
            REPEAT
              LaborContractTermsSetup.SETRANGE("Table Type",LaborContractTermsSetup."Table Type"::Position);
              LaborContractTermsSetup.SETRANGE("No.","No.");
              LaborContractTermsSetup.SETRANGE("Element Code",DefaultLaborContractTerms."Element Code");
              LaborContractTermsSetup.SETRANGE("Operation Type",DefaultLaborContractTerms."Operation Type");
              LaborContractTermsSetup.SETRANGE("Start Date",DefaultLaborContractTerms."Start Date");
              IF LaborContractTermsSetup.FINDFIRST THEN BEGIN
                IF LaborContractTermsSetup.Amount < DefaultLaborContractTerms.Amount THEN BEGIN
                  LaborContractTermsSetup.Amount := DefaultLaborContractTerms.Amount;
                  LaborContractTermsSetup.MODIFY;
                END;
                IF LaborContractTermsSetup.Quantity < DefaultLaborContractTerms.Quantity THEN BEGIN
                  LaborContractTermsSetup.Quantity := DefaultLaborContractTerms.Quantity;
                  LaborContractTermsSetup.MODIFY;
                END;
              END ELSE BEGIN
                LaborContractTermsSetup.INIT;
                LaborContractTermsSetup."Table Type" := LaborContractTermsSetup."Table Type"::Position;
                LaborContractTermsSetup."No." := "No.";
                LaborContractTermsSetup."Element Code" := DefaultLaborContractTerms."Element Code";
                LaborContractTermsSetup."Operation Type" := DefaultLaborContractTerms."Operation Type";
                LaborContractTermsSetup."Start Date" := DefaultLaborContractTerms."Start Date";
                LaborContractTermsSetup."End Date" := DefaultLaborContractTerms."End Date";
                LaborContractTermsSetup.Type := DefaultLaborContractTerms.Type;
                LaborContractTermsSetup.Amount := DefaultLaborContractTerms.Amount;
                LaborContractTermsSetup.Percent := DefaultLaborContractTerms.Percent;
                LaborContractTermsSetup.Quantity := DefaultLaborContractTerms.Quantity;
                LaborContractTermsSetup."Additional Salary" := DefaultLaborContractTerms."Additional Salary";
                LaborContractTermsSetup.INSERT;
              END;
            UNTIL DefaultLaborContractTerms.NEXT = 0;
        END;
    end;


    procedure ShowContractTerms()
    var
        LaborContractTermsSetup: Record "33055876";
        PayrollElement: Record 50109;
    //    LaborContractTermsSetupPage: Page "33055971";
    begin
        LaborContractTermsSetup.SETRANGE("Table Type",LaborContractTermsSetup."Table Type"::Position);
        LaborContractTermsSetup.SETRANGE("No.","No.");
        LaborContractTermsSetupPage.SETTABLEVIEW(LaborContractTermsSetup);
        LaborContractTermsSetupPage.RUNMODAL;

        IF Status = Status::Planned THEN BEGIN
          "Additional Salary" := 0;
          LaborContractTermsSetup.SETRANGE(Type,LaborContractTermsSetup.Type::"Payroll Element");
          IF LaborContractTermsSetup.FIND('-') THEN
            REPEAT
              PayrollElement.GET(LaborContractTermsSetup."Element Code");
              IF PayrollElement.Type = PayrollElement.Type::Wage THEN
                "Additional Salary" := "Additional Salary" + LaborContractTermsSetup.Amount;
            UNTIL LaborContractTermsSetup.NEXT = 0;

          IF "Additional Salary" <> xRec."Additional Salary" THEN BEGIN
            VALIDATE("Additional Salary");
            MODIFY;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure CopyPosition(CreationDate: Date): Code[20]
    var
        NewPosition: Record "33055880";
        NewLaborContractTermsSetup: Record "33055876";
    begin
        NewPosition.INIT;
        NewPosition.TRANSFERFIELDS(Rec,FALSE);
        NewPosition.Status := NewPosition.Status::Planned;
        NewPosition."Created By User" := USERID;
        NewPosition."Creation Date" := CreationDate;
        NewPosition."Approved By User" := '';
        NewPosition."Approval Date" := 0D;
        NewPosition."Closed By User" := '';
        NewPosition."Closing Date" := 0D;
        NewPosition."No." := '';
        NewPosition.INSERT(TRUE);

        LaborContractTermsSetup.RESET;
        LaborContractTermsSetup.SETRANGE("Table Type",LaborContractTermsSetup."Table Type"::Position);
        LaborContractTermsSetup.SETRANGE("No.","No.");
        IF LaborContractTermsSetup.FINDSET THEN
          REPEAT
            NewLaborContractTermsSetup := LaborContractTermsSetup;
            NewLaborContractTermsSetup."No." := NewPosition."No.";
            NewLaborContractTermsSetup.INSERT;
          UNTIL LaborContractTermsSetup.NEXT = 0;

        EXIT(NewPosition."No.");
    end; */
}

