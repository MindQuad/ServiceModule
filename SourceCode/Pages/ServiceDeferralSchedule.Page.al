page 51702 "Service Deferral Schedule"
{
    Caption = 'Deferral Schedule';
    DataCaptionFields = "Start Date";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "Deferral Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Amount to Defer"; Rec."Amount to Defer")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount to defer per period.';
                }
                field("Calc. Method"; Rec."Calc. Method")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how the Amount field for each period is calculated. Straight-Line: Calculated per the number of periods, distributed by period length. Equal Per Period: Calculated per the number of periods, distributed evenly on periods. Days Per Period: Calculated per the number of days in the period. User-Defined: Not calculated. You must manually fill the Amount field for each period.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies when to start calculating deferral amounts.';
                }
                field("No. of Periods"; Rec."No. of Periods")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how many accounting periods the total amounts will be deferred to.';
                }
            }
            part(DeferralSheduleSubform; "Deferral Schedule Subform")
            {
                ApplicationArea = Suite;

                SubPageLink = "Deferral Doc. Type" = FIELD("Deferral Doc. Type"),
                                "Gen. Jnl. Template Name" = FIELD("Gen. Jnl. Template Name"),
                                "Gen. Jnl. Batch Name" = FIELD("Gen. Jnl. Batch Name"),
                                "Document Type" = FIELD("Document Type"),
                                "Document No." = FIELD("Document No."),
                                "Line No." = FIELD("Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                action(CalculateSchedule)
                {
                    ApplicationArea = Suite;
                    Caption = 'Calculate Schedule';
                    Image = CalculateCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Calculate the deferral schedule by which revenue or expense amounts will be distributed over multiple accounting periods.';

                    trigger OnAction()
                    begin
                        Changed := Rec.CalculateSchedule;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Changed := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Changed := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Changed := TRUE;
    end;

    trigger OnOpenPage()
    begin
        InitForm;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        DeferralUtilities: Codeunit "Deferral Utilities";
        EarliestPostingDate: Date;
        RecCount: Integer;
        ExpectedCount: Integer;
    begin
        // Prevent closing of the window if the sum of the periods does not equal the Amount to Defer
        IF DeferralHeader.GET(Rec."Deferral Doc. Type",
             Rec."Gen. Jnl. Template Name",
             Rec."Gen. Jnl. Batch Name",
             Rec."Document Type",
             Rec."Document No.", Rec."Line No.")
        THEN BEGIN
            Rec.CALCFIELDS("Schedule Line Total");
            IF Rec."Schedule Line Total" <> DeferralHeader."Amount to Defer" THEN
                ERROR(TotalToDeferErr);
        END;

        DeferralLine.SETRANGE("Deferral Doc. Type", Rec."Deferral Doc. Type");
        DeferralLine.SETRANGE("Gen. Jnl. Template Name", Rec."Gen. Jnl. Template Name");
        DeferralLine.SETRANGE("Gen. Jnl. Batch Name", Rec."Gen. Jnl. Batch Name");
        DeferralLine.SETRANGE("Document Type", Rec."Document Type");
        DeferralLine.SETRANGE("Document No.", Rec."Document No.");
        DeferralLine.SETRANGE("Line No.", Rec."Line No.");

        RecCount := DeferralLine.COUNT;
        ExpectedCount := DeferralUtilities.CalcDeferralNoOfPeriods(Rec."Calc. Method", Rec."No. of Periods", Rec."Start Date");
        IF ExpectedCount <> RecCount THEN
            Rec.FIELDERROR("No. of Periods");

        DeferralLine.SETFILTER("Posting Date", '>%1', 0D);
        IF DeferralLine.FINDFIRST THEN BEGIN
            EarliestPostingDate := DeferralLine."Posting Date";
            IF EarliestPostingDate <> DeferralHeader."Start Date" THEN
                ERROR(PostingDateErr);
        END;
    end;

    var
        TotalToDeferErr: Label 'The sum of the deferred amounts must be equal to the amount in the Amount to Defer field.';
        Changed: Boolean;
        DisplayDeferralDocType: Option Purchase,Sales,"G/L";
        DisplayGenJnlTemplateName: Code[10];
        DisplayGenJnlBatchName: Code[10];
        DisplayDocumentType: Integer;
        DisplayDocumentNo: Code[20];
        DisplayLineNo: Integer;
        PostingDateErr: Label 'You cannot specify a posting date that is earlier than the start date.';



    procedure SetParameter(DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer)
    begin
        DisplayDeferralDocType := DeferralDocType;
        DisplayGenJnlTemplateName := GenJnlTemplateName;
        DisplayGenJnlBatchName := GenJnlBatchName;
        DisplayDocumentType := DocumentType;
        DisplayDocumentNo := DocumentNo;
        DisplayLineNo := LineNo;
    end;


    procedure GetParameter(): Boolean
    begin
        EXIT(Changed OR CurrPage.DeferralSheduleSubform.PAGE.GetChanged)
    end;


    procedure InitForm()
    begin
        Rec.GET(DisplayDeferralDocType, DisplayGenJnlTemplateName, DisplayGenJnlBatchName, DisplayDocumentType, DisplayDocumentNo, DisplayLineNo);
    end;
}

