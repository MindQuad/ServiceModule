codeunit 50011 AllSubciber
{
    Permissions = tabledata "G/L Entry" = RIMD;//Win593

    trigger OnRun()
    begin

    end;

    //CU11

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeRunCheck', '', true, true)]
    local procedure OnBeforeRunCheck(var GenJournalLine: Record "Gen. Journal Line"; sender: Codeunit "Gen. Jnl.-Check Line")

    begin
        IF (GenJournalLine."Account No." <> '') AND
           NOT GenJournalLine."System-Created Entry" AND
           NOT GenJournalLine."Allow Zero-Amount Posting" AND
           (GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"Fixed Asset")
           then
            ;

    end;

    //CU12
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnCodeOnBeforeFinishPosting', '', true, true)]
    local procedure OnCodeOnBeforeFinishPosting(Balancing: Boolean; sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line")
    var
        DeferralUtilities: Codeunit "Deferral Utilities";
        FirstEntryNo: Integer;
        GLSourceCode: Code[10];
    begin
        IF GenJournalLine."Account No." <> '' THEN
            IF GenJournalLine."Account Type" IN
               [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor, GenJournalLine."Account Type"::"Bank Account"]
            THEN
                IF (GenJournalLine."Deferral Code" <> '') AND (GenJournalLine."Source Code" = GLSourceCode) THEN BEGIN
                    // Once posting has completed, move the deferral schedule over to Posted Deferral Schedule
                    IF NOT Balancing THEN
                        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJournalLine);
                    DeferralUtilities.CreateScheduleFromGL(GenJournalLine, FirstEntryNo);
                END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', true, true)]
    local procedure OnAfterPostGLAcc(var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        //Win593
        //Win160 to flow narration in gl entry
        TempGLEntryBuf.Narration := GenJnlLine.Narration;
        TempGLEntryBuf."Check No." := GenJnlLine."Check No";
        TempGLEntryBuf."Check Date" := GenJnlLine."Check Date";
        TempGLEntryBuf."Creation Date" := TODAY;
        //Win593
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', true, true)]
    local procedure OnAfterInitGLEntry(AddCurrAmount: Decimal; Amount: Decimal; GenJournalLine: Record "Gen. Journal Line"; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."PDC Document No." := GenJournalLine."PDC Document No.";
        GLEntry."PDC Line No." := GenJournalLine."PDC Line No.";    //PPG
        GLEntry."Check No." := GenJournalLine."Check No.";   //win315
        GLEntry."Service Contract No." := GenJournalLine."Service Contract No.";  //win315
        GLEntry."Charge Code" := GenJournalLine."Charge Code";  //win315
        GLEntry."Charge Description" := GenJournalLine."Charge Description";  //win315
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustUnrealizedVAT', '', true, true)]
    local procedure OnBeforeCustUnrealizedVAT(var GenJnlLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry"; SettledAmount: Decimal; var IsHandled: Boolean)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        UnapplyVATEntries: Boolean;
        VATEntry: Record "VAT Entry";
    begin
        IF VATPostingSetup."Adjust for Payment Discount" AND NOT IsNotPayment(VATEntry."Document Type") AND
           (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT")
        THEN
            UnapplyVATEntries := TRUE;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCalcPmtDiscVATAmounts', '', true, true)]
    local procedure OnBeforeCalcPmtDiscVATAmounts(var VATEntry: Record "VAT Entry"; var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var GenJnlLine: Record "Gen. Journal Line");
    var
        EntryType: Option;
        VATEntryModifier: Integer;
    begin
        CASE EntryType OF
            //Win513++
            //DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)".AsInteger():
                //Win513--
                VATEntryModifier := 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDtldCustLedgEntriesOnBeforeUpdateTotalAmounts', '', true, true)]
    local procedure OnPostDtldCustLedgEntriesOnBeforeUpdateTotalAmounts(var GenJnlLine: Record "Gen. Journal Line"; DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var IsHandled: Boolean)
    var
        DimMgt: Codeunit 408;
    begin
        DimMgt.UpdateGenJnlLineDimFromCustLedgEntry(GenJnlLine, DtldCustLedgEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeDeferralPosting', '', true, true)]
    local procedure OnBeforeDeferralPosting(DeferralCode: Code[10]; SourceCode: Code[10]; AccountNo: Code[20]; var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var IsHandled: Boolean)
    var
        GLSourceCode: Code[10];
    begin
        IF (SourceCode <> GLSourceCode) AND (ServiceDeferral = FALSE) THEN;//Wintt 070617 start>>should not use postdefferalpostbufferas we aretreating service deferals as gen. journal deferals not like sales and purchase>>THEN
    end;
    //end;
    //New procedure CU12

    local procedure RemoveDeferralScheduleTEST(GenJournalLine: Record 81);
    var
        DeferralUtilities: Codeunit 1720;
        DeferralDocType: Option "Purchase","Sales","G/L";
    BEGIN
        // Removing deferral schedule after all deferrals for this line have been posted successfully
        //Win513++
        //WITH GenJournalLine DO
        // DeferralUtilities.DeferralCodeOnDelete(
        //   DeferralDocType::"G/L",
        //   "Journal Template Name",
        //   "Journal Batch Name", 0, '', "Line No.");
        DeferralUtilities.DeferralCodeOnDelete(
        DeferralDocType::"G/L",
        GenJournalLine."Journal Template Name",
        GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.");
        //Win513--
    END;

    PROCEDURE PostDeferral(VAR GenJournalLine: Record 81; AccountNumber: Code[20]);
    VAR
        GenJouPostLine: Codeunit 12;
        DeferralTemplate: Record 1700;
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        GLEntry: Record 17;
        GenJouCheckLine: Codeunit 11;
        CurrExchRate: Record 330;
        DeferralUtilities: Codeunit 1720;
        PerPostDate: Date;
        PeriodicCount: Integer;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        EmptyDeferralLine: Boolean;
        GLSourceCode: Code[10];
        DeferralDocType: Option "Purchase","Sales","G/L";
        InvalidPostingDateErr: Label '%1 is not within the range of posting dates for your company.';
        NoDeferralScheduleErr: Label '@@@="%1=The line number of the general ledger transaction, %2=The Deferral Template Code";ENU=You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.;ENA=You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.';
        ZeroDeferralAmtErr: Label '@@@="%1=The line number of the general ledger transaction, %2=The Deferral Template Code";ENU=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.;ENA=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.';
    BEGIN
        //Win513++
        //WITH GenJournalLine DO BEGIN
        //Win513--    
        //Wintt Start 070617<< should not use postdefferalpostbufferas we aretreating service deferals as gen. journal deferals not like sales and purchase
        IF ServiceDeferral = FALSE THEN BEGIN
            //Standard<<
            //Win513++
            //IF "Source Type" IN ["Source Type"::Vendor, "Source Type"::Customer] THEN
            IF GenJournalLine."Source Type" IN [GenJournalLine."Source Type"::Vendor, GenJournalLine."Source Type"::Customer] THEN
                //Win513--
                // Purchasing and Sales, respectively
                // We can create these types directly from the GL window, need to make sure we don't already have a deferral schedule
                // created for this GL Trx before handing it off to sales/purchasing subsystem
                //Win513++
                IF GenJournalLine."Source Code" <> GLSourceCode THEN BEGIN
                    //Win513--    
                    PostDeferralPostBuffer(GenJournalLine);
                    EXIT;
                END;
            //Standard>>
        END;
        //Wintt End 070617>>

        //Win513++
        //IF DeferralHeader.GET(DeferralDocType::"G/L", "Journal Template Name", "Journal Batch Name", 0, '', "Line No.") THEN BEGIN
        IF DeferralHeader.GET(DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.") THEN BEGIN

            //Win513--    
            EmptyDeferralLine := FALSE;
            // Get the range of detail records for this schedule
            DeferralLine.SETRANGE("Deferral Doc. Type", DeferralDocType::"G/L");
            //Win513++
            // DeferralLine.SETRANGE("Gen. Jnl. Template Name", "Journal Template Name");
            // DeferralLine.SETRANGE("Gen. Jnl. Batch Name", "Journal Batch Name");
            DeferralLine.SETRANGE("Gen. Jnl. Template Name", GenJournalLine."Journal Template Name");
            DeferralLine.SETRANGE("Gen. Jnl. Batch Name", GenJournalLine."Journal Batch Name");
            //Win513--
            DeferralLine.SETRANGE("Document Type", 0);
            DeferralLine.SETRANGE("Document No.", '');
            //Win513++
            //DeferralLine.SETRANGE("Line No.", "Line No.");
            DeferralLine.SETRANGE("Line No.", GenJournalLine."Line No.");
            //Win513--
            IF DeferralLine.FINDSET THEN
                REPEAT
                    IF DeferralLine.Amount = 0.0 THEN
                        EmptyDeferralLine := TRUE;
                UNTIL (DeferralLine.NEXT = 0) OR EmptyDeferralLine;
            IF EmptyDeferralLine THEN
                //Win513++
                //ERROR(ZeroDeferralAmtErr, "Line No.", "Deferral Code");
                ERROR(ZeroDeferralAmtErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");
            //Win513--
            DeferralHeader."Amount to Defer (LCY)" :=
            //Win513++
            //   ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code",
            //       DeferralHeader."Amount to Defer", "Currency Factor"));
                  ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GenJournalLine."Posting Date", GenJournalLine."Currency Code",
                  DeferralHeader."Amount to Defer", GenJournalLine."Currency Factor"));
            //Win513--
            DeferralHeader.MODIFY;
        END;

        DeferralUtilities.RoundDeferralAmount(
          DeferralHeader,
          //Win513++
          //"Currency Code", "Currency Factor", "Posting Date", AmtToDefer, AmtToDeferACY);
          GenJournalLine."Currency Code", GenJournalLine."Currency Factor", GenJournalLine."Posting Date", AmtToDefer, AmtToDeferACY);


        //DeferralTemplate.GET("Deferral Code");
        DeferralTemplate.GET(GenJournalLine."Deferral Code");
        //Win513--
        DeferralTemplate.TESTFIELD("Deferral Account");
        DeferralTemplate.TESTFIELD("Deferral %");

        // Get the Deferral Header table so we know the amount to defer...
        // Assume straight GL posting
        //Win513++
        //IF DeferralHeader.GET(DeferralDocType::"G/L", "Journal Template Name", "Journal Batch Name", 0, '', "Line No.") THEN BEGIN
        IF DeferralHeader.GET(DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.") THEN BEGIN
            //Win513--
            // Get the range of detail records for this schedule
            DeferralLine.SETRANGE("Deferral Doc. Type", DeferralDocType::"G/L");
            //Win513++
            // DeferralLine.SETRANGE("Gen. Jnl. Template Name", "Journal Template Name");
            // DeferralLine.SETRANGE("Gen. Jnl. Batch Name", "Journal Batch Name");
            DeferralLine.SETRANGE("Gen. Jnl. Template Name", GenJournalLine."Journal Template Name");
            DeferralLine.SETRANGE("Gen. Jnl. Batch Name", GenJournalLine."Journal Batch Name");
            //Win513--
            DeferralLine.SETRANGE("Document Type", 0);
            DeferralLine.SETRANGE("Document No.", '');
            //Win513++
            //DeferralLine.SETRANGE("Line No.", "Line No.");
            DeferralLine.SETRANGE("Line No.", GenJournalLine."Line No.");
            //Win513--
        END ELSE
            //Win513++
            //ERROR(NoDeferralScheduleErr, "Line No.", "Deferral Code");
            ERROR(NoDeferralScheduleErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");
        //Win513--

        GenJouPostLine.InitGLEntry(GenJournalLine, GLEntry,
           AccountNumber,
           -DeferralHeader."Amount to Defer (LCY)",
           -DeferralHeader."Amount to Defer", TRUE, TRUE);
        //Win513++   
        //GLEntry.Description := Description;
        GLEntry.Description := GenJournalLine.Description;
        //Win513--
        GenJouPostLine.InsertGLEntry(GenJournalLine, GLEntry, TRUE);

        GenJouPostLine.InitGLEntry(GenJournalLine, GLEntry,
          DeferralTemplate."Deferral Account",
          DeferralHeader."Amount to Defer (LCY)",
          DeferralHeader."Amount to Defer", TRUE, TRUE);

        //Win513++
        //GLEntry.Description := Description;
        GLEntry.Description := GenJournalLine.Description;
        //Win513--
        GenJouPostLine.InsertGLEntry(GenJournalLine, GLEntry, TRUE);

        // Here we want to get the Deferral Details table range and loop through them...
        IF DeferralLine.FINDSET THEN BEGIN
            PeriodicCount := 1;
            REPEAT
                PerPostDate := DeferralLine."Posting Date";
                IF GenJouCheckLine.DateNotAllowed(PerPostDate) THEN
                    ERROR(InvalidPostingDateErr, PerPostDate);

                GenJouPostLine.InitGLEntry(GenJournalLine, GLEntry, AccountNumber, DeferralLine."Amount (LCY)",
                  DeferralLine.Amount,
                  TRUE, TRUE);
                GLEntry."Posting Date" := PerPostDate;
                GLEntry.Description := DeferralLine.Description;
                GenJouPostLine.InsertGLEntry(GenJournalLine, GLEntry, TRUE);

                GenJouPostLine.InitGLEntry(GenJournalLine, GLEntry,
                  DeferralTemplate."Deferral Account", -DeferralLine."Amount (LCY)",
                  -DeferralLine.Amount,
                  TRUE, TRUE);
                GLEntry."Posting Date" := PerPostDate;
                GLEntry.Description := DeferralLine.Description;
                GenJouPostLine.InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                PeriodicCount := PeriodicCount + 1;
            UNTIL DeferralLine.NEXT = 0;
        END ELSE
            //Win513++
            //ERROR(NoDeferralScheduleErr, "Line No.", "Deferral Code");
            ERROR(NoDeferralScheduleErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");

        //END;
        //Win513--
    END;

    LOCAL PROCEDURE PostDeferralPostBuffer(GenJournalLine: Record 81);
    VAR
        DeferralPostBuffer: Record "Deferral Posting Buffer";
        GLEntry: Record 17;
        PostDate: Date;

        DeferralDocType: Option "Purchase","Sales","G/L";
        GenJnlCheckLine: Codeunit 11;
    BEGIN
        //Win513++
        //WITH GenJournalLine DO BEGIN

        IF GenJournalLine."Source Type" = GenJournalLine."Source Type"::Customer THEN
            //Win513--
                DeferralDocType := DeferralDocType::Sales
        ELSE
            DeferralDocType := DeferralDocType::Purchase;

        DeferralPostBuffer.SETRANGE("Deferral Doc. Type", DeferralDocType);
        //Win513++
        // DeferralPostBuffer.SETRANGE("Document No.", "Document No.");
        // DeferralPostBuffer.SETRANGE("Deferral Line No.", "Deferral Line No.");
        DeferralPostBuffer.SETRANGE("Document No.", GenJournalLine."Document No.");
        DeferralPostBuffer.SETRANGE("Deferral Line No.", GenJournalLine."Deferral Line No.");
        //Win513--

        IF DeferralPostBuffer.FINDSET THEN BEGIN
            REPEAT
                PostDate := DeferralPostBuffer."Posting Date";
                IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                    ERROR(InvalidPostingDateErr, PostDate);

                // When no sales/purch amount is entered, the offset was already posted
                IF (DeferralPostBuffer."Sales/Purch Amount" <> 0) OR (DeferralPostBuffer."Sales/Purch Amount (LCY)" <> 0) THEN BEGIN
                    GenJnlPostLine.InitGLEntry(GenJournalLine, GLEntry, DeferralPostBuffer."G/L Account",
                      DeferralPostBuffer."Sales/Purch Amount (LCY)",
                      DeferralPostBuffer."Sales/Purch Amount",
                      TRUE, TRUE);
                    GLEntry."Posting Date" := PostDate;
                    GLEntry.Description := DeferralPostBuffer.Description;
                    GLEntry.CopyFromDeferralPostBuffer(DeferralPostBuffer);
                    GenJnlPostLine.InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                END;

                GenJnlPostLine.InitGLEntry(GenJournalLine, GLEntry,
                  DeferralPostBuffer."Deferral Account",
                  -DeferralPostBuffer."Amount (LCY)",
                  -DeferralPostBuffer.Amount,
                  TRUE, TRUE);
                GLEntry."Posting Date" := PostDate;
                GLEntry.Description := DeferralPostBuffer.Description;
                GenJnlPostLine.InsertGLEntry(GenJournalLine, GLEntry, TRUE);
            UNTIL DeferralPostBuffer.NEXT = 0;
            DeferralPostBuffer.DELETEALL;
        END;
        //Win513++
        //END;
        //Win513--
    END;

    var
        GenJnlPostLine: Codeunit 12;
        InvalidPostingDateErr: Label '%1 is not within the range of posting dates for your company.';
        NoDeferralScheduleErr: Label '@@@="%1=The line number of the general ledger transaction, %2=The Deferral Template Code";ENU=You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.;ENA=You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.';
        ZeroDeferralAmtErr: Label '@@@="%1=The line number of the general ledger transaction, %2=The Deferral Template Code";ENU=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.;ENA=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.';

    PROCEDURE SetServiceDeferral();
    BEGIN
        ServiceDeferral := TRUE;//WINS-PPG
    END;

    LOCAL PROCEDURE "--WINS.PY"();
    BEGIN
    END;

    LOCAL PROCEDURE PostEmployee(GenJnlLine: Record 81);
    VAR
        Employee: Record 5200;
        EmployeePostingGr: Record "Employee Posting Group";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        CVLedgEntryBuf: Record 382;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        DtldEmplLedgEntry: Record "Detailed Employee Ledger Entry";
        DtldLedgEntryInserted: Boolean;
        NextTransactionNo: Integer;
        InsertedTempGLEntryVAT: Integer;
        IsTempGLEntryBufEmpty: Boolean;
        GenJnlPostLine: Codeunit 12;
        GenJournalLine: record 81;
    BEGIN
        //Win513++
        //WITH GenJnlLine DO BEGIN

        // Employee.GET("Account No.");

        // IF "Posting Group" = '' THEN BEGIN
        Employee.GET(GenJournalLine."Account No.");

        IF GenJournalLine."Posting Group" = '' THEN BEGIN
            //Win513--
            Employee.TESTFIELD("Employee Posting Group");
            //Win513++
            //"Posting Group" := Employee."Employee Posting Group";
            GenJournalLine."Posting Group" := Employee."Employee Posting Group";
            //Win513--
        END;
        //Win513++
        //EmployeePostingGr.GET("Posting Group");
        EmployeePostingGr.GET(GenJournalLine."Posting Group");
        //Win513--

        DtldEmplLedgEntry.LOCKTABLE;
        EmployeeLedgerEntry.LOCKTABLE;

        InitEmployeeLedgerEntry(GenJnlLine, EmployeeLedgerEntry);

        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := EmployeeLedgerEntry."Entry No.";
        CVLedgEntryBuf.CopyFromEmplLedgEntry(EmployeeLedgerEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        // Post application
        ApplyEmplLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Employee);

        // Post vendor entry
        EmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        EmployeeLedgerEntry."Amount to Apply" := 0;
        EmployeeLedgerEntry."Applies-to Doc. No." := '';
        EmployeeLedgerEntry.INSERT(TRUE);

        // Post detailed employee entries
        DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, EmployeePostingGr, TRUE);

        // Posting GL Entry
        IF DtldLedgEntryInserted THEN
            IF IsTempGLEntryBufEmpty THEN
                DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);

        //WIN502 OnMoveGenJournalLine(EmployeeLedgerEntry.RECORDID);
        //Win513++
        //END;
        //Win513--
    END;

    LOCAL PROCEDURE InitEmployeeLedgerEntry(GenJnlLine: Record 81; VAR EmployeeLedgerEntry: Record "Employee Ledger Entry");
    var
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
    BEGIN
        EmployeeLedgerEntry.INIT;
        EmployeeLedgerEntry.CopyFromGenJnlLine(GenJnlLine);
        EmployeeLedgerEntry."Entry No." := NextEntryNo;
        EmployeeLedgerEntry."Transaction No." := NextTransactionNo;
    END;

    LOCAL PROCEDURE ApplyEmplLedgEntry(VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; Employee: Record 5200);
    VAR
        OldEmplLedgEntry: Record "Employee Ledger Entry";
        OldCVLedgEntryBuf: Record 382;
        NewCVLedgEntryBuf2: Record 382;
        TempOldEmplLedgEntry: Record "Employee Ledger Entry" TEMPORARY;
        Completed: Boolean;
        AppliedAmount: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
    BEGIN
        IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
            EXIT;

        AllApplied := TRUE;
        IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
           NOT
           ((Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") AND
            GenJnlLine."Allow Application")
        THEN
            EXIT;

        PmtTolAmtToBeApplied := 0;
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        IF NOT PrepareTempEmplLedgEntry(GenJnlLine, NewCVLedgEntryBuf, TempOldEmplLedgEntry, Employee, ApplyingDate) THEN
            EXIT;

        GenJnlLine."Posting Date" := ApplyingDate;

        // Apply the new entry (Payment) to the old entries one at a time
        REPEAT
            TempOldEmplLedgEntry.CALCFIELDS(
              TempOldEmplLedgEntry.Amount, TempOldEmplLedgEntry."Amount (LCY)", TempOldEmplLedgEntry."Remaining Amount", TempOldEmplLedgEntry."Remaining Amt. (LCY)",
              TempOldEmplLedgEntry."Original Amount", TempOldEmplLedgEntry."Original Amt. (LCY)");
            OldCVLedgEntryBuf.CopyFromEmplLedgEntry(TempOldEmplLedgEntry);
            TempOldEmplLedgEntry.COPYFILTER(TempOldEmplLedgEntry.Positive, OldCVLedgEntryBuf.Positive);

            PostApply(
              GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2,
              TRUE, AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            // Update the Old Entry
            TempOldEmplLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
            OldEmplLedgEntry := TempOldEmplLedgEntry;
            OldEmplLedgEntry."Applies-to ID" := '';
            OldEmplLedgEntry."Amount to Apply" := 0;
            OldEmplLedgEntry.MODIFY;

            TempOldEmplLedgEntry.DELETE;

            // Find the next old entry to apply to the new entry
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN
                Completed := TRUE
            ELSE
                IF TempOldEmplLedgEntry.GETFILTER(TempOldEmplLedgEntry.Positive) <> '' THEN
                    IF TempOldEmplLedgEntry.NEXT = 1 THEN
                        Completed := FALSE
                    ELSE BEGIN
                        TempOldEmplLedgEntry.SETRANGE(TempOldEmplLedgEntry.Positive);
                        TempOldEmplLedgEntry.FIND('-');
                        TempOldEmplLedgEntry.CALCFIELDS(TempOldEmplLedgEntry."Remaining Amount");
                        Completed := TempOldEmplLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
                    END
                ELSE
                    IF NewCVLedgEntryBuf.Open THEN
                        Completed := TempOldEmplLedgEntry.NEXT = 0
                    ELSE
                        Completed := TRUE;
        UNTIL Completed;

        DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.", "Entry Type");
        DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.", NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SETRANGE(
          "Entry Type",
          DtldCVLedgEntryBuf."Entry Type"::Application);
        DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)", Amount);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;
    END;

    LOCAL PROCEDURE PostDtldEmplLedgEntries(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; EmplPostingGr: Record "Employee Posting Group"; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean;
    VAR
        //Win513++
        //TempInvPostBuf: Record 49 TEMPORARY;
        TempInvPostBuf: Record 50500 TEMPORARY;
        //Win513--
        DtldEmplLedgEntry: Record "Detailed Employee Ledger Entry";
        DummyAdjAmount: ARRAY[4] OF Decimal;
        DtldEmplLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
        NextEntryNo: Integer;
        GenJnlPostLine: Codeunit 12;
    BEGIN
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Employee THEN
            EXIT;

        IF DtldEmplLedgEntry.FINDLAST THEN
            DtldEmplLedgEntryNoOffset := DtldEmplLedgEntry."Entry No."
        ELSE
            DtldEmplLedgEntryNoOffset := 0;

        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            END;
            REPEAT
                InsertDtldEmplLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldEmplLedgEntry, DtldEmplLedgEntryNoOffset);

                UpdateTotalAmounts(
                   TempInvPostBuf, GenJnlLine."Dimension Set ID",
                   DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount");
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;
        END;


        CreateGLEntriesForTotalAmounts(
          GenJnlLine, TempInvPostBuf, DummyAdjAmount, SaveEntryNo, EmplPostingGr.GetPayablesAccount, LedgEntryInserted);

        DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
        DtldCVLedgEntryBuf.DELETEALL;
    END;

    //Win513++
    //LOCAL PROCEDURE UpdateTotalAmounts(VAR TempInvPostBuf: Record 49 TEMPORARY; DimSetID: Integer; AmountToCollect: Decimal; AmountACYToCollect: Decimal);
    LOCAL PROCEDURE UpdateTotalAmounts(VAR TempInvPostBuf: Record 50500 TEMPORARY; DimSetID: Integer; AmountToCollect: Decimal; AmountACYToCollect: Decimal);
    //Win513++
    BEGIN
        //Win513++
        //WITH TempInvPostBuf DO BEGIN
        //Win513--
        // SETRANGE("Dimension Set ID", DimSetID);
        // IF FINDFIRST THEN BEGIN
        //     Amount += AmountToCollect;
        //     "Amount (ACY)" += AmountACYToCollect;
        //     MODIFY;
        // END ELSE BEGIN
        //     INIT;
        //     "Dimension Set ID" := DimSetID;
        //     Amount := AmountToCollect;
        //     "Amount (ACY)" := AmountACYToCollect;
        //     INSERT;
        // END;
        TempInvPostBuf.SETRANGE(TempInvPostBuf."Dimension Set ID", DimSetID);
        IF TempInvPostBuf.FINDFIRST THEN BEGIN
            TempInvPostBuf.Amount += AmountToCollect;
            TempInvPostBuf."Amount (ACY)" += AmountACYToCollect;
            TempInvPostBuf.MODIFY;
        END ELSE BEGIN
            TempInvPostBuf.INIT;
            TempInvPostBuf."Dimension Set ID" := DimSetID;
            TempInvPostBuf.Amount := AmountToCollect;
            TempInvPostBuf."Amount (ACY)" := AmountACYToCollect;
            TempInvPostBuf.INSERT;
        END;
        //Win513++
        //END;
        //Win513--
    END;


    //Win513++
    //LOCAL PROCEDURE CreateGLEntriesForTotalAmounts(GenJnlLine: Record 81; VAR InvPostBuf: Record 49; AdjAmountBuf: ARRAY[4] OF Decimal; SavedEntryNo: Integer; GLAccNo: Code[20]; LedgEntryInserted: Boolean);
    LOCAL PROCEDURE CreateGLEntriesForTotalAmounts(GenJnlLine: Record 81; VAR InvPostBuf: Record 50500; AdjAmountBuf: ARRAY[4] OF Decimal; SavedEntryNo: Integer; GLAccNo: Code[20]; LedgEntryInserted: Boolean);
    //Win513--
    VAR
        DimMgt: Codeunit 408;
        GLEntryInserted: Boolean;
        AddCurrencyCode: Code[10];
    BEGIN
        GLEntryInserted := FALSE;

        //Win513++
        //WITH InvPostBuf DO BEGIN
        //Win513--
        // RESET;
        // IF FINDSET THEN
        //     REPEAT
        //         IF (Amount <> 0) OR ("Amount (ACY)" <> 0) AND (AddCurrencyCode <> '') THEN BEGIN
        //             DimMgt.UpdateGenJnlLineDim(GenJnlLine, "Dimension Set ID");
        //             CreateGLEntryForTotalAmounts(GenJnlLine, Amount, "Amount (ACY)", AdjAmountBuf, SavedEntryNo, GLAccNo);
        //             GLEntryInserted := TRUE;
        //         END;
        //     UNTIL NEXT = 0;
        InvPostBuf.RESET;
        IF InvPostBuf.FINDSET THEN
            REPEAT
                IF (InvPostBuf.Amount <> 0) OR (InvPostBuf."Amount (ACY)" <> 0) AND (AddCurrencyCode <> '') THEN BEGIN
                    DimMgt.UpdateGenJnlLineDim(GenJnlLine, InvPostBuf."Dimension Set ID");
                    CreateGLEntryForTotalAmounts(GenJnlLine, InvPostBuf.Amount, InvPostBuf."Amount (ACY)", AdjAmountBuf, SavedEntryNo, GLAccNo);
                    GLEntryInserted := TRUE;
                END;
            UNTIL InvPostBuf.NEXT = 0;
        //Win513++
        //END;
        //Win513--

        IF NOT GLEntryInserted AND LedgEntryInserted THEN
            CreateGLEntryForTotalAmounts(GenJnlLine, 0, 0, AdjAmountBuf, SavedEntryNo, GLAccNo);
    END;

    procedure IsNotPayment(DocumentType: Enum "Gen. Journal Document Type") Result: Boolean
    begin
        Result := DocumentType in [DocumentType::Invoice,
                              DocumentType::"Credit Memo",
                              DocumentType::"Finance Charge Memo",
                              DocumentType::Reminder];


    end;

    PROCEDURE CreateGLEntryForTotalAmounts(GenJnlLine: Record 81; Amount: Decimal; AmountACY: Decimal; AdjAmountBuf: ARRAY[4] OF Decimal; VAR SavedEntryNo: Integer; GLAccNo: Code[20]);
    VAR
        GLEntry: Record 17;
    BEGIN
        HandleDtldAdjustment(GenJnlLine, GLEntry, AdjAmountBuf, Amount, AmountACY, GLAccNo);
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        UpdateGLEntryNo(GLEntry."Entry No.", SavedEntryNo);
        GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    END;

    PROCEDURE HandleDtldAdjustment(GenJnlLine: Record 81; VAR GLEntry: Record 17; AdjAmount: ARRAY[4] OF Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAccNo: Code[20]);
    BEGIN
        IF NOT PostDtldAdjustment(
             GenJnlLine, GLEntry, AdjAmount,
             TotalAmountLCY, TotalAmountAddCurr, GLAccNo,
             GetAdjAmountOffset(TotalAmountLCY, TotalAmountAddCurr))
        THEN
            InitGLEntry(GenJnlLine, GLEntry, GLAccNo, TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
    END;

    PROCEDURE PostDtldAdjustment(GenJnlLine: Record 81; VAR GLEntry: Record 17; AdjAmount: ARRAY[4] OF Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAcc: Code[20]; ArrayIndex: Integer): Boolean;
    BEGIN
        IF (GenJnlLine."Bal. Account No." <> '') AND
           ((AdjAmount[ArrayIndex] <> 0) OR (AdjAmount[ArrayIndex + 1] <> 0)) AND
           ((TotalAmountLCY + AdjAmount[ArrayIndex] <> 0) OR (TotalAmountAddCurr + AdjAmount[ArrayIndex + 1] <> 0))
        THEN BEGIN
            CreateGLEntryBalAcc(
              GenJnlLine, GLAcc, -AdjAmount[ArrayIndex], -AdjAmount[ArrayIndex + 1],
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
            InitGLEntry(GenJnlLine, GLEntry,
              GLAcc, TotalAmountLCY + AdjAmount[ArrayIndex],
              TotalAmountAddCurr + AdjAmount[ArrayIndex + 1], TRUE, TRUE);
            AdjAmount[ArrayIndex] := 0;
            AdjAmount[ArrayIndex + 1] := 0;
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE InitGLEntry(GenJnlLine: Record 81; VAR GLEntry: Record 17; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean);
    VAR
        GLAcc: Record 15;
        EntryType: Option;
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
        FADimAlreadyChecked: Boolean;
        UseVendExchRate: Boolean;
    BEGIN
        IF GLAccNo <> '' THEN BEGIN
            GLAcc.GET(GLAccNo);
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);

            // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
            IF (NOT
                ((GLAccNo = GenJnlLine."Account No.") AND
                 (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account")) OR
                ((GLAccNo = GenJnlLine."Bal. Account No.") AND
                 (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"G/L Account"))) AND
               NOT FADimAlreadyChecked
            THEN
                CheckGLAccDimError(GenJnlLine, GLAccNo);
        END;

        GLEntry.INIT;
        //GLEntry."Entry Type" := EntryType;
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        GLEntry."Entry No." := NextEntryNo;
        GenJnlLine."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        UseVendExchRate := FALSE;
        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(Amount, AmountAddCurr, GLEntry."Additional-Currency Amount", UseAmountAddCurr, GenJnlLine, UseVendExchRate);


        GLEntry."PDC Document No." := GenJnlLine."PDC Document No.";
        GLEntry."PDC Line No." := GenJnlLine."PDC Line No.";    //PPG
        GLEntry."Check No." := GenJnlLine."Check No.";   //win315
        GLEntry."Service Contract No." := GenJnlLine."Service Contract No.";  //win315
        GLEntry."Charge Code" := GenJnlLine."Charge Code";  //win315
        GLEntry."Charge Description" := GenJnlLine."Charge Description";  //win315
    END;

    LOCAL PROCEDURE CheckGLAccDimError(GenJnlLine: Record 81; GLAccNo: Code[20]);
    VAR
        DimMgt: Codeunit 408;
        TableID: ARRAY[10] OF Integer;
        AccNo: ARRAY[10] OF Code[20];
        DimensionUsedErr: Label 'ENU = @@@=Comment;ENU=A dimension used in %1 %2, %3, %4 has caused an error. %5.;ENA=A dimension used in %1 %2, %3, %4 has caused an error. %5.';
    BEGIN
        IF (GenJnlLine.Amount = 0) AND (GenJnlLine."Amount (LCY)" = 0) THEN
            EXIT;

        TableID[1] := DATABASE::"G/L Account";
        AccNo[1] := GLAccNo;
        IF DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
            EXIT;

        IF GenJnlLine."Line No." <> 0 THEN
            ERROR(
              DimensionUsedErr,
              GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
              GenJnlLine."Journal Batch Name", GenJnlLine."Line No.",
              DimMgt.GetDimValuePostingErr);

        ERROR(DimMgt.GetDimValuePostingErr);
    END;

    PROCEDURE GLCalcAddCurrency(Amount: Decimal; AddCurrAmount: Decimal; OldAddCurrAmount: Decimal; UseAddCurrAmount: Boolean; GenJnlLine: Record 81; VAR UseVendExchRateCheck: Boolean): Decimal;
    VAR
        PurchSetup: Record 312;
        AddCurrencyCode: Code[10];
        UseVendExchRate: Boolean;
    BEGIN
        IF (AddCurrencyCode <> '') AND
           (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None)
        THEN BEGIN
            IF (GenJnlLine."Source Currency Code" = AddCurrencyCode) AND UseAddCurrAmount THEN
                EXIT(AddCurrAmount);

            PurchSetup.GET;
            IF PurchSetup.GET AND PurchSetup."Enable Vendor GST Amount (ACY)" AND UseVendExchRateCheck THEN
                EXIT(AddCurrAmount);

            //EXIT(ExchangeAmtLCYToFCY2(Amount));
        END;
        UseVendExchRate := FALSE;
        EXIT(OldAddCurrAmount);
    END;

    //Win513++
    //PROCEDURE CreateGLEntryBalAcc(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: option; BalAccNo: Code[20]);
    PROCEDURE CreateGLEntryBalAcc(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]);
    //Win513--
    VAR
        GLEntry: Record 17;
    BEGIN
        GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE);
        GLEntry."Bal. Account Type" := BalAccType;
        GLEntry."Bal. Account No." := BalAccNo;
        GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        //Win502 OnMoveGenJournalLine(GLEntry.RECORDID);
    END;

    PROCEDURE GetAdjAmountOffset(Amount: Decimal; AmountACY: Decimal): Integer;
    BEGIN
        IF (Amount > 0) OR (Amount = 0) AND (AmountACY > 0) THEN
            EXIT(1);
        EXIT(3);
    END;


    PROCEDURE UpdateGLEntryNo(VAR GLEntryNo: Integer; VAR SavedEntryNo: Integer);
    var
        NextEntryNo: Integer;
    BEGIN
        IF SavedEntryNo <> 0 THEN BEGIN
            GLEntryNo := SavedEntryNo;
            NextEntryNo := NextEntryNo - 1;
            SavedEntryNo := 0;
        END;
    END;

    LOCAL PROCEDURE CreateGLEntry(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean);
    VAR
        GLEntry: Record 17;
    BEGIN
        IF UseAmountAddCurr THEN
            GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE)
        ELSE BEGIN
            GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
        END;
        GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    END;

    LOCAL PROCEDURE PrepareTempEmplLedgEntry(GenJnlLine: Record 81; VAR NewCVLedgEntryBuf: Record 382; VAR TempOldEmplLedgEntry: Record "Employee Ledger Entry" TEMPORARY; Employee: Record 5200; VAR ApplyingDate: Date): Boolean;
    VAR
        OldEmplLedgEntry: Record "Employee Ledger Entry";
        RemainingAmount: Decimal;
    BEGIN
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find the entry to be applied to
            OldEmplLedgEntry.RESET;
            OldEmplLedgEntry.SETCURRENTKEY("Document No.");
            OldEmplLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            OldEmplLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            OldEmplLedgEntry.SETRANGE("Employee No.", NewCVLedgEntryBuf."CV No.");
            OldEmplLedgEntry.SETRANGE(Open, TRUE);
            OldEmplLedgEntry.FINDFIRST;
            OldEmplLedgEntry.TESTFIELD(Positive, NOT NewCVLedgEntryBuf.Positive);
            IF OldEmplLedgEntry."Posting Date" > ApplyingDate THEN
                ApplyingDate := OldEmplLedgEntry."Posting Date";
            TempOldEmplLedgEntry := OldEmplLedgEntry;
            TempOldEmplLedgEntry.INSERT;
        END ELSE BEGIN
            // Find the first old entry which the new entry (Payment) should apply to
            OldEmplLedgEntry.RESET;
            OldEmplLedgEntry.SETCURRENTKEY("Employee No.", "Applies-to ID", Open, Positive);
            TempOldEmplLedgEntry.SETCURRENTKEY("Employee No.", "Applies-to ID", Open, Positive);
            OldEmplLedgEntry.SETRANGE("Employee No.", NewCVLedgEntryBuf."CV No.");
            OldEmplLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            OldEmplLedgEntry.SETRANGE(Open, TRUE);
            OldEmplLedgEntry.SETFILTER("Entry No.", '<>%1', NewCVLedgEntryBuf."Entry No.");
            IF NOT (Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") THEN
                OldEmplLedgEntry.SETFILTER("Amount to Apply", '<>%1', 0);

            IF Employee."Application Method" = Employee."Application Method"::"Apply to Oldest" THEN
                OldEmplLedgEntry.SETFILTER("Posting Date", '..%1', GenJnlLine."Posting Date");

            OldEmplLedgEntry.SETRANGE("Currency Code", NewCVLedgEntryBuf."Currency Code");
            IF OldEmplLedgEntry.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    IF (OldEmplLedgEntry."Posting Date" > ApplyingDate) AND (OldEmplLedgEntry."Applies-to ID" <> '') THEN
                        ApplyingDate := OldEmplLedgEntry."Posting Date";
                    TempOldEmplLedgEntry := OldEmplLedgEntry;
                    TempOldEmplLedgEntry.INSERT;
                UNTIL OldEmplLedgEntry.NEXT = 0;

            TempOldEmplLedgEntry.SETRANGE(Positive, NewCVLedgEntryBuf."Remaining Amount" > 0);

            IF TempOldEmplLedgEntry.FIND('-') THEN BEGIN
                RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
                TempOldEmplLedgEntry.SETRANGE(Positive);
                TempOldEmplLedgEntry.FIND('-');
                REPEAT
                    TempOldEmplLedgEntry.CALCFIELDS("Remaining Amount");
                    RemainingAmount += TempOldEmplLedgEntry."Remaining Amount";
                UNTIL TempOldEmplLedgEntry.NEXT = 0;
                TempOldEmplLedgEntry.SETRANGE(Positive, RemainingAmount < 0);
            END ELSE
                TempOldEmplLedgEntry.SETRANGE(Positive);
            EXIT(TempOldEmplLedgEntry.FIND('-'));
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostApply(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR OldCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf2: Record 382; BlockPaymentTolerance: Boolean; AllApplied: Boolean; VAR AppliedAmount: Decimal; VAR PmtTolAmtToBeApplied: Decimal);
    VAR
        OldCVLedgEntryBuf2: Record 382;
        OldCVLedgEntryBuf3: Record 382;
        OldRemainingAmtBeforeAppln: Decimal;
        ApplnRoundingPrecision: Decimal;
        AppliedAmountLCY: Decimal;
        OldAppliedAmount: Decimal;
        GenJouPostLine: Codeunit 12;
        NextTransactionNo: Integer;
        FirstNewVATEntryNo: Integer;
        PaymentToleranceMgt: Codeunit 426;
        GLSetup: Record 98;


    BEGIN
        OldRemainingAmtBeforeAppln := OldCVLedgEntryBuf."Remaining Amount";
        OldCVLedgEntryBuf3 := OldCVLedgEntryBuf;

        // Management of posting in multiple currencies
        OldCVLedgEntryBuf2 := OldCVLedgEntryBuf;
        OldCVLedgEntryBuf.COPYFILTER(Positive, OldCVLedgEntryBuf2.Positive);
        ApplnRoundingPrecision := GetApplnRoundPrecision(NewCVLedgEntryBuf, OldCVLedgEntryBuf);

        OldCVLedgEntryBuf2.RecalculateAmounts(
          OldCVLedgEntryBuf2."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");

        IF NOT BlockPaymentTolerance THEN
            CalcPmtTolerance(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              PmtTolAmtToBeApplied, NextTransactionNo, FirstNewVATEntryNo);

        CalcPmtDisc(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
          PmtTolAmtToBeApplied, ApplnRoundingPrecision, NextTransactionNo, FirstNewVATEntryNo);

        IF NOT BlockPaymentTolerance THEN
            CalcPmtDiscTolerance(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              NextTransactionNo, FirstNewVATEntryNo);

        CalcCurrencyApplnRounding(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf,
          GenJnlLine, ApplnRoundingPrecision);

        FindAmtForAppln(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2,
          AppliedAmount, AppliedAmountLCY, OldAppliedAmount, ApplnRoundingPrecision);

        CalcCurrencyUnrealizedGainLoss(
          OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, -OldAppliedAmount, OldRemainingAmtBeforeAppln);

        CalcCurrencyRealizedGainLoss(
           NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, AppliedAmount, AppliedAmountLCY);

        CalcCurrencyRealizedGainLoss(
          OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, -OldAppliedAmount, -AppliedAmountLCY);

        CalcApplication(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, DtldCVLedgEntryBuf,
          GenJnlLine, AppliedAmount, AppliedAmountLCY, OldAppliedAmount,
          NewCVLedgEntryBuf2, OldCVLedgEntryBuf3, AllApplied);

        PaymentToleranceMgt.CalcRemainingPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, GLSetup);

        CalcAmtLCYAdjustment(OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);
    END;


    // std Local proc add

    PROCEDURE FindAmtForAppln(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR AppliedAmount: Decimal; VAR AppliedAmountLCY: Decimal; VAR OldAppliedAmount: Decimal; ApplnRoundingPrecision: Decimal);
    var
        PaymentToleranceMgt: Codeunit 426;
        CurrExchRate: Record 330;
    BEGIN
        IF OldCVLedgEntryBuf2.GETFILTER(Positive) <> '' THEN BEGIN
            IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN BEGIN
                IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
                    (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
                     ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")))
                THEN
                    AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount"
                ELSE
                    AppliedAmount := -OldCVLedgEntryBuf2."Amount to Apply"
            END ELSE
                AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
        END ELSE BEGIN
            IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN
                IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
                    (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
                     ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")) AND
                    (ABS(NewCVLedgEntryBuf."Remaining Amount") >=
                     ABS(
                       ABSMin(
                         OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible",
                         OldCVLedgEntryBuf2."Amount to Apply")))) OR
                   OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance"
                THEN BEGIN
                    AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
                    OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance" := FALSE;
                END ELSE
                    AppliedAmount := GetAppliedAmountFromBuffers(NewCVLedgEntryBuf, OldCVLedgEntryBuf2)
            ELSE
                AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf2."Remaining Amount");
        END;

        IF (ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply") < ApplnRoundingPrecision) AND
           (ApplnRoundingPrecision <> 0) AND
           (OldCVLedgEntryBuf2."Amount to Apply" <> 0)
        THEN
            AppliedAmount := AppliedAmount - (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply");

        IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code" THEN BEGIN
            AppliedAmountLCY := ROUND(AppliedAmount / OldCVLedgEntryBuf."Original Currency Factor");
            OldAppliedAmount := AppliedAmount;
        END ELSE BEGIN
            // Management of posting in multiple currencies
            IF AppliedAmount = -OldCVLedgEntryBuf2."Remaining Amount" THEN
                OldAppliedAmount := -OldCVLedgEntryBuf."Remaining Amount"
            ELSE
                OldAppliedAmount :=
                  CurrExchRate.ExchangeAmount(
                    AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                    OldCVLedgEntryBuf2."Currency Code", NewCVLedgEntryBuf."Posting Date");

            IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
                // Post the realized gain or loss on the NewCVLedgEntryBuf
                AppliedAmountLCY := ROUND(OldAppliedAmount / OldCVLedgEntryBuf."Original Currency Factor")
            ELSE
                // Post the realized gain or loss on the OldCVLedgEntryBuf
                AppliedAmountLCY := ROUND(AppliedAmount / NewCVLedgEntryBuf."Original Currency Factor");
        END;
    END;

    PROCEDURE GetAppliedAmountFromBuffers(NewCVLedgEntryBuf: Record 382; OldCVLedgEntryBuf: Record 382): Decimal;
    BEGIN
        IF (((NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."Document Type"::Payment) AND
             (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."Document Type"::"Credit Memo")) OR
            ((NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."Document Type"::Refund) AND
             (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."Document Type"::Invoice))) AND
           (ABS(NewCVLedgEntryBuf."Remaining Amount") < ABS(OldCVLedgEntryBuf."Amount to Apply"))
        THEN
            EXIT(ABSMax(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf."Amount to Apply"));
        EXIT(ABSMin(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf."Amount to Apply"));
    END;

    PROCEDURE ABSMax(Decimal1: Decimal; Decimal2: Decimal): Decimal;
    BEGIN
        IF ABS(Decimal1) > ABS(Decimal2) THEN
            EXIT(Decimal1);
        EXIT(Decimal2);
    END;

    PROCEDURE ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal;
    BEGIN
        IF ABS(Decimal1) < ABS(Decimal2) THEN
            EXIT(Decimal1);
        EXIT(Decimal2);
    END;

    PROCEDURE CalcAmtLCYAdjustment(VAR CVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81);
    VAR
        AdjustedAmountLCY: Decimal;
    BEGIN
        IF CVLedgEntryBuf."Currency Code" = '' THEN
            EXIT;

        AdjustedAmountLCY :=
          ROUND(CVLedgEntryBuf."Remaining Amount" / CVLedgEntryBuf."Adjusted Currency Factor");

        IF AdjustedAmountLCY <> CVLedgEntryBuf."Remaining Amt. (LCY)" THEN BEGIN
            DtldCVLedgEntryBuf.InitFromGenJnlLine(GenJnlLine);
            DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(CVLedgEntryBuf);
            DtldCVLedgEntryBuf."Entry Type" :=
              DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount";
            DtldCVLedgEntryBuf."Amount (LCY)" := AdjustedAmountLCY - CVLedgEntryBuf."Remaining Amt. (LCY)";
            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, CVLedgEntryBuf, FALSE);
        END;
    END;


    PROCEDURE CalcApplication(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; AppliedAmount: Decimal; AppliedAmountLCY: Decimal; OldAppliedAmount: Decimal; PrevNewCVLedgEntryBuf: Record 382; PrevOldCVLedgEntryBuf: Record 382; VAR AllApplied: Boolean);
    BEGIN
        IF AppliedAmount = 0 THEN
            EXIT;
        //Win513++
        //DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        DtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
          //Win513--
          GenJnlLine, OldCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::Application, OldAppliedAmount, AppliedAmountLCY, 0,
          NewCVLedgEntryBuf."Entry No.", PrevOldCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
          PrevOldCVLedgEntryBuf."Max. Payment Tolerance");

        OldCVLedgEntryBuf.Open := OldCVLedgEntryBuf."Remaining Amount" <> 0;
        IF NOT OldCVLedgEntryBuf.Open THEN
            OldCVLedgEntryBuf.SetClosedFields(
              NewCVLedgEntryBuf."Entry No.", GenJnlLine."Posting Date",
              -OldAppliedAmount, -AppliedAmountLCY, NewCVLedgEntryBuf."Currency Code", -AppliedAmount)
        ELSE
            AllApplied := FALSE;

        //Win513++
        //DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        DtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
            //Win513--
            GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
            DtldCVLedgEntryBuf."Entry Type"::Application, -AppliedAmount, -AppliedAmountLCY, 0,
            NewCVLedgEntryBuf."Entry No.", PrevNewCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
            PrevNewCVLedgEntryBuf."Max. Payment Tolerance");

        NewCVLedgEntryBuf.Open := NewCVLedgEntryBuf."Remaining Amount" <> 0;
        IF NOT NewCVLedgEntryBuf.Open AND NOT AllApplied THEN
            NewCVLedgEntryBuf.SetClosedFields(
              OldCVLedgEntryBuf."Entry No.", GenJnlLine."Posting Date",
              AppliedAmount, AppliedAmountLCY, OldCVLedgEntryBuf."Currency Code", OldAppliedAmount);
    END;

    PROCEDURE GetApplnRoundPrecision(NewCVLedgEntryBuf: Record 382; OldCVLedgEntryBuf: Record 382): Decimal;
    VAR
        ApplnCurrency: Record 4;
        CurrencyCode: Code[10];
        GLSetup: Record 98;
    BEGIN
        IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
            CurrencyCode := NewCVLedgEntryBuf."Currency Code"
        ELSE
            CurrencyCode := OldCVLedgEntryBuf."Currency Code";
        IF CurrencyCode = '' THEN
            EXIT(0);
        ApplnCurrency.GET(CurrencyCode);
        IF ApplnCurrency."Appln. Rounding Precision" <> 0 THEN
            EXIT(ApplnCurrency."Appln. Rounding Precision");
        EXIT(GLSetup."Appln. Rounding Precision");
    END;

    LOCAL PROCEDURE InsertDtldEmplLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VAR DtldEmplLedgEntry: Record "Detailed Employee Ledger Entry"; Offset: Integer);
    var
        NextTransactionNo: Integer;
    BEGIN
        //Win513++
        //WITH DtldEmplLedgEntry DO BEGIN
        //Win513--
        // INIT;
        // TRANSFERFIELDS(DtldCVLedgEntryBuf);
        // "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        // "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        // "Reason Code" := GenJnlLine."Reason Code";
        // "Source Code" := GenJnlLine."Source Code";
        // "Transaction No." := NextTransactionNo;
        // UpdateDebitCredit(GenJnlLine.Correction);
        // INSERT(TRUE);
        DtldEmplLedgEntry.INIT;
        DtldEmplLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);
        DtldEmplLedgEntry."Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        DtldEmplLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        DtldEmplLedgEntry."Reason Code" := GenJnlLine."Reason Code";
        DtldEmplLedgEntry."Source Code" := GenJnlLine."Source Code";
        DtldEmplLedgEntry."Transaction No." := NextTransactionNo;
        DtldEmplLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        DtldEmplLedgEntry.INSERT(TRUE);
        //Win513++
        //END;
        //Win513--
    end;

    LOCAL PROCEDURE CalcCurrencyUnrealizedGainLoss(VAR CVLedgEntryBuf: Record 382; VAR TempDtldCVLedgEntryBuf: Record 383 temporary; GenJnlLine: Record 81; AppliedAmount: Decimal; RemainingAmountBeforeAppln: Decimal);
    VAR
        DtldCustLedgEntry: Record 379;
        DtldVendLedgEntry: Record 380;
        UnRealizedGainLossLCY: Decimal;
    BEGIN
        IF (CVLedgEntryBuf."Currency Code" = '') OR (RemainingAmountBeforeAppln = 0) THEN
            EXIT;

        // Calculate Unrealized GainLoss
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
            UnRealizedGainLossLCY :=
              ROUND(
                DtldCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln))
        ELSE
            UnRealizedGainLossLCY :=
              ROUND(
                DtldVendLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln));

        IF UnRealizedGainLossLCY <> 0 THEN
            IF UnRealizedGainLossLCY < 0 THEN
                //Win513++
                //TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                TempDtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
                //Win513--    
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0)
            ELSE
                //Win513++
                //TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                TempDtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
                //Win513--
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0);
    END;

    LOCAL PROCEDURE CalcCurrencyRealizedGainLoss(VAR CVLedgEntryBuf: Record 382; VAR TempDtldCVLedgEntryBuf: Record 383 TEMPORARY; GenJnlLine: Record 81; AppliedAmount: Decimal; AppliedAmountLCY: Decimal);
    VAR
        RealizedGainLossLCY: Decimal;
    BEGIN
        IF CVLedgEntryBuf."Currency Code" = '' THEN
            EXIT;

        // Calculate Realized GainLoss
        RealizedGainLossLCY :=
          AppliedAmountLCY - ROUND(AppliedAmount / CVLedgEntryBuf."Original Currency Factor");
        IF RealizedGainLossLCY <> 0 THEN
            IF RealizedGainLossLCY < 0 THEN
                //Win513++
                //TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                TempDtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
                  //Win513--
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Realized Loss", 0, RealizedGainLossLCY, 0, 0, 0, 0)
            ELSE
                //Win513++
                //TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                TempDtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
                  //Win513--
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Realized Gain", 0, RealizedGainLossLCY, 0, 0, 0, 0);
    END;


    PROCEDURE CalcPmtTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; VAR PmtTolAmtToBeApplied: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer);
    VAR
        PmtTol: Decimal;
        PmtTolLCY: Decimal;
        PmtTolAddCurr: Decimal;
        AddCurrencyCode: Code[10];
        GLSetup: Record 98;
    BEGIN
        IF OldCVLedgEntryBuf2."Accepted Payment Tolerance" = 0 THEN
            EXIT;

        PmtTol := -OldCVLedgEntryBuf2."Accepted Payment Tolerance";
        PmtTolAmtToBeApplied := PmtTolAmtToBeApplied + PmtTol;
        PmtTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Accepted Payment Tolerance" := 0;
        OldCVLedgEntryBuf."Pmt. Tolerance (LCY)" := -PmtTolLCY;

        IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
            PmtTolAddCurr := PmtTol
        ELSE
            PmtTolAddCurr := CalcLCYToAddCurr(PmtTolLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtTolLCY <> 0) THEN
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtTolLCY, PmtTolAddCurr,
              NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)");

        //Win513++
        //DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        DtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
          //Win513--
          GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance", PmtTol, PmtTolLCY, PmtTolAddCurr, 0, 0, 0);
    END;

    //Win513++
    //PROCEDURE CalcPmtDiscIfAdjVAT(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; VAR PmtDiscLCY2: Decimal; VAR PmtDiscAddCurr2: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer; EntryType: Interger);
    PROCEDURE CalcPmtDiscIfAdjVAT(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; VAR PmtDiscLCY2: Decimal; VAR PmtDiscAddCurr2: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer; EntryType: Enum "Detailed CV Ledger Entry Type");
    //Win513--
    VAR
        VATEntry2: Record 254;
        VATPostingSetup: Record 325;
        TaxJurisdiction: Record 320;
        DtldCVLedgEntryBuf2: Record 383;
        OriginalAmountAddCurr: Decimal;
        PmtDiscRounding: Decimal;
        PmtDiscRoundingAddCurr: Decimal;
        PmtDiscFactorLCY: Decimal;
        PmtDiscFactorAddCurr: Decimal;
        VATBase: Decimal;
        VATBaseAddCurr: Decimal;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        TotalVATAmount: Decimal;
        LastConnectionNo: Integer;
        VATEntryModifier: Integer;
        AddCurrencyCode: code[10];
        AddCurrency: Record 4;
        TempVATEntry: Record 254 TEMPORARY;
    BEGIN
        IF OldCVLedgEntryBuf."Original Amt. (LCY)" = 0 THEN
            EXIT;

        IF (AddCurrencyCode = '') OR (AddCurrencyCode = OldCVLedgEntryBuf."Currency Code") THEN
            OriginalAmountAddCurr := OldCVLedgEntryBuf.Amount
        ELSE
            OriginalAmountAddCurr := CalcLCYToAddCurr(OldCVLedgEntryBuf."Original Amt. (LCY)");

        PmtDiscRounding := PmtDiscLCY2;
        PmtDiscFactorLCY := PmtDiscLCY2 / OldCVLedgEntryBuf."Original Amt. (LCY)";
        IF OriginalAmountAddCurr <> 0 THEN
            PmtDiscFactorAddCurr := PmtDiscAddCurr2 / OriginalAmountAddCurr
        ELSE
            PmtDiscFactorAddCurr := 0;
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", OldCVLedgEntryBuf."Transaction No.");
        IF OldCVLedgEntryBuf."Transaction No." = NextTransactionNo THEN
            VATEntry2.SETRANGE("Entry No.", 0, FirstNewVATEntryNo - 1);
        IF VATEntry2.FINDSET THEN BEGIN
            TotalVATAmount := 0;
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATEntry2."VAT Calculation Type" =
                   VATEntry2."VAT Calculation Type"::"Sales Tax"
                THEN BEGIN
                    TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                    VATPostingSetup."Adjust for Payment Discount" :=
                      TaxJurisdiction."Adjust for Payment Discount";
                END;
                IF VATPostingSetup."Adjust for Payment Discount" THEN BEGIN
                    IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                        IF LastConnectionNo <> 0 THEN BEGIN
                            DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                            DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, FALSE);
                            InsertSummarizedVAT(GenJnlLine);
                        END;

                        CalcPmtDiscVATBases(VATEntry2, VATBase, VATBaseAddCurr);

                        PmtDiscRounding := PmtDiscRounding + VATBase * PmtDiscFactorLCY;
                        VATBase := ROUND(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATBase;

                        PmtDiscRoundingAddCurr := PmtDiscRoundingAddCurr + VATBaseAddCurr * PmtDiscFactorAddCurr;
                        VATBaseAddCurr := ROUND(CalcLCYToAddCurr(VATBase), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATBaseAddCurr;

                        DtldCVLedgEntryBuf2.INIT;
                        DtldCVLedgEntryBuf2."Posting Date" := GenJnlLine."Posting Date";
                        DtldCVLedgEntryBuf2."Document Date" := GenJnlLine."Document Date";
                        DtldCVLedgEntryBuf2."Document Type" := GenJnlLine."Document Type";
                        DtldCVLedgEntryBuf2."Document No." := GenJnlLine."Document No.";
                        DtldCVLedgEntryBuf2.Amount := 0;
                        DtldCVLedgEntryBuf2."Amount (LCY)" := -VATBase;
                        DtldCVLedgEntryBuf2."Entry Type" := EntryType;
                        CASE EntryType of
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                                VATEntryModifier := 0;
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                                VATEntryModifier := 1000000;
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                                VATEntryModifier := 2000000;
                        END;
                        DtldCVLedgEntryBuf2.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
                        // The total payment discount in currency is posted on the entry made in
                        // the function CalcPmtDisc.
                        DtldCVLedgEntryBuf2."User ID" := USERID;
                        DtldCVLedgEntryBuf2."Additional-Currency Amount" := -VATBaseAddCurr;
                        DtldCVLedgEntryBuf2.CopyPostingGroupsFromVATEntry(VATEntry2);
                        TotalVATAmount := 0;
                        LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                    END;

                    CalcPmtDiscVATAmounts(
                      VATEntry2, VATBase, VATBaseAddCurr, VATAmount, VATAmountAddCurr,
                      PmtDiscRounding, PmtDiscFactorLCY, PmtDiscLCY2, PmtDiscAddCurr2);

                    TotalVATAmount := TotalVATAmount + VATAmount;

                    IF (PmtDiscAddCurr2 <> 0) AND (PmtDiscLCY2 = 0) THEN BEGIN
                        VATAmountAddCurr := VATAmountAddCurr - PmtDiscAddCurr2;
                        PmtDiscAddCurr2 := 0;
                    END;

                    // Post VAT
                    // VAT for VAT entry
                    IF VATEntry2.Type.AsInteger() <> 0 THEN
                        InsertPmtDiscVATForVATEntry(
                          GenJnlLine, TempVATEntry, VATEntry2, VATEntryModifier,
                          VATAmount, VATAmountAddCurr, VATBase, VATBaseAddCurr,
                          PmtDiscFactorLCY, PmtDiscFactorAddCurr);

                    // VAT for G/L entry/entries
                    InsertPmtDiscVATForGLEntry(
                      GenJnlLine, DtldCVLedgEntryBuf, NewCVLedgEntryBuf, VATEntry2,
                      VATPostingSetup, TaxJurisdiction, EntryType, VATAmount, VATAmountAddCurr);
                END;
            UNTIL VATEntry2.NEXT = 0;

            IF LastConnectionNo <> 0 THEN BEGIN
                DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                InsertSummarizedVAT(GenJnlLine);
            END;
        END;
    END;

    LOCAL PROCEDURE InsertSummarizedVAT(GenJnlLine: Record 81);
    var
        TempGLEntryVAT: Record 17 TEMPORARY;
        GenJouPostLine: Codeunit "Gen. Jnl.-Post Line";
        NextConnectionNo: Integer;
        InsertedTempGLEntryVAT: Integer;
    BEGIN
        IF TempGLEntryVAT.FINDSET THEN BEGIN
            REPEAT
                GenJouPostLine.InsertGLEntry(GenJnlLine, TempGLEntryVAT, TRUE);
            UNTIL TempGLEntryVAT.NEXT = 0;
            TempGLEntryVAT.DELETEALL;
            InsertedTempGLEntryVAT := 0;
        END;
        NextConnectionNo := NextConnectionNo + 1;
    END;

    LOCAL PROCEDURE InsertPmtDiscVATForVATEntry(GenJnlLine: Record 81; VAR TempVATEntry: Record 254 TEMPORARY; VATEntry2: Record 254; VATEntryModifier: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal; VATBase: Decimal; VATBaseAddCurr: Decimal; PmtDiscFactorLCY: Decimal; PmtDiscFactorAddCurr: Decimal);
    VAR
        TempVATEntryNo: Integer;
        NextTransactionNo: Integer;
        NextConnectionNo: Integer;
        AddCurrencyCode: Code[10];
        AddCurrency: Record 4;

    BEGIN
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Entry No.", VATEntryModifier, VATEntryModifier + 999999);
        IF TempVATEntry.FINDLAST THEN
            TempVATEntryNo := TempVATEntry."Entry No." + 1
        ELSE
            TempVATEntryNo := VATEntryModifier + 1;
        InsertPmtDiscGSTReport(GenJnlLine, VATEntry2);
        TempVATEntry := VATEntry2;
        TempVATEntry."Entry No." := TempVATEntryNo;
        TempVATEntry."Posting Date" := GenJnlLine."Posting Date";
        TempVATEntry."Document No." := GenJnlLine."Document No.";
        TempVATEntry."External Document No." := GenJnlLine."External Document No.";
        TempVATEntry."Document Type" := GenJnlLine."Document Type";
        TempVATEntry."Source Code" := GenJnlLine."Source Code";
        TempVATEntry."Reason Code" := GenJnlLine."Reason Code";
        TempVATEntry."Transaction No." := NextTransactionNo;
        TempVATEntry."Sales Tax Connection No." := NextConnectionNo;
        TempVATEntry."Unrealized Amount" := 0;
        TempVATEntry."Unrealized Base" := 0;
        TempVATEntry."Remaining Unrealized Amount" := 0;
        TempVATEntry."Remaining Unrealized Base" := 0;
        TempVATEntry."User ID" := USERID;
        TempVATEntry."Closed by Entry No." := 0;
        TempVATEntry.Closed := FALSE;
        TempVATEntry."Internal Ref. No." := '';
        TempVATEntry.Amount := VATAmount;
        TempVATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        TempVATEntry."VAT Difference" := 0;
        TempVATEntry."Add.-Curr. VAT Difference" := 0;
        TempVATEntry."Add.-Currency Unrealized Amt." := 0;
        TempVATEntry."Add.-Currency Unrealized Base" := 0;
        TempVATEntry."BAS Adjustment" := GenJnlLine."BAS Adjustment";
        TempVATEntry."BAS Doc. No." := '';
        TempVATEntry."BAS Version" := 0;
        SetBASFields(TempVATEntry, VATEntry2."BAS Doc. No.", VATEntry2."BAS Version", VATEntry2."BAS Adjustment");

        IF VATEntry2."Tax on Tax" THEN BEGIN
            TempVATEntry.Base :=
              ROUND((VATEntry2.Base + VATEntry2."Unrealized Base") * PmtDiscFactorLCY);
            TempVATEntry."Additional-Currency Base" :=
              ROUND(
                (VATEntry2."Additional-Currency Base" +
                 VATEntry2."Add.-Currency Unrealized Base") * PmtDiscFactorAddCurr,
                AddCurrency."Amount Rounding Precision");
        END ELSE BEGIN
            TempVATEntry.Base := VATBase;
            TempVATEntry."Additional-Currency Base" := VATBaseAddCurr;
        END;

        IF AddCurrencyCode = '' THEN BEGIN
            TempVATEntry."Additional-Currency Base" := 0;
            TempVATEntry."Additional-Currency Amount" := 0;
            TempVATEntry."Add.-Currency Unrealized Amt." := 0;
            TempVATEntry."Add.-Currency Unrealized Base" := 0;
        END;
        TempVATEntry.INSERT;
    END;

    PROCEDURE InsertPmtDiscGSTReport(GenJnlLine: Record 81; VATEntry: Record 254);
    VAR
        TempGenJnlLine: Record 81 TEMPORARY;
        NextVATEntryNo: Integer;
    BEGIN
        //Win513++
        // WITH TempGenJnlLine DO BEGIN
        //     INIT;
        //     "Line No." := GenJnlLine."Line No.";
        //     "Posting Date" := GenJnlLine."Posting Date";
        //     "Document Type" := GenJnlLine."Document Type";
        //     "Document No." := GenJnlLine."Document No.";
        //     "VAT Base Amount (LCY)" := VATEntry.Base;
        //     "VAT Amount (LCY)" := VATEntry.Amount;
        //     "VAT Calculation Type" := VATEntry."VAT Calculation Type";
        //     "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
        //     "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
        //     "Gen. Posting Type" := VATEntry.Type;
        //     InsertGSTReport(NextVATEntryNo, TempGenJnlLine);
        // END;
        TempGenJnlLine.INIT;
        TempGenJnlLine."Line No." := GenJnlLine."Line No.";
        TempGenJnlLine."Posting Date" := GenJnlLine."Posting Date";
        TempGenJnlLine."Document Type" := GenJnlLine."Document Type";
        TempGenJnlLine."Document No." := GenJnlLine."Document No.";
        TempGenJnlLine."VAT Base Amount (LCY)" := VATEntry.Base;
        TempGenJnlLine."VAT Amount (LCY)" := VATEntry.Amount;
        TempGenJnlLine."VAT Calculation Type" := VATEntry."VAT Calculation Type";
        TempGenJnlLine."VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
        TempGenJnlLine."VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
        TempGenJnlLine."Gen. Posting Type" := VATEntry.Type;
        InsertGSTReport(NextVATEntryNo, TempGenJnlLine);
        //Win513--
    END;

    PROCEDURE InsertGSTReport(VATEntryNo: Integer; GenJnlLine2: Record 81);
    VAR
        GSTSaleReport: Record "GST Sales Entry";
        GSTPurchReport: Record "GST Purchase Entry";
        EntryNo: Integer;
        GLSetup: Record 98;
        Text28000: Label 'ENU=No Matching Document;ENA=No Matching Document';
    BEGIN
        IF NOT GLSetup."GST Report" THEN
            EXIT;
        //Win513++
        //WITH GenJnlLine2 DO BEGIN

        //IF "System-Created Entry" THEN
        IF GenJnlLine2."System-Created Entry" THEN
            //Win513--
                EXIT;
        //Win513++
        //IF "Gen. Posting Type" = "Gen. Posting Type"::Sale THEN BEGIN
        IF GenJnlLine2."Gen. Posting Type" = GenJnlLine2."Gen. Posting Type"::Sale THEN BEGIN
            //Win513--
            IF GSTSaleReport.FINDLAST THEN
                EntryNo := GSTSaleReport."Entry No." + 1
            ELSE
                EntryNo := 1;

            GSTSaleReport.INIT;
            GSTSaleReport."Entry No." := EntryNo;
            GSTSaleReport."GST Entry No." := VATEntryNo;
            //Win513++
            // GSTSaleReport."Posting Date" := "Posting Date";
            // IF "Document Type" = "Document Type"::Invoice THEN
            //     GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::Invoice;
            // IF "Document Type" = "Document Type"::"Credit Memo" THEN
            //     GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::"Credit Memo";
            // IF "Document Type" = "Document Type"::Payment THEN
            //     GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::Payment;

            // GSTSaleReport."Document No." := "Document No.";
            // GSTSaleReport."Document Line No." := "Line No.";
            GSTSaleReport."Posting Date" := GenJnlLine2."Posting Date";
            IF GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Invoice THEN
                GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::Invoice;
            IF GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::"Credit Memo" THEN
                GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::"Credit Memo";
            IF GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Payment THEN
                GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::Payment;

            GSTSaleReport."Document No." := GenJnlLine2."Document No.";
            GSTSaleReport."Document Line No." := GenJnlLine2."Line No.";
            //Win513--
            GSTSaleReport."Document Line Type" := GSTSaleReport."Document Line Type"::"G/L Account";
            GSTSaleReport."Document Line Description" := Text28000;
            GSTSaleReport."GST Entry Type" := GSTSaleReport."GST Entry Type"::Sale;
            //Win513++
            // GSTSaleReport."GST Base" := "VAT Base Amount (LCY)";
            // GSTSaleReport.Amount := "VAT Amount (LCY)";
            // GSTSaleReport."VAT Calculation Type" := "VAT Calculation Type";
            // GSTSaleReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
            // GSTSaleReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            GSTSaleReport."GST Base" := GenJnlLine2."VAT Base Amount (LCY)";
            GSTSaleReport.Amount := GenJnlLine2."VAT Amount (LCY)";
            GSTSaleReport."VAT Calculation Type" := GenJnlLine2."VAT Calculation Type";
            GSTSaleReport."VAT Bus. Posting Group" := GenJnlLine2."VAT Bus. Posting Group";
            GSTSaleReport."VAT Prod. Posting Group" := GenJnlLine2."VAT Prod. Posting Group";
            //Win513--
            GSTSaleReport.INSERT;
        END ELSE
            //Win513++
            //IF "Gen. Posting Type" = "Gen. Posting Type"::Purchase THEN BEGIN
            IF GenJnlLine2."Gen. Posting Type" = GenJnlLine2."Gen. Posting Type"::Purchase THEN BEGIN
                //Win513--
                IF GSTPurchReport.FINDLAST THEN
                    EntryNo := GSTPurchReport."Entry No." + 1
                ELSE
                    EntryNo := 1;

                GSTPurchReport.INIT;
                GSTPurchReport."Entry No." := EntryNo;
                GSTPurchReport."GST Entry No." := VATEntryNo;
                //Win513++
                // GSTPurchReport."Posting Date" := "Posting Date";
                // IF "Document Type" = "Document Type"::Invoice THEN
                //     GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
                // IF "Document Type" = "Document Type"::"Credit Memo" THEN
                //     GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
                // IF "Document Type" = "Document Type"::Payment THEN
                //     GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;

                // GSTPurchReport."Document No." := "Document No.";
                // GSTPurchReport."Document Line No." := "Line No.";

                GSTPurchReport."Posting Date" := GenJnlLine2."Posting Date";
                IF GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Invoice THEN
                    GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
                IF GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::"Credit Memo" THEN
                    GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
                IF GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Payment THEN
                    GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;

                GSTPurchReport."Document No." := GenJnlLine2."Document No.";
                GSTPurchReport."Document Line No." := GenJnlLine2."Line No.";
                //Win513--
                GSTPurchReport."Document Line Type" := GSTPurchReport."Document Line Type"::"G/L Account";
                GSTPurchReport."Document Line Description" := Text28000;
                GSTPurchReport."GST Entry Type" := GSTPurchReport."GST Entry Type"::Purchase;
                //Win513++
                // GSTPurchReport."GST Base" := "VAT Base Amount (LCY)";
                // GSTPurchReport.Amount := "VAT Amount (LCY)";
                // GSTPurchReport."VAT Calculation Type" := "VAT Calculation Type";
                // GSTPurchReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                // GSTPurchReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                GSTPurchReport."GST Base" := GenJnlLine2."VAT Base Amount (LCY)";
                GSTPurchReport.Amount := GenJnlLine2."VAT Amount (LCY)";
                GSTPurchReport."VAT Calculation Type" := GenJnlLine2."VAT Calculation Type";
                GSTPurchReport."VAT Bus. Posting Group" := GenJnlLine2."VAT Bus. Posting Group";
                GSTPurchReport."VAT Prod. Posting Group" := GenJnlLine2."VAT Prod. Posting Group";
                //Win513--
                GSTPurchReport.INSERT;
            END;
        //Win513++
        //END;
        //Win513--
    END;

    PROCEDURE SetBASFields(VAR VATEntry: Record 254; BASDocNo: Code[11]; BASVersion: Integer; BASAdjustment: Boolean);
    VAR
        BASCalculationSheet: Record "BAS Calculation Sheet";
    BEGIN
        IF NOT (BASCalculationSheet.GET(BASDocNo, BASVersion) AND BASCalculationSheet.Updated) THEN BEGIN
            VATEntry."BAS Adjustment" := BASAdjustment;
            VATEntry."BAS Doc. No." := BASDocNo;
            VATEntry."BAS Version" := BASVersion;
        END;
    END;

    //Win513++
    //LOCAL PROCEDURE InsertPmtDiscVATForGLEntry(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR NewCVLedgEntryBuf: Record 382; VATEntry2: Record 254; VAR VATPostingSetup: Record 325; VAR TaxJurisdiction: Record 320; EntryType: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal);
    LOCAL PROCEDURE InsertPmtDiscVATForGLEntry(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR NewCVLedgEntryBuf: Record 382; VATEntry2: Record 254; VAR VATPostingSetup: Record 325; VAR TaxJurisdiction: Record 320; EntryType: Enum "Detailed CV Ledger Entry Type"; VATAmount: Decimal; VATAmountAddCurr: Decimal);
    //Win513--
    BEGIN
        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
        CASE EntryType OF
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)";
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)";
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)";
        END;
        DtldCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
        DtldCVLedgEntryBuf."Document Date" := GenJnlLine."Document Date";
        DtldCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
        DtldCVLedgEntryBuf."Document No." := GenJnlLine."Document No.";
        DtldCVLedgEntryBuf.Amount := 0;
        DtldCVLedgEntryBuf."VAT Bus. Posting Group" := VATEntry2."VAT Bus. Posting Group";
        DtldCVLedgEntryBuf."VAT Prod. Posting Group" := VATEntry2."VAT Prod. Posting Group";
        DtldCVLedgEntryBuf."Tax Jurisdiction Code" := VATEntry2."Tax Jurisdiction Code";
        // The total payment discount in currency is posted on the entry made in
        // the function CalcPmtDisc.
        DtldCVLedgEntryBuf."User ID" := USERID;
        DtldCVLedgEntryBuf."Use Additional-Currency Amount" := TRUE;

        CASE VATEntry2.Type OF
            VATEntry2.Type::Purchase:
                CASE VATEntry2."VAT Calculation Type" OF
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        BEGIN
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        BEGIN
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), '',
                              -VATAmount, -VATAmountAddCurr, FALSE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        IF VATEntry2."Use Tax" THEN BEGIN
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetRevChargeAccount(FALSE), '',
                              -VATAmount, -VATAmountAddCurr, FALSE);
                        END ELSE BEGIN
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                END;
            VATEntry2.Type::Sale:
                CASE VATEntry2."VAT Calculation Type" OF
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        BEGIN
                            InitGLEntryVAT(
                              GenJnlLine, VATPostingSetup.GetSalesAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        ;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            InitGLEntryVAT(
                              GenJnlLine, TaxJurisdiction.GetSalesAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                END;
        END;
    END;

    PROCEDURE InitGLEntryVAT(GenJnlLine: Record 81; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmtAddCurr: Boolean);
    VAR
        GLEntry: Record 17;
        GLSetup: Record 98;
    BEGIN
        IF UseAmtAddCurr THEN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE)
        ELSE BEGIN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
            GLEntry."Bal. Account No." := BalAccNo;
        END;
        SummarizeVAT(GLSetup."Summarize G/L Entries", GLEntry);
    END;

    PROCEDURE SummarizeVAT(SummarizeGLEntries: Boolean; GLEntry: Record 17);
    VAR
        InsertedTempVAT: Boolean;
        TempGLEntryVAT: Record 17 TEMPORARY;
        InsertedTempGLEntryVAT: Integer;
    BEGIN
        InsertedTempVAT := FALSE;
        IF SummarizeGLEntries THEN
            IF TempGLEntryVAT.FINDSET THEN
                REPEAT
                    IF (TempGLEntryVAT."G/L Account No." = GLEntry."G/L Account No.") AND
                       (TempGLEntryVAT."Bal. Account No." = GLEntry."Bal. Account No.")
                    THEN BEGIN
                        TempGLEntryVAT.Amount := TempGLEntryVAT.Amount + GLEntry.Amount;
                        TempGLEntryVAT."Additional-Currency Amount" :=
                          TempGLEntryVAT."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
                        TempGLEntryVAT.MODIFY;
                        InsertedTempVAT := TRUE;
                    END;
                UNTIL (TempGLEntryVAT.NEXT = 0) OR InsertedTempVAT;
        IF NOT InsertedTempVAT OR NOT SummarizeGLEntries THEN BEGIN
            TempGLEntryVAT := GLEntry;
            TempGLEntryVAT."Entry No." :=
              TempGLEntryVAT."Entry No." + InsertedTempGLEntryVAT;
            TempGLEntryVAT.INSERT;
            InsertedTempGLEntryVAT := InsertedTempGLEntryVAT + 1;
        END;
    END;

    PROCEDURE CalcPmtDiscVATAmounts(VATEntry2: Record 254; VATBase: Decimal; VATBaseAddCurr: Decimal; VAR VATAmount: Decimal; VAR VATAmountAddCurr: Decimal; VAR PmtDiscRounding: Decimal; PmtDiscFactorLCY: Decimal; VAR PmtDiscLCY2: Decimal; VAR PmtDiscAddCurr2: Decimal);
    var
        AddCurrency: Record 4;
    BEGIN
        CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
          VATEntry2."VAT Calculation Type"::"Full VAT":
                IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
                   (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                THEN BEGIN
                    IF (VATBase = 0) AND
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    THEN
                        VATAmount := 0
                    ELSE BEGIN
                        PmtDiscRounding :=
                          PmtDiscRounding +
                          (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                        VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                    END;
                    IF (VATBaseAddCurr = 0) AND
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    THEN
                        VATAmountAddCurr := 0
                    ELSE BEGIN
                        VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                    END;
                END ELSE BEGIN
                    VATAmount := 0;
                    VATAmountAddCurr := 0;
                END;
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                    VATAmount :=
                      ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
                    VATAmount :=
                      ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                END ELSE
                    IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
                       (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                    THEN BEGIN
                        IF VATBase = 0 THEN
                            VATAmount := 0
                        ELSE BEGIN
                            PmtDiscRounding :=
                              PmtDiscRounding +
                              (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                            VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                            PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                        END;

                        IF VATBaseAddCurr = 0 THEN
                            VATAmountAddCurr := 0
                        ELSE BEGIN
                            VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                            PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                        END;
                    END ELSE BEGIN
                        VATAmount := 0;
                        VATAmountAddCurr := 0;
                    END;
        END;
    END;


    PROCEDURE CalcPmtDiscVATBases(VATEntry2: Record 254; VAR VATBase: Decimal; VAR VATBaseAddCurr: Decimal);
    VAR
        VATEntry: Record 254;
    BEGIN
        CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
            VATEntry2."VAT Calculation Type"::"Full VAT":
                BEGIN
                    VATBase :=
                      VATEntry2.Base + VATEntry2."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry2."Additional-Currency Base" +
                      VATEntry2."Add.-Currency Unrealized Base";
                END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                BEGIN
                    VATEntry.RESET;
                    VATEntry.SETCURRENTKEY("Transaction No.");
                    VATEntry.SETRANGE("Transaction No.", VATEntry2."Transaction No.");
                    VATEntry.SETRANGE("Sales Tax Connection No.", VATEntry2."Sales Tax Connection No.");
                    VATEntry := VATEntry2;
                    REPEAT
                        IF VATEntry.Base < 0 THEN
                            VATEntry.SETFILTER(Base, '>%1', VATEntry.Base)
                        ELSE
                            VATEntry.SETFILTER(Base, '<%1', VATEntry.Base);
                    UNTIL NOT VATEntry.FINDLAST;
                    VATEntry.RESET;
                    VATBase :=
                      VATEntry.Base + VATEntry."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry."Additional-Currency Base" +
                      VATEntry."Add.-Currency Unrealized Base";
                END;
        END;
    END;

    PROCEDURE ExchangeAmtLCYToFCY2(Amount: Decimal): Decimal;
    var
        AddCurrency: Record 4;
        CurrExchRate: Record 330;
        CurrencyFactor: Decimal;
        UseCurrFactorOnly: Boolean;
        CurrencyDate: Date;
        AddCurrencyCode: Code[10];
    BEGIN
        IF UseCurrFactorOnly THEN
            EXIT(
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCYOnlyFactor(Amount, CurrencyFactor),
                AddCurrency."Amount Rounding Precision"));
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              CurrencyDate, AddCurrencyCode, Amount, CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
    END;

    PROCEDURE CalcLCYToAddCurr(AmountLCY: Decimal): Decimal;
    var
        AddCurrencyCode: code[10];
    BEGIN
        IF AddCurrencyCode = '' THEN
            EXIT;

        EXIT(ExchangeAmtLCYToFCY2(AmountLCY));
    END;

    PROCEDURE CalcPmtDiscTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer);
    VAR
        PmtDiscTol: Decimal;
        PmtDiscTolLCY: Decimal;
        PmtDiscTolAddCurr: Decimal;
        AddCurrencyCode: code[10];
        GLSetup: Record 98;
    BEGIN
        IF NOT OldCVLedgEntryBuf2."Accepted Pmt. Disc. Tolerance" THEN
            EXIT;

        PmtDiscTol := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
        PmtDiscTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtDiscTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscTolLCY;

        IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
            PmtDiscTolAddCurr := PmtDiscTol
        ELSE
            PmtDiscTolAddCurr := CalcLCYToAddCurr(PmtDiscTolLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtDiscTolLCY <> 0) THEN
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtDiscTolLCY, PmtDiscTolAddCurr,
              NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)");

        //Win513++
        //DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        DtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
            //Win513--
            GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance", PmtDiscTol, PmtDiscTolLCY, PmtDiscTolAddCurr, 0, 0, 0);
    END;

    PROCEDURE CalcPmtDisc(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; PmtTolAmtToBeApplied: Decimal; ApplnRoundingPrecision: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer);
    VAR
        PmtDisc: Decimal;
        PmtDiscLCY: Decimal;
        PmtDiscAddCurr: Decimal;
        MinimalPossibleLiability: Decimal;
        PaymentExceedsLiability: Boolean;
        ToleratedPaymentExceedsLiability: Boolean;
        PaymentToleranceMgt: Codeunit 426;
        AddCurrencyCode: Code[10];
        GLSetup: Record 98;
    BEGIN
        MinimalPossibleLiability := ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible");
        PaymentExceedsLiability := ABS(OldCVLedgEntryBuf2."Amount to Apply") >= MinimalPossibleLiability;
        ToleratedPaymentExceedsLiability := ABS(NewCVLedgEntryBuf."Remaining Amount" + PmtTolAmtToBeApplied) >= MinimalPossibleLiability;

        IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, TRUE, TRUE) AND
            ((OldCVLedgEntryBuf2."Amount to Apply" = 0) OR PaymentExceedsLiability) OR
            (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
             (OldCVLedgEntryBuf2."Amount to Apply" <> 0) AND PaymentExceedsLiability AND ToleratedPaymentExceedsLiability))
        THEN BEGIN
            PmtDisc := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
            PmtDiscLCY :=
              ROUND(
                (NewCVLedgEntryBuf."Original Amount" + PmtDisc) / NewCVLedgEntryBuf."Original Currency Factor") -
              NewCVLedgEntryBuf."Original Amt. (LCY)";

            OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscLCY;

            IF (NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode) AND (AddCurrencyCode <> '') THEN
                PmtDiscAddCurr := PmtDisc
            ELSE
                PmtDiscAddCurr := CalcLCYToAddCurr(PmtDiscLCY);

            IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND
               (PmtDiscLCY <> 0)
            THEN
                CalcPmtDiscIfAdjVAT(
                  NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtDiscLCY, PmtDiscAddCurr,
                  NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)");

            //Win513++
            //DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            DtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
              //Win513--
              GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
              DtldCVLedgEntryBuf."Entry Type"::"Payment Discount", PmtDisc, PmtDiscLCY, PmtDiscAddCurr, 0, 0, 0);
        END;
    END;

    LOCAL PROCEDURE CalcCurrencyApplnRounding(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; ApplnRoundingPrecision: Decimal);
    VAR
        ApplnRounding: Decimal;
        ApplnRoundingLCY: Decimal;
    BEGIN
        IF ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Payment) AND
            (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)) OR
           (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code")
        THEN
            EXIT;

        ApplnRounding := -(NewCVLedgEntryBuf."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount");
        ApplnRoundingLCY := ROUND(ApplnRounding / NewCVLedgEntryBuf."Adjusted Currency Factor");

        IF (ApplnRounding = 0) OR (ABS(ApplnRounding) > ApplnRoundingPrecision) THEN
            EXIT;

        //win513++
        //DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        DtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(
        //Win513--    
          GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding", ApplnRounding, ApplnRoundingLCY, ApplnRounding, 0, 0, 0);
    END;


    //CU13
    //Win513++
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnProcessLinesOnAfterPostGenJnlLines', '', true, true)]
    // local procedure OnProcessLinesOnAfterPostGenJnlLines(GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; PreviewMode: Boolean; var GLRegNo: Integer)
    // var
    //     CurrentICPartner: Code[20];
    //     GenJnlLine5: Record 81;
    //     GLSetup: Record 98;
    //     WHTEntry: Record "WHT Entry";
    //     WHTPostingSetup: Record "WHT Posting Setup";
    //     PurchInvLine: Record 123;
    //     GenJnlLine3: Record 81;
    //     CustLedgEntry: Record 21;
    //     VendLedgEntry: Record 25;
    //     GenJouPostBatch: Codeunit 13;
    //     TotWHT: Decimal;
    //     Counter: Integer;
    //     TempCustLedgerEntry: Record 21 TEMPORARY;
    //     TempVendLedgerEntry: Record 25 TEMPORARY;
    //     LineCount: Integer;
    //     GenJnlTemplate: Record 80;
    //     TempGenJnlLine4: Record 81 TEMPORARY;
    //     ICOutboxMgt: Codeunit 427;
    //     ICTransactionNo: Integer;
    //     NoOfReversingRecords: Integer;
    //     NoOfRecords: Integer;
    //     WHTAmt: Decimal;
    //     RefPostingState: Option "Checking lines","Checking balance","Updating bal. lines","Posting Lines","Posting revers. lines","Updating lines";
    // begin
    //     IF CurrentICPartner <> '' THEN
    //         GenJournalLine."IC Partner Code" := CurrentICPartner;
    //     GenJouPostBatch.UpdateDialog(RefPostingState::"Posting Lines", LineCount, NoOfRecords);
    //     MakeRecurringTexts(GenJnlLine3);
    //     CheckDocumentNo(GenJnlLine3);
    //     GenJnlLine5.COPY(GenJnlLine3);
    //     PrepareGenJnlLineAddCurr(GenJnlLine5);
    //     // Update/delete lines
    //     IF GLSetup."Enable WHT" AND (NOT GLSetup."Enable GST (Australia)") THEN BEGIN
    //         IF NOT GenJnlLine5."Skip WHT" THEN BEGIN
    //             IF GenJnlLine5."Applies-to Doc. No." <> '' THEN BEGIN
    //                 WHTEntry.SETCURRENTKEY("Document Type", "Document No.");
    //                 WHTEntry.SETRANGE("Document No.", GenJnlLine5."Applies-to Doc. No.");
    //                 WHTEntry.SETRANGE("Document Type", GenJnlLine5."Applies-to Doc. Type");
    //                 IF WHTEntry.FINDFIRST THEN BEGIN
    //                     IF WHTPostingSetup.GET(WHTEntry."WHT Bus. Posting Group", WHTEntry."WHT Prod. Posting Group") THEN BEGIN
    //                         WHTEntry.CALCSUMS("Unrealized Base (LCY)");
    //                         CheckWHTCalculationRule(WHTEntry."Unrealized Base (LCY)", WHTPostingSetup, GenJnlLine5);
    //                     END;
    //                 END;
    //                 IF GenJnlLine5."Applies-to Doc. Type" = GenJnlLine5."Applies-to Doc. Type"::Invoice THEN BEGIN
    //                     PurchInvLine.SETRANGE("Document No.", GenJnlLine5."Applies-to Doc. No.");
    //                     IF PurchInvLine.FINDFIRST THEN
    //                         IF PurchInvLine."Blanket Order No." <> '' THEN
    //                             GenJnlLine5."Skip WHT" := FALSE;
    //                 END;
    //             END ELSE
    //                 IF GenJnlLine5."Applies-to ID" <> '' THEN BEGIN
    //                     IF GenJnlLine5."Account Type" = GenJnlLine5."Account Type"::Customer THEN BEGIN
    //                         TotWHT := 0;
    //                         CustLedgEntry.SETRANGE("Applies-to ID", GenJournalLine."Document No.");
    //                         IF CustLedgEntry.FINDFIRST THEN
    //                             CustomerMinWHT(CustLedgEntry, GenJnlLine5);
    //                     END ELSE
    //                         IF GenJnlLine5."Account Type" = GenJnlLine5."Account Type"::Vendor THEN BEGIN
    //                             TotWHT := 0;
    //                             VendLedgEntry.SETRANGE("Applies-to ID", GenJournalLine."Document No.");
    //                             IF VendLedgEntry.FINDFIRST THEN
    //                                 VendorMinWHT(VendLedgEntry, GenJnlLine5);
    //                         END;
    //                 END
    //                 ELSE
    //                     IF GenJnlLine5."Account Type" = GenJnlLine5."Account Type"::"G/L Account" THEN BEGIN
    //                         IF Counter = 0 THEN BEGIN
    //                             IF TempCustLedgerEntry.FINDFIRST THEN
    //                                 Counter := 1;
    //                             IF TempVendLedgerEntry.FINDFIRST THEN
    //                                 Counter := 2;
    //                         END;
    //                         WHTAmt := 0;
    //                     END;
    //         END;
    //     END;

    //     UpdateIncomingDocument(GenJnlLine5);
    //     GenJnlPostLine.RunWithoutCheck(GenJnlLine5);
    //     IF (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND (CurrentICPartner <> '') AND
    //        (GenJournalLine."IC Direction" = GenJournalLine."IC Direction"::Outgoing) AND (ICTransactionNo > 0)
    //     THEN
    //         ICOutboxMgt.CreateOutboxJnlLine(ICTransactionNo, 1, GenJnlLine5);
    //     //Win513++
    //     //IF (GenJournalLine."Recurring Method" >= GenJournalLine."Recurring Method"::"RF Reversing Fixed") AND (GenJournalLine."Posting Date" <> 0D) THEN BEGIN
    //     IF (GenJournalLine."Recurring Method".AsInteger() >= GenJournalLine."Recurring Method"::"RF Reversing Fixed".AsInteger()) AND (GenJournalLine."Posting Date" <> 0D) THEN BEGIN
    //         //Win513--
    //         GenJournalLine."Posting Date" := GenJournalLine."Posting Date" + 1;
    //         GenJournalLine."Document Date" := GenJournalLine."Posting Date";
    //         MultiplyAmounts(GenJnlLine3, -1);
    //         TempGenJnlLine4 := GenJnlLine3;
    //         TempGenJnlLine4."Reversing Entry" := TRUE;
    //         TempGenJnlLine4.INSERT;
    //         NoOfReversingRecords := NoOfReversingRecords + 1;
    //         GenJournalLine."Posting Date" := GenJournalLine."Posting Date" - 1;
    //         GenJournalLine."Document Date" := GenJournalLine."Posting Date";
    //     END;
    //     PostAllocations(GenJnlLine3, FALSE);
    // END;
    // //end;
    //Win513--

    var
        myInt: Integer;
        ServiceDeferral: Boolean;

    //Std local procedure 

    LOCAL PROCEDURE PostAllocations(VAR AllocateGenJnlLine: Record 81; Reversing: Boolean);
    var
        GenJnlAlloc: Record 221;
        GenJnlLine2: Record 81;
    BEGIN
        //Win513++
        //WITH AllocateGenJnlLine DO BEGIN

        //IF "Account No." <> '' THEN BEGIN
        IF AllocateGenJnlLine."Account No." <> '' THEN BEGIN
            //Win513--
            GenJnlAlloc.RESET;
            //Win513++
            // GenJnlAlloc.SETRANGE("Journal Template Name", "Journal Template Name");
            // GenJnlAlloc.SETRANGE("Journal Batch Name", "Journal Batch Name");
            // GenJnlAlloc.SETRANGE("Journal Line No.", "Line No.");
            GenJnlAlloc.SETRANGE("Journal Template Name", AllocateGenJnlLine."Journal Template Name");
            GenJnlAlloc.SETRANGE("Journal Batch Name", AllocateGenJnlLine."Journal Batch Name");
            GenJnlAlloc.SETRANGE("Journal Line No.", AllocateGenJnlLine."Line No.");
            //Win513--
            GenJnlAlloc.SETFILTER("Account No.", '<>%1', '');
            IF GenJnlAlloc.FINDSET(TRUE, FALSE) THEN BEGIN
                GenJnlLine2.INIT;
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                //Win513++
                // GenJnlLine2."Posting Date" := "Posting Date";
                // GenJnlLine2."Document Type" := "Document Type";
                // GenJnlLine2."Document No." := "Document No.";
                // GenJnlLine2.Description := Description;
                // GenJnlLine2."Source Code" := "Source Code";
                // GenJnlLine2."Journal Batch Name" := "Journal Batch Name";
                // GenJnlLine2."Line No." := "Line No.";
                // GenJnlLine2."Reason Code" := "Reason Code";
                // GenJnlLine2.Correction := Correction;
                // GenJnlLine2."Recurring Method" := "Recurring Method";
                // IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor] THEN BEGIN
                //     GenJnlLine2."Bill-to/Pay-to No." := "Bill-to/Pay-to No.";
                //     GenJnlLine2."Ship-to/Order Address Code" := "Ship-to/Order Address Code";
                GenJnlLine2."Posting Date" := AllocateGenJnlLine."Posting Date";
                GenJnlLine2."Document Type" := AllocateGenJnlLine."Document Type";
                GenJnlLine2."Document No." := AllocateGenJnlLine."Document No.";
                GenJnlLine2.Description := AllocateGenJnlLine.Description;
                GenJnlLine2."Source Code" := AllocateGenJnlLine."Source Code";
                GenJnlLine2."Journal Batch Name" := AllocateGenJnlLine."Journal Batch Name";
                GenJnlLine2."Line No." := AllocateGenJnlLine."Line No.";
                GenJnlLine2."Reason Code" := AllocateGenJnlLine."Reason Code";
                GenJnlLine2.Correction := AllocateGenJnlLine.Correction;
                GenJnlLine2."Recurring Method" := AllocateGenJnlLine."Recurring Method";
                IF AllocateGenJnlLine."Account Type" IN [AllocateGenJnlLine."Account Type"::Customer, AllocateGenJnlLine."Account Type"::Vendor] THEN BEGIN
                    GenJnlLine2."Bill-to/Pay-to No." := AllocateGenJnlLine."Bill-to/Pay-to No.";
                    GenJnlLine2."Ship-to/Order Address Code" := AllocateGenJnlLine."Ship-to/Order Address Code";
                    //Win513--
                END;
                REPEAT
                    GenJnlLine2.CopyFromGenJnlAllocation(GenJnlAlloc);
                    GenJnlLine2."Shortcut Dimension 1 Code" := GenJnlAlloc."Shortcut Dimension 1 Code";
                    GenJnlLine2."Shortcut Dimension 2 Code" := GenJnlAlloc."Shortcut Dimension 2 Code";
                    GenJnlLine2."Dimension Set ID" := GenJnlAlloc."Dimension Set ID";
                    GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
                    PrepareGenJnlLineAddCurr(GenJnlLine2);
                    IF NOT Reversing THEN BEGIN
                        GenJnlPostLine.RunWithCheck(GenJnlLine2);
                        //Win513++
                        // IF "Recurring Method" IN
                        //    ["Recurring Method"::"V  Variable", "Recurring Method"::"B  Balance"]
                        IF AllocateGenJnlLine."Recurring Method" IN
                           [AllocateGenJnlLine."Recurring Method"::"V  Variable", AllocateGenJnlLine."Recurring Method"::"B  Balance"]
                        //Win513--
                        THEN BEGIN
                            GenJnlAlloc.Amount := 0;
                            GenJnlAlloc."Additional-Currency Amount" := 0;
                            GenJnlAlloc.MODIFY;
                        END;
                    END ELSE BEGIN
                        MultiplyAmounts(GenJnlLine2, -1);
                        GenJnlLine2."Reversing Entry" := TRUE;
                        GenJnlPostLine.RunWithCheck(GenJnlLine2);
                        //Win513++
                        // IF "Recurring Method" IN
                        //    ["Recurring Method"::"RV Reversing Variable",
                        //     "Recurring Method"::"RB Reversing Balance"]
                        IF AllocateGenJnlLine."Recurring Method" IN
                           [AllocateGenJnlLine."Recurring Method"::"RV Reversing Variable",
                            AllocateGenJnlLine."Recurring Method"::"RB Reversing Balance"]
                        //Win513--
                        THEN BEGIN
                            GenJnlAlloc.Amount := 0;
                            GenJnlAlloc."Additional-Currency Amount" := 0;
                            GenJnlAlloc.MODIFY;
                        END;
                    END;
                UNTIL GenJnlAlloc.NEXT = 0;
            END;
        END;
        //Win513++    
        //END;
        //Win513--
    END;

    local procedure MultiplyAmounts(var GenJnlLine2: Record "Gen. Journal Line"; Factor: Decimal)
    begin
        //Win513++
        // with GenJnlLine2 do
        //     if "Account No." <> '' then begin
        //         Amount := Amount * Factor;
        //         "Debit Amount" := "Debit Amount" * Factor;
        //         "Credit Amount" := "Credit Amount" * Factor;
        //         "Amount (LCY)" := "Amount (LCY)" * Factor;
        //         "Balance (LCY)" := "Balance (LCY)" * Factor;
        //         "Sales/Purch. (LCY)" := "Sales/Purch. (LCY)" * Factor;
        //         "Profit (LCY)" := "Profit (LCY)" * Factor;
        //         "Inv. Discount (LCY)" := "Inv. Discount (LCY)" * Factor;
        //         Quantity := Quantity * Factor;
        //         "VAT Amount" := "VAT Amount" * Factor;
        //         "VAT Base Amount" := "VAT Base Amount" * Factor;
        //         "VAT Amount (LCY)" := "VAT Amount (LCY)" * Factor;
        //         "VAT Base Amount (LCY)" := "VAT Base Amount (LCY)" * Factor;
        //         "Source Currency Amount" := "Source Currency Amount" * Factor;
        //         if "Job No." <> '' then
        //             MultiplyJobAmounts(GenJnlLine2, Factor);
        //      end;
        if GenJnlLine2."Account No." <> '' then begin
            GenJnlLine2.Amount := GenJnlLine2.Amount * Factor;
            GenJnlLine2."Debit Amount" := GenJnlLine2."Debit Amount" * Factor;
            GenJnlLine2."Credit Amount" := GenJnlLine2."Credit Amount" * Factor;
            GenJnlLine2."Amount (LCY)" := GenJnlLine2."Amount (LCY)" * Factor;
            GenJnlLine2."Balance (LCY)" := GenJnlLine2."Balance (LCY)" * Factor;
            GenJnlLine2."Sales/Purch. (LCY)" := GenJnlLine2."Sales/Purch. (LCY)" * Factor;
            GenJnlLine2."Profit (LCY)" := GenJnlLine2."Profit (LCY)" * Factor;
            GenJnlLine2."Inv. Discount (LCY)" := GenJnlLine2."Inv. Discount (LCY)" * Factor;
            GenJnlLine2.Quantity := GenJnlLine2.Quantity * Factor;
            GenJnlLine2."VAT Amount" := GenJnlLine2."VAT Amount" * Factor;
            GenJnlLine2."VAT Base Amount" := GenJnlLine2."VAT Base Amount" * Factor;
            GenJnlLine2."VAT Amount (LCY)" := GenJnlLine2."VAT Amount (LCY)" * Factor;
            GenJnlLine2."VAT Base Amount (LCY)" := GenJnlLine2."VAT Base Amount (LCY)" * Factor;
            GenJnlLine2."Source Currency Amount" := GenJnlLine2."Source Currency Amount" * Factor;
            if GenJnlLine2."Job No." <> '' then
                MultiplyJobAmounts(GenJnlLine2, Factor);
        end;
        //Win513--
    End;

    local procedure MultiplyJobAmounts(var GenJnlLine2: Record "Gen. Journal Line"; Factor: Decimal)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;
        //Win513++
        // with GenJnlLine2 do begin
        //     "Job Quantity" := "Job Quantity" * Factor;
        //     "Job Total Cost (LCY)" := "Job Total Cost (LCY)" * Factor;
        //     "Job Total Price (LCY)" := "Job Total Price (LCY)" * Factor;
        //     "Job Line Amount (LCY)" := "Job Line Amount (LCY)" * Factor;
        //     "Job Total Cost" := "Job Total Cost" * Factor;
        //     "Job Total Price" := "Job Total Price" * Factor;
        //     "Job Line Amount" := "Job Line Amount" * Factor;
        //     "Job Line Discount Amount" := "Job Line Discount Amount" * Factor;
        //     "Job Line Disc. Amount (LCY)" := "Job Line Disc. Amount (LCY)" * Factor;
        // end;
        //Win513--
        GenJnlLine2."Job Quantity" := GenJnlLine2."Job Quantity" * Factor;
        GenJnlLine2."Job Total Cost (LCY)" := GenJnlLine2."Job Total Cost (LCY)" * Factor;
        GenJnlLine2."Job Total Price (LCY)" := GenJnlLine2."Job Total Price (LCY)" * Factor;
        GenJnlLine2."Job Line Amount (LCY)" := GenJnlLine2."Job Line Amount (LCY)" * Factor;
        GenJnlLine2."Job Total Cost" := GenJnlLine2."Job Total Cost" * Factor;
        GenJnlLine2."Job Total Price" := GenJnlLine2."Job Total Price" * Factor;
        GenJnlLine2."Job Line Amount" := GenJnlLine2."Job Line Amount" * Factor;
        GenJnlLine2."Job Line Discount Amount" := GenJnlLine2."Job Line Discount Amount" * Factor;
        GenJnlLine2."Job Line Disc. Amount (LCY)" := GenJnlLine2."Job Line Disc. Amount (LCY)" * Factor;
    end;

    procedure VendorMinWHT(var VendLedgEntry: Record "Vendor Ledger Entry"; var GenJnlLine5: Record "Gen. Journal Line")
    var
        TempVendLedgerEntry: Record "Vendor Ledger Entry" temporary;
        WHTPostingSetup: Record "WHT Posting Setup";
        WHTEntry: Record "WHT Entry";
        TotWHT: Decimal;
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        repeat
            TempVendLedgerEntry.Init();
            TempVendLedgerEntry."Entry No." := VendLedgEntry."Entry No.";
            TempVendLedgerEntry."Document Type" := VendLedgEntry."Document Type";
            TempVendLedgerEntry."Document No." := VendLedgEntry."Document No.";
            TempVendLedgerEntry.Insert();
            WHTEntry.Reset();
            WHTPostingSetup.Reset();
            TotWHT := 0;
            WHTEntry.SetCurrentKey("Document Type", "Document No.");
            WHTEntry.SetRange("Document Type", VendLedgEntry."Document Type");
            WHTEntry.SetRange("Document No.", VendLedgEntry."Document No.");
            if WHTEntry.FindFirst then begin
                WHTEntry.CalcSums("Unrealized Base (LCY)");
                TotWHT := TotWHT + WHTEntry."Unrealized Base (LCY)";
            end;
            if WHTPostingSetup.Get(WHTEntry."WHT Bus. Posting Group", WHTEntry."WHT Prod. Posting Group") then
                CheckWHTCalculationRule(TotWHT, WHTPostingSetup, GenJnlLine5);

            if VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice then begin
                PurchInvLine.SetRange("Document No.", VendLedgEntry."Applies-to Doc. No.");
                if PurchInvLine.FindFirst and (PurchInvLine."Blanket Order No." <> '') then
                    GenJnlLine5."Skip WHT" := false;
            end;
        // IF (NOT GenJnlLine5."Skip WHT") THEN
        // EXIT;
        until VendLedgEntry.Next() = 0;
    end;

    procedure CustomerMinWHT(var CustLedgEntry: Record "Cust. Ledger Entry"; var GenJnlLine5: Record "Gen. Journal Line")
    var
        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
        WHTPostingSetup: Record "WHT Posting Setup";
        WHTEntry: Record "WHT Entry";
        TotWHT: Decimal;
        SalesInvLine: Record "Sales Invoice Line";
    begin
        repeat
            TempCustLedgerEntry.Init();
            TempCustLedgerEntry."Entry No." := CustLedgEntry."Entry No.";
            TempCustLedgerEntry."Document Type" := CustLedgEntry."Document Type";
            TempCustLedgerEntry."Document No." := CustLedgEntry."Document No.";
            TempCustLedgerEntry.Insert();
            WHTEntry.Reset();
            WHTPostingSetup.Reset();
            TotWHT := 0;
            WHTEntry.SetCurrentKey("Document Type", "Document No.");
            WHTEntry.SetRange("Document Type", CustLedgEntry."Document Type");
            WHTEntry.SetRange("Document No.", CustLedgEntry."Document No.");
            if WHTEntry.FindFirst then begin
                WHTEntry.CalcSums("Unrealized Base (LCY)");
                TotWHT := TotWHT + WHTEntry."Unrealized Base (LCY)";
            end;
            if WHTPostingSetup.Get(WHTEntry."WHT Bus. Posting Group", WHTEntry."WHT Prod. Posting Group") then
                CheckWHTCalculationRule(TotWHT, WHTPostingSetup, GenJnlLine5);

            if CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice then begin
                SalesInvLine.SetRange("Document No.", CustLedgEntry."Applies-to Doc. No.");
                if SalesInvLine.FindFirst and (SalesInvLine."Blanket Order No." <> '') then
                    GenJnlLine5."Skip WHT" := false;
            end;
            if not GenJnlLine5."Skip WHT" then
                exit;
        until CustLedgEntry.Next() = 0;
    end;

    procedure CheckWHTCalculationRule(TotalInvoiceAmountLCY: Decimal; WHTPostingSetup: Record "WHT Posting Setup"; var GenJnlLine5: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GenJnlLine5."Skip WHT" :=
          not CompareAmounts(TotalInvoiceAmountLCY, WHTPostingSetup) and
          (CompareAmounts(GenJnlLine5."Amount (LCY)", WHTPostingSetup) or GLSetup."Min. WHT Calc only on Inv. Amt");
    end;

    procedure CompareAmounts(AmountLCY: Decimal; WHTPostSetup: Record "WHT Posting Setup"): Boolean
    begin
        AmountLCY := Abs(AmountLCY);
        //Win513++
        // with WHTPostSetup do
        //     case "WHT Calculation Rule" of
        //         "WHT Calculation Rule"::"Less than":
        //             exit(AmountLCY >= "WHT Minimum Invoice Amount");
        //         "WHT Calculation Rule"::"Less than or equal to":
        //             exit(AmountLCY > "WHT Minimum Invoice Amount");
        //         "WHT Calculation Rule"::"Equal to":
        //             exit(AmountLCY <> "WHT Minimum Invoice Amount");
        //         "WHT Calculation Rule"::"Greater than":
        //             exit(AmountLCY <= "WHT Minimum Invoice Amount");
        //         "WHT Calculation Rule"::"Greater than or equal to":
        //             exit(AmountLCY < "WHT Minimum Invoice Amount");
        //     end;

        case WHTPostSetup."WHT Calculation Rule" of
            WHTPostSetup."WHT Calculation Rule"::"Less than":
                exit(AmountLCY >= WHTPostSetup."WHT Minimum Invoice Amount");
            WHTPostSetup."WHT Calculation Rule"::"Less than or equal to":
                exit(AmountLCY > WHTPostSetup."WHT Minimum Invoice Amount");
            WHTPostSetup."WHT Calculation Rule"::"Equal to":
                exit(AmountLCY <> WHTPostSetup."WHT Minimum Invoice Amount");
            WHTPostSetup."WHT Calculation Rule"::"Greater than":
                exit(AmountLCY <= WHTPostSetup."WHT Minimum Invoice Amount");
            WHTPostSetup."WHT Calculation Rule"::"Greater than or equal to":
                exit(AmountLCY < WHTPostSetup."WHT Minimum Invoice Amount");
        end;
        //Win513--
    end;


    local procedure PrepareGenJnlLineAddCurr(var GenJnlLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if (GLSetup."Additional Reporting Currency" <> '') and
           (GenJnlLine."Recurring Method" in
            [GenJnlLine."Recurring Method"::"B  Balance",
             GenJnlLine."Recurring Method"::"RB Reversing Balance"])
        then begin
            GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
            if (GenJnlLine.Amount = 0) and
               (GenJnlLine."Source Currency Amount" <> 0)
            then begin
                GenJnlLine."Additional-Currency Posting" :=
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                GenJnlLine.Amount := GenJnlLine."Source Currency Amount";
                GenJnlLine."Source Currency Amount" := 0;
            end;
        end;
    end;

    PROCEDURE CheckDocumentNo(VAR GenJnlLine2: Record 81);

    var
        GenJnlBatch: Record 232;
        LastDocNo: Code[20];
        LastPostedDocNo: Code[20];
        NoSeries: Record "No. Series" temporary;
        NoOfPostingNoSeries: Integer;
        NoSeriesMgt2: array[10] of Codeunit NoSeriesManagement;
        Text025: Label 'A maximum of %1 posting number series can be used in each journal.';
        PostingNoSeriesNo: Integer;
    BEGIN
        //Win513++
        //WITH GenJnlLine2 DO BEGIN
        // IF "Posting No. Series" = '' THEN
        //     "Posting No. Series" := GenJnlBatch."No. Series"
        IF GenJnlLine2."Posting No. Series" = '' THEN
            GenJnlLine2."Posting No. Series" := GenJnlBatch."No. Series"
        //Win513--
        ELSE
            //Win513++
            // IF NOT EmptyLine THEN
            //     IF "Document No." = LastDocNo THEN
            //         "Document No." := LastPostedDocNo
            IF NOT GenJnlLine2.EmptyLine THEN
                IF GenJnlLine2."Document No." = LastDocNo THEN
                    GenJnlLine2."Document No." := LastPostedDocNo
                //Win513--
                ELSE BEGIN
                    //Win513++
                    //IF NOT NoSeries.GET("Posting No. Series") THEN BEGIN
                    IF NOT NoSeries.GET(GenJnlLine2."Posting No. Series") THEN BEGIN
                        //Win513--
                        NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                        IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                            ERROR(
                              Text025,
                              ARRAYLEN(NoSeriesMgt2));
                        //Win513++      
                        //NoSeries.Code := "Posting No. Series";
                        NoSeries.Code := GenJnlLine2."Posting No. Series";
                        //Win513--
                        NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                        NoSeries.INSERT;
                    END;
                    //Win513++
                    //LastDocNo := "Document No.";
                    LastDocNo := GenJnlLine2."Document No.";
                    //Win513--
                    EVALUATE(PostingNoSeriesNo, NoSeries.Description);
                    //Win513++
                    // "Document No." :=
                    //   NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", "Posting Date", TRUE);
                    // LastPostedDocNo := "Document No.";
                    GenJnlLine2."Document No." :=
                      NoSeriesMgt2[PostingNoSeriesNo].GetNextNo(GenJnlLine2."Posting No. Series", GenJnlLine2."Posting Date", TRUE);
                    LastPostedDocNo := GenJnlLine2."Document No.";
                    //Win513--
                END;
        //Win513++
        //END;
        //Win513--
    END;

    PROCEDURE MakeRecurringTexts(VAR GenJnlLine2: Record 81);
    var
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        Text024: Label '<Month Text>', Locked = true;
        AccountingPeriod: Record "Accounting Period";
    BEGIN
        //Win513++
        //WITH GenJnlLine2 DO BEGIN
        //Win513--
        // IF ("Account No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
        //     Day := DATE2DMY("Posting Date", 1);
        //     Week := DATE2DWY("Posting Date", 2);
        //     Month := DATE2DMY("Posting Date", 2);
        //     MonthText := FORMAT("Posting Date", 0, Text024);
        //     AccountingPeriod.SETRANGE("Starting Date", 0D, "Posting Date");
        //     IF NOT AccountingPeriod.FINDLAST THEN
        //         AccountingPeriod.Name := '';
        //     "Document No." :=
        //       DELCHR(
        //         PADSTR(
        //           STRSUBSTNO("Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
        //           MAXSTRLEN("Document No.")),
        //         '>');
        //     Description :=
        //       DELCHR(
        //         PADSTR(
        //           STRSUBSTNO(Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
        //           MAXSTRLEN(Description)),
        //         '>');
        // END;
        IF (GenJnlLine2."Account No." <> '') AND (GenJnlLine2."Recurring Method".AsInteger() <> 0) THEN BEGIN
            Day := DATE2DMY(GenJnlLine2."Posting Date", 1);
            Week := DATE2DWY(GenJnlLine2."Posting Date", 2);
            Month := DATE2DMY(GenJnlLine2."Posting Date", 2);
            MonthText := FORMAT(GenJnlLine2."Posting Date", 0, Text024);
            AccountingPeriod.SETRANGE("Starting Date", 0D, GenJnlLine2."Posting Date");
            IF NOT AccountingPeriod.FINDLAST THEN
                AccountingPeriod.Name := '';
            GenJnlLine2."Document No." :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(GenJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(GenJnlLine2."Document No.")),
                '>');
            GenJnlLine2.Description :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(GenJnlLine2.Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(GenJnlLine2.Description)),
                '>');
        END;
        //Win513++
        //END;
        //Win513++
    END;

    Procedure UpdateIncomingDocument(VAR GenJnlLine: Record "Gen. Journal Line")
    var
        IncomingDocument: Record "Incoming Document";
    begin
        //Win513++
        // WITH GenJnlLine DO
        //     IncomingDocument.UpdateIncomingDocumentFromPosting("Incoming Document Entry No.", "Posting Date", "Document No.");
        IncomingDocument.UpdateIncomingDocumentFromPosting(GenJnlLine."Incoming Document Entry No.", GenJnlLine."Posting Date", GenJnlLine."Document No.");
        //Win513--

    end;
    //Cu17 "Gen. Jnl.-Show Card" code added already
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnBeforeReverse', '', true, true)]
    local procedure OnBeforeReverse(var ReversalEntry: Record "Reversal Entry"; var ReversalEntry2: Record "Reversal Entry"; var IsHandled: Boolean)
    var
        //WIN502 Commentbox: DotNet "'Microsoft.VisualBasic, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.Microsoft.VisualBasic.Interaction" RUNONCLIENT;
        ReversalCode: Code[20];
        PageReason: Page 259;
        ReasonCode: Record 231;
        ReversalComments: Text[100];
    //WIN502 Commentbox: DotNet "'Microsoft.VisualBasic, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.Microsoft.VisualBasic.Interaction" RUNONCLIENT;

    begin
        ReasonCode.RESET;
        ReasonCode.FINDFIRST;
        //WINS.AE 201804302133 +++
        COMMIT;
        CLEAR(PageReason);
        PageReason.SETRECORD(ReasonCode);
        PageReason.SETTABLEVIEW(ReasonCode);
        PageReason.LOOKUPMODE(TRUE);

        IF PageReason.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PageReason.GETRECORD(ReasonCode);
            ReversalCode := ReasonCode.Code;
            //WIN502 ReversalComments := Commentbox.InputBox('Reversal Comments (If Any)', 'Reversal Comments', ReasonCode.Description, 100, 100);
        END;
        //WINS.AE 201804302133---

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnAfterPostReverse', '', true, true)]
    local procedure OnAfterPostReverse(var GenJournalLine: Record "Gen. Journal Line")
    var
        GLEntry2: Record 17;
        GLEntry: Record 17;
        ReversedGLEntry: Record 17;
        TempReversedGLEntry: Record 17 TEMPORARY;
        TempCustLedgEntry: Record 21 TEMPORARY;
        VendLedgEntry: Record 25;
        CannotReverseErr: Label 'You cannot reverse the transaction, because it has already been reversed.;ENA=You cannot reverse the transaction, because it has already been reversed.';
        ReversalCode: Code[20];
        PageReason: Page 259;
        ReasonCode: Record 231;
        ReversalComments: Text[100];
        PDCLine: Record 50098;
        MailCU: Codeunit 50000;
        RecordLinks: Record 2000000068;
        TempVendLedgEntry: Record 25 TEMPORARY;
        NextDtldCustLedgEntryEntryNo: Integer;
        NextDtldVendLedgEntryEntryNo: Integer;
        FAInsertLedgEntry: Codeunit 5600;
        TempBankAccLedgEntry: Record 271 TEMPORARY;
        ReversalEntry: Record "Reversal Entry";
        GenJnlLine: Record "Gen. Journal Line";
        ReversalEntry2: Record 179;
        GenJoupostreverse: Codeunit 17;
    begin
        //Win513++
        //WITH GLEntry2 DO
        //Win513--
        // IF FIND('+') THEN
        //     REPEAT
        //         if "Reversed by Entry No." <> 0 THEN
        //             ERROR(CannotReverseErr);
        //         CheckDimComb("Entry No.", "Dimension Set ID", DATABASE::"G/L Account", "G/L Account No.", 0, '');
        //         GLEntry := GLEntry2;
        //         IF "FA Entry No." <> 0 THEN
        //             FAInsertLedgEntry.InsertReverseEntry(
        //               GenJnlPostLine.GetNextEntryNo, "FA Entry Type", "FA Entry No.", GLEntry."FA Entry No.",
        //               GenJnlPostLine.GetNextTransactionNo);
        //         GLEntry.Amount := -Amount;
        //         GLEntry.Quantity := -Quantity;
        //         GLEntry."VAT Amount" := -"VAT Amount";
        //         GLEntry."Debit Amount" := -"Debit Amount";
        //         GLEntry."Credit Amount" := -"Credit Amount";
        //         GLEntry."Additional-Currency Amount" := -"Additional-Currency Amount";
        //         GLEntry."Add.-Currency Debit Amount" := -"Add.-Currency Debit Amount";
        //         GLEntry."Add.-Currency Credit Amount" := -"Add.-Currency Credit Amount";
        //         GLEntry."Entry No." := GenJnlPostLine.GetNextEntryNo;
        //         GLEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //         GLEntry."User ID" := USERID;
        //         GenJournalLine.Correction :=
        //           (GLEntry."Debit Amount" < 0) OR (GLEntry."Credit Amount" < 0) OR
        //           (GLEntry."Add.-Currency Debit Amount" < 0) OR (GLEntry."Add.-Currency Credit Amount" < 0);
        //         GLEntry."Journal Batch Name" := '';
        //         GLEntry."Source Code" := GenJournalLine."Source Code";
        //         SetReversalDescription(
        //           ReversalEntry."Entry Type"::"G/L Account", GLEntry.Description);
        //         GLEntry."Reversed Entry No." := "Entry No.";
        //         GLEntry.Reversed := TRUE;
        //         //WINS.AE 201804302133 ++
        //         GLEntry."Reversal Reason Code" := ReversalCode;
        //         GLEntry."Reversal Reason Comments" := ReversalComments;
        //         //WINS.AE 201804302133 --


        //         // Reversal of Reversal
        //         IF "Reversed Entry No." <> 0 THEN BEGIN
        //             ReversedGLEntry.GET("Reversed Entry No.");
        //             ReversedGLEntry."Reversed by Entry No." := 0;
        //             ReversedGLEntry.Reversed := FALSE;
        //             ReversedGLEntry.MODIFY;
        //             "Reversed Entry No." := GLEntry."Entry No.";
        //             GLEntry."Reversed by Entry No." := "Entry No.";
        //         END;
        //         "Reversed by Entry No." := GLEntry."Entry No.";
        //         Reversed := TRUE;
        //         //Win+++
        //         "Reversal Reason Code" := ReversalCode;
        //         "Reversal Reason Comments" := ReversalComments;
        //         //Win---
        //         MODIFY;
        //         GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, FALSE);
        //         TempReversedGLEntry := GLEntry;
        //         TempReversedGLEntry.INSERT;

        //         CASE TRUE OF
        //             TempCustLedgEntry.GET("Entry No."):
        //                 BEGIN
        //                     CheckDimComb("Entry No.", "Dimension Set ID",
        //                       DATABASE::Customer, TempCustLedgEntry."Customer No.",
        //                       DATABASE::"Salesperson/Purchaser", TempCustLedgEntry."Salesperson Code");
        //                     ReverseCustLedgEntry(
        //                       TempCustLedgEntry, GLEntry."Entry No.", GenJnlLine.Correction, GenJnlLine."Source Code",
        //                       NextDtldCustLedgEntryEntryNo, ReversalEntry2);
        //                     TempCustLedgEntry.DELETE;
        //                 END;
        //             TempVendLedgEntry.GET("Entry No."):
        //                 BEGIN
        //                     CheckDimComb("Entry No.", "Dimension Set ID",
        //                       DATABASE::Vendor, TempVendLedgEntry."Vendor No.",
        //                       DATABASE::"Salesperson/Purchaser", TempVendLedgEntry."Purchaser Code");
        //                     ReverseVendLedgEntry(
        //                       TempVendLedgEntry, GLEntry."Entry No.", GenJnlLine.Correction, GenJnlLine."Source Code",
        //                       NextDtldVendLedgEntryEntryNo, ReversalEntry2);
        //                     TempVendLedgEntry.DELETE;
        //                 END;
        //             TempBankAccLedgEntry.GET("Entry No."):
        //                 BEGIN
        //                     CheckDimComb("Entry No.", "Dimension Set ID",
        //                       DATABASE::"Bank Account", TempBankAccLedgEntry."Bank Account No.", 0, '');
        //                     ReverseBankAccLedgEntry(TempBankAccLedgEntry, GLEntry."Entry No.", GenJnlLine."Source Code");
        //                     TempBankAccLedgEntry.DELETE;
        //                 END;
        //         END;
        //     UNTIL NEXT(-1) = 0;

        //Win593++ //
        // IF GLEntry2.FIND('+') THEN
        //     REPEAT
        //         if GLEntry2."Reversed by Entry No." <> 0 THEN
        //             ERROR(CannotReverseErr);
        //         CheckDimComb(GLEntry2."Entry No.", GLEntry2."Dimension Set ID", DATABASE::"G/L Account", GLEntry2."G/L Account No.", 0, '');
        //         GLEntry := GLEntry2;
        //         IF GLEntry2."FA Entry No." <> 0 THEN
        //             FAInsertLedgEntry.InsertReverseEntry(
        //               GenJnlPostLine.GetNextEntryNo, GLEntry2."FA Entry Type", GLEntry2."FA Entry No.", GLEntry."FA Entry No.",
        //               GenJnlPostLine.GetNextTransactionNo);
        //         GLEntry.Amount := -GLEntry2.Amount;
        //         GLEntry.Quantity := -GLEntry2.Quantity;
        //         GLEntry."VAT Amount" := -GLEntry2."VAT Amount";
        //         GLEntry."Debit Amount" := -GLEntry2."Debit Amount";
        //         GLEntry."Credit Amount" := -GLEntry2."Credit Amount";
        //         GLEntry."Additional-Currency Amount" := -GLEntry2."Additional-Currency Amount";
        //         GLEntry."Add.-Currency Debit Amount" := -GLEntry2."Add.-Currency Debit Amount";
        //         GLEntry."Add.-Currency Credit Amount" := -GLEntry2."Add.-Currency Credit Amount";
        //         GLEntry."Entry No." := GenJnlPostLine.GetNextEntryNo;
        //         GLEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //         GLEntry."User ID" := USERID;
        //         GenJournalLine.Correction :=
        //           (GLEntry."Debit Amount" < 0) OR (GLEntry."Credit Amount" < 0) OR
        //           (GLEntry."Add.-Currency Debit Amount" < 0) OR (GLEntry."Add.-Currency Credit Amount" < 0);
        //         GLEntry."Journal Batch Name" := '';
        //         GLEntry."Source Code" := GenJournalLine."Source Code";
        //         SetReversalDescription(
        //           ReversalEntry."Entry Type"::"G/L Account", GLEntry.Description);
        //         GLEntry."Reversed Entry No." := GLEntry2."Entry No.";
        //         GLEntry.Reversed := TRUE;
        //         //WINS.AE 201804302133 ++
        //         GLEntry."Reversal Reason Code" := ReversalCode;
        //         GLEntry."Reversal Reason Comments" := ReversalComments;
        //         //WINS.AE 201804302133 --


        //         // Reversal of Reversal
        //         IF GLEntry2."Reversed Entry No." <> 0 THEN BEGIN
        //             ReversedGLEntry.GET(GLEntry2."Reversed Entry No.");
        //             ReversedGLEntry."Reversed by Entry No." := 0;
        //             ReversedGLEntry.Reversed := FALSE;
        //             ReversedGLEntry.MODIFY;
        //             GLEntry2."Reversed Entry No." := GLEntry."Entry No.";
        //             GLEntry."Reversed by Entry No." := GLEntry2."Entry No.";
        //         END;
        //         GLEntry2."Reversed by Entry No." := GLEntry."Entry No.";
        //         GLEntry2.Reversed := TRUE;
        //         //Win+++
        //         GLEntry2."Reversal Reason Code" := ReversalCode;
        //         GLEntry2."Reversal Reason Comments" := ReversalComments;
        //         //Win---
        //         GLEntry2.MODIFY;
        //         GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, FALSE);
        //         TempReversedGLEntry := GLEntry;
        //         TempReversedGLEntry.INSERT;

        //         CASE TRUE OF
        //             TempCustLedgEntry.GET(GLEntry2."Entry No."):
        //                 BEGIN
        //                     CheckDimComb(GLEntry2."Entry No.", GLEntry2."Dimension Set ID",
        //                       DATABASE::Customer, TempCustLedgEntry."Customer No.",
        //                       DATABASE::"Salesperson/Purchaser", TempCustLedgEntry."Salesperson Code");
        //                     ReverseCustLedgEntry(
        //                       TempCustLedgEntry, GLEntry."Entry No.", GenJnlLine.Correction, GenJnlLine."Source Code",
        //                       NextDtldCustLedgEntryEntryNo, ReversalEntry2);
        //                     TempCustLedgEntry.DELETE;
        //                 END;
        //             TempVendLedgEntry.GET(GLEntry2."Entry No."):
        //                 BEGIN
        //                     CheckDimComb(GLEntry2."Entry No.", GLEntry2."Dimension Set ID",
        //                       DATABASE::Vendor, TempVendLedgEntry."Vendor No.",
        //                       DATABASE::"Salesperson/Purchaser", TempVendLedgEntry."Purchaser Code");
        //                     ReverseVendLedgEntry(
        //                       TempVendLedgEntry, GLEntry."Entry No.", GenJnlLine.Correction, GenJnlLine."Source Code",
        //                       NextDtldVendLedgEntryEntryNo, ReversalEntry2);
        //                     TempVendLedgEntry.DELETE;
        //                 END;
        //             TempBankAccLedgEntry.GET(GLEntry2."Entry No."):
        //                 BEGIN
        //                     CheckDimComb(GLEntry2."Entry No.", GLEntry2."Dimension Set ID",
        //                       DATABASE::"Bank Account", TempBankAccLedgEntry."Bank Account No.", 0, '');
        //                     ReverseBankAccLedgEntry(TempBankAccLedgEntry, GLEntry."Entry No.", GenJnlLine."Source Code");
        //                     TempBankAccLedgEntry.DELETE;
        //                 END;
        //         END;
        //     UNTIL GLEntry2.NEXT(-1) = 0;
        //Win593--
        //Win513--
        //  //WINS.AE 201804302133 ++
        //      IF (GLEntry2."PDC Document No." <> '') AND (GLEntry2."PDC Line No." <> 0) THEN BEGIN
        //        PDCLine.RESET;
        //        PDCLine.SETRANGE("Document No.",GLEntry2."PDC Document No.");
        //        PDCLine.SETRANGE("Line Number",GLEntry2."PDC Line No.");
        //        IF PDCLine.FINDSET THEN BEGIN
        //           PDCLine."Reversal Reason Code" := ReversalCode;
        //           PDCLine."Reversal Reason Comments" := ReversalComments;
        //           PDCLine.Status := PDCLine.Status::Reversed;
        //           PDCLine.MODIFY;
        //        END;
        //      END;
        //    //WINS.AE 201804302133 --
        //WIN325
        IF (GLEntry2."PDC Document No." <> '') AND (GLEntry2."PDC Line No." <> 0) THEN BEGIN
            PDCLine.RESET;
            PDCLine.SETRANGE("Document No.", GLEntry2."PDC Document No.");
            PDCLine.SETRANGE("Line Number", GLEntry2."PDC Line No.");
            IF PDCLine.FINDSET THEN BEGIN
                PDCLine."Reversal Reason Code" := ReversalCode;
                PDCLine."Reversal Reason Comments" := ReversalComments;
                PDCLine.Status := PDCLine.Status::Reversed;
                PDCLine."Reversal Date" := GLEntry2."Posting Date";
                PDCLine."Settlement Type" := PDCLine."Settlement Type"::"Notify Legal Department";
                IF PDCLine."Reversal Reason Code" = 'CH-BOUNCE' THEN //WIN 315
                    PDCLine."Check Bounce" := TRUE
                ELSE
                    IF PDCLine."Reversal Reason Code" = 'LEASE-CAN' THEN BEGIN  //WIN 315
                        PDCLine.Status := PDCLine.Status::Cancelled;
                        PDCLine."Cancelled Check" := TRUE;
                    END
                    ELSE
                        IF PDCLine."Reversal Reason Code" = 'CH-REPLACE' THEN BEGIN
                            PDCLine.Status := PDCLine.Status::Replaced;
                            PDCLine."Replacement Check" := TRUE;
                        END;
                PDCLine.MODIFY;
                //END;
            END;
            //WIN325
        end;
    end;



    //std proc add

    PROCEDURE ReverseCustLedgEntry(CustLedgEntry: Record 21; NewEntryNo: Integer; Correction: Boolean; SourceCode: Code[10]; VAR NextDtldCustLedgEntryEntryNo: Integer; VAR ReversalEntry: Record 179);
    VAR
        NewCustLedgEntry: Record 21;
        ReversedCustLedgEntry: Record 21;
        DtldCustLedgEntry: Record 379;
        NewDtldCustLedgEntry: Record 379;
    BEGIN
        //Win513++
        // WITH NewCustLedgEntry DO BEGIN
        //     NewCustLedgEntry := CustLedgEntry;
        //     "Sales (LCY)" := -"Sales (LCY)";
        //     "Profit (LCY)" := -"Profit (LCY)";
        //     "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
        //     "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
        //     "Pmt. Disc. Given (LCY)" := -"Pmt. Disc. Given (LCY)";
        //     Positive := NOT Positive;
        //     "Adjusted Currency Factor" := "Adjusted Currency Factor";
        //     "Original Currency Factor" := "Original Currency Factor";
        //     "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
        //     "Max. Payment Tolerance" := -"Max. Payment Tolerance";
        //     "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
        //     "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
        //     "User ID" := USERID;
        //     "Entry No." := NewEntryNo;
        //     "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //     "Journal Batch Name" := '';
        //     "Source Code" := SourceCode;
        //     SetReversalDescription(
        //         ReversalEntry, Description);
        //     "Reversed Entry No." := CustLedgEntry."Entry No.";
        //     Reversed := TRUE;
        //     "Applies-to ID" := '';
        //     // Reversal of Reversal
        //     IF CustLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
        //         ReversedCustLedgEntry.GET(CustLedgEntry."Reversed Entry No.");
        //         ReversedCustLedgEntry."Reversed by Entry No." := 0;
        //         ReversedCustLedgEntry.Reversed := FALSE;
        //         ReversedCustLedgEntry.MODIFY;
        //         CustLedgEntry."Reversed Entry No." := "Entry No.";
        //         "Reversed by Entry No." := CustLedgEntry."Entry No.";
        //     END;
        //     CustLedgEntry."Applies-to ID" := '';
        //     CustLedgEntry."Reversed by Entry No." := "Entry No.";
        //     CustLedgEntry.Reversed := TRUE;
        //     CustLedgEntry.MODIFY;
        //     INSERT;

        //     IF NextDtldCustLedgEntryEntryNo = 0 THEN BEGIN
        //         DtldCustLedgEntry.FINDLAST;
        //         NextDtldCustLedgEntryEntryNo := DtldCustLedgEntry."Entry No." + 1;
        //     END;
        //     DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        //     DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        //     DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);
        //     DtldCustLedgEntry.FINDSET;
        //     REPEAT
        //         DtldCustLedgEntry.TESTFIELD("Entry Type", DtldCustLedgEntry."Entry Type"::"Initial Entry");
        //         NewDtldCustLedgEntry := DtldCustLedgEntry;
        //         NewDtldCustLedgEntry.Amount := -NewDtldCustLedgEntry.Amount;
        //         NewDtldCustLedgEntry."Amount (LCY)" := -NewDtldCustLedgEntry."Amount (LCY)";
        //         NewDtldCustLedgEntry.UpdateDebitCredit(Correction);
        //         NewDtldCustLedgEntry."Cust. Ledger Entry No." := NewEntryNo;
        //         NewDtldCustLedgEntry."User ID" := USERID;
        //         NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //         NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
        //         NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
        //         NewDtldCustLedgEntry.INSERT(TRUE);
        //     UNTIL DtldCustLedgEntry.NEXT = 0;

        //     ApplyCustLedgEntryByReversal(
        //       CustLedgEntry, NewCustLedgEntry, NewDtldCustLedgEntry, "Entry No.", NextDtldCustLedgEntryEntryNo);
        //     ApplyCustLedgEntryByReversal(
        //       NewCustLedgEntry, CustLedgEntry, DtldCustLedgEntry, "Entry No.", NextDtldCustLedgEntryEntryNo);
        // END;
        NewCustLedgEntry := CustLedgEntry;
        NewCustLedgEntry."Sales (LCY)" := -NewCustLedgEntry."Sales (LCY)";
        NewCustLedgEntry."Profit (LCY)" := -NewCustLedgEntry."Profit (LCY)";
        NewCustLedgEntry."Inv. Discount (LCY)" := -NewCustLedgEntry."Inv. Discount (LCY)";
        NewCustLedgEntry."Original Pmt. Disc. Possible" := -NewCustLedgEntry."Original Pmt. Disc. Possible";
        NewCustLedgEntry."Pmt. Disc. Given (LCY)" := -NewCustLedgEntry."Pmt. Disc. Given (LCY)";
        NewCustLedgEntry.Positive := NOT NewCustLedgEntry.Positive;
        NewCustLedgEntry."Adjusted Currency Factor" := NewCustLedgEntry."Adjusted Currency Factor";
        NewCustLedgEntry."Original Currency Factor" := NewCustLedgEntry."Original Currency Factor";
        NewCustLedgEntry."Remaining Pmt. Disc. Possible" := -NewCustLedgEntry."Remaining Pmt. Disc. Possible";
        NewCustLedgEntry."Max. Payment Tolerance" := -NewCustLedgEntry."Max. Payment Tolerance";
        NewCustLedgEntry."Accepted Payment Tolerance" := -NewCustLedgEntry."Accepted Payment Tolerance";
        NewCustLedgEntry."Pmt. Tolerance (LCY)" := -NewCustLedgEntry."Pmt. Tolerance (LCY)";
        NewCustLedgEntry."User ID" := USERID;
        NewCustLedgEntry."Entry No." := NewEntryNo;
        NewCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewCustLedgEntry."Journal Batch Name" := '';
        NewCustLedgEntry."Source Code" := SourceCode;
        SetReversalDescription(
            ReversalEntry, NewCustLedgEntry.Description);
        NewCustLedgEntry."Reversed Entry No." := CustLedgEntry."Entry No.";
        NewCustLedgEntry.Reversed := TRUE;
        NewCustLedgEntry."Applies-to ID" := '';
        // Reversal of Reversal
        IF CustLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
            ReversedCustLedgEntry.GET(CustLedgEntry."Reversed Entry No.");
            ReversedCustLedgEntry."Reversed by Entry No." := 0;
            ReversedCustLedgEntry.Reversed := FALSE;
            ReversedCustLedgEntry.MODIFY;
            CustLedgEntry."Reversed Entry No." := NewCustLedgEntry."Entry No.";
            NewCustLedgEntry."Reversed by Entry No." := CustLedgEntry."Entry No.";
        END;
        CustLedgEntry."Applies-to ID" := '';
        CustLedgEntry."Reversed by Entry No." := NewCustLedgEntry."Entry No.";
        CustLedgEntry.Reversed := TRUE;
        CustLedgEntry.MODIFY;
        NewCustLedgEntry.INSERT;

        IF NextDtldCustLedgEntryEntryNo = 0 THEN BEGIN
            DtldCustLedgEntry.FINDLAST;
            NextDtldCustLedgEntryEntryNo := DtldCustLedgEntry."Entry No." + 1;
        END;
        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);
        DtldCustLedgEntry.FINDSET;
        REPEAT
            DtldCustLedgEntry.TESTFIELD("Entry Type", DtldCustLedgEntry."Entry Type"::"Initial Entry");
            NewDtldCustLedgEntry := DtldCustLedgEntry;
            NewDtldCustLedgEntry.Amount := -NewDtldCustLedgEntry.Amount;
            NewDtldCustLedgEntry."Amount (LCY)" := -NewDtldCustLedgEntry."Amount (LCY)";
            NewDtldCustLedgEntry.UpdateDebitCredit(Correction);
            NewDtldCustLedgEntry."Cust. Ledger Entry No." := NewEntryNo;
            NewDtldCustLedgEntry."User ID" := USERID;
            NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
            NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
            NewDtldCustLedgEntry.INSERT(TRUE);
        UNTIL DtldCustLedgEntry.NEXT = 0;

        ApplyCustLedgEntryByReversal(
          CustLedgEntry, NewCustLedgEntry, NewDtldCustLedgEntry, NewCustLedgEntry."Entry No.", NextDtldCustLedgEntryEntryNo);
        ApplyCustLedgEntryByReversal(
          NewCustLedgEntry, CustLedgEntry, DtldCustLedgEntry, NewCustLedgEntry."Entry No.", NextDtldCustLedgEntryEntryNo);

        //Win513--
    END;

    procedure ReverseBankAccLedgEntry(BankAccLedgEntry: Record "Bank Account Ledger Entry"; NewEntryNo: Integer; SourceCode: Code[10])
    var
        NewBankAccLedgEntry: Record "Bank Account Ledger Entry";
        ReversedBankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        //Win513++
        // with NewBankAccLedgEntry do begin
        //     NewBankAccLedgEntry := BankAccLedgEntry;
        //     Amount := -Amount;
        //     "Remaining Amount" := -"Remaining Amount";
        //     "Amount (LCY)" := -"Amount (LCY)";
        //     "Debit Amount" := -"Debit Amount";
        //     "Credit Amount" := -"Credit Amount";
        //     "Debit Amount (LCY)" := -"Debit Amount (LCY)";
        //     "Credit Amount (LCY)" := -"Credit Amount (LCY)";
        //     Positive := not Positive;
        //     "User ID" := UserId;
        //     "Entry No." := NewEntryNo;
        //     "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //     "Journal Batch Name" := '';
        //     "Source Code" := SourceCode;
        //     SetReversalDescription(BankAccLedgEntry, Description);
        //     "Reversed Entry No." := BankAccLedgEntry."Entry No.";
        //     Reversed := true;
        //     // Reversal of Reversal
        //     if BankAccLedgEntry."Reversed Entry No." <> 0 then begin
        //         ReversedBankAccLedgEntry.Get(BankAccLedgEntry."Reversed Entry No.");
        //         ReversedBankAccLedgEntry."Reversed by Entry No." := 0;
        //         ReversedBankAccLedgEntry.Reversed := false;
        //         ReversedBankAccLedgEntry.Modify();
        //         BankAccLedgEntry."Reversed Entry No." := "Entry No.";
        //         "Reversed by Entry No." := BankAccLedgEntry."Entry No.";
        //     end;
        //     BankAccLedgEntry."Reversed by Entry No." := "Entry No.";
        //     BankAccLedgEntry.Reversed := true;
        //     BankAccLedgEntry.Modify();

        //     Insert;
        //end;
        NewBankAccLedgEntry := BankAccLedgEntry;
        NewBankAccLedgEntry.Amount := -NewBankAccLedgEntry.Amount;
        NewBankAccLedgEntry."Remaining Amount" := -NewBankAccLedgEntry."Remaining Amount";
        NewBankAccLedgEntry."Amount (LCY)" := -NewBankAccLedgEntry."Amount (LCY)";
        NewBankAccLedgEntry."Debit Amount" := -NewBankAccLedgEntry."Debit Amount";
        NewBankAccLedgEntry."Credit Amount" := -NewBankAccLedgEntry."Credit Amount";
        NewBankAccLedgEntry."Debit Amount (LCY)" := -NewBankAccLedgEntry."Debit Amount (LCY)";
        NewBankAccLedgEntry."Credit Amount (LCY)" := -NewBankAccLedgEntry."Credit Amount (LCY)";
        NewBankAccLedgEntry.Positive := not NewBankAccLedgEntry.Positive;
        NewBankAccLedgEntry."User ID" := UserId;
        NewBankAccLedgEntry."Entry No." := NewEntryNo;
        NewBankAccLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewBankAccLedgEntry."Journal Batch Name" := '';
        NewBankAccLedgEntry."Source Code" := SourceCode;
        SetReversalDescription(BankAccLedgEntry, NewBankAccLedgEntry.Description);
        NewBankAccLedgEntry."Reversed Entry No." := BankAccLedgEntry."Entry No.";
        NewBankAccLedgEntry.Reversed := true;
        // Reversal of Reversal
        if BankAccLedgEntry."Reversed Entry No." <> 0 then begin
            ReversedBankAccLedgEntry.Get(BankAccLedgEntry."Reversed Entry No.");
            ReversedBankAccLedgEntry."Reversed by Entry No." := 0;
            ReversedBankAccLedgEntry.Reversed := false;
            ReversedBankAccLedgEntry.Modify();
            BankAccLedgEntry."Reversed Entry No." := NewBankAccLedgEntry."Entry No.";
            NewBankAccLedgEntry."Reversed by Entry No." := BankAccLedgEntry."Entry No.";
        end;
        BankAccLedgEntry."Reversed by Entry No." := NewBankAccLedgEntry."Entry No.";
        BankAccLedgEntry.Reversed := true;
        BankAccLedgEntry.Modify();

        NewBankAccLedgEntry.Insert;
        //Win513--
    end;

    procedure ApplyVendLedgEntryByReversal(VendLedgEntry: Record "Vendor Ledger Entry"; VendLedgEntry2: Record "Vendor Ledger Entry"; DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; AppliedEntryNo: Integer; var NextDtldVendLedgEntryEntryNo: Integer)
    var
        NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        IsHandled: Boolean;
    begin
        VendLedgEntry2.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
        VendLedgEntry."Closed by Entry No." := VendLedgEntry2."Entry No.";
        VendLedgEntry."Closed at Date" := VendLedgEntry2."Posting Date";
        VendLedgEntry."Closed by Amount" := -VendLedgEntry2."Remaining Amount";
        VendLedgEntry."Closed by Amount (LCY)" := -VendLedgEntry2."Remaining Amt. (LCY)";
        VendLedgEntry."Closed by Currency Code" := VendLedgEntry2."Currency Code";
        VendLedgEntry."Closed by Currency Amount" := -VendLedgEntry2."Remaining Amount";
        VendLedgEntry.Open := false;
        VendLedgEntry."EFT Register No." := 0;
        VendLedgEntry."EFT Amount Transferred" := 0;
        VendLedgEntry."EFT Bank Account No." := '';
        VendLedgEntry.Modify();


        NewDtldVendLedgEntry := DtldVendLedgEntry2;
        NewDtldVendLedgEntry."Vendor Ledger Entry No." := VendLedgEntry."Entry No.";
        NewDtldVendLedgEntry."Entry Type" := NewDtldVendLedgEntry."Entry Type"::Application;
        NewDtldVendLedgEntry."Applied Vend. Ledger Entry No." := AppliedEntryNo;
        NewDtldVendLedgEntry."User ID" := UserId;
        NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
        NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
        IsHandled := false;

        if not IsHandled then
            NewDtldVendLedgEntry.Insert(true);
    end;

    PROCEDURE ReverseVendLedgEntry(VendLedgEntry: Record 25; NewEntryNo: Integer; Correction: Boolean; SourceCode: Code[10]; VAR NextDtldVendLedgEntryEntryNo: Integer; VAR ReversalEntry: Record 179);
    VAR
        NewVendLedgEntry: Record 25;
        ReversedVendLedgEntry: Record 25;
        DtldVendLedgEntry: Record 380;
        NewDtldVendLedgEntry: Record 380;
    BEGIN
        //Win513++
        // WITH NewVendLedgEntry DO BEGIN
        //     NewVendLedgEntry := VendLedgEntry;
        //     "Purchase (LCY)" := -"Purchase (LCY)";
        //     "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
        //     "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
        //     "Pmt. Disc. Rcd.(LCY)" := -"Pmt. Disc. Rcd.(LCY)";
        //     Positive := NOT Positive;
        //     "Adjusted Currency Factor" := "Adjusted Currency Factor";
        //     "Original Currency Factor" := "Original Currency Factor";
        //     "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
        //     "Max. Payment Tolerance" := -"Max. Payment Tolerance";
        //     "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
        //     "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
        //     "User ID" := USERID;
        //     "Entry No." := NewEntryNo;
        //     "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //     "Journal Batch Name" := '';
        //     "Source Code" := SourceCode;
        //     SetReversalDescription(
        //        ReversalEntry, Description);
        //     "Reversed Entry No." := VendLedgEntry."Entry No.";
        //     Reversed := TRUE;
        //     "Applies-to ID" := '';
        //     // Reversal of Reversal
        //     IF VendLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
        //         ReversedVendLedgEntry.GET(VendLedgEntry."Reversed Entry No.");
        //         ReversedVendLedgEntry."Reversed by Entry No." := 0;
        //         ReversedVendLedgEntry.Reversed := FALSE;
        //         ReversedVendLedgEntry.MODIFY;
        //         VendLedgEntry."Reversed Entry No." := "Entry No.";
        //         "Reversed by Entry No." := VendLedgEntry."Entry No.";
        //     END;
        //     VendLedgEntry."Applies-to ID" := '';
        //     VendLedgEntry."Reversed by Entry No." := "Entry No.";
        //     VendLedgEntry.Reversed := TRUE;
        //     VendLedgEntry."EFT Register No." := 0;
        //     VendLedgEntry."EFT Amount Transferred" := 0;
        //     VendLedgEntry."EFT Bank Account No." := '';
        //     VendLedgEntry.MODIFY;
        //     INSERT;

        //     IF NextDtldVendLedgEntryEntryNo = 0 THEN BEGIN
        //         DtldVendLedgEntry.FINDLAST;
        //         NextDtldVendLedgEntryEntryNo := DtldVendLedgEntry."Entry No." + 1;
        //     END;
        //     DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
        //     DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
        //     DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);
        //     DtldVendLedgEntry.FINDSET;
        //     REPEAT
        //         DtldVendLedgEntry.TESTFIELD("Entry Type", DtldVendLedgEntry."Entry Type"::"Initial Entry");
        //         NewDtldVendLedgEntry := DtldVendLedgEntry;
        //         NewDtldVendLedgEntry.Amount := -NewDtldVendLedgEntry.Amount;
        //         NewDtldVendLedgEntry."Amount (LCY)" := -NewDtldVendLedgEntry."Amount (LCY)";
        //         NewDtldVendLedgEntry.UpdateDebitCredit(Correction);
        //         NewDtldVendLedgEntry."Vendor Ledger Entry No." := NewEntryNo;
        //         NewDtldVendLedgEntry."User ID" := USERID;
        //         NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //         NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
        //         NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
        //         NewDtldVendLedgEntry.INSERT(TRUE);
        //     UNTIL DtldVendLedgEntry.NEXT = 0;

        //     ApplyVendLedgEntryByReversal(
        //       VendLedgEntry, NewVendLedgEntry, NewDtldVendLedgEntry, "Entry No.", NextDtldVendLedgEntryEntryNo);
        //     ApplyVendLedgEntryByReversal(
        //       NewVendLedgEntry, VendLedgEntry, DtldVendLedgEntry, "Entry No.", NextDtldVendLedgEntryEntryNo);
        // END;
        NewVendLedgEntry := VendLedgEntry;
        NewVendLedgEntry."Purchase (LCY)" := -NewVendLedgEntry."Purchase (LCY)";
        NewVendLedgEntry."Inv. Discount (LCY)" := -NewVendLedgEntry."Inv. Discount (LCY)";
        NewVendLedgEntry."Original Pmt. Disc. Possible" := -NewVendLedgEntry."Original Pmt. Disc. Possible";
        NewVendLedgEntry."Pmt. Disc. Rcd.(LCY)" := -NewVendLedgEntry."Pmt. Disc. Rcd.(LCY)";
        NewVendLedgEntry.Positive := NOT NewVendLedgEntry.Positive;
        NewVendLedgEntry."Adjusted Currency Factor" := NewVendLedgEntry."Adjusted Currency Factor";
        NewVendLedgEntry."Original Currency Factor" := NewVendLedgEntry."Original Currency Factor";
        NewVendLedgEntry."Remaining Pmt. Disc. Possible" := -NewVendLedgEntry."Remaining Pmt. Disc. Possible";
        NewVendLedgEntry."Max. Payment Tolerance" := -NewVendLedgEntry."Max. Payment Tolerance";
        NewVendLedgEntry."Accepted Payment Tolerance" := -NewVendLedgEntry."Accepted Payment Tolerance";
        NewVendLedgEntry."Pmt. Tolerance (LCY)" := -NewVendLedgEntry."Pmt. Tolerance (LCY)";
        NewVendLedgEntry."User ID" := USERID;
        NewVendLedgEntry."Entry No." := NewEntryNo;
        NewVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewVendLedgEntry."Journal Batch Name" := '';
        NewVendLedgEntry."Source Code" := SourceCode;
        SetReversalDescription(
           ReversalEntry, NewVendLedgEntry.Description);
        NewVendLedgEntry."Reversed Entry No." := VendLedgEntry."Entry No.";
        NewVendLedgEntry.Reversed := TRUE;
        NewVendLedgEntry."Applies-to ID" := '';
        // Reversal of Reversal
        IF VendLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
            ReversedVendLedgEntry.GET(VendLedgEntry."Reversed Entry No.");
            ReversedVendLedgEntry."Reversed by Entry No." := 0;
            ReversedVendLedgEntry.Reversed := FALSE;
            ReversedVendLedgEntry.MODIFY;
            VendLedgEntry."Reversed Entry No." := NewVendLedgEntry."Entry No.";
            NewVendLedgEntry."Reversed by Entry No." := VendLedgEntry."Entry No.";
        END;
        VendLedgEntry."Applies-to ID" := '';
        VendLedgEntry."Reversed by Entry No." := NewVendLedgEntry."Entry No.";
        VendLedgEntry.Reversed := TRUE;
        VendLedgEntry."EFT Register No." := 0;
        VendLedgEntry."EFT Amount Transferred" := 0;
        VendLedgEntry."EFT Bank Account No." := '';
        VendLedgEntry.MODIFY;
        NewVendLedgEntry.INSERT;

        IF NextDtldVendLedgEntryEntryNo = 0 THEN BEGIN
            DtldVendLedgEntry.FINDLAST;
            NextDtldVendLedgEntryEntryNo := DtldVendLedgEntry."Entry No." + 1;
        END;
        DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
        DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);
        DtldVendLedgEntry.FINDSET;
        REPEAT
            DtldVendLedgEntry.TESTFIELD("Entry Type", DtldVendLedgEntry."Entry Type"::"Initial Entry");
            NewDtldVendLedgEntry := DtldVendLedgEntry;
            NewDtldVendLedgEntry.Amount := -NewDtldVendLedgEntry.Amount;
            NewDtldVendLedgEntry."Amount (LCY)" := -NewDtldVendLedgEntry."Amount (LCY)";
            NewDtldVendLedgEntry.UpdateDebitCredit(Correction);
            NewDtldVendLedgEntry."Vendor Ledger Entry No." := NewEntryNo;
            NewDtldVendLedgEntry."User ID" := USERID;
            NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
            NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
            NewDtldVendLedgEntry.INSERT(TRUE);
        UNTIL DtldVendLedgEntry.NEXT = 0;

        ApplyVendLedgEntryByReversal(
          VendLedgEntry, NewVendLedgEntry, NewDtldVendLedgEntry, NewVendLedgEntry."Entry No.", NextDtldVendLedgEntryEntryNo);
        ApplyVendLedgEntryByReversal(
          NewVendLedgEntry, VendLedgEntry, DtldVendLedgEntry, NewVendLedgEntry."Entry No.", NextDtldVendLedgEntryEntryNo);
        //Win513--
    END;

    procedure ReverseCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry"; NewEntryNo: Integer; Correction: Boolean; SourceCode: Code[10]; var NextDtldCustLedgEntryEntryNo: Integer)
    var
        NewCustLedgEntry: Record "Cust. Ledger Entry";
        ReversedCustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        IsHandled: Boolean;
    begin
        //Win513++
        // with NewCustLedgEntry do begin
        //     NewCustLedgEntry := CustLedgEntry;
        //     "Sales (LCY)" := -"Sales (LCY)";
        //     "Profit (LCY)" := -"Profit (LCY)";
        //     "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
        //     "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
        //     "Pmt. Disc. Given (LCY)" := -"Pmt. Disc. Given (LCY)";
        //     Positive := not Positive;
        //     "Adjusted Currency Factor" := "Adjusted Currency Factor";
        //     "Original Currency Factor" := "Original Currency Factor";
        //     "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
        //     "Max. Payment Tolerance" := -"Max. Payment Tolerance";
        //     "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
        //     "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
        //     "User ID" := UserId;
        //     "Entry No." := NewEntryNo;
        //     "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //     "Journal Batch Name" := '';
        //     "Source Code" := SourceCode;
        //     SetReversalDescription(CustLedgEntry, Description);
        //     "Reversed Entry No." := CustLedgEntry."Entry No.";
        //     Reversed := true;
        //     "Applies-to ID" := '';
        //     // Reversal of Reversal
        //     if CustLedgEntry."Reversed Entry No." <> 0 then begin
        //         ReversedCustLedgEntry.Get(CustLedgEntry."Reversed Entry No.");
        //         ReversedCustLedgEntry."Reversed by Entry No." := 0;
        //         ReversedCustLedgEntry.Reversed := false;
        //         ReversedCustLedgEntry.Modify();
        //         CustLedgEntry."Reversed Entry No." := "Entry No.";
        //         "Reversed by Entry No." := CustLedgEntry."Entry No.";
        //     end;
        //     CustLedgEntry."Applies-to ID" := '';
        //     CustLedgEntry."Reversed by Entry No." := "Entry No.";
        //     CustLedgEntry.Reversed := true;
        //     CustLedgEntry.Modify();

        //     Insert;


        //     if NextDtldCustLedgEntryEntryNo = 0 then begin
        //         DtldCustLedgEntry.FindLast;
        //         NextDtldCustLedgEntryEntryNo := DtldCustLedgEntry."Entry No." + 1;
        //     end;
        //     DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");
        //     DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        //     DtldCustLedgEntry.SetRange(Unapplied, false);

        //     DtldCustLedgEntry.FindSet();
        //     repeat
        //         DtldCustLedgEntry.TestField("Entry Type", DtldCustLedgEntry."Entry Type"::"Initial Entry");
        //         NewDtldCustLedgEntry := DtldCustLedgEntry;
        //         NewDtldCustLedgEntry.Amount := -NewDtldCustLedgEntry.Amount;
        //         NewDtldCustLedgEntry."Amount (LCY)" := -NewDtldCustLedgEntry."Amount (LCY)";
        //         NewDtldCustLedgEntry.UpdateDebitCredit(Correction);
        //         NewDtldCustLedgEntry."Cust. Ledger Entry No." := NewEntryNo;
        //         NewDtldCustLedgEntry."User ID" := UserId;
        //         NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        //         NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
        //         NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
        //         IsHandled := false;


        //         if not IsHandled then
        //             NewDtldCustLedgEntry.Insert(true);
        //     until DtldCustLedgEntry.Next() = 0;

        //     ApplyCustLedgEntryByReversal(
        //       CustLedgEntry, NewCustLedgEntry, NewDtldCustLedgEntry, "Entry No.", NextDtldCustLedgEntryEntryNo);
        //     ApplyCustLedgEntryByReversal(
        //       NewCustLedgEntry, CustLedgEntry, DtldCustLedgEntry, "Entry No.", NextDtldCustLedgEntryEntryNo);
        // end;
        NewCustLedgEntry := CustLedgEntry;
        NewCustLedgEntry."Sales (LCY)" := -NewCustLedgEntry."Sales (LCY)";
        NewCustLedgEntry."Profit (LCY)" := -NewCustLedgEntry."Profit (LCY)";
        NewCustLedgEntry."Inv. Discount (LCY)" := -NewCustLedgEntry."Inv. Discount (LCY)";
        NewCustLedgEntry."Original Pmt. Disc. Possible" := -NewCustLedgEntry."Original Pmt. Disc. Possible";
        NewCustLedgEntry."Pmt. Disc. Given (LCY)" := -NewCustLedgEntry."Pmt. Disc. Given (LCY)";
        NewCustLedgEntry.Positive := not NewCustLedgEntry.Positive;
        NewCustLedgEntry."Adjusted Currency Factor" := NewCustLedgEntry."Adjusted Currency Factor";
        NewCustLedgEntry."Original Currency Factor" := NewCustLedgEntry."Original Currency Factor";
        NewCustLedgEntry."Remaining Pmt. Disc. Possible" := -NewCustLedgEntry."Remaining Pmt. Disc. Possible";
        NewCustLedgEntry."Max. Payment Tolerance" := -NewCustLedgEntry."Max. Payment Tolerance";
        NewCustLedgEntry."Accepted Payment Tolerance" := -NewCustLedgEntry."Accepted Payment Tolerance";
        NewCustLedgEntry."Pmt. Tolerance (LCY)" := -NewCustLedgEntry."Pmt. Tolerance (LCY)";
        NewCustLedgEntry."User ID" := UserId;
        NewCustLedgEntry."Entry No." := NewEntryNo;
        NewCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewCustLedgEntry."Journal Batch Name" := '';
        NewCustLedgEntry."Source Code" := SourceCode;
        SetReversalDescription(CustLedgEntry, NewCustLedgEntry.Description);
        NewCustLedgEntry."Reversed Entry No." := CustLedgEntry."Entry No.";
        NewCustLedgEntry.Reversed := true;
        NewCustLedgEntry."Applies-to ID" := '';
        // Reversal of Reversal
        if CustLedgEntry."Reversed Entry No." <> 0 then begin
            ReversedCustLedgEntry.Get(CustLedgEntry."Reversed Entry No.");
            ReversedCustLedgEntry."Reversed by Entry No." := 0;
            ReversedCustLedgEntry.Reversed := false;
            ReversedCustLedgEntry.Modify();
            CustLedgEntry."Reversed Entry No." := NewCustLedgEntry."Entry No.";
            NewCustLedgEntry."Reversed by Entry No." := CustLedgEntry."Entry No.";
        end;
        CustLedgEntry."Applies-to ID" := '';
        CustLedgEntry."Reversed by Entry No." := NewCustLedgEntry."Entry No.";
        CustLedgEntry.Reversed := true;
        CustLedgEntry.Modify();

        NewCustLedgEntry.Insert;


        if NextDtldCustLedgEntryEntryNo = 0 then begin
            DtldCustLedgEntry.FindLast;
            NextDtldCustLedgEntryEntryNo := DtldCustLedgEntry."Entry No." + 1;
        end;
        DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        DtldCustLedgEntry.SetRange(Unapplied, false);

        DtldCustLedgEntry.FindSet();
        repeat
            DtldCustLedgEntry.TestField("Entry Type", DtldCustLedgEntry."Entry Type"::"Initial Entry");
            NewDtldCustLedgEntry := DtldCustLedgEntry;
            NewDtldCustLedgEntry.Amount := -NewDtldCustLedgEntry.Amount;
            NewDtldCustLedgEntry."Amount (LCY)" := -NewDtldCustLedgEntry."Amount (LCY)";
            NewDtldCustLedgEntry.UpdateDebitCredit(Correction);
            NewDtldCustLedgEntry."Cust. Ledger Entry No." := NewEntryNo;
            NewDtldCustLedgEntry."User ID" := UserId;
            NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
            NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
            IsHandled := false;


            if not IsHandled then
                NewDtldCustLedgEntry.Insert(true);
        until DtldCustLedgEntry.Next() = 0;

        ApplyCustLedgEntryByReversal(
          CustLedgEntry, NewCustLedgEntry, NewDtldCustLedgEntry, NewCustLedgEntry."Entry No.", NextDtldCustLedgEntryEntryNo);
        ApplyCustLedgEntryByReversal(
          NewCustLedgEntry, CustLedgEntry, DtldCustLedgEntry, NewCustLedgEntry."Entry No.", NextDtldCustLedgEntryEntryNo);
        //Win513--
    end;

    procedure ApplyCustLedgEntryByReversal(CustLedgEntry: Record "Cust. Ledger Entry"; CustLedgEntry2: Record "Cust. Ledger Entry"; DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry"; AppliedEntryNo: Integer; var NextDtldCustLedgEntryEntryNo: Integer)
    var
        NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        IsHandled: Boolean;
    begin
        CustLedgEntry2.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
        CustLedgEntry."Closed by Entry No." := CustLedgEntry2."Entry No.";
        CustLedgEntry."Closed at Date" := CustLedgEntry2."Posting Date";
        CustLedgEntry."Closed by Amount" := -CustLedgEntry2."Remaining Amount";
        CustLedgEntry."Closed by Amount (LCY)" := -CustLedgEntry2."Remaining Amt. (LCY)";
        CustLedgEntry."Closed by Currency Code" := CustLedgEntry2."Currency Code";
        CustLedgEntry."Closed by Currency Amount" := -CustLedgEntry2."Remaining Amount";
        CustLedgEntry.Open := false;
        CustLedgEntry.Modify();



        NewDtldCustLedgEntry := DtldCustLedgEntry2;
        NewDtldCustLedgEntry."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
        NewDtldCustLedgEntry."Entry Type" := NewDtldCustLedgEntry."Entry Type"::Application;
        NewDtldCustLedgEntry."Applied Cust. Ledger Entry No." := AppliedEntryNo;
        NewDtldCustLedgEntry."User ID" := UserId;
        NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
        NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
        IsHandled := false;

        if not IsHandled then
            NewDtldCustLedgEntry.Insert(true);
    end;

    PROCEDURE SetReversalDescription(RecVar: Variant; var Description: Text[100]);
    var
        EntryType: Option;
        EntryNo: Integer;
        ReversalEntry: Record "Reversal Entry";
    BEGIN
        ReversalEntry.RESET;
        ReversalEntry.SETRANGE("Entry Type", EntryType);
        ReversalEntry.SETRANGE("Entry No.", EntryNo);
        IF ReversalEntry.FINDFIRST THEN
            Description := ReversalEntry.Description;
    END;

    PROCEDURE CheckDimComb(EntryNo: Integer; DimSetID: Integer; TableID1: Integer; AccNo1: Code[20]; TableID2: Integer; AccNo2: Code[20]);
    VAR
        DimMgt: Codeunit 408;
        TableID: ARRAY[10] OF Integer;
        AccNo: ARRAY[10] OF Code[20];
        DimCombBlockedErr: Label 'ENU=The combination of dimensions used in general ledger entry %1 is blocked. %2.;ENA=The combination of dimensions used in general ledger entry %1 is blocked. %2.';
    BEGIN
        IF NOT DimMgt.CheckDimIDComb(DimSetID) THEN
            ERROR(DimCombBlockedErr, EntryNo, DimMgt.GetDimCombErr);
        CLEAR(TableID);
        CLEAR(AccNo);
        TableID[1] := TableID1;
        AccNo[1] := AccNo1;
        TableID[2] := TableID2;
        AccNo[2] := AccNo2;
        IF NOT DimMgt.CheckDimValuePosting(TableID, AccNo, DimSetID) THEN
            ERROR(DimMgt.GetDimValuePostingErr);
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseOnBeforeFinishPosting', '', true, true)]

    local procedure OnReverseOnBeforeFinishPosting(var ReversalEntry: Record "Reversal Entry"; var ReversalEntry2: Record "Reversal Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var GLRegister: Record "G/L Register")
    var
        TempRevertTransactionNo: Record 2000000026 TEMPORARY;
        VATEntry: Record 254;
        GenJnlLine: Record 81;
        GlEntry: Record 17;
        TempReversedGLEntry: Record 17 TEMPORARY;
    begin
        //Win593++ 
        // IF ReversalEntry2."Reversal Type" = ReversalEntry2."Reversal Type"::Transaction THEN BEGIN
        //     TempRevertTransactionNo.FINDSET;
        //     REPEAT
        //         VATEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
        //         ReverseVAT(TempReversedGLEntry, GenJnlLine."Source Code");
        //     UNTIL TempRevertTransactionNo.NEXT = 0;
        // END ELSE
        //     ReverseVAT(TempReversedGLEntry, GenJnlLine."Source Code");
        //Win593--
    end;

    procedure ReverseVAT(GLEntry: Record "G/L Entry"; SourceCode: Code[10])
    var
        VATEntry: Record "VAT Entry";
        NewVATEntry: Record "VAT Entry";
        ReversedVATEntry: Record "VAT Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        CannotReverseErr: Label 'ENU=You cannot reverse the transaction, because it has already been reversed.;ENA=You cannot reverse the transaction, because it has already been reversed.';
    begin
        GLEntryVATEntryLink.SetRange("G/L Entry No.", GLEntry."Reversed Entry No.");
        if GLEntryVATEntryLink.FindSet then
            repeat
                VATEntry.Get(GLEntryVATEntryLink."VAT Entry No.");
                if VATEntry."Reversed by Entry No." <> 0 then
                    Error(CannotReverseErr);
                //Win513++    
                // with NewVATEntry do begin
                //     NewVATEntry := VATEntry;
                //     Base := -Base;
                //     Amount := -Amount;
                //     "Unrealized Amount" := -"Unrealized Amount";
                //     "Unrealized Base" := -"Unrealized Base";
                //     "Remaining Unrealized Amount" := -"Remaining Unrealized Amount";
                //     "Remaining Unrealized Base" := -"Remaining Unrealized Base";
                //     "Additional-Currency Amount" := -"Additional-Currency Amount";
                //     "Additional-Currency Base" := -"Additional-Currency Base";
                //     "Add.-Currency Unrealized Amt." := -"Add.-Currency Unrealized Amt.";
                //     "Add.-Curr. Rem. Unreal. Amount" := -"Add.-Curr. Rem. Unreal. Amount";
                //     "Add.-Curr. Rem. Unreal. Base" := -"Add.-Curr. Rem. Unreal. Base";
                //     "VAT Difference" := -"VAT Difference";
                //     "Add.-Curr. VAT Difference" := -"Add.-Curr. VAT Difference";
                //     "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
                //     "Source Code" := SourceCode;
                //     "User ID" := UserId;
                //     "Entry No." := GenJnlPostLine.GetNextVATEntryNo;
                //     "Reversed Entry No." := VATEntry."Entry No.";
                //     "BAS Doc. No." := '';
                //     "BAS Version" := 0;
                //     Reversed := true;
                //     // Reversal of Reversal
                //     if VATEntry."Reversed Entry No." <> 0 then begin
                //         ReversedVATEntry.Get(VATEntry."Reversed Entry No.");
                //         ReversedVATEntry."Reversed by Entry No." := 0;
                //         ReversedVATEntry.Reversed := false;
                //         ReversedVATEntry.Modify();
                //         VATEntry."Reversed Entry No." := "Entry No.";
                //         "Reversed by Entry No." := VATEntry."Entry No.";
                //     end;
                //     VATEntry."Reversed by Entry No." := "Entry No.";
                //     VATEntry.Reversed := true;
                //     VATEntry.Modify();

                //     Insert;
                //     GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.", "Entry No.");
                //     ReverseGST(VATEntry);
                //     GenJnlPostLine.IncrNextVATEntryNo;
                // end;
                NewVATEntry := VATEntry;
                NewVATEntry.Base := -NewVATEntry.Base;
                NewVATEntry.Amount := -NewVATEntry.Amount;
                NewVATEntry."Unrealized Amount" := -NewVATEntry."Unrealized Amount";
                NewVATEntry."Unrealized Base" := -NewVATEntry."Unrealized Base";
                NewVATEntry."Remaining Unrealized Amount" := -NewVATEntry."Remaining Unrealized Amount";
                NewVATEntry."Remaining Unrealized Base" := -NewVATEntry."Remaining Unrealized Base";
                NewVATEntry."Additional-Currency Amount" := -NewVATEntry."Additional-Currency Amount";
                NewVATEntry."Additional-Currency Base" := -NewVATEntry."Additional-Currency Base";
                NewVATEntry."Add.-Currency Unrealized Amt." := -NewVATEntry."Add.-Currency Unrealized Amt.";
                NewVATEntry."Add.-Curr. Rem. Unreal. Amount" := -NewVATEntry."Add.-Curr. Rem. Unreal. Amount";
                NewVATEntry."Add.-Curr. Rem. Unreal. Base" := -NewVATEntry."Add.-Curr. Rem. Unreal. Base";
                NewVATEntry."VAT Difference" := -NewVATEntry."VAT Difference";
                NewVATEntry."Add.-Curr. VAT Difference" := -NewVATEntry."Add.-Curr. VAT Difference";
                NewVATEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
                NewVATEntry."Source Code" := SourceCode;
                NewVATEntry."User ID" := UserId;
                NewVATEntry."Entry No." := GenJnlPostLine.GetNextVATEntryNo;
                NewVATEntry."Reversed Entry No." := VATEntry."Entry No.";
                NewVATEntry."BAS Doc. No." := '';
                NewVATEntry."BAS Version" := 0;
                NewVATEntry.Reversed := true;
                // Reversal of Reversal
                if VATEntry."Reversed Entry No." <> 0 then begin
                    ReversedVATEntry.Get(VATEntry."Reversed Entry No.");
                    ReversedVATEntry."Reversed by Entry No." := 0;
                    ReversedVATEntry.Reversed := false;
                    ReversedVATEntry.Modify();
                    VATEntry."Reversed Entry No." := NewVATEntry."Entry No.";
                    NewVATEntry."Reversed by Entry No." := VATEntry."Entry No.";
                end;
                VATEntry."Reversed by Entry No." := NewVATEntry."Entry No.";
                VATEntry.Reversed := true;
                VATEntry.Modify();

                NewVATEntry.Insert;
                GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.", NewVATEntry."Entry No.");
                ReverseGST(VATEntry);
                GenJnlPostLine.IncrNextVATEntryNo;
            //Win513--
            until GLEntryVATEntryLink.Next() = 0;
    end;

    PROCEDURE ReverseGST(VATEntry: Record 254);
    VAR
        GLSetup: Record 98;
        InsertPurGST: Record "GST Purchase Entry";
        InsertPurGST2: Record "GST Purchase Entry";
        InsertSaleGST: Record "GST Sales Entry";
        InsertSaleGST2: Record "GST Sales Entry";
        EntryNo: Integer;
    BEGIN
        GLSetup.GET;
        IF NOT GLSetup."GST Report" THEN
            EXIT;

        EntryNo := 0;
        IF VATEntry.Type = VATEntry.Type::Purchase THEN BEGIN
            InsertPurGST.RESET;
            IF InsertPurGST.FINDLAST THEN
                EntryNo := InsertPurGST."Entry No." + 1
            ELSE
                EntryNo := 1;

            InsertPurGST.SETRANGE("GST Entry No.", VATEntry."Entry No.");
            IF InsertPurGST.FINDSET THEN
                REPEAT
                    InsertPurGST2.TRANSFERFIELDS(InsertPurGST);
                    InsertPurGST2."Entry No." := EntryNo;
                    InsertPurGST2."GST Entry No." := GenJnlPostLine.GetNextVATEntryNo;
                    InsertPurGST2."GST Base" := -InsertPurGST."GST Base";
                    InsertPurGST2.Amount := -InsertPurGST.Amount;
                    InsertPurGST2.INSERT;
                    EntryNo += 1;
                UNTIL InsertPurGST.NEXT = 0;
        END ELSE
            IF VATEntry.Type = VATEntry.Type::Sale THEN BEGIN
                InsertSaleGST.RESET;
                IF InsertSaleGST.FINDLAST THEN
                    EntryNo := InsertSaleGST."Entry No." + 1
                ELSE
                    EntryNo := 1;

                InsertSaleGST.SETRANGE("GST Entry No.", VATEntry."Entry No.");
                IF InsertSaleGST.FINDSET THEN
                    REPEAT
                        InsertSaleGST2.TRANSFERFIELDS(InsertSaleGST);
                        InsertSaleGST2."Entry No." := EntryNo;
                        InsertSaleGST2."GST Entry No." := GenJnlPostLine.GetNextVATEntryNo;
                        InsertSaleGST2."GST Base" := -InsertSaleGST."GST Base";
                        InsertSaleGST2.Amount := -InsertSaleGST.Amount;
                        InsertSaleGST2.INSERT;
                        EntryNo += 1;
                    UNTIL InsertSaleGST.NEXT = 0;
            END;
    END;


    //WIN513++
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", 'OnBeforeUpdateAll', '', true, true)]
    // local procedure OnBeforeUpdateAll(DirectlyFromPosting: Boolean; var AnalysisView: Record "Analysis View"; Which: Option)
    // var
    //     GLEntry2: Record 17;
    //     ReversalCode: Code[20];
    //     ReversalComments: Text[100];
    // begin
    //     SendMailtoCustomer(GLEntry2."Document No.", ReversalCode, ReversalComments); //WIN325   //PPG
    // end;
    //Win513--

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeLoop', '', true, true)]
    local procedure OnReverseGLEntryOnBeforeLoop(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        ReversalEntry: Record 179;
        CustLedgEntry: Record 21;
        Description: Text[100];
    begin
        SetReversalDescription(ReversalEntry, Description);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseVendLedgEntryOnBeforeInsertVendLedgEntry', '', true, true)]
    local procedure OnReverseVendLedgEntryOnBeforeInsertVendLedgEntry(var NewVendLedgEntry: Record "Vendor Ledger Entry"; VendLedgEntry: Record "Vendor Ledger Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        ReversalEntry: Record 179;
        Description: Text[100];
    begin
        SetReversalDescription(ReversalEntry, Description);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseBankAccLedgEntryOnBeforeInsert', '', true, true)]
    local procedure OnReverseBankAccLedgEntryOnBeforeInsert(var NewBankAccLedgEntry: Record "Bank Account Ledger Entry"; BankAccLedgEntry: Record "Bank Account Ledger Entry")
    var
        ReversalEntry: Record 179;
        Description: Text[100];
    begin
        SetReversalDescription(ReversalEntry, Description);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseVATEntryOnBeforeInsert', '', true, true)]
    local procedure OnReverseVATEntryOnBeforeInsert(var NewVATEntry: Record "VAT Entry"; VATEntry: Record "VAT Entry")
    var
        GLEntryVATEntryLink: Record 253;
        TempReversedGLEntry: Record 17;
    begin
        GLEntryVATEntryLink.SETRANGE("VAT Entry No.", VATEntry."Entry No.");
        IF GLEntryVATEntryLink.FINDSET THEN
            REPEAT
                TempReversedGLEntry.SETRANGE("Reversed Entry No.", GLEntryVATEntryLink."G/L Entry No.");
                IF TempReversedGLEntry.FINDFIRST THEN
                    GLEntryVATEntryLink.InsertLink(TempReversedGLEntry."Entry No.", TempReversedGLEntry."Entry No.");
            UNTIL GLEntryVATEntryLink.NEXT = 0;
    end;



    local procedure SendMailtoCustomer(VAR DocNo: Code[20]; ReasonCode: Code[20]; ReversalComments: Text[100])
    var
        myInt: Integer;
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'ENU=Email Id is blank for the Customer %1';
        //SMTPMail: Codeunit 400;
        //SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;

        lText002: Label 'ENU=Mail sent to Customer %1 Successfully';
        lReasonCode: Record 231;
        lUserSetup: Record 91;
        lUser: Record 2000000120;
        PDCLine: Record 50098;
        //EMail: List of [Text];
        Recipients: List of [Text];
    begin
        IF lReasonCode.GET(ReasonCode) THEN
            IF NOT lReasonCode."Mail to Customer" THEN
                EXIT;
        lUserSetup.GET(USERID);
        lUserSetup.TESTFIELD("E-Mail");

        lUser.RESET;
        lUser.SETRANGE("User Name", USERID);
        IF lUser.FINDSET THEN;
        /*
              {lCLE.RESET;
              lCLE.SETRANGE("Document No.",DocNo);
              IF NOT lCLE.FINDSET THEN
                EXIT;}

              {IF lCust.GET(lCLE."Customer No.") THEN BEGIN
                  IF lCust."E-Mail" = '' THEN
                    ERROR(lText001,lCust."No.");}*/

        IF lCust.GET(PDCLine."Customer No.") THEN BEGIN
            IF lCust."E-Mail" = '' THEN
                ERROR(lText001, lCust."No.");

            // EMail.Add(lCust."E-Mail");
            // SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", EMail, 'Reversal Entry ' + DocNo, '', TRUE);
            // SMTPMail.AppendBody('Hi ' + FORMAT(lCust.Name) + ',');
            // SMTPMail.AppendBody('<br><br>');
            // SMTPMail.AppendBody('Good day!');
            // SMTPMail.AppendBody('<br><Br>');
            // //SMTPMail.AppendBody(ReversalComments);
            // SMTPMail.AppendBody('Your check has been bounced for contract ' + FORMAT(PDCLine."Contract No.") + '.' + 'Following are the details :');
            // SMTPMail.AppendBody('<br><Br>');
            // SMTPMail.AppendBody('Tenant name: ' + FORMAT(PDCLine."Customer Name") + ',' + 'Building No.: ' + FORMAT(PDCLine."Building No.") + ',' + 'Unit No.: ' + FORMAT(PDCLine."Unit No.") + ',' + 'Bank Name: ' + FORMAT(PDCLine."Bank Account") + ',' +
            // 'Check No.: ' + FORMAT(PDCLine."Check No.") + ',' + 'Amount: ' + FORMAT(ABS(PDCLine.Amount)) + '.');
            // SMTPMail.AppendBody('<br><Br>');
            // SMTPMail.AppendBody('Thanks & Regards,');
            // SMTPMail.AppendBody('<br>');
            // SMTPMail.AppendBody(lUser."Full Name");
            // SMTPMail.AppendBody('<br><br>');
            // SMTPMail.Send;

            Recipients.Add(lCust."E-Mail");
            //SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", EMail, 'Reversal Entry ' + DocNo, '', TRUE);
            Subject := 'Reversal Entry ' + DocNo;

            Body := 'Hi ' + FORMAT(lCust.Name) + ', <br><br> Good day! <br><Br> Your check has been bounced for contract ' + FORMAT(PDCLine."Contract No.") + '.';
            Body += 'Following are the details : <br><Br> Tenant name: ' + FORMAT(PDCLine."Customer Name") + ',' + 'Building No.: ' + FORMAT(PDCLine."Building No.");
            Body += ',' + 'Unit No.: ' + FORMAT(PDCLine."Unit No.") + ',' + 'Bank Name: ' + FORMAT(PDCLine."Bank Account") + ',' + 'Check No.: ';
            Body += FORMAT(PDCLine."Check No.") + ',' + 'Amount: ' + FORMAT(ABS(PDCLine.Amount)) + '. <br><Br>  Thanks & Regards, <br>';
            Body += lUser."Full Name" + '<br><br>';

            EmailMessage.Create(Recipients, Subject, Body, true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            //SMTPMail.Send;
            MESSAGE(lText002, lCust."No.");
        END;
    END;


    local procedure SendMailtoNotifyLegalDepart()
    var
        myInt: Integer;
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'ENU =Email Id is blank %1';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;

        lText002: Label 'ENU =Mail sent successfully';
        lReasonCode: Record 231;
        lUserSetup: Record 91;
        lUser: Record 2000000120;
        lPDCLine: Record 50098;
        lGlSetup: Record "General Ledger Setup";
        lText003: Label 'ENU =Do you want to send mail to Legal department?';
        ServCntr: Record 5965;
        RecordLinks: Record 2000000068;
        pPDCLine: Record 50098;
        //Email: List of [text];
        Recipients: List of [Text];
    begin

        IF NOT CONFIRM(lText003) THEN
            EXIT;

        lGlSetup.GET;
        lGlSetup.TESTFIELD(lGlSetup."Legal Department Mail ID");

        lUserSetup.GET(USERID);
        lUserSetup.TESTFIELD("E-Mail");

        lUser.RESET;
        lUser.SETRANGE("User Name", USERID);
        IF lUser.FINDSET THEN;

        // EMail.Add(lGlSetup."Legal Department Mail ID");
        // SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", Email, 'PDC Details', '', TRUE);
        // SMTPMail.AppendBody('Hi ' + ',');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');

        Recipients.Add(lGlSetup."Legal Department Mail ID");
        Subject := 'PDC Details';
        Body := 'Hi ' + ', <br><br>  Good day!  <br><Br>';

        lPDCLine.COPY(pPDCLine);
        //lPDCLine.SETFILTER(Status,'%1|%2',lPDCLine.Status::Received,lPDCLine.Status::Reversed);
        lPDCLine.SETRANGE("Settlement Type", lPDCLine."Settlement Type"::"Notify Legal Department");
        IF lPDCLine.FINDSET THEN BEGIN
            REPEAT
                lPDCLine.TESTFIELD("Settlement Comments");
                // SMTPMail.AppendBody(lPDCLine."Settlement Comments");
                // SMTPMail.AppendBody('<br><Br>');
                // SMTPMail.AppendBody('Just to notify that we have already sent email for bounce check and we are informing to legal department. Following are the Details.');
                // //SMTPMail.AppendBody('Building No.: '+FORMAT(lPDCLine."Building No.")+','+'Unit No.: '+FORMAT(lPDCLine."Unit No.")+','+'Bank Name: '+FORMAT(lPDCLine."Bank Account")+','+'Amount: '+ FORMAT(ABS(lPDCLine.Amount))+'.');
                // SMTPMail.AppendBody('<br>');

                Body += lPDCLine."Settlement Comments" + '<br><Br> Just to notify that we have already sent email for bounce check and we are informing to legal department. Following are the Details. <br>';
            UNTIL lPDCLine.NEXT = 0;
        END;
        //SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Tenant name: ' + FORMAT(lPDCLine."Customer Name") + ',' + 'Building No.: ' + FORMAT(lPDCLine."Building No.") + ',' + 'Unit No.: ' + FORMAT(lPDCLine."Unit No.") + ',' + 'Check No.: ' + FORMAT(lPDCLine."Check No.") + ',' +
        // 'Bank Name: ' + FORMAT(lPDCLine."Bank Account") + ',' + 'Amount: ' + FORMAT(ABS(lPDCLine.Amount)) + '.');
        // //SMTPMail.AppendBody('Building No.: '+FORMAT(lPDCLine."Building No.")+','+'Unit No.: '+FORMAT(lPDCLine."Unit No.")+','+'Bank Name: '+FORMAT(lPDCLine."Bank Account")+','+'Amount: '+ FORMAT(ABS(lPDCLine.Amount))+'.');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody(lUser."Full Name");
        // SMTPMail.AppendBody('<br><br>');

        Body += 'Tenant name: ' + FORMAT(lPDCLine."Customer Name") + ',' + 'Building No.: ' + FORMAT(lPDCLine."Building No.") + ',' + 'Unit No.: ' + FORMAT(lPDCLine."Unit No.") + ',' + 'Check No.: ' + FORMAT(lPDCLine."Check No.") + ',' +
                'Bank Name: ' + FORMAT(lPDCLine."Bank Account") + ',' + 'Amount: ' + FORMAT(ABS(lPDCLine.Amount)) + '.';
        //SMTPMail.AppendBody('Building No.: '+FORMAT(lPDCLine."Building No.")+','+'Unit No.: '+FORMAT(lPDCLine."Unit No.")+','+'Bank Name: '+FORMAT(lPDCLine."Bank Account")+','+'Amount: '+ FORMAT(ABS(lPDCLine.Amount))+'.');
        Body += '<br><Br> Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';

        /* {
         RecordLinks.SETRANGE("Record ID",FATransferEmail.RECORDID);
                 IF RecordLinks.FINDSET THEN BEGIN
                   REPEAT
                     Smtp.AppendBody('<tr>'+
                                '<td Colspan=7> Link : ' + RecordLinks.URL1 + '</td>'+
                                '</tr>');
                   UNTIL (RecordLinks.NEXT = 0);
                 END;
                 Smtp.AppendBody('</table>');

                 Smtp.Send();
         }*/
        ServCntr.RESET;
        ServCntr.SETRANGE(ServCntr."Contract No.", lPDCLine."Contract No.");
        IF ServCntr.FINDFIRST THEN BEGIN
            RecordLinks.SETRANGE(RecordLinks."Record ID", ServCntr.RECORDID);
            IF RecordLinks.FINDSET THEN
                REPEAT

                //WIN502 SMTPMail.AddAttachment(RecordLinks.URL1, RecordLinks.URL1);
                UNTIL RecordLinks.NEXT = 0;
        END;

        lPDCLine.Status := lPDCLine.Status::"Escalated to Legal";
        lPDCLine.MODIFY;

        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        MESSAGE(lText002);
    END;

    PROCEDURE SendMailtointernal(VAR DocNo: Code[20]; ReasonCode: Code[20]; ReversalComments: Text[100]);
    VAR
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'ENU =Email Id is blank for the Customer %1';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;

        lText002: Label 'ENU =Mail sent to Legal Department Successfully';
        lReasonCode: Record 231;
        lUserSetup: Record 91;
        lUser: Record 2000000120;
        GeneralLedgerSetup: Record "General Ledger Setup";
        // Email: List of [Text];
        // Email1: List of [Text];
        Recipients: List of [Text];
    BEGIN
        IF lReasonCode.GET(ReasonCode) THEN
            IF NOT lReasonCode."Mail to Property Mgmt/Legal" THEN
                EXIT;
        lUserSetup.GET(USERID);
        lUserSetup.TESTFIELD("E-Mail");

        lUser.RESET;
        lUser.SETRANGE("User Name", USERID);
        IF lUser.FINDSET THEN;

        lCLE.RESET;
        lCLE.SETRANGE("Document No.", DocNo);
        IF NOT lCLE.FINDSET THEN
            EXIT;

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD(GeneralLedgerSetup."Legal Department Mail ID");
        GeneralLedgerSetup.TESTFIELD(GeneralLedgerSetup."Property Management Mail ID");

        // Email.Add(GeneralLedgerSetup."Legal Department Mail ID");
        // Email1.Add(GeneralLedgerSetup."Property Management Mail ID");
        // SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", Email, 'Reversal Entry ' + DocNo, '', TRUE);
        // SMTPMail.AddRecipients(Email1);
        // SMTPMail.AppendBody('Hi Team');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Just to notify that PDC entry has been reversed and reversal comments are as below');
        // SMTPMail.AppendBody(ReversalComments);
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody(lUser."Full Name");
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;

        Recipients.Add(GeneralLedgerSetup."Legal Department Mail ID");
        Recipients.Add(GeneralLedgerSetup."Property Management Mail ID");
        Subject := 'Reversal Entry ' + DocNo;

        Body := 'Hi Team  <br><br> Good day! <br><Br>';
        Body += 'Just to notify that PDC entry has been reversed and reversal comments are as below';
        Body += ReversalComments + '<br><Br>  Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';

        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        MESSAGE(lText002);
    END;


    //CU47
    /*

    PROCEDURE GetSelectionFilterForPayrollElement(VAR PayrollElement: Record "Payroll Element"): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(PayrollElement);
        EXIT(GetSelectionFilter(RecRef, PayrollElement.FIELDNO(Code)));
    END;
    
        PROCEDURE GetSelectionFilterForPayrollElementGroup(VAR PayrollElementGroup: Record "Payroll Element Group"): Text;
        VAR
            RecRef: RecordRef;
        BEGIN
            RecRef.GETTABLE(PayrollElementGroup);
            EXIT(GetSelectionFilter(RecRef, PayrollElementGroup.FIELDNO(Code)));
        END;
       

    PROCEDURE GetSelectionFilterForLaborContract(VAR LaborContract: Record "Labor Contract"): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(LaborContract);
        EXIT(GetSelectionFilter(RecRef, LaborContract.FIELDNO("No.")));
    END;

    PROCEDURE GetSelectionFilterForEmployee(VAR Employee: Record 5200): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Employee);
        EXIT(GetSelectionFilter(RecRef, Employee.FIELDNO("No.")));
    END;
     */

    /*
        PROCEDURE GetSelectionFilterForOrgUnit(VAR OrganizationalUnit: Record "Organizational Unit"): Text;
        VAR
            RecRef: RecordRef;
        BEGIN
            RecRef.GETTABLE(OrganizationalUnit);
            EXIT(GetSelectionFilter(RecRef, OrganizationalUnit.FIELDNO(Code)));
        END;

    

    PROCEDURE GetSelectionFilterForCompany(VAR Comp: Record 2000000006): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        //WIN325050617
        RecRef.GETTABLE(Comp);
        EXIT(GetSelectionFilter(RecRef, Comp.FIELDNO(Name)));
    END;
    //WIN325050617 - Added Function() - GetSelectionFilterForCompany()
    */

    //Codeunit 80 Sales-Post
    var
        PreviewMode: Boolean;
        Window: Dialog;
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeMakeInventoryAdjustment', '', true, true)]
    local procedure OnRunOnBeforeMakeInventoryAdjustment(var SalesHeader: Record "Sales Header"; SalesInvHeader: Record "Sales Invoice Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        IF PreviewMode THEN BEGIN
            Window.CLOSE;
            GenJnlPostPreview.ThrowError;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterSetEverythingInvoiced', '', true, true)]
    local procedure OnPostSalesLineOnAfterSetEverythingInvoiced(SalesLine: Record "Sales Line"; var EverythingInvoiced: Boolean; var IsHandled: Boolean)
    var

    begin
        IF SalesLine.Quantity = 0 THEN
            SalesLine.TESTFIELD(SalesLine.Amount, 0)
        ELSE BEGIN
            SalesLine.TESTFIELD(SalesLine."No.");
            SalesLine.TESTFIELD(Type);
            SalesLine.TESTFIELD(SalesLine."Gen. Bus. Posting Group");
            SalesLine.TESTFIELD(SalesLine."Gen. Prod. Posting Group");

        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnTestSalesLineOnAfterTestSalesLineJob', '', true, true)]
    local procedure OnTestSalesLineOnAfterTestSalesLineJob(var SalesLine: Record "Sales Line")
    var
        DropShipmentErr: label '@@@="%1 = Line No.";ENU=You cannot ship sales order line %1. The line is marked as a drop shipment and is not yet associated with a purchase order.;ENA=You cannot ship sales order line %1. The line is marked as a drop shipment and is not yet associated with a purchase order.';
    begin
        IF SalesLine."Drop Shipment" THEN BEGIN
            IF SalesLine.Type <> SalesLine.Type::Item THEN
                SalesLine.TESTFIELD("Drop Shipment", FALSE);
            IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." = 0) THEN
                ERROR(DropShipmentErr, SalesLine."Line No.");
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePurchRcptHeaderInsert', '', true, true)]
    local procedure OnBeforePurchRcptHeaderInsert(CommitIsSuppressed: Boolean; PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var RunOnInsert: Boolean)
    var
        PurchPost: Codeunit 90;
        PurchOrderHeader: Record 38;
    begin
        PurchPost.ArchiveUnpostedOrder(PurchOrderHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePurchRcptLineInsert', '', true, true)]
    local procedure OnBeforePurchRcptLineInsert(CommitIsSuppressed: Boolean; DropShptPostBuffer: Record "Drop Shpt. Post. Buffer"; PurchOrderLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        TempDropShptPostBuffer: Record 223 TEMPORARY;
    begin
        PurchRcptLine.INSERT;
        PurchOrderLine."Qty. to Receive" := TempDropShptPostBuffer.Quantity;
        PurchOrderLine."Qty. to Receive (Base)" := TempDropShptPostBuffer."Quantity (Base)";

    end;

    var
        RemQtyToBeInvoicedBase: Decimal;
        RemQtyToBeInvoiced: Decimal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostItemTracking', '', true, true)]
    local procedure OnBeforePostItemTracking(SalesHeader: Record "Sales Header"; TrackingSpecificationExists: Boolean; var IsHandled: Boolean; var SalesLine: Record "Sales Line"; var TempTrackingSpecification: Record "Tracking Specification")
    var
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
        ReturnRcptLine: Record 6661;
    begin
        IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
            QtyToBeInvoiced := TempTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := TempTrackingSpecification."Qty. to Invoice (Base)";
        END ELSE BEGIN
            QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Return Qty. to Receive (Base)";
        END;
        IF ABS(QtyToBeInvoiced) >
           ABS(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")
        THEN BEGIN
            QtyToBeInvoiced := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
            QtyToBeInvoicedBase := ReturnRcptLine."Quantity (Base)" - ReturnRcptLine."Qty. Invoiced (Base)";
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostUpdateInvoiceLineOnBeforeInitQtyToInvoice', '', true, true)]
    local procedure OnPostUpdateInvoiceLineOnBeforeInitQtyToInvoice(var SalesOrderLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line")
    begin
        IF (SalesOrderLine."Purch. Order Line No." <> 0) AND
               (SalesOrderLine.Quantity = SalesOrderLine."Quantity Invoiced")
            THEN
            UpdateAssocLines(SalesOrderLine);
        SalesOrderLine.MODIFY;
    end;
    //std local proc add

    procedure CheckFullGSTonPrepayment(VATBusPostingGr: Text[30]; VATProdPostingGr: Text[30]): Boolean
    var

        VATPostingSetup: Record "VAT Posting Setup";
        GLSETUP: Record "General Ledger Setup";
    begin
        IF GLSETUP."Full GST on Prepayment" THEN
            IF VATPostingSetup.GET(VATBusPostingGr, VATProdPostingGr) THEN
                IF VATPostingSetup."Unrealized VAT Type" <> VATPostingSetup."Unrealized VAT Type"::Percentage THEN
                    EXIT(TRUE);
        EXIT(FALSE);
    end;

    PROCEDURE DivideAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; QtyType: Option General,Invoicing,Shipping; SalesLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    VAR
        DivideFactor: Decimal;
        FullGST: Boolean;
        OriginalDeferralAmount: Decimal;
        GLSetup: record "General Ledger Setup";
        RoundingLineInserted: Boolean;
        RoundingLineNo: Integer;
        Currency: Record 4;

    BEGIN
        GLSetup.GET;
        IF RoundingLineInserted AND (RoundingLineNo = SalesLine."Line No.") THEN
            EXIT;
        //Win513++
        // WITH SalesLine DO
        //     IF (SalesLineQty = 0) OR ("Unit Price" = 0) THEN BEGIN
        //         "Line Amount" := 0;
        //         "Line Discount Amount" := 0;
        //         "Inv. Discount Amount" := 0;
        //         "VAT Base Amount" := 0;
        //         Amount := 0;
        //         "Amount Including VAT" := 0;
        //     END ELSE BEGIN
        //         OriginalDeferralAmount := GetDeferralAmount;
        //         FullGST :=
        //           ("Prepayment Line" OR ("Prepmt. Line Amount" <> 0)) AND
        //           CheckFullGSTonPrepayment("VAT Bus. Posting Group", "VAT Prod. Posting Group");
        //         TempVATAmountLine.GET(
        //           "VAT Identifier", "VAT Calculation Type", "Tax Group Code", FALSE, "Line Amount" >= 0, FullGST);
        //         IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
        //             "VAT %" := TempVATAmountLine."VAT %";
        //         TempVATAmountLineRemainder := TempVATAmountLine;
        //         IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
        //             TempVATAmountLineRemainder.INIT;
        //             TempVATAmountLineRemainder.INSERT;
        //         END;
        //         "Line Amount" := GetLineAmountToHandle(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
        //         IF SalesLineQty <> Quantity THEN
        //             "Line Discount Amount" :=
        //               ROUND("Line Discount Amount" * SalesLineQty / Quantity, Currency."Amount Rounding Precision");

        //         IF "Allow Invoice Disc." AND (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) THEN
        //             IF QtyType = QtyType::Invoicing THEN
        //                 "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
        //             ELSE BEGIN
        //                 TempVATAmountLineRemainder."Invoice Discount Amount" :=
        //                   TempVATAmountLineRemainder."Invoice Discount Amount" +
        //                   TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
        //                   TempVATAmountLine."Inv. Disc. Base Amount";
        //                 "Inv. Discount Amount" :=
        //                   ROUND(
        //                     TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
        //                 TempVATAmountLineRemainder."Invoice Discount Amount" :=
        //                   TempVATAmountLineRemainder."Invoice Discount Amount" - "Inv. Discount Amount";
        //             END;

        //         IF SalesHeader."Prices Including VAT" THEN BEGIN
        //             IF (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) OR
        //                ("Line Amount" = 0)
        //             THEN BEGIN
        //                 TempVATAmountLineRemainder."VAT Amount" := 0;
        //                 TempVATAmountLineRemainder."Amount Including VAT" := 0;
        //             END ELSE BEGIN
        //                 TempVATAmountLineRemainder."VAT Amount" :=
        //                   TempVATAmountLineRemainder."VAT Amount" +
        //                   TempVATAmountLine."VAT Amount" *
        //                   ("Line Amount" - "Inv. Discount Amount") /
        //                   (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
        //                 TempVATAmountLineRemainder."Amount Including VAT" :=
        //                   TempVATAmountLineRemainder."Amount Including VAT" +
        //                   TempVATAmountLine."Amount Including VAT" *
        //                   ("Line Amount" - "Inv. Discount Amount") /
        //                   (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
        //             END;
        //             IF "Line Discount %" <> 100 THEN
        //                 "Amount Including VAT" :=
        //                   ROUND(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision")
        //             ELSE
        //                 "Amount Including VAT" := 0;
        //             Amount :=
        //               ROUND("Amount Including VAT", Currency."Amount Rounding Precision") -
        //               ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
        //             IF FullGST THEN
        //                 "VAT Base Amount" := TempVATAmountLine."VAT Base"
        //             ELSE
        //                 "VAT Base Amount" :=
        //                   ROUND(
        //                     Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
        //             TempVATAmountLineRemainder."Amount Including VAT" :=
        //               TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
        //             TempVATAmountLineRemainder."VAT Amount" :=
        //               TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
        //             DivideFactor := ROUND(SalesLineQty / Quantity);
        //             "Prepmt. Line Amount" := ROUND("Prepmt. Line Amount" * DivideFactor, Currency."Amount Rounding Precision");
        //             "Prepmt. Amt. Inv." := ROUND("Prepmt. Amt. Inv." * DivideFactor, Currency."Amount Rounding Precision");
        //             "Prepmt. Amt. Incl. VAT" := ROUND("Prepmt. Amt. Incl. VAT" * DivideFactor, Currency."Amount Rounding Precision");
        //             "Prepayment Amount" := ROUND("Prepayment Amount" * DivideFactor, Currency."Amount Rounding Precision");
        //             "Prepmt. VAT Base Amt." := ROUND("Prepmt. VAT Base Amt." * DivideFactor, Currency."Amount Rounding Precision");
        //         END ELSE
        //             IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
        //                 IF "Line Discount %" <> 100 THEN
        //                     "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount"
        //                 ELSE
        //                     "Amount Including VAT" := 0;
        //                 Amount := 0;
        //                 "VAT Base Amount" := 0;
        //             END ELSE BEGIN
        //                 Amount := "Line Amount" - "Inv. Discount Amount";
        //                 DivideFactor := ROUND(SalesLineQty / Quantity);
        //                 "Prepmt. Line Amount" := ROUND("Prepmt. Line Amount" * DivideFactor, Currency."Amount Rounding Precision");
        //                 "Prepmt. Amt. Inv." := ROUND("Prepmt. Amt. Inv." * DivideFactor, Currency."Amount Rounding Precision");
        //                 "Prepmt. Amt. Incl. VAT" := ROUND("Prepmt. Amt. Incl. VAT" * DivideFactor, Currency."Amount Rounding Precision");
        //                 "Prepayment Amount" := ROUND("Prepayment Amount" * DivideFactor, Currency."Amount Rounding Precision");
        //                 "Prepmt. VAT Base Amt." := ROUND("Prepmt. VAT Base Amt." * DivideFactor, Currency."Amount Rounding Precision");
        //                 IF FullGST THEN
        //                     "VAT Base Amount" := TempVATAmountLine."VAT Base"
        //                 ELSE
        //                     "VAT Base Amount" :=
        //                       ROUND(
        //                         Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
        //                 IF TempVATAmountLine."VAT Base" = 0 THEN
        //                     TempVATAmountLineRemainder."VAT Amount" := 0
        //                 ELSE BEGIN
        //                     IF "Prepayment Line" AND FullGST THEN
        //                         TempVATAmountLineRemainder."VAT Amount" :=
        //                           TempVATAmountLineRemainder."VAT Amount" +
        //                           TempVATAmountLine."VAT Amount" *
        //                           ("Line Amount" - "Inv. Discount Amount") /
        //                           (TempVATAmountLine."Line Amount" - "Inv. Discount Amount")
        //                     ELSE
        //                         TempVATAmountLineRemainder."VAT Amount" :=
        //                           TempVATAmountLineRemainder."VAT Amount" +
        //                           TempVATAmountLine."VAT Amount" *
        //                           ("Line Amount" - "Inv. Discount Amount") /
        //                           (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
        //                 END;
        //                 IF "Line Discount %" <> 100 THEN
        //                     "Amount Including VAT" :=
        //                       Amount + ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision")
        //                 ELSE
        //                     "Amount Including VAT" := 0;
        //                 TempVATAmountLineRemainder."VAT Amount" :=
        //                   TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
        //             END;

        //         TempVATAmountLineRemainder.MODIFY;
        //         IF "Deferral Code" <> '' THEN
        //             CalcDeferralAmounts(SalesHeader, SalesLine, OriginalDeferralAmount);
        //     END;
        //Win513--
        IF (SalesLineQty = 0) OR (SalesLine."Unit Price" = 0) THEN BEGIN
            SalesLine."Line Amount" := 0;
            SalesLine."Line Discount Amount" := 0;
            SalesLine."Inv. Discount Amount" := 0;
            SalesLine."VAT Base Amount" := 0;
            SalesLine.Amount := 0;
            SalesLine."Amount Including VAT" := 0;
        END ELSE BEGIN
            OriginalDeferralAmount := SalesLine.GetDeferralAmount;
            FullGST :=
              (SalesLine."Prepayment Line" OR (SalesLine."Prepmt. Line Amount" <> 0)) AND
              CheckFullGSTonPrepayment(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
            TempVATAmountLine.GET(
              SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", FALSE, SalesLine."Line Amount" >= 0, FullGST);
            IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" THEN
                SalesLine."VAT %" := TempVATAmountLine."VAT %";
            TempVATAmountLineRemainder := TempVATAmountLine;
            IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
                TempVATAmountLineRemainder.INIT;
                TempVATAmountLineRemainder.INSERT;
            END;
            SalesLine."Line Amount" := SalesLine.GetLineAmountToHandle(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
            IF SalesLineQty <> SalesLine.Quantity THEN
                SalesLine."Line Discount Amount" :=
                  ROUND(SalesLine."Line Discount Amount" * SalesLineQty / SalesLine.Quantity, Currency."Amount Rounding Precision");

            IF SalesLine."Allow Invoice Disc." AND (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) THEN
                IF QtyType = QtyType::Invoicing THEN
                    SalesLine."Inv. Discount Amount" := SalesLine."Inv. Disc. Amount to Invoice"
                ELSE BEGIN
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" +
                      TempVATAmountLine."Invoice Discount Amount" * SalesLine."Line Amount" /
                      TempVATAmountLine."Inv. Disc. Base Amount";
                    SalesLine."Inv. Discount Amount" :=
                      ROUND(
                        TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" - SalesLine."Inv. Discount Amount";
                END;

            IF SalesHeader."Prices Including VAT" THEN BEGIN
                IF (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) OR
                   (SalesLine."Line Amount" = 0)
                THEN BEGIN
                    TempVATAmountLineRemainder."VAT Amount" := 0;
                    TempVATAmountLineRemainder."Amount Including VAT" := 0;
                END ELSE BEGIN
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" +
                      TempVATAmountLine."VAT Amount" *
                      (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      TempVATAmountLineRemainder."Amount Including VAT" +
                      TempVATAmountLine."Amount Including VAT" *
                      (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                END;
                IF SalesLine."Line Discount %" <> 100 THEN
                    SalesLine."Amount Including VAT" :=
                      ROUND(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision")
                ELSE
                    SalesLine."Amount Including VAT" := 0;
                SalesLine.Amount :=
                  ROUND(SalesLine."Amount Including VAT", Currency."Amount Rounding Precision") -
                  ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                IF FullGST THEN
                    SalesLine."VAT Base Amount" := TempVATAmountLine."VAT Base"
                ELSE
                    SalesLine."VAT Base Amount" :=
                      ROUND(
                        SalesLine.Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."Amount Including VAT" :=
                  TempVATAmountLineRemainder."Amount Including VAT" - SalesLine."Amount Including VAT";
                TempVATAmountLineRemainder."VAT Amount" :=
                  TempVATAmountLineRemainder."VAT Amount" - SalesLine."Amount Including VAT" + SalesLine.Amount;
                DivideFactor := ROUND(SalesLineQty / SalesLine.Quantity);
                SalesLine."Prepmt. Line Amount" := ROUND(SalesLine."Prepmt. Line Amount" * DivideFactor, Currency."Amount Rounding Precision");
                SalesLine."Prepmt. Amt. Inv." := ROUND(SalesLine."Prepmt. Amt. Inv." * DivideFactor, Currency."Amount Rounding Precision");
                SalesLine."Prepmt. Amt. Incl. VAT" := ROUND(SalesLine."Prepmt. Amt. Incl. VAT" * DivideFactor, Currency."Amount Rounding Precision");
                SalesLine."Prepayment Amount" := ROUND(SalesLine."Prepayment Amount" * DivideFactor, Currency."Amount Rounding Precision");
                SalesLine."Prepmt. VAT Base Amt." := ROUND(SalesLine."Prepmt. VAT Base Amt." * DivideFactor, Currency."Amount Rounding Precision");
            END ELSE
                IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" THEN BEGIN
                    IF SalesLine."Line Discount %" <> 100 THEN
                        SalesLine."Amount Including VAT" := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount"
                    ELSE
                        SalesLine."Amount Including VAT" := 0;
                    SalesLine.Amount := 0;
                    SalesLine."VAT Base Amount" := 0;
                END ELSE BEGIN
                    SalesLine.Amount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                    DivideFactor := ROUND(SalesLineQty / SalesLine.Quantity);
                    SalesLine."Prepmt. Line Amount" := ROUND(SalesLine."Prepmt. Line Amount" * DivideFactor, Currency."Amount Rounding Precision");
                    SalesLine."Prepmt. Amt. Inv." := ROUND(SalesLine."Prepmt. Amt. Inv." * DivideFactor, Currency."Amount Rounding Precision");
                    SalesLine."Prepmt. Amt. Incl. VAT" := ROUND(SalesLine."Prepmt. Amt. Incl. VAT" * DivideFactor, Currency."Amount Rounding Precision");
                    SalesLine."Prepayment Amount" := ROUND(SalesLine."Prepayment Amount" * DivideFactor, Currency."Amount Rounding Precision");
                    SalesLine."Prepmt. VAT Base Amt." := ROUND(SalesLine."Prepmt. VAT Base Amt." * DivideFactor, Currency."Amount Rounding Precision");
                    IF FullGST THEN
                        SalesLine."VAT Base Amount" := TempVATAmountLine."VAT Base"
                    ELSE
                        SalesLine."VAT Base Amount" :=
                          ROUND(
                            SalesLine.Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                    IF TempVATAmountLine."VAT Base" = 0 THEN
                        TempVATAmountLineRemainder."VAT Amount" := 0
                    ELSE BEGIN
                        IF SalesLine."Prepayment Line" AND FullGST THEN
                            TempVATAmountLineRemainder."VAT Amount" :=
                              TempVATAmountLineRemainder."VAT Amount" +
                              TempVATAmountLine."VAT Amount" *
                              (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                              (TempVATAmountLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        ELSE
                            TempVATAmountLineRemainder."VAT Amount" :=
                              TempVATAmountLineRemainder."VAT Amount" +
                              TempVATAmountLine."VAT Amount" *
                              (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                              (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    END;
                    IF SalesLine."Line Discount %" <> 100 THEN
                        SalesLine."Amount Including VAT" :=
                          SalesLine.Amount + ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision")
                    ELSE
                        SalesLine."Amount Including VAT" := 0;
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" - SalesLine."Amount Including VAT" + SalesLine.Amount;
                END;

            TempVATAmountLineRemainder.MODIFY;
            IF SalesLine."Deferral Code" <> '' THEN
                CalcDeferralAmounts(SalesHeader, SalesLine, OriginalDeferralAmount);
            //Win513--
        END;
    END;

    PROCEDURE UpdateAssocLines(VAR SalesOrderLine: Record 37);
    VAR
        PurchOrderLine: Record 39;
    BEGIN
        PurchOrderLine.GET(
          PurchOrderLine."Document Type"::Order,
          SalesOrderLine."Purchase Order No.", SalesOrderLine."Purch. Order Line No.");
        PurchOrderLine."Sales Order No." := '';
        PurchOrderLine."Sales Order Line No." := 0;
        PurchOrderLine.MODIFY;
        SalesOrderLine."Purchase Order No." := '';
        SalesOrderLine."Purch. Order Line No." := 0;
    END;

    PROCEDURE CalcDeferralAmounts(SalesHeader: Record 36; SalesLine: Record 37; OriginalDeferralAmount: Decimal);
    VAR
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        CurrExchRate: Record 330;
        TotalAmountLCY: Decimal;
        TotalAmount: Decimal;
        DeferralUtilities: Codeunit 1720;
        TotalDeferralCount: Integer;
        DeferralCount: Integer;
        UseDate: Date;
        TempDeferralLine: Record 1702 TEMPORARY;
        TempDeferralHeader: Record 1701 TEMPORARY;
        Currency: Record 4;
    BEGIN
        // Populate temp and calculate the LCY amounts for posting
        IF SalesHeader."Posting Date" = 0D THEN
            UseDate := WORKDATE
        ELSE
            UseDate := SalesHeader."Posting Date";

        IF DeferralHeader.GET(
             //Win513++
             //DeferralUtilities.GetSalesDeferralDocType, '', '', SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
             GetSalesDeferralDocType, '', '', SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
        //Win513--
        THEN BEGIN
            TempDeferralHeader := DeferralHeader;
            IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
                TempDeferralHeader."Amount to Defer" :=
                  ROUND(TempDeferralHeader."Amount to Defer" *
                    SalesLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");
            TempDeferralHeader."Amount to Defer (LCY)" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TempDeferralHeader."Amount to Defer", SalesHeader."Currency Factor"));
            TempDeferralHeader.INSERT;

            //Win513++
            // WITH DeferralLine DO BEGIN
            //     SETRANGE("Deferral Doc. Type", DeferralHeader."Deferral Doc. Type");
            //     SETRANGE("Gen. Jnl. Template Name", DeferralHeader."Gen. Jnl. Template Name");
            //     SETRANGE("Gen. Jnl. Batch Name", DeferralHeader."Gen. Jnl. Batch Name");
            //     SETRANGE("Document Type", DeferralHeader."Document Type");
            //     SETRANGE("Document No.", DeferralHeader."Document No.");
            //     SETRANGE("Line No.", DeferralHeader."Line No.");
            //     IF FINDSET THEN BEGIN
            //         TotalDeferralCount := COUNT;
            //         REPEAT
            //             DeferralCount := DeferralCount + 1;
            //             TempDeferralLine.INIT;
            //             TempDeferralLine := DeferralLine;

            //             IF DeferralCount = TotalDeferralCount THEN BEGIN
            //                 TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
            //                 TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
            //             END ELSE BEGIN
            //                 IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
            //                     TempDeferralLine.Amount :=
            //                       ROUND(TempDeferralLine.Amount *
            //                         SalesLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");

            //                 TempDeferralLine."Amount (LCY)" :=
            //                   ROUND(
            //                     CurrExchRate.ExchangeAmtFCYToLCY(
            //                       UseDate, SalesHeader."Currency Code",
            //                       TempDeferralLine.Amount, SalesHeader."Currency Factor"));
            //                 TotalAmount := TotalAmount + TempDeferralLine.Amount;
            //                 TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
            //             END;
            //             TempDeferralLine.INSERT;
            //         UNTIL NEXT = 0;
            //     END;
            // END;
            DeferralLine.SETRANGE(DeferralLine."Deferral Doc. Type", DeferralHeader."Deferral Doc. Type");
            DeferralLine.SETRANGE(DeferralLine."Gen. Jnl. Template Name", DeferralHeader."Gen. Jnl. Template Name");
            DeferralLine.SETRANGE(DeferralLine."Gen. Jnl. Batch Name", DeferralHeader."Gen. Jnl. Batch Name");
            DeferralLine.SETRANGE(DeferralLine."Document Type", DeferralHeader."Document Type");
            DeferralLine.SETRANGE(DeferralLine."Document No.", DeferralHeader."Document No.");
            DeferralLine.SETRANGE(DeferralLine."Line No.", DeferralHeader."Line No.");
            IF DeferralLine.FINDSET THEN BEGIN
                TotalDeferralCount := DeferralLine.COUNT;
                REPEAT
                    DeferralCount := DeferralCount + 1;
                    TempDeferralLine.INIT;
                    TempDeferralLine := DeferralLine;

                    IF DeferralCount = TotalDeferralCount THEN BEGIN
                        TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                        TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
                    END ELSE BEGIN
                        IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
                            TempDeferralLine.Amount :=
                              ROUND(TempDeferralLine.Amount *
                                SalesLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");

                        TempDeferralLine."Amount (LCY)" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              UseDate, SalesHeader."Currency Code",
                              TempDeferralLine.Amount, SalesHeader."Currency Factor"));
                        TotalAmount := TotalAmount + TempDeferralLine.Amount;
                        TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
                    END;
                    TempDeferralLine.INSERT;
                UNTIL DeferralLine.NEXT = 0;
            END;
            //Win513--
        END;
    END;

    //Win513++
    procedure GetSalesDeferralDocType(): Integer
    var
        DeferralHeader: Record "Deferral Header";
    begin
        EXIT(DeferralHeader."Deferral Doc. Type"::Sales.AsInteger());
    end;
    //Win513--
    PROCEDURE GetPrepmtDiffToLineAmount(SalesLine: Record 37): Decimal;
    var
        TempPrepmtDeductLCYSalesLine: Record 37 TEMPORARY;

    BEGIN
        //Win513++
        //WITH TempPrepmtDeductLCYSalesLine DO
        // IF SalesLine."Prepayment %" = 100 THEN
        //     IF GET(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") THEN
        //         EXIT("Prepmt Amt to Deduct" - "Line Amount");
        IF SalesLine."Prepayment %" = 100 THEN
            IF TempPrepmtDeductLCYSalesLine.GET(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") THEN
                EXIT(TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct" - TempPrepmtDeductLCYSalesLine."Line Amount");
        //Win513--
        EXIT(0);
    END;

    //81 new code not found
    //cu86

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnCheckInProgressOpportunitiesOnBeforeRunCloseOpportunityPage', '', true, true)]
    local procedure OnCheckInProgressOpportunitiesOnBeforeRunCloseOpportunityPage(Opp: Record Opportunity; var IsHandled: Boolean; var SalesHeader: Record "Sales Header"; var TempOpportunityEntry: Record "Opportunity Entry")
    var
        CustCheckCreditLimit: Codeunit 312;
        HideValidationDialog: Boolean;
        SalesOrderHeader: Record 36;
    begin
        IF GUIALLOWED AND NOT HideValidationDialog THEN
            CustCheckCreditLimit.SalesHeaderCheck(SalesOrderHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterOnRun', '', true, true)]
    local procedure OnAfterOnRun(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        SalesLine: Record 37;
        ItemCheckAvail: Codeunit 311;
        CustCheckCreditLimit: Codeunit 312;

    begin
        CLEAR(CustCheckCreditLimit);
        CLEAR(ItemCheckAvail);
    end;

    local procedure CheckAvailability(SalesQuoteHeader: Record 36)
    var
        myInt: Integer;
        SalesQuoteLine: Record 37;
        SalesLine: Record 37;
        HideValidationDialog: Boolean;
        ItemCheckAvail: Codeunit 311;

    begin
        SalesQuoteLine.SETRANGE("Document Type", SalesQuoteHeader."Document Type");
        SalesQuoteLine.SETRANGE("Document No.", SalesQuoteHeader."No.");
        SalesQuoteLine.SETRANGE(Type, SalesQuoteLine.Type::Item);
        SalesQuoteLine.SETFILTER("No.", '<>%1', '');
        IF SalesQuoteLine.FINDSET THEN
            REPEAT
                IF SalesQuoteLine."Outstanding Quantity" > 0 THEN BEGIN
                    SalesLine := SalesQuoteLine;
                    SalesLine.VALIDATE("Reserved Qty. (Base)", 0);
                    SalesLine."Outstanding Quantity" -= SalesLine."Qty. to Assemble to Order";
                    SalesLine."Outstanding Qty. (Base)" -= SalesLine."Qty. to Asm. to Order (Base)";
                    IF GUIALLOWED AND NOT HideValidationDialog THEN
                        IF ItemCheckAvail.SalesLineCheck(SalesLine) THEN
                            ItemCheckAvail.RaiseUpdateInterruptedError;
                END;
            UNTIL SalesQuoteLine.NEXT = 0;
    end;
    //Cu90

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnBeforeMakeInventoryAdjustment', '', true, true)]
    local procedure OnRunOnBeforeMakeInventoryAdjustmentcodeunit(var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var PurchaseHeader: Record "Purchase Header")
    var
        GenJnlPostPreview: Codeunit 19;
    begin
        IF PreviewMode THEN BEGIN
            Window.CLOSE;
            GenJnlPostPreview.ThrowError;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeUpdatePostingNos', '', true, true)]
    local procedure OnBeforeUpdatePostingNos(SuppressCommit: Boolean; var IsHandled: Boolean; var ModifyHeader: Boolean; var NoSeriesMgt: Codeunit NoSeriesManagement; var PurchHeader: Record "Purchase Header")
    var
        IsCreditDocType: Boolean;
        PurchSetup: Record 312;
    begin
        IF PurchHeader.Ship AND (PurchHeader."Return Shipment No." = '') THEN
            IF IsCreditDocType AND PurchSetup."Return Shipment on Credit Memo" THEN BEGIN
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnGetItemChargeLineOnAfterGet', '', true, true)]
    local procedure OnGetItemChargeLineOnAfterGet(PurchHeader: Record "Purchase Header"; var ItemChargePurchLine: Record "Purchase Line")
    begin
        IF ABS(ItemChargePurchLine."Qty. to Invoice") >
                ABS(ItemChargePurchLine."Quantity Received" + ItemChargePurchLine."Qty. to Receive" +
                  ItemChargePurchLine."Return Qty. Shipped" + ItemChargePurchLine."Return Qty. to Ship" -
                  ItemChargePurchLine."Quantity Invoiced")
             THEN
            ItemChargePurchLine."Qty. to Invoice" :=
              ItemChargePurchLine."Quantity Received" + ItemChargePurchLine."Qty. to Receive" +
              ItemChargePurchLine."Return Qty. Shipped (Base)" + ItemChargePurchLine."Return Qty. to Ship (Base)" -
              ItemChargePurchLine."Quantity Invoiced";
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostItemTrackingCheckReceipt', '', true, true)]
    local procedure OnBeforePostItemTrackingCheckReceipt(PurchaseLine: Record "Purchase Line"; RemQtyToBeInvoiced: Decimal; var IsHandled: Boolean)
    var
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
        ReturnShptLine: Record 6651;
        TrackingSpecificationExists: Boolean;
        TempTrackingSpecification: Record 336 TEMPORARY;
        ReturnShipmentSamesSignErr: Label 'ENU=must have the same sign as the return shipment;ENA=must have the same sign as the return shipment';
    begin
        IF PurchaseLine."Qty. to Invoice" * ReturnShptLine.Quantity > 0 THEN
            PurchaseLine.FIELDERROR("Qty. to Invoice", ReturnShipmentSamesSignErr);
        IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
            QtyToBeInvoiced := TempTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := TempTrackingSpecification."Qty. to Invoice (Base)";
        END ELSE BEGIN
            QtyToBeInvoiced := RemQtyToBeInvoiced - PurchaseLine."Return Qty. to Ship";
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchaseLine."Return Qty. to Ship (Base)";
        END;
        IF ABS(QtyToBeInvoiced) >
           ABS(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced")
        THEN BEGIN
            QtyToBeInvoiced := ReturnShptLine."Quantity Invoiced" - ReturnShptLine.Quantity;
            QtyToBeInvoicedBase := ReturnShptLine."Qty. Invoiced (Base)" - ReturnShptLine."Quantity (Base)";
        END;
    end;

    //CU96 code not found
    //Cu134

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Import Attachment - Inc. Doc.", 'OnAfterImportAttachment', '', true, true)]
    local procedure OnAfterImportAttachment(var IncomingDocumentAttachment: Record "Incoming Document Attachment")
    var
        CalledFromExpense: Boolean;
        ExpenseLineNo: Integer;
        IncomingDocument: Record 130;
    begin
        //win start
        IF CalledFromExpense = FALSE THEN
            IncomingDocumentAttachment."Line No." := GetIncomingDocumentNextLineNo(IncomingDocument)
        ELSE
            IncomingDocumentAttachment."Line No." := ExpenseLineNo;
        //win end
    end;

    local procedure NextExpenseLine(VAR Lineno: Integer);
    var
        myInt: Integer;
        CalledFromExpense: Boolean;
        ExpenseLineNo: Integer;
    begin
        //win start
        CalledFromExpense := TRUE;
        ExpenseLineNo := Lineno;
        //win end
    end;

    //std local procedure add

    PROCEDURE GetIncomingDocumentNextLineNo(IncomingDocument: Record 130): Integer;
    VAR
        IncomingDocumentAttachment: Record 133;
    BEGIN
        //Win513++
        // WITH IncomingDocumentAttachment DO BEGIN
        //     SETRANGE("Incoming Document Entry No.", IncomingDocument."Entry No.");
        //     IF FINDLAST THEN;
        //     EXIT("Line No." + LineIncrement);
        // END;
        IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.", IncomingDocument."Entry No.");
        IF IncomingDocumentAttachment.FINDLAST THEN;
        EXIT(IncomingDocumentAttachment."Line No." + LineIncrement);
        //Win513--
    END;

    PROCEDURE LineIncrement(): Integer;
    BEGIN
        EXIT(10000);
    END;
    //cu179 modified code not found
    //cu225 code available in bc
    //CU228 

    //Win513++
    // local procedure PrintEmplJnlBatch(EmplJnlBatch: Record "Employee Journal Batch")
    // var
    //     //EmplJnlBatch: record "Employee Journal Batch";
    //     EmplJnlTemplate: Record "Employee Journal Template";
    // begin
    //     BEGIN
    //         EmplJnlBatch.SETRECFILTER;
    //         EmplJnlTemplate.GET(EmplJnlBatch."Journal Template Name");
    //         EmplJnlTemplate.TESTFIELD(EmplJnlTemplate."Test Report ID");
    //         REPORT.RUN(EmplJnlTemplate."Test Report ID", TRUE, FALSE, EmplJnlBatch);
    //     END;
    // end;

    // local procedure PrintEmplJnlLine(VAR NewEmplJnlLine: Record "Employee Journal Line")
    // var
    //     EmplJnlLine: Record "Employee Journal Line";
    //     EmplJnlTemplate: Record "Employee Journal Template";
    // begin
    //     EmplJnlLine.COPY(NewEmplJnlLine);
    //     EmplJnlLine.SETRANGE("Journal Template Name", EmplJnlLine."Journal Template Name");
    //     EmplJnlLine.SETRANGE("Journal Batch Name", EmplJnlLine."Journal Batch Name");
    //     EmplJnlTemplate.GET(EmplJnlLine."Journal Template Name");
    //     EmplJnlTemplate.TESTFIELD(EmplJnlTemplate."Test Report ID");
    //     REPORT.RUN(EmplJnlTemplate."Test Report ID", TRUE, FALSE, EmplJnlLine);
    // end;
    //Win513--

    local procedure PrintEmpAnalysisSheet(NewEmployee: Record 5200)
    var
        EmployeeAnalysis: Record 5200;
    begin
        EmployeeAnalysis := NewEmployee;
        EmployeeAnalysis.SETRECFILTER;
        //PrintReport(ReportSelection.Usage::"S.Test");
    end;
    /* 
        local procedure PrintSalaryDisbursment(VAR NewSalDisb: Record "Salary Disbursement Header")
        var

        begin
            SalHeader := NewSalDisb;
            SalHeader.SETRECFILTER;
            PrintReport(ReportSelection.Usage::"90");
        end;

        local procedure PrintEmployeeSettlement()
        var

        begin
            FnFHeader := NewEmpSettlement;
              FnFHeader.SETRECFILTER;
              PrintReport(ReportSelection.Usage::EmployeeSettlement);//NAV code commented
        end;
        */

    local procedure PrintReport(ReportUsage: Integer)
    var
        ReportSelection: Record 77;
        SalesHeader: Record 36;
        PurchHeader: Record 38;
        BankAccRecon: Record 273;
        ServiceHeader: Record 5900;
        InvtPeriod: Record 5814;
    //WIN502 SalHeader:Record "Salary Disbursement Header";

    begin
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportUsage);
        ReportSelection.FIND('-');
        REPEAT
            ReportSelection.TESTFIELD("Report ID");
            CASE ReportUsage OF
                //Win513++
                //     ReportSelection.Usage::"S.Test Prepmt.",
                //   ReportSelection.Usage::"S.Test":
                //         REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, SalesHeader);
                //     ReportSelection.Usage::"P.Test Prepmt.",
                //   ReportSelection.Usage::"P.Test":
                //         REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, PurchHeader);
                //     ReportSelection.Usage::"B.Recon.Test":
                //         REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, BankAccRecon);
                //     ReportSelection.Usage::"SM.Test":
                //         REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, ServiceHeader);
                ReportSelection.Usage::"S.Test Prepmt.".AsInteger(),
              ReportSelection.Usage::"S.Test".AsInteger():
                    REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, SalesHeader);
                ReportSelection.Usage::"P.Test Prepmt.".AsInteger(),
              ReportSelection.Usage::"P.Test".AsInteger():
                    REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, PurchHeader);
                ReportSelection.Usage::"B.Recon.Test".AsInteger():
                    REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, BankAccRecon);
                ReportSelection.Usage::"SM.Test".AsInteger():
                    REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, ServiceHeader);
            //Win513--
            /* ReportSelection.Usage::"Invt. Period Test":
                 REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, InvtPeriod);
          ReportSelection.Usage::"90":
              REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, SalHeader);
          ReportSelection.Usage::"91":
              REPORT.RUN(ReportSelection."Report ID", TRUE, FALSE, StatEmployee); *///Win502
            END;
        UNTIL ReportSelection.NEXT = 0;
    END;
    /*
        local procedure PrintPayrollJnlLine(VAR NewGenJnlLine: Record "Payroll Journal Line")
        var
            myInt: Integer;
        begin
            PayJnlLine.COPY(NewGenJnlLine);
            PayJnlLine.SETRANGE("Journal Template Name", PayJnlLine."Journal Template Name");
            PayJnlLine.SETRANGE("Journal Batch Name", PayJnlLine."Journal Batch Name");
            PayrollJnlTemplate.GET(PayJnlLine."Journal Template Name");
            PayrollJnlTemplate.TESTFIELD("Test Report ID");
            REPORT.RUN(PayrollJnlTemplate."Test Report ID", TRUE, FALSE, PayJnlLine);
        END;

        local procedure PrintSalaryHeader(VAR NewSalHeader: Record "Salary Disbursement Header")
        var
            SalHeader: Record "Salary Disbursement Header";
        begin
            SalHeader := NewSalHeader;
            SalHeader.SETRECFILTER;
            PrintReport(ReportSelection.Usage::"94");

            /*
            {
              PurchHeader := NewPurchHeader;
              PurchHeader.SETRECFILTER;
              CalcPurchDisc(PurchHeader);
              ReportSelection.PrintWithCheck(ReportSelection.Usage::"P.Test",PurchHeader,'');


        end;
        */

    //CU229 
    //modify  code not found

    //CU378

    /*
        local procedure PayrollCheckIfAnyExtText(VAR PayrollLine: Record "Salary Disbursement Lines"; Unconditionally: Boolean): Boolean;
        var
            PayrollHeader: Record "Salary Disbursement Header";
            ExtTextHeader: Record 279;
        begin
            MakeUpdateRequired := FALSE;
            IF IsDeleteAttachedLines(PayrollLine."Line No.", PayrollLine."Payroll Parameter", PayrollLine."Attached to Line No.") THEN
                MakeUpdateRequired := DeletePayrollLines(PayrollLine);

            AutoText := FALSE;

            IF Unconditionally THEN
                AutoText := TRUE
            ELSE
                CASE PayrollLine.Type OF
                    PayrollLine.Type::" ":
                        AutoText := TRUE;
                /*{
                PayrollLine.Type::"G/L Account":
                  BEGIN
                    IF GLAcc.GET(PayrollLine."No.") THEN
                      AutoText := GLAcc."Automatic Ext. Texts";
                  END;
                PayrollLine.Type::Item:
                  BEGIN
                    IF Item.GET(PayrollLine."No.") THEN
                      AutoText := Item."Automatic Ext. Texts";
                  END;
                  }
                END;

            IF AutoText THEN BEGIN
                PayrollLine.TESTFIELD("Document No.");
                PayrollHeader.GET(PayrollLine."Document Type", PayrollLine."Document No.");
                ExtTextHeader.SETRANGE("Table Name", PayrollLine.Type);
                ExtTextHeader.SETRANGE("No.", PayrollLine."Document No.");
                CASE PayrollLine."Document Type" OF
                    PayrollLine."Document Type"::Payroll:
                        BEGIN
                            //ExtTextHeader.SETRANGE("Purchase Quote",TRUE);
                        END;
                END;
                EXIT(ReadLines(ExtTextHeader, PayrollHeader."Document Date", PayrollHeader."Language Code"));
            END;
        end;

        local procedure DeletePayrollLines()
        var
            PayrollLine2: Record "Salary Disbursement Lines";
        begin
            PayrollLine2.SETRANGE("Document Type", PayrollLine."Document Type");
            PayrollLine2.SETRANGE("Document No.", PayrollLine."Document No.");
            PayrollLine2.SETRANGE("Attached to Line No.", PayrollLine."Line No.");
            PayrollLine2 := PayrollLine;
            IF PayrollLine2.FIND('>') THEN BEGIN
                REPEAT
                    PayrollLine2.DELETE(TRUE);
                UNTIL PayrollLine2.NEXT = 0;
                EXIT(TRUE);
            END;
        END;


        local procedure (VAR PayrollLine: Record "Payroll Transaction Line")
        var
            myInt: Integer;

        begin

        end;


        //pending
    */
    //CU408
    /*
        local procedure UpdatePayrollJnlLineDim(VAR GenJnlLine: Record "Payroll Journal Line"; DimSetID: Integer)
        var

        begin
            GenJnlLine."Dimension Set ID" := DimSetID;
            UpdateGlobalDimFromDimSetID(
              GenJnlLine."Dimension Set ID",
              GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

        end;
        */

    local procedure UpdatePayrollJnlLineDimFromEmpLedgEntry(VAR GenJnlLine: Record 81; DtldVendLedgEntry: Record 380)
    var
        VendLedgEntry: Record 25;
    begin
        IF DtldVendLedgEntry."Vendor Ledger Entry No." <> 0 THEN BEGIN
            VendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");
            UpdateGenJnlLineDim(GenJnlLine, VendLedgEntry."Dimension Set ID");
        END;
    END;
    //std local proc add
    PROCEDURE UpdateGenJnlLineDim(VAR GenJnlLine: Record 81; DimSetID: Integer);
    BEGIN
        GenJnlLine."Dimension Set ID" := DimSetID;
        UpdateGlobalDimFromDimSetID(
          GenJnlLine."Dimension Set ID",
          GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
    END;

    PROCEDURE UpdateGlobalDimFromDimSetID(DimSetID: Integer; VAR GlobalDimVal1: Code[20]; VAR GlobalDimVal2: Code[20]);
    var
        GLSetupShortcutDimCode: ARRAY[8] OF Code[20];
        DimSetEntry: Record 480;
    BEGIN
        GetGLSetup;
        GlobalDimVal1 := '';
        GlobalDimVal2 := '';
        IF GLSetupShortcutDimCode[1] <> '' THEN
            IF DimSetEntry.GET(DimSetID, GLSetupShortcutDimCode[1]) THEN
                GlobalDimVal1 := DimSetEntry."Dimension Value Code";
        IF GLSetupShortcutDimCode[2] <> '' THEN
            IF DimSetEntry.GET(DimSetID, GLSetupShortcutDimCode[2]) THEN
                GlobalDimVal2 := DimSetEntry."Dimension Value Code";
    END;

    PROCEDURE GetGLSetup();
    VAR
        GLSetup: Record 98;
        GLSetupShortcutDimCode: ARRAY[8] OF Code[20];
        HasGotGLSetup: Boolean;
    BEGIN
        IF NOT HasGotGLSetup THEN BEGIN
            GLSetup.GET;
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            HasGotGLSetup := TRUE;
        END;
    END;

    //CU414

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseATOs', '', true, true)]
    local procedure OnAfterReleaseATOs(PreviewMode: Boolean; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        VATAmountLine: Record 290;
        TempVATAmountLine0: Record 290 TEMPORARY;
        TempVATAmountLine1: Record 290 TEMPORARY;
        LinesWereModified: Boolean;
    begin
        SalesLine.SetSalesHeader(SalesHeader);
        SalesLine.CalcVATAmountLines(0, SalesHeader, SalesLine, TempVATAmountLine0);
        SalesLine.CalcVATAmountLines(1, SalesHeader, SalesLine, TempVATAmountLine1);
        LinesWereModified := LinesWereModified OR
          SalesLine.UpdateVATOnLines(0, SalesHeader, SalesLine, TempVATAmountLine0) OR
          SalesLine.UpdateVATOnLines(1, SalesHeader, SalesLine, TempVATAmountLine1);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseATOs', '', true, true)]
    local procedure OnAfterReleaseATOsReleasesalesdoc()
    var
        ServItem: Record 5940;
        SalesHeader: Record 36;
    begin
        //WIN325
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN BEGIN
            IF ServItem.GET(SalesHeader."Service Item No.") THEN BEGIN
                ServItem.VALIDATE("Customer No.", SalesHeader."Sell-to Customer No.");
                ServItem.VALIDATE("Ship-to Code", SalesHeader."Ship-to Code");
                ServItem."Sales Order No." := SalesHeader."No.";
                ServItem.MODIFY;
            END;
        END;
        //WIN325

    end;

    //CU415

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnBeforeModifyHeader', '', true, true)]
    local procedure OnCodeOnBeforeModifyHeader(PreviewMode: Boolean; var LinesWereModified: Boolean; var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        TempVATAmountLine0: Record 290 TEMPORARY;
        TempVATAmountLine1: Record 290 TEMPORARY;
    begin
        PurchaseLine.SetPurchHeader(PurchaseHeader);
        PurchaseLine.CalcVATAmountLines(0, PurchaseHeader, PurchaseLine, TempVATAmountLine0);
        PurchaseLine.CalcVATAmountLines(1, PurchaseHeader, PurchaseLine, TempVATAmountLine1);
        LinesWereModified := LinesWereModified OR
          PurchaseLine.UpdateVATOnLines(0, PurchaseHeader, PurchaseLine, TempVATAmountLine0) OR
          PurchaseLine.UpdateVATOnLines(1, PurchaseHeader, PurchaseLine, TempVATAmountLine1);
        //modify(true);

    end;


    local procedure ReleaseServiceDocument(VAR ServiceHeader: Record 5900)
    begin
        // S001
        //Win513++
        // WITH ServiceHeader DO BEGIN
        //     "Approval Status" := "Approval Status"::Released;
        //     MODIFY(TRUE);
        // END;
        ServiceHeader."Approval Status" := ServiceHeader."Approval Status"::Released;
        ServiceHeader.MODIFY(TRUE);
        //Win513--
    END;

    local procedure ReopenServicedocument(VAR ServiceHeader: Record 5900)
    var

    begin
        //S001
        //Win513++
        // WITH ServiceHeader DO BEGIN
        //     IF "Approval Status" = "Approval Status"::Open THEN
        //         EXIT;
        //     "Approval Status" := "Approval Status"::Open;
        //     MODIFY(TRUE);
        // END;
        IF ServiceHeader."Approval Status" = ServiceHeader."Approval Status"::Open THEN
            EXIT;
        ServiceHeader."Approval Status" := ServiceHeader."Approval Status"::Open;
        ServiceHeader.MODIFY(TRUE);
        //Win513--
    END;

    local procedure ReleaseServiceContractDocument(VAR ServiceContractHeader: Record 5965)
    var

    begin
        // S002
        //Win513++
        //  WITH ServiceContractHeader DO BEGIN
        //     "Approval Status" := "Approval Status"::Released;
        //     //"Change Status" := "Change Status"::Locked; //win315
        //     MODIFY(TRUE);
        // END;
        ServiceContractHeader."Approval Status" := ServiceContractHeader."Approval Status"::Released;
        //"Change Status" := "Change Status"::Locked; //win315
        ServiceContractHeader.MODIFY(TRUE);
        //Win513--
    end;

    local procedure ReopenServiceContractdocument(VAR ServiceContractHeader: Record 5965)
    var

    begin
        //S002
        //Win513++
        // WITH ServiceContractHeader DO BEGIN
        //     IF "Approval Status" = "Approval Status"::Open THEN
        //         EXIT;
        //     "Approval Status" := "Approval Status"::Open;
        //     "Change Status" := "Change Status"::Open; //win315
        //     MODIFY(TRUE);
        //     // S001 : Service order approval
        //     // S002 : Service Contract Approval
        // END;
        IF ServiceContractHeader."Approval Status" = ServiceContractHeader."Approval Status"::Open THEN
            EXIT;
        ServiceContractHeader."Approval Status" := ServiceContractHeader."Approval Status"::Open;
        ServiceContractHeader."Change Status" := ServiceContractHeader."Change Status"::Open; //win315
        ServiceContractHeader.MODIFY(TRUE);
        // S001 : Service order approval
        // S002 : Service Contract Approval
        //Win513--
    end;

    //cu700



}