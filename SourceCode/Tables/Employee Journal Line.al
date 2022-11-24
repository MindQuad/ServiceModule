table 50201 "Employee Journal Line"
{
    // version WRHRPR10.00 AE

    Caption = 'Employee Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Employee Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Employee Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate();
            begin
                Employee.GET("Employee No.");
                // //"Posting Group" := Employee."Posting Group";

                //"Contract No." := Employee."Contract No.";
                "Person No." := Employee."Person No.";
                IF "Starting Date" = 0D THEN BEGIN
                    //  "Calendar Code" := Employee."Calendar Code";
                    // "Position No." := Employee."Position No.";
                END ELSE
                    FIELDERROR("Starting Date");

                "Relative Person No." := '';
                "Applies-to Entry" := 0;

                CreateDim(
                  DATABASE::Employee, "Employee No.",
                  DATABASE::"Payroll Element", "Element Code");
            end;
        }
        field(5; "Element Code"; Code[20])
        {
            Caption = 'Element Code';
            TableRelation = "Payroll Element";

            trigger OnValidate();
            begin
                PayrollElement.GET("Element Code");
                Description := PayrollElement.Description;
                IF PayrollElement."Payroll Posting Group" <> '' THEN
                    VALIDATE("Posting Group", PayrollElement."Payroll Posting Group");

                CreateDim(
                  DATABASE::"Payroll Element", "Element Code",
                  DATABASE::Employee, "Employee No.")
            end;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate();
            begin
                IF "Posting Date" <> 0D THEN
                    "Period Code" :=
                      PayrollPeriod.PeriodByDate("Posting Date");
            end;
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate();
            begin
                TESTFIELD("Employee No.");
                IF "Starting Date" <> 0D THEN BEGIN

                    "Calendar Code" := EmployeeJobEntry."Calendar Code";
                    "Position No." := EmployeeJobEntry."Position No.";
                END;
                PayrollElement.GET("Element Code");
                IF PayrollElement."Bonus Type" <> 0 THEN
                    "Wage Period From" := PayrollPeriod.PeriodByDate("Starting Date");
            END;

        }
        field(8; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate();
            begin
                PayrollElement.GET("Element Code");
                IF PayrollElement."Bonus Type" <> 0 THEN
                    "Wage Period To" := PayrollPeriod.PeriodByDate("Ending Date");
            end;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 5;
        }
        field(10; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "Payroll Posting Group";
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(12; "Calendar Code"; Code[10])
        {
            Caption = 'Calendar Code';
            Editable = false;
            TableRelation = "Payroll Calendar";
        }
        field(13; "Payroll Calc Group"; Code[10])
        {
            Caption = 'Payroll Calc Group';
            Editable = false;
            TableRelation = "Payroll Calc Group";
        }
        field(14; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            Editable = false;
        }
        field(15; "HR Order No."; Code[20])
        {
            Caption = 'HR Order No.';
        }
        field(16; "HR Order Date"; Date)
        {
            Caption = 'HR Order Date';
        }
        field(17; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(19; "Period Code"; Code[10])
        {
            Caption = 'Period Code';
            TableRelation = "Payroll Period";
        }
        field(20; "Position No."; Code[20])
        {
            Caption = 'Position No.';
            Editable = false;
            TableRelation = Position;
        }
        field(21; "Person No."; Code[20])
        {
            Caption = 'Person No.';
            Editable = false;
            TableRelation = Person;
        }
        field(23; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(24; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(25; "Time Activity Code"; Code[10])
        {
            Caption = 'Time Activity Code';
            TableRelation = "Time Activity";

            trigger OnValidate();
            begin
                IF TimeActivity.GET("Time Activity Code") THEN
                    IF ("Element Code" = '') AND (TimeActivity."Element Code" <> '') THEN
                        VALIDATE("Element Code", TimeActivity."Element Code");
            end;
        }
        field(26; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(28; "Post Action"; Option)
        {
            Caption = 'Post Action';
            OptionCaption = 'Add,Update,Close';
            OptionMembers = Add,Update,Close;
        }
        field(29; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';

            trigger OnLookup();
            var
                EmployeeLedgEntry: Record "Employee Ledger Entry";
                EmployeeLedgEntries: Page "Employee Ledger Entries";
            begin
                IF "Post Action" <> "Post Action"::Add THEN BEGIN
                    EmployeeLedgEntry.RESET;
                    EmployeeLedgEntry.SETCURRENTKEY("Employee No.", "Element Code");
                    EmployeeLedgEntry.SETRANGE("Employee No.", "Employee No.");
                    EmployeeLedgEntry.SETRANGE("Element Code", "Element Code");
                    EmployeeLedgEntries.SETTABLEVIEW(EmployeeLedgEntry);
                    EmployeeLedgEntries.LOOKUPMODE(TRUE);
                    IF EmployeeLedgEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        EmployeeLedgEntries.GETRECORD(EmployeeLedgEntry);
                        VALIDATE("Applies-to Entry", EmployeeLedgEntry."Entry No.");
                    END;
                END ELSE
                    TESTFIELD("Post Action", "Post Action"::Add);
            end;

            trigger OnValidate();
            var
                EmployeeLedgEntry: Record "Employee Ledger Entry";
            begin
                IF "Applies-to Entry" <> 0 THEN
                    EmployeeLedgEntry.GET("Applies-to Entry");
            end;
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = '" ,Vacation,Sick Leave,Travel,Other Absence"';
            OptionMembers = " ",Vacation,"Sick Leave",Travel,"Other Absence";
        }
        field(31; "Vacation Type"; Option)
        {
            Caption = 'Vacation Type';
            OptionCaption = '" ,Regular,Additional,Education,Childcare,Other"';
            OptionMembers = " ",Regular,Additional,Education,Childcare,Other;
        }
        field(32; "Payment Days"; Decimal)
        {
            Caption = 'Payment Days';
        }
        field(33; "Payment Percent"; Decimal)
        {
            Caption = 'Payment Percent';
        }
        field(34; "Sick Leave Type"; Option)
        {
            Caption = 'Sick Leave Type';
            OptionCaption = '" ,Common Disease,Common Injury,Professional Disease,Work Injury,Family Member Care,Post Vaccination,Quarantine,Sanatory Cure,Pregnancy Leave,Child Care 1.5 years,Child Care 3 years"';
            OptionMembers = " ","Common Disease","Common Injury","Professional Disease","Work Injury","Family Member Care","Post Vaccination",Quarantine,"Sanatory Cure","Pregnancy Leave","Child Care 1.5 years","Child Care 3 years";
        }
        field(35; "Child Grant Type"; Option)
        {
            Caption = 'Child Grant Type';
            OptionCaption = '0,1,2,3,4,5';
            OptionMembers = "0","1","2","3","4","5";
        }
        field(36; "AE Period From"; Code[10])
        {
            Caption = 'AE Period From';
            TableRelation = "Payroll Period";

            trigger OnValidate();
            begin
                IF ("AE Period From" <> '') AND ("AE Period To" <> '') THEN
                    IF "AE Period From" > "AE Period To" THEN
                        ERROR(Text001, FIELDCAPTION("AE Period To"), FIELDCAPTION("AE Period From"));

                IF ("Period Code" <> '') AND ("AE Period From" <> '') THEN
                    IF "AE Period From" > "Period Code" THEN
                        ERROR(Text001, FIELDCAPTION("Period Code"), FIELDCAPTION("AE Period From"));
            end;
        }
        field(37; "AE Period To"; Code[10])
        {
            Caption = 'AE Period To';
            TableRelation = "Payroll Period";

            trigger OnValidate();
            begin
                IF ("AE Period From" <> '') AND ("AE Period To" <> '') THEN
                    IF "AE Period From" > "AE Period To" THEN
                        ERROR(Text001, FIELDCAPTION("AE Period To"), FIELDCAPTION("AE Period From"));

                IF ("Period Code" <> '') AND ("AE Period To" <> '') THEN
                    IF "AE Period To" > "Period Code" THEN
                        ERROR(Text001, FIELDCAPTION("Period Code"), FIELDCAPTION("AE Period To"));
            end;
        }
        field(38; "Wage Period To"; Code[10])
        {
            Caption = 'Wage Period To';
            TableRelation = "Payroll Period";
        }
        field(39; "Wage Period From"; Code[10])
        {
            Caption = 'Wage Period From';
            TableRelation = "Payroll Period";
        }
        field(43; "Days Not Paid"; Decimal)
        {
            Caption = 'Days Not Paid';
        }
        field(45; "Relative Person No."; Code[20])
        {
            Caption = 'Relative Person No.';
            TableRelation = Person;

            trigger OnLookup();
            var
                EmployeeRelative: Record 5205;
            begin
                EmployeeRelative.RESET;
                EmployeeRelative.SETRANGE("Employee No.", "Person No.");
                IF PAGE.RUNMODAL(0, EmployeeRelative) = ACTION::LookupOK THEN BEGIN
                    EmployeeRelative.TESTFIELD("Relative's Employee No.");
                    VALIDATE("Relative Person No.", EmployeeRelative."Relative's Employee No.");
                END;
            end;
        }
        field(46; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnValidate();
            begin
                IF "HR Order No." = '' THEN
                    "HR Order No." := "Document No.";
            end;
        }
        field(47; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate();
            begin
                IF "HR Order Date" = 0D THEN
                    "HR Order Date" := "Document Date";
            end;
        }
        field(48; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(49; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(50; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(51; "Salary Indexation"; Boolean)
        {
            Caption = 'Salary Indexation';
        }
        field(52; "Depends on Salary Element"; Code[20])
        {
            Caption = 'Depends on Salary Element';
            TableRelation = "Payroll Element" WHERE(Type = CONST(Wage));
        }
        field(53; "Payment Source"; Option)
        {
            Caption = 'Payment Source';
            OptionCaption = 'Employeer,FSI';
            OptionMembers = Employeer,FSI;
        }
        field(54; Terminated; Boolean)
        {
            Caption = 'Terminated';
            Editable = false;
        }
        field(55; "External Document No."; Text[30])
        {
            Caption = 'External Document No.';
        }
        field(56; "External Document Date"; Date)
        {
            Caption = 'External Document Date';
        }
        field(57; "External Document Issued By"; Text[50])
        {
            Caption = 'External Document Issued By';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;

            trigger OnValidate();
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
    end;

    var
        Employee: Record 5200;
        PayrollElement: Record "Payroll Element";
        TimeActivity: Record "Time Activity";
        EmployeeJnlTemplate: Record "Employee Journal Template";
        EmployeeJnlBatch: Record "Employee Journal Batch";
        EmployeeJnlLine: Record "Employee Journal Line";
        PayrollPeriod: Record "Payroll Period";
        EmployeeJobEntry: Record "Employee Job Entry";
        NoSeriesMgt: Codeunit 396;
        DimMgt: Codeunit 408;
        Text001: Label '%1 should be greater than %2.';

    procedure EmptyLine(): Boolean;
    begin
        EXIT(("Employee No." = '') AND ("Element Code" = ''));
    end;

    procedure SetUpNewLine(LastEmployeeJnlLine: Record "Employee Journal Line")

    begin
        EmployeeJnlTemplate.GET("Journal Template Name");
        EmployeeJnlBatch.GET("Journal Template Name", "Journal Batch Name");
        EmployeeJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        EmployeeJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        IF EmployeeJnlLine.FINDFIRST THEN BEGIN
            "Posting Date" := LastEmployeeJnlLine."Posting Date";
            "HR Order Date" := LastEmployeeJnlLine."Posting Date";
            "HR Order No." := LastEmployeeJnlLine."HR Order No.";
        END ELSE BEGIN
            "Posting Date" := WORKDATE;
            "HR Order Date" := WORKDATE;
            IF EmployeeJnlBatch."No. Series" <> '' THEN BEGIN
                CLEAR(NoSeriesMgt);
                "HR Order No." := NoSeriesMgt.TryGetNextNo(EmployeeJnlBatch."No. Series", "Posting Date");
            END;
        END;
        "Source Code" := EmployeeJnlTemplate."Source Code";
        "Reason Code" := EmployeeJnlBatch."Reason Code";
        "Posting No. Series" := EmployeeJnlBatch."Posting No. Series";
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]);
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        //Win513++
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    //Win513--
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        //Win513++
        // "Dimension Set ID" :=
        //   DimMgt.GetDefaultDimID(
        //     TableID, No, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        "Dimension Set ID" :=
            DimMgt.GetDefaultDimID(DefaultDimSource, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        //Win513--   
    end;
}

