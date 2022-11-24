table 50109 "Payroll Element"
{
    Caption = 'Payroll Element';
    //LookupPageID = 33056041;

    fields
    {
        field(1; "Code1"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            NotBlank = true;
            OptionCaption = 'Wage,Bonus,Income Tax,Netto Salary,Tax Deduction,Deduction,Other,Funds,Reporting';
            OptionMembers = Wage,Bonus,"Income Tax","Netto Salary","Tax Deduction",Deduction,Other,Funds,Reporting;

            trigger OnValidate()
            begin
                IF Type <> xRec.Type THEN
                    CASE Type OF
                        Type::Wage,
                        Type::Bonus:
                            BEGIN
                                "Posting Type" := "Posting Type"::Charge;
                                "Normal Sign" := "Normal Sign"::Positive;
                            END;
                        Type::"Income Tax",
                        Type::Deduction:
                            BEGIN
                                "Posting Type" := "Posting Type"::Liability;
                                "Normal Sign" := "Normal Sign"::Negative;
                            END;
                        Type::Funds:
                            BEGIN
                                "Posting Type" := "Posting Type"::"Liability Charge";
                                "Normal Sign" := "Normal Sign"::Negative;
                            END;
                        Type::"Netto Salary":
                            BEGIN
                                "Posting Type" := "Posting Type"::"Not Post";
                                "Normal Sign" := "Normal Sign"::Negative;
                            END;
                        Type::"Tax Deduction":
                            BEGIN
                                "Posting Type" := "Posting Type"::"Not Post";
                                "Normal Sign" := "Normal Sign"::Negative;
                            END;
                        Type::Other:
                            ;
                    END;
            end;
        }
        field(3; "Element Group"; Code[20])
        {
            Caption = 'Element Group';
            // TableRelation = "Payroll Element Group";
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Last Change Date"; Date)
        {
            Caption = 'Last Change Date';
            Editable = false;
        }
        field(9; "Print in Pay-Sheet"; Option)
        {
            Caption = 'Print in Pay-Sheet';
            InitValue = "Current+YTD";
            OptionCaption = 'No Print,Current Value,YTD,Balance,Current+YTD,Current+Balance';
            OptionMembers = "No Print","Current Value",YTD,Balance,"Current+YTD","Current+Balance";
        }
        field(10; "Fund Type"; Option)
        {
            Caption = 'Fund Type';
            OptionCaption = ' ,FSI,FSI Injury,Federal FMI,Territorial FMI,PF Accum. Part,PF Insur. Part';
            OptionMembers = " ",FSI,"FSI Injury","Federal FMI","Territorial FMI","PF Accum. Part","PF Insur. Part";
        }
        field(11; "Posting Type"; Option)
        {
            Caption = 'Posting Type';
            OptionCaption = 'Not Post,Charge,Liability,Liability Charge,Information Only';
            OptionMembers = "Not Post",Charge,Liability,"Liability Charge","Information Only";
        }
        field(12; "Payroll Posting Group"; Code[20])
        {
            Caption = 'Payroll Posting Group';
            TableRelation = "Payroll Posting Group";
        }
        field(13; Comment; Boolean)
        {
            /* CalcFormula = Exist ("Human Resource Comment Line" WHERE (Table Name=CONST(17400),
                                                                     No.=FIELD(Code))); */
            Caption = 'Comment';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(15; "Directory Code"; Code[10])
        {
            Caption = 'Directory Code';
            /* TableRelation = IF (Type=FILTER(Wage|Bonus|Other)) "Payroll Directory".Code WHERE (Type=FILTER(Income))
                            ELSE IF (Type=FILTER(Tax Deduction|Deduction),
                                     Posting Type=FILTER(Not Post|Charge)) "Payroll Directory".Code WHERE (Type=FILTER(Tax Deduction))
                                     ELSE IF (Type=FILTER(Funds)) "Payroll Directory".Code WHERE (Type=FILTER(Tax)); */

            trigger OnValidate()
            begin
                IF "Directory Code" <> xRec."Directory Code" THEN;
                //ChangeDirCodeEmplLedgerEntry;
            end;
        }
        field(16; Calculate; Boolean)
        {
            Caption = 'Calculate';
        }
        field(17; "Normal Sign"; Option)
        {
            Caption = 'Normal Sign';
            OptionCaption = 'Negative,Positive';
            OptionMembers = Negative,Positive;
        }
        field(18; "Use Indexation"; Boolean)
        {
            Caption = 'Use Indexation';

            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Wage);
            end;
        }
        field(19; "Depends on Salary Element"; Code[20])
        {
            Caption = 'Depends on Salary Element';
            TableRelation = "Payroll Element" WHERE(Type = CONST(Wage));
        }
        field(20; "Distribute by Periods"; Boolean)
        {
            Caption = 'Distribute by Periods';
        }
        field(21; "Include into Calculation by"; Option)
        {
            Caption = 'Include into Calculation by';
            OptionCaption = 'Action Period,Period Code';
            OptionMembers = "Action Period","Period Code";
        }
        field(22; "Fixed Amount Bonus"; Boolean)
        {
            Caption = 'Fixed Amount Bonus';
        }
        field(25; "Amount Mandatory"; Boolean)
        {
            Caption = 'Amount Mandatory';
        }
        field(26; "Quantity Mandatory"; Boolean)
        {
            Caption = 'Quantity Mandatory';
        }
        field(33; Calculations; Boolean)
        {
            // CalcFormula = Exist("Payroll Calculation" WHERE (Element Code=FIELD(Code)));
            Caption = 'Calculations';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(34; "Base Amounts"; Boolean)
        {
            // CalcFormula = Exist("Payroll Base Amount" WHERE (Element Code=FIELD(Code)));
            Caption = 'Base Amounts';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(35; Ranges; Boolean)
        {
            //CalcFormula = Exist("Payroll Range Header" WHERE (Element Code=FIELD(Code)));
            Caption = 'Ranges';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(39; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(42; "FSI Base"; Boolean)
        {
            Caption = 'FSI Base';
        }
        field(44; "Federal FMI Base"; Boolean)
        {
            Caption = 'Federal FMI Base';
        }
        field(45; "Territorial FMI Base"; Boolean)
        {
            Caption = 'Territorial FMI Base';
        }
        field(46; "PF Base"; Boolean)
        {
            Caption = 'PF Base';
        }
        field(47; "Income Tax Base"; Boolean)
        {
            Caption = 'Income Tax Base';
        }
        field(48; "FSI Injury Base"; Boolean)
        {
            Caption = 'FSI Injury Base';
        }
        field(55; "Print Priority"; Integer)
        {
            Caption = 'Print Priority';
        }
        field(58; "Pay Type"; Option)
        {
            Caption = 'Pay Type';
            OptionCaption = ' ,Salary Schedule,Social,Other Income';
            OptionMembers = " ","Salary Schedule",Social,"Other Income";
        }
        field(61; "Bonus Type"; Option)
        {
            Caption = 'Bonus Type';
            OptionCaption = ' ,Monthly,Quarterly,Semi-Annual,Annual';
            OptionMembers = " ",Monthly,Quarterly,"Semi-Annual",Annual;
        }
        field(69; "Source Pay"; Option)
        {
            Caption = 'Source Pay';
            OptionCaption = ' ,Cost,Profit,FSI,FOSI';
            OptionMembers = " ",Cost,Profit,FSI,FOSI;
        }
        field(105; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                MODIFY;
            end;
        }
        field(106; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //  ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                MODIFY;
            end;
        }
        field(110; "Used for Spreadsheet"; Boolean)
        {
            Caption = 'Used for Spreadsheet';
        }
        field(111; "Used in Calc Type"; Integer)
        {
            //CalcFormula = Count("Payroll Calc Type Line" WHERE ("Element Code"=FIELD(Code)));
            Caption = 'Used in Calc Type';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(112; "Advance Payment"; Boolean)
        {
            Caption = 'Advance Payment';
        }
        field(120; "T-3 Report Column"; Option)
        {
            Caption = 'T-3 Report Column';
            OptionCaption = ',Column 6,Column 7,Column 8';
            OptionMembers = ,"Column 6","Column 7","Column 8";
        }
        field(200; "Journal Template Name"; Code[20])
        {
            Caption = 'Journal Template Name';
            Description = 'HR100.10';
            //TableRelation = "Payroll Journal Template".Name;
        }
        field(201; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            Description = 'HR100.10';
            //TableRelation = "Payroll Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
    }

    keys
    {
        key(Key1; "Code1")
        {
            Clustered = true;
        }
        key(Key2; "Directory Code")
        {
        }
        key(Key3; "Print Priority")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var

    begin

    end;

    trigger OnModify()
    begin

    End;



    var
        /*  PayrollLedgerEntry: Record "33055895";
         PayrollCalcTypeLine: Record "33055959";
         PayrollDocLine: Record "33055892";
         PayrollBaseAmount: Record "33055963";
         PayrollRangeHeader: Record "33055964";
         PayrollRangeLine: Record "33055965";
         PayrollCalculation: Record "33055965";
         PayrollCalculationLine: Record "33055961";
  */
        Text007: Label 'You cannot delete %1 because it is used in table %2.';
        DimMgt: Codeunit 408;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Payroll Element", Code1, FieldNumber, ShortcutDimCode);
        MODIFY;
    end;



}

