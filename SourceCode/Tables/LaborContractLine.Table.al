table 50107 "Labor Contract Line"
{
    Caption = 'Labor Contract Line';

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Labor Contract";
        }
        field(2; "Supplement No."; Code[10])
        {
            Caption = 'Supplement No.';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
                TESTFIELD("Operation Type", "Operation Type"::Transfer);
            end;
        }
        field(3; "Operation Type"; Option)
        {
            Caption = 'Operation Type';
            OptionCaption = 'Hire,Transfer,Combination,Dismissal';
            OptionMembers = Hire,Transfer,Combination,Dismissal;

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);

                GetContract;
                LaborContract.TESTFIELD("Person No.");
                "Person No." := LaborContract."Person No.";

                CASE "Operation Type" OF
                    "Operation Type"::Hire:
                        BEGIN
                            LaborContract.TESTFIELD("Starting Date");
                            "Starting Date" := LaborContract."Starting Date";
                            "Ending Date" := LaborContract."Ending Date";
                        END;
                    "Operation Type"::Dismissal:
                        BEGIN
                            LaborContract.TESTFIELD("Ending Date");
                            "Starting Date" := LaborContract."Ending Date";
                            "Ending Date" := LaborContract."Ending Date";
                            Employee.GET(LaborContract."Employee No.");
                            //"Position No." := Employee."Position No.";
                        END;
                END;
            end;
        }
        field(4; "Person No."; Code[20])
        {
            Caption = 'Person No.';
            TableRelation = Person;

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(6; "Order Date"; Date)
        {
            Caption = 'Order Date';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);

                GetContract;
                IF "Operation Type" = "Operation Type"::Hire THEN BEGIN
                    LaborContract.TESTFIELD("Starting Date");
                    "Starting Date" := LaborContract."Starting Date";
                END;
                IF "Operation Type" = "Operation Type"::Dismissal THEN
                    TESTFIELD("Starting Date", 0D);

                IF ("Starting Date" <> 0D) AND ("Starting Date" < LaborContract."Starting Date") THEN
                    ERROR(Text14704,
                      "Starting Date",
                      LaborContract.FIELDCAPTION("Starting Date"),
                      LaborContract.TABLECAPTION);
            end;
        }
        field(8; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                CheckContractStatus;
                IF "Operation Type" <> "Operation Type"::Combination THEN
                    TESTFIELD(Status, Status::Open);

                GetContract;
                IF "Operation Type" = "Operation Type"::Dismissal THEN BEGIN
                    LaborContract.TESTFIELD("Ending Date");
                    TESTFIELD("Ending Date", LaborContract."Ending Date");
                END ELSE
                    IF ("Ending Date" <> 0D) AND (LaborContract."Ending Date" <> 0D) AND
                       ("Ending Date" > LaborContract."Ending Date")
                    THEN
                        ERROR(Text14705,
                          "Ending Date",
                          LaborContract.FIELDCAPTION("Ending Date"),
                          LaborContract.TABLECAPTION);

                ValidateFieldValue(CurrFieldNo);
            end;
        }
        field(10; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Approved';
            OptionMembers = Open,Approved;
        }
        field(11; "Position No."; Code[20])
        {
            Caption = 'Position No.';
            TableRelation = Position;

            trigger OnLookup()
            var
                TempPosition: Record 50110 temporary;
            begin
                CASE Status OF
                    Status::Open:
                        BEGIN
                            TESTFIELD(Status, Status::Open);
                            IF "Operation Type" = "Operation Type"::Hire THEN BEGIN
                                GetContract;
                                LaborContract.TESTFIELD("Starting Date");
                                "Starting Date" := LaborContract."Starting Date";
                            END;
                            IF "Operation Type" = "Operation Type"::Combination THEN
                                TESTFIELD("Ending Date");

                            GetContract;

                            TempPosition.DELETEALL;
                            TempPosition.RESET;

                            Position.RESET;
                            Position.SETRANGE(Status, Position.Status::Approved);
                            Position.SETRANGE("Budgeted Position", FALSE);
                            CASE LaborContract."Contract Type" OF
                                LaborContract."Contract Type"::"Labor Contract":
                                    Position.SETRANGE("Out-of-Staff", FALSE);
                                LaborContract."Contract Type"::"Civil Contract":
                                    Position.SETRANGE("Out-of-Staff", TRUE);
                            END;
                            Position.SETRANGE("Starting Date", 0D, "Starting Date");
                            Position.SETFILTER("Ending Date", '%1|%2..', 0D, "Starting Date");
                            IF Position.FINDSET THEN
                                REPEAT
                                    Position.CALCFIELDS("Filled Rate");
                                    IF Position.Rate - Position."Filled Rate" >= "Position Rate" THEN BEGIN
                                        TempPosition := Position;
                                        TempPosition.INSERT;
                                    END;
                                UNTIL Position.NEXT = 0;

                            IF "Position No." <> '' THEN
                                TempPosition.GET("Position No.");
                            /*               IF PAGE.RUNMODAL(PAGE::"Open Positions", TempPosition) = ACTION::LookupOK THEN
                                              VALIDATE("Position No.", TempPosition."No."); */
                        END;
                    Status::Approved:
                        BEGIN
                            Position.RESET;
                            Position.GET("Position No.");
                            PAGE.RUNMODAL(0, Position);
                        END;
                END;
            end;

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
                IF "Position No." <> '' THEN BEGIN
                    TESTFIELD("Starting Date");
                    ValidateFieldValue(CurrFieldNo);

                    Position.GET("Position No.");
                    Position.TESTFIELD(Status, Position.Status::Approved);
                    Position.TESTFIELD("Budgeted Position", FALSE);
                    Position.TESTFIELD("Job Title Code");
                    Position.TESTFIELD("Org. Unit Code");
                    Position.TESTFIELD("Category Code");
                    Position.TESTFIELD("Kind of Work");
                    Position.TESTFIELD("Conditions of Work");
                    Position.TESTFIELD("Calc Group Code");
                    Position.TESTFIELD("Posting Group");
                    Position.TESTFIELD(Rate);
                    Position.CALCFIELDS("Filled Rate");

                    GetContract;
                    CASE LaborContract."Contract Type" OF
                        LaborContract."Contract Type"::"Labor Contract":
                            Position.TESTFIELD("Out-of-Staff", FALSE);
                        LaborContract."Contract Type"::"Civil Contract":
                            Position.TESTFIELD("Out-of-Staff", TRUE);
                    END;

                    IF (("Operation Type" = "Operation Type"::Hire) OR ("Operation Type" = "Operation Type"::Transfer)) AND
                       ("Position Rate" = 0)
                    THEN
                        "Position Rate" := Position.Rate;

                    IF "Position No." <> xRec."Position No." THEN BEGIN
                        LaborContractTerms.RESET;
                        LaborContractTerms.SETRANGE("Labor Contract No.", "Contract No.");
                        LaborContractTerms.SETRANGE("Operation Type", "Operation Type");
                        LaborContractTerms.SETRANGE("Supplement No.", "Supplement No.");
                        IF NOT LaborContractTerms.ISEMPTY THEN
                            IF CONFIRM(Text14706, TRUE, LaborContractTerms.TABLECAPTION) THEN BEGIN
                                LaborContractTerms.DELETEALL;
                                CheckFillRate;
                            END ELSE
                                "Position No." := xRec."Position No."
                        ELSE
                            CheckFillRate;
                    END;

                    IF Position."Use Trial Period" THEN BEGIN
                        Position.TESTFIELD("Trial Period Formula");
                        "Trial Period Start Date" := "Starting Date";
                        "Trial Period End Date" := CALCDATE(Position."Trial Period Formula", "Starting Date");
                        "Trial Period Description" := Position."Trial Period Description";
                    END ELSE BEGIN
                        "Trial Period Start Date" := 0D;
                        "Trial Period End Date" := 0D;
                        "Trial Period Description" := '';
                    END;
                END ELSE BEGIN
                    "Position Rate" := 0;

                    "Trial Period Start Date" := 0D;
                    "Trial Period End Date" := 0D;
                    "Trial Period Description" := '';

                    LaborContractTerms.RESET;
                    LaborContractTerms.SETRANGE("Labor Contract No.", "Contract No.");
                    LaborContractTerms.SETRANGE("Operation Type", "Operation Type");
                    LaborContractTerms.SETRANGE("Supplement No.", "Supplement No.");
                    IF NOT LaborContractTerms.ISEMPTY THEN
                        LaborContractTerms.DELETEALL;
                END;
            end;
        }
        field(14; "Dismissal Reason"; Code[10])
        {
            Caption = 'Dismissal Reason';
            TableRelation = "Grounds for Termination";

            trigger OnValidate()
            begin
                CheckContractStatus;

                TESTFIELD(Status, Status::Open);
                TESTFIELD("Operation Type", "Operation Type"::Dismissal);
                ValidateFieldValue(CurrFieldNo);

                IF "Dismissal Reason" <> xRec."Dismissal Reason" THEN BEGIN
                    //IF TerminationGround.GET(xRec."Dismissal Reason") THEN BEGIN
                    LaborContractTerms.RESET;
                    LaborContractTerms.SETRANGE("Labor Contract No.", "Contract No.");
                    LaborContractTerms.SETRANGE("Operation Type", "Operation Type");
                    LaborContractTerms.SETRANGE("Supplement No.", "Supplement No.");
                    //  LaborContractTerms.SETRANGE("Element Code", TerminationGround."Element Code");
                    LaborContractTerms.DELETEALL;
                END;
                //  IF TerminationGround.GET("Dismissal Reason") THEN
                //    IF TerminationGround."Element Code" <> '' THEN BEGIN
                LaborContractTerms.RESET;
                LaborContractTerms."Labor Contract No." := "Contract No.";
                LaborContractTerms."Operation Type" := "Operation Type";
                LaborContractTerms."Supplement No." := "Supplement No.";
                LaborContractTerms."Line Type" := LaborContractTerms."Line Type"::"Payroll Element";
                //            LaborContractTerms.VALIDATE("Element Code", TerminationGround."Element Code");
                LaborContractTerms.VALIDATE("Starting Date", "Starting Date");
                LaborContractTerms.VALIDATE("Ending Date", "Ending Date");
                LaborContractTerms.VALIDATE(Quantity, 1);
                Employee.GET(LaborContract."Employee No.");
                //              Position.GET(Employee."Position No.");
                LaborContractTerms.VALIDATE("Posting Group", Position."Posting Group");
                LaborContractTerms.INSERT;
            END;
            //END;
            //end;
        }
        field(15; "Dismissal Document"; Text[50])
        {
            Caption = 'Dismissal Document';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
                ValidateFieldValue(CurrFieldNo);
            end;
        }
        field(16; "Position Rate"; Decimal)
        {
            Caption = 'Position Rate';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(17; "Salary Terms"; Boolean)
        {
            CalcFormula = Exist("Labor Contract Terms" WHERE("Labor Contract No." = FIELD("Contract No."),
                                                              "Supplement No." = FIELD("Supplement No."),
                                                              "Operation Type" = FIELD("Operation Type"),
                                                              "Line Type" = CONST("Payroll Element")));
            Caption = 'Salary Terms';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Vacation Terms"; Boolean)
        {
            CalcFormula = Exist("Labor Contract Terms" WHERE("Labor Contract No." = FIELD("Contract No."),
                                                              "Supplement No." = FIELD("Supplement No."),
                                                              "Operation Type" = FIELD("Operation Type"),
                                                              "Line Type" = CONST("Vacation Accrual")));
            Caption = 'Vacation Terms';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(22; "Order No."; Code[20])
        {
            Caption = 'Order No.';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(30; "Trial Period Start Date"; Date)
        {
            Caption = 'Trial Period Start Date';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
                ValidateFieldValue(CurrFieldNo);
            end;
        }
        field(31; "Trial Period End Date"; Date)
        {
            Caption = 'Trial Period End Date';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
                ValidateFieldValue(CurrFieldNo);
            end;
        }
        field(32; "Trial Period Description"; Text[50])
        {
            Caption = 'Trial Period Description';

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
                ValidateFieldValue(CurrFieldNo);
            end;
        }
        field(35; "Territorial Conditions"; Code[20])
        {
            Caption = 'Territorial Conditions';
            //TableRelation = "General Directory".Code WHERE(Type = FILTER(Territor. Condition));

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(36; "Special Conditions"; Code[20])
        {
            Caption = 'Special Conditions';
            //TableRelation = "General Directory".Code WHERE(Type = FILTER(Special Work Condition));

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(37; "Record of Service Reason"; Code[20])
        {
            Caption = 'Calc Seniority: Reason';
            //TableRelation = "General Directory".Code WHERE(Type = FILTER(Countable Service Reason));

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(38; "Record of Service Additional"; Code[20])
        {
            Caption = 'Calc Seniority: Addition';
            //TableRelation = "General Directory".Code WHERE(Type = FILTER(Countable Service Addition));

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(39; "Service Years Reason"; Code[20])
        {
            Caption = 'Long Service: Reason';
            //TableRelation = "General Directory".Code WHERE(Type = FILTER(Long Service Reason));

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(40; "Service Years Additional"; Code[20])
        {
            Caption = 'Long Service: Addition';
            //TableRelation = "General Directory".Code WHERE(Type = FILTER("Long Service Addition"));

            trigger OnValidate()
            begin
                CheckContractStatus;
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Contract No.", "Operation Type", "Supplement No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);
        CheckContractStatus;

        LaborContractTerms.RESET;
        LaborContractTerms.SETRANGE("Labor Contract No.", "Contract No.");
        LaborContractTerms.SETRANGE("Operation Type", "Operation Type");
        LaborContractTerms.SETRANGE("Supplement No.", "Supplement No.");
        LaborContractTerms.DELETEALL;
    end;

    trigger OnInsert()
    begin
        CheckContractStatus;

        IF ("Operation Type" = "Operation Type"::Transfer) AND ("Supplement No." = '') THEN
            IF xRec."Supplement No." = '' THEN
                "Supplement No." := '001'
            ELSE
                "Supplement No." := INCSTR(xRec."Supplement No.");

        VALIDATE("Operation Type");

        LaborContractLine.RESET;
        LaborContractLine.SETRANGE("Contract No.", "Contract No.");
        IF LaborContractLine.ISEMPTY THEN
            TESTFIELD("Operation Type", "Operation Type"::Hire);
    end;

    trigger OnRename()
    begin
        ERROR('');
    end;

    var
        LaborContract: Record "Labor Contract";
        LaborContractLine: Record "Labor Contract Line";
        LaborContractTerms: Record "Labor Contract Terms";
        Position: Record 50110;
        Text14700: Label 'Filled Rate must be 0 for position %1.';
        Text14704: Label '%1 should not be earlier than %2 in %3.';
        Text14705: Label '%1 should not be later than %2 in %3.';
        Text14706: Label '%1 will be deleted. Continue?';
        Text14707: Label 'First contract line must have Operation Type %1.';
        Text14708: Label '%1 cannot be changed if Operation Type is %2.';
        Text14709: Label 'Amount and Quantity should not be equal 0 simultaneously.';
        Employee: Record 5200;
    //    TerminationGround: Record "5217";


    procedure GetContract()
    begin
        IF LaborContract."No." <> "Contract No." THEN
            LaborContract.GET("Contract No.");
    end;


    procedure CheckPosition(LaborContractLine: Record 50107)
    begin
        //Win513++
        //WITH LaborContractLine DO BEGIN
        //Win513--
        Position.GET("Position No.");
        Position.TESTFIELD("Job Title Code");
        Position.TESTFIELD("Org. Unit Code");
        Position.TESTFIELD(Status, Position.Status::Approved);
        Position.TESTFIELD(Rate);
        Position.TESTFIELD("Base Salary");
        Position.TESTFIELD("Monthly Salary");
        Position.TESTFIELD("Category Code");
        Position.TESTFIELD("Statistical Group Code");
        Position.TESTFIELD("Calendar Code");
        Position.TESTFIELD("Calc Group Code");
        Position.TESTFIELD("Posting Group");
        Position.TESTFIELD("Kind of Work");
        Position.TESTFIELD("Conditions of Work");
        Position.TESTFIELD("Starting Date");
        CheckFillRate;
        //Win513++
        //END;
        //Win513--
    end;


    procedure CheckFillRate()
    begin
        Position.CALCFIELDS("Filled Rate");
        IF Position."Filled Rate" <> 0 THEN
            ERROR(Text14700, "Position No.");
    end;


    procedure CheckLine()
    var
        Vendor: Record 23;
        Person: Record 50112;
    begin
        GetContract;
        LaborContract.TESTFIELD("Person No.");
        LaborContract.TESTFIELD("Starting Date");

        TESTFIELD("Position Rate");
        TESTFIELD("Position No.");
        TESTFIELD("Starting Date");
        CheckContractStatus;
        TESTFIELD(Status, Status::Open);

        Person.GET(LaborContract."Person No.");
        Person.TESTFIELD("Vendor No.");
        Vendor.GET(Person."Vendor No.");
        /*
        IF Vendor."Agreement Posting" = Vendor."Agreement Posting"::Mandatory THEN
          LaborContract.TESTFIELD("Vendor Agreement No.");
        
        
        IF LaborContract."Vendor Agreement No." <> '' THEN BEGIN
          VendorAgreement.GET(Vendor."No.",LaborContract."Vendor Agreement No.");
          IF "Starting Date" < VendorAgreement."Starting Date" THEN
            ERROR(Text14704,
              FIELDCAPTION("Starting Date"),VendorAgreement.FIELDCAPTION("Starting Date"),VendorAgreement.TABLECAPTION);
        END;
        */

        IF "Starting Date" < LaborContract."Starting Date" THEN
            ERROR(Text14704,
              FIELDCAPTION("Starting Date"), LaborContract.FIELDCAPTION("Starting Date"), LaborContract.TABLECAPTION);

        IF ("Starting Date" > LaborContract."Ending Date") AND (LaborContract."Ending Date" <> 0D) THEN
            ERROR(Text14705,
              FIELDCAPTION("Starting Date"), LaborContract.FIELDCAPTION("Ending Date"), LaborContract.TABLECAPTION);

        IF ("Ending Date" > LaborContract."Ending Date") AND (LaborContract."Ending Date" <> 0D) THEN
            ERROR(Text14704,
              FIELDCAPTION("Ending Date"), LaborContract.FIELDCAPTION("Ending Date"), LaborContract.TABLECAPTION);

        IF "Operation Type" <> "Operation Type"::Hire THEN BEGIN
            LaborContractLine.RESET;
            LaborContractLine.SETRANGE("Contract No.", "Contract No.");
            LaborContractLine.FINDFIRST;
            IF LaborContractLine."Operation Type" <> LaborContractLine."Operation Type"::Hire THEN
                ERROR(Text14707, "Operation Type"::Hire);
        END;

        LaborContractTerms.RESET;
        LaborContractTerms.SETRANGE("Labor Contract No.", "Contract No.");
        LaborContractTerms.SETRANGE("Operation Type", "Operation Type");
        LaborContractTerms.SETRANGE("Supplement No.", "Supplement No.");
        IF LaborContractTerms.FINDSET THEN
            REPEAT
                LaborContractTerms.TESTFIELD("Element Code");
                LaborContractTerms.TESTFIELD("Starting Date");
                CASE LaborContractTerms."Line Type" OF
                    LaborContractTerms."Line Type"::"Payroll Element":
                        IF (LaborContractTerms.Amount = 0) AND (LaborContractTerms.Quantity = 0) THEN
                            ERROR(Text14709);
                    LaborContractTerms."Line Type"::"Vacation Accrual":
                        BEGIN
                            LaborContractTerms.TESTFIELD(Amount, 0);
                            LaborContractTerms.TESTFIELD(Quantity);
                        END;
                END;
            UNTIL LaborContractTerms.NEXT = 0;

    end;

    procedure CheckDateOrder()
    begin
        LaborContractLine.RESET;
        LaborContractLine.SETRANGE("Contract No.", "Contract No.");
        IF LaborContractLine.FINDLAST THEN
            IF LaborContractLine."Starting Date" > "Starting Date" THEN
                ERROR(Text14704,
                  FIELDCAPTION("Starting Date"), LaborContractLine.TABLECAPTION, LaborContractLine.FIELDCAPTION("Starting Date"));
    end;


    procedure ShowContractTerms()
    var
        LaborContractTerms: Record 50108;
    //LaborContractTermsPage: Page "33055970";
    begin
        LaborContractTerms.RESET;
        LaborContractTerms.SETRANGE("Labor Contract No.", "Contract No.");
        LaborContractTerms.SETRANGE("Operation Type", "Operation Type");
        LaborContractTerms.SETRANGE("Supplement No.", "Supplement No.");
        /* LaborContractTermsPage.SETTABLEVIEW(LaborContractTerms);
        LaborContractTermsPage.RUN;
        CLEAR(LaborContractTermsPage); */
    end;

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure ShowComments()
    var
        HRComment: Record 5208;
    //HRCommentList: Page "5223";
    begin
        /*
        HRComment.RESET;
        HRComment.SETRANGE("Table Name",HRComment."Table Name"::"Labor Contract");
        HRComment.SETRANGE("No.","Contract No.");
        HRComment.SETRANGE("Alternative Address Code","Supplement No.");
        HRCommentList.SETTABLEVIEW(HRComment);
        HRCommentList.RUN;
        CLEAR(HRCommentList);
        */

    end;


    procedure PrintOrder()
    var
        LaborContractLine: Record 50107;
    begin

        /*LaborContractLine.RESET;
        LaborContractLine.SETRANGE("Contract No.","Contract No.");
        LaborContractLine.SETRANGE("Operation Type","Operation Type");
        LaborContractLine.SETRANGE("Supplement No.","Supplement No.");
        IF LaborContractLine.FINDFIRST THEN
          CASE "Operation Type" OF
            "Operation Type"::Hire:
              HROrderPrint.PrintFormT1(LaborContractLine);
            "Operation Type"::Transfer:
              HROrderPrint.PrintFormT5(LaborContractLine);
            "Operation Type"::Combination:
              ;
            "Operation Type"::Dismissal:
              HROrderPrint.PrintFormT8(LaborContractLine);
          END;
          *///WIN315

    end;


    procedure ValidateFieldValue(FieldNumber: Integer)
    var
        "Field": Record 2000000041;
        UpdateForbidden: Boolean;
    begin
        IF FieldNumber = 0 THEN
            EXIT;

        IF NOT IsValueChanged(FieldNumber) THEN
            EXIT;

        Field.GET(DATABASE::"Labor Contract Line", FieldNumber);

        CASE "Operation Type" OF
            "Operation Type"::Hire,
          "Operation Type"::Transfer:
                UpdateForbidden := FieldNumber IN [
                                                   FIELDNO("Dismissal Reason"),
                                                   FIELDNO("Dismissal Document")
                                                   ];
            "Operation Type"::Combination:
                UpdateForbidden := FieldNumber IN [
                                                   FIELDNO("Dismissal Reason"),
                                                   FIELDNO("Dismissal Document"),
                                                   FIELDNO("Dismissal Reason"),
                                                   FIELDNO("Trial Period Start Date"),
                                                   FIELDNO("Trial Period End Date"),
                                                   FIELDNO("Trial Period Description")
                                                   ];
            "Operation Type"::Dismissal:
                UpdateForbidden := FieldNumber IN [
                                                   FIELDNO("Starting Date"),
                                                   FIELDNO("Position No."),
                                                   FIELDNO("Trial Period Start Date"),
                                                   FIELDNO("Trial Period End Date"),
                                                   FIELDNO("Trial Period Description")
                                                   ];
        END;

        IF UpdateForbidden THEN
            ERROR(Text14708, Field."Field Caption", "Operation Type");
    end;


    procedure IsValueChanged(FieldNumber: Integer): Boolean
    var
        RecRef: RecordRef;
        xRecRef: RecordRef;
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        RecRef.GETTABLE(Rec);
        xRecRef.GETTABLE(xRec);
        FieldRef := RecRef.FIELD(FieldNumber);
        xFieldRef := xRecRef.FIELD(FieldNumber);
        EXIT(FORMAT(FieldRef.VALUE) <> FORMAT(xFieldRef.VALUE));
    end;


    procedure CheckContractStatus()
    begin
        GetContract;
        IF LaborContract.Status = LaborContract.Status::Closed THEN
            LaborContract.FIELDERROR(Status);
    end;


    procedure CheckTransferDate(SupplementNo: Code[10]; OrderNo: Code[20]; OrderDate: Date)
    begin
        LaborContractLine.RESET;
        LaborContractLine.SETRANGE("Contract No.", "Contract No.");
        LaborContractLine.SETRANGE(
          "Operation Type",
          LaborContractLine."Operation Type"::Hire,
          LaborContractLine."Operation Type"::Transfer);
        LaborContractLine.SETRANGE("Supplement No.", SupplementNo);
        LaborContractLine.SETRANGE("Order No.", OrderNo);
        LaborContractLine.SETRANGE("Order Date", OrderDate);
        IF LaborContractLine.FINDLAST THEN
            IF LaborContractLine."Starting Date" > "Starting Date" THEN
                ERROR(
                  Text14704,
                  FIELDCAPTION("Starting Date"), LaborContractLine.TABLECAPTION, LaborContractLine.FIELDCAPTION("Starting Date"));
    end;


}

