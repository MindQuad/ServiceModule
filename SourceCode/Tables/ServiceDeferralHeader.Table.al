table 51701 "Service Deferral Header"
{
    Caption = 'Deferral Header';
    DataCaptionFields = "Schedule Description";

    fields
    {
        //Win513++
        //field(1; "Deferral Doc. Type"; Option)
        field(1; "Deferral Doc. Type"; Enum "Deferral Document Type")
        //Win513--
        {
            Caption = 'Deferral Doc. Type';
            //Win513++
            // OptionCaption = 'Purchase,Sales,G/L';
            // OptionMembers = Purchase,Sales,"G/L";
            //Win513--
        }
        field(2; "Gen. Jnl. Template Name"; Code[10])
        {
            Caption = 'Gen. Jnl. Template Name';
        }
        field(3; "Gen. Jnl. Batch Name"; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Name';
        }
        field(4; "Document Type"; Integer)
        {
            Caption = 'Document Type';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; "Deferral Code"; Code[10])
        {
            Caption = 'Deferral Code';
            NotBlank = true;
        }
        field(8; "Amount to Defer"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount to Defer';

            trigger OnValidate()
            begin
                IF "Initial Amount to Defer" < 0 THEN BEGIN// Negative amount
                    IF "Amount to Defer" < "Initial Amount to Defer" THEN
                        ERROR(AmountToDeferErr);
                    IF "Amount to Defer" > 0 THEN
                        ERROR(AmountToDeferErr)
                END;

                IF "Initial Amount to Defer" >= 0 THEN BEGIN// Positive amount
                    IF "Amount to Defer" > "Initial Amount to Defer" THEN
                        ERROR(AmountToDeferErr);
                    IF "Amount to Defer" < 0 THEN
                        ERROR(AmountToDeferErr);
                END;

                IF "Amount to Defer" = 0 THEN
                    ERROR(ZeroAmountToDeferErr);
            end;
        }
        field(9; "Amount to Defer (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount to Defer (LCY)';
        }
        //Win513++
        //        field(10; "Calc. Method"; Option)
        field(10; "Calc. Method"; Enum "Deferral Calculation Method")
        //Win513--
        {
            Caption = 'Calc. Method';
            //Win513++
            // OptionCaption = 'Straight-Line,Equal per Period,Days per Period,User-Defined';
            // OptionMembers = "Straight-Line","Equal per Period","Days per Period","User-Defined";
            //Win513--
        }
        field(11; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            var
                AccountingPeriod: Record 50;
            begin
                IF GenJnlCheckLine.DateNotAllowed("Start Date") THEN
                    ERROR(InvalidPostingDateErr, "Start Date");

                AccountingPeriod.SETFILTER("Starting Date", '>=%1', "Start Date");
                IF AccountingPeriod.ISEMPTY THEN
                    ERROR(DeferSchedOutOfBoundsErr);
            end;
        }
        field(12; "No. of Periods"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Periods';
            NotBlank = true;

            trigger OnValidate()
            begin
                IF "No. of Periods" < 1 THEN
                    ERROR(NumberofPeriodsErr);
            end;
        }
        field(13; "Schedule Description"; Text[50])
        {
            Caption = 'Schedule Description';
        }
        field(14; "Initial Amount to Defer"; Decimal)
        {
            Caption = 'Initial Amount to Defer';
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }
        field(20; "Schedule Line Total"; Decimal)
        {
            CalcFormula = Sum("Deferral Line".Amount WHERE("Deferral Doc. Type" = FIELD("Deferral Doc. Type"),
                                                            "Gen. Jnl. Template Name" = FIELD("Gen. Jnl. Template Name"),
                                                            "Gen. Jnl. Batch Name" = FIELD("Gen. Jnl. Batch Name"),
                                                            "Document Type" = FIELD("Document Type"),
                                                            "Document No." = FIELD("Document No."),
                                                            "Line No." = FIELD("Line No.")));
            Caption = 'Schedule Line Total';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Deferral Doc. Type", "Gen. Jnl. Template Name", "Gen. Jnl. Batch Name", "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DeferralLine: Record 1702;
    begin
        // If the user deletes the header, all associated lines should also be deleted
        DeferralLine.SETRANGE("Deferral Doc. Type", "Deferral Doc. Type");
        DeferralLine.SETRANGE("Gen. Jnl. Template Name", "Gen. Jnl. Template Name");
        DeferralLine.SETRANGE("Gen. Jnl. Batch Name", "Gen. Jnl. Batch Name");
        DeferralLine.SETRANGE("Document Type", "Document Type");
        DeferralLine.SETRANGE("Document No.", "Document No.");
        DeferralLine.SETRANGE("Line No.", "Line No.");
        DeferralLine.DELETEALL;
    end;

    var
        AmountToDeferErr: Label 'The deferred amount cannot be greater than the document line amount.';
        GenJnlCheckLine: Codeunit 11;
        InvalidPostingDateErr: Label '%1 is not within the range of posting dates for your company.', Comment = '%1=The date passed in for the posting date.';
        DeferSchedOutOfBoundsErr: Label 'The deferral schedule falls outside the accounting periods that have been set up for the company.';
        SelectionMsg: Label 'You must specify a deferral code for this line before you can view the deferral schedule.';
        DeferralUtilities: Codeunit 1720;
        NumberofPeriodsErr: Label 'You must specify one or more periods.';
        ZeroAmountToDeferErr: Label 'The Amount to Defer cannot be 0.';

    //Win513++
    //[Scope('Internal')]
    //Win513--
    procedure CalculateSchedule(): Boolean
    var
        DeferralDescription: Text[50];
    begin
        IF "Deferral Code" = '' THEN BEGIN
            MESSAGE(SelectionMsg);
            EXIT(FALSE);
        END;
        DeferralDescription := "Schedule Description";
        DeferralUtilities.CreateDeferralSchedule("Deferral Code", "Deferral Doc. Type".AsInteger(), "Gen. Jnl. Template Name",
          "Gen. Jnl. Batch Name", "Document Type", "Document No.", "Line No.", "Amount to Defer",
          "Calc. Method", "Start Date", "No. of Periods", FALSE, DeferralDescription, FALSE, "Currency Code");
        EXIT(TRUE);
    end;
}

