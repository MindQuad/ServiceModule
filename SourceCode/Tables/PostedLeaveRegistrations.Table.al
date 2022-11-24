table 50111 "Posted Leave Registrations"
{
    /* DrillDownPageID = 60107;
    LookupPageID = 60107; */

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(4; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(5; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            var
            //EmpLeaveSetup: Record "33055822";
            begin
            end;
        }
        field(6; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Human Resource Unit of Measure";
        }
        field(11; Comment; Boolean)
        {
            /* CalcFormula = Exist("Human Resource Comment Line" WHERE(Table Name=CONST(Employee Absence),
                                                                     No.=FIELD(Entry No.))); */
            Caption = 'Comment';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(12; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(60000; "No. Series"; Code[10])
        {
            Description = 'HRnP-HR5.0';
        }
        field(60001; "Leave Approved"; Boolean)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;

            /* trigger OnValidate()
            var
                EmpLeaveSetup: Record "33055822";
                Leaves: Record "33055826";
                LeaveRegLines: Record "33055829";
                CauseofAbsence: Record "5206";
                TempDate: Date;
                LeaveApplicableDate: Date;
                NoofDaysAvailed: Integer;
                NoofDaysLeft: Integer;
                NoofDaysApproved: Integer;
            begin
            end; */
        }
        field(60002; "Leave Availed"; Boolean)
        {
            Description = 'HRnP-HR5.0';

            /*  trigger OnValidate()
             begin
                 //Check Blank date of return
                 TESTFIELD("Date of Return");
                 TESTFIELD("Leave Approved",TRUE);
                 TESTFIELD(Cancelled,FALSE);

                 IF "Date of Return" < "Approve From Date" THEN
                   ERROR('Date of Return cannot be lesser than %2',"Approve From Date");

                 EmpLeaveSetup.GET("Employee No.","Cause of Absence Code");
                 IF EmpLeaveSetup."Leave working days" THEN BEGIN
                   "No. of Days Availed" := DateFunctions.NoOfWorkingDays("Approve From Date",("Date of Return"-1));
                   Quantity := DateFunctions.NoOfWorkingDays("Approve From Date","Approve To Date");
                 END ELSE BEGIN
                   "No. of Days Availed" := "Date of Return" - "Approve From Date";
                   Quantity := "Approve To Date" - "Approve From Date" + 1;
                 END;
             end; */
        }
        field(60003; "No. of Days Approved"; Decimal)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60004; "No. of Days Availed"; Decimal)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60005; "Days Balance"; Decimal)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60006; "No. of Days Applied"; Decimal)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60007; "Date Approved"; Date)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60008; "Date of Return"; Date)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60009; "Leave Approved By"; Code[10])
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60015; Destination; Option)
        {
            BlankZero = true;
            Description = 'HRnP-HR5.0';
            OptionMembers = " ","Local","Home Country",Foreign;
        }
        field(60016; "Leave Address"; Text[30])
        {
            Description = 'HRnP-HR5.0';
        }
        field(60017; "Approve From Date"; Date)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60018; "Approve To Date"; Date)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60020; "Cancelled Date"; Date)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60021; "Cancelled By"; Code[10])
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60022; Cancelled; Boolean)
        {
            Description = 'HRnP-HR5.0';
            Editable = false;
        }
        field(60028; "With Payment"; Option)
        {
            Description = 'HRnP-HR5.0';
            OptionCaption = 'With Payment,Without Payment';
            OptionMembers = "With Payment","Without Payment";
        }
        field(60030; "Full and Final"; Boolean)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60033; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(60034; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(60035; Name; Text[30])
        {
            Description = 'HRnP-HR5.0';
        }
        field(60036; "Document Date"; Date)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60037; "Last Date Leave Sal. Issued"; Date)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60038; "Last Salary Date"; Date)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60044; "Notice Period"; DateFormula)
        {
            Description = 'HRnP-HR5.0';
        }
        field(60045; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = FILTER(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(60046; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 3 Code");
            end;
        }
        field(60047; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 3 Code");
            end;
        }
        field(60048; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 3 Code");
            end;
        }
        field(60049; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 3 Code");
            end;
        }
        field(60050; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Description = 'HRnP-HR5.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(8,"Shortcut Dimension 3 Code");
            end;
        }
        field(60060; "Approved Leave"; Boolean)
        {
            Description = 'HR1.0';
        }
        field(60061; Open; Boolean)
        {
        }
        field(60062; "Days Availed"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Cause of Absence Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRSetup: Record "Human Resources Setup";
    //EmpLeaveSetup: Record "33055822";
    //DimMgt: Codeunit 408;
    //DateFunctions: Codeunit "33055728";

    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        /*
        DimMgt.ValidateDimValueCode(FieldNo,ShortcutDimCode);
        DimMgt.SaveDocDim(DATABASE::"Posted Leave Registrations",DocDim."Document Type"::" ","Entry No.",0,FieldNo,ShortcutDimCode);
        */

    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure ShowDimensions()
    begin
        /*
        PostedDocDim.RESET;
        PostedDocDim.SETRANGE("Table ID",DATABASE::"Posted Leave Registrations");
        PostedDocDim.SETRANGE("Document No.","Entry No.");
        PostedDocDim.SETRANGE("Line No.",0);
        PostedDocDims.SETTABLEVIEW(PostedDocDim);
        PostedDocDims.RUNMODAL;
        */

    end;
}

