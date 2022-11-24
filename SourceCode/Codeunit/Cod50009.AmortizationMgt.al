Codeunit 50009 "AmortizationMgt"
{
    // WINPDC : Added code on function POSTJOURNAL for posting Cash entries.

    Permissions = TableData "Cust. Ledger Entry" = rim,
                  TableData "Vendor Ledger Entry" = rim;

    trigger OnRun()
    begin
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        TemplateNameG: Code[10];
        BatchNameG: Code[10];
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        AmortizationEntry: Record "Amortization Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        CreateVendorPmtSuggestion: Report "Suggest Vendor Payments";
        Text1500000: label '%1 %2 %3 lines created.';
        Text1500001: label 'Journal Template %1, Batch Name %2, Line Number %3 was not a Post Dated Check Entry.';
        Text1500002: label 'Are you sure you want to cancel the post dated check?';
        Text1500003: label 'Cancelled from Cash Receipt Journal.';
        Text1500004: label 'Cancelled from Payment Journal.';
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        Text1500005: label 'Account Type shall be vendor';
        DocPrint: Codeunit "Document-Print";
        Text1500006: label 'Void Check %1?';
        CheckManagement: Codeunit CheckManagement;
        LineNumber: Integer;
        CheckCount: Integer;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Text1500007: label '%1 %2 %3 lines created and Posted Successfully';


    procedure Post(var AmortizationEntry: Record "Amortization Entry")
    begin
        AmortizationEntry.FindFirst;
        CheckCount := AmortizationEntry.Count;
        repeat
            GenJnlLine.Reset;
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
                SalesSetup.Get;
                SalesSetup.TestField("Post Dated Check Template");
                SalesSetup.TestField("Post Dated Check Batch");
                GenJnlLine.SetRange("Journal Template Name", SalesSetup."Post Dated Check Template");
                if AmortizationEntry."Batch Name" <> '' then
                    GenJnlLine.SetRange("Journal Batch Name", AmortizationEntry."Batch Name")
                else
                    GenJnlLine.SetRange("Journal Batch Name", SalesSetup."Post Dated Check Batch");
            end else
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then begin
                    PurchSetup.Get;
                    PurchSetup.TestField("Post Dated Check Template");
                    PurchSetup.TestField("Post Dated Check Batch");
                    GenJnlLine.SetRange("Journal Template Name", PurchSetup."Post Dated Check Template");
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", AmortizationEntry."Batch Name")
                    else
                        GenJnlLine.SetRange("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                end;

            if GenJnlLine.FindLast then begin
                LineNumber := GenJnlLine."Line No.";
                GenJnlLine2 := GenJnlLine;
            end else
                LineNumber := 0;
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
                GenJnlManagement.OpenJnl(SalesSetup."Post Dated Check Batch", GenJnlLine);
                Commit;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := SalesSetup."Post Dated Check Template";
                if AmortizationEntry."Batch Name" <> '' then
                    GenJnlLine.Validate("Journal Batch Name", AmortizationEntry."Batch Name")
                else
                    GenJnlLine.Validate("Journal Batch Name", SalesSetup."Post Dated Check Batch");
            end else
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then begin
                    GenJnlManagement.OpenJnl(PurchSetup."Post Dated Check Batch", GenJnlLine);
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := PurchSetup."Post Dated Check Template";
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", AmortizationEntry."Batch Name")
                    else
                        GenJnlLine.Validate("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                end;
            GenJnlLine."Line No." := LineNumber + 10000;
            GenJnlLine.SetUpNewLine(GenJnlLine2, 0, true);
            GenJnlLine.Validate("Posting Date", AmortizationEntry."Check Date");
            GenJnlLine.Validate("Document Date", AmortizationEntry."Check Date");
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Customer);
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Vendor);
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::"G/L Account" then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
            GenJnlLine.Validate("Account No.", AmortizationEntry."Account No.");
            if AmortizationEntry."Check Cancelled Befoe Posting" = true then
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::" ")
            else
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::Payment);
            GenJnlLine."Interest Amount" := Round(AmortizationEntry."Interest Amount");
            GenJnlLine."Interest Amount (LCY)" := Round(AmortizationEntry."Interest Amount (LCY)");
            GenJnlLine."Applies-to Doc. Type" := AmortizationEntry."Applies-to Doc. Type";
            GenJnlLine."Applies-to Doc. No." := AmortizationEntry."Applies-to Doc. No.";
            if (AmortizationEntry."Document No." <> '') or AmortizationEntry."Check Printed" then
                GenJnlLine."Document No." := AmortizationEntry."Document No.";
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
                if AmortizationEntry."Applies-to ID" <> '' then begin
                    CustLedgEntry.SetRange("Applies-to ID", AmortizationEntry."Applies-to ID");
                    if CustLedgEntry.FindSet then
                        repeat
                            CustLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                            CustLedgEntry.Modify;
                        until CustLedgEntry.Next = 0;
                    GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                end;
            end
            else
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then begin
                    if AmortizationEntry."Applies-to ID" <> '' then begin
                        VendLedgEntry.SetRange("Applies-to ID", AmortizationEntry."Applies-to ID");
                        if VendLedgEntry.FindSet then
                            repeat
                                VendLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                                VendLedgEntry.Modify;
                            until VendLedgEntry.Next = 0;
                        GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                    end;
                end;

            GenJnlLine.Validate("Currency Code", AmortizationEntry."Currency Code");
            GenJnlLine.Validate(Amount, AmortizationEntry.Amount);
            GenJnlLine."Check No." := AmortizationEntry."Check No.";
            GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then
                if AmortizationEntry."Bank Account" <> '' then
                    GenJnlLine.Validate("Bal. Account No.", AmortizationEntry."Bank Account");
            GenJnlLine."Bank Payment Type" := AmortizationEntry."Bank Payment Type";
            GenJnlLine."Check Printed" := AmortizationEntry."Check Printed";
            GenJnlLine."Post Dated Check" := true;
            GenJnlLine.Insert(true);
            GenJnlLine2 := GenJnlLine;
        until AmortizationEntry.Next = 0;

        //AmortizationEntry.DELETEALL;


        case GenJnlLine."Account Type" of
            GenJnlLine."account type"::Customer:
                begin
                    if CheckCount > 0 then
                        Message(Text1500000, CheckCount, SalesSetup."Post Dated Check Template",
                          SalesSetup."Post Dated Check Batch")
                end;
            GenJnlLine."account type"::Vendor:
                begin
                    if CheckCount > 0 then
                        Message(Text1500000, CheckCount, PurchSetup."Post Dated Check Template",
                          PurchSetup."Post Dated Check Batch")
                end;
        end;
    end;


    procedure CancelCheck(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if not GenJnlLine."Post Dated Check" then
            Error(Text1500001, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
        if not Confirm(Text1500002, false) then
            exit;
        AmortizationEntry.Reset;
        AmortizationEntry.SetCurrentkey("Line Number");
        if AmortizationEntry.FindLast then
            LineNumber := AmortizationEntry."Line Number"
        else
            LineNumber := 0;
        case GenJnlLine."Account Type" of
            GenJnlLine."account type"::"G/L Account":
                AmortizationEntry.SetRange("Account Type", AmortizationEntry."account type"::"G/L Account");
            GenJnlLine."account type"::Customer:
                AmortizationEntry.SetRange("Account Type", AmortizationEntry."account type"::Customer);
            GenJnlLine."account type"::Vendor:
                AmortizationEntry.SetRange("Account Type", AmortizationEntry."account type"::Vendor);
        end;

        AmortizationEntry.Init;
        case GenJnlLine."Account Type" of
            GenJnlLine."account type"::"G/L Account":
                AmortizationEntry.Validate("Account Type", AmortizationEntry."account type"::"G/L Account");
            GenJnlLine."account type"::Customer:
                AmortizationEntry.Validate("Account Type", AmortizationEntry."account type"::Customer);
            GenJnlLine."account type"::Vendor:
                AmortizationEntry.Validate("Account Type", AmortizationEntry."account type"::Vendor);
        end;
        AmortizationEntry.Validate("Batch Name", GenJnlLine."Journal Batch Name");
        AmortizationEntry.Validate("Account No.", GenJnlLine."Account No.");
        AmortizationEntry."Check Date" := GenJnlLine."Document Date";
        AmortizationEntry."Line Number" := LineNumber + 10000;
        AmortizationEntry.Validate("Currency Code", GenJnlLine."Currency Code");
        AmortizationEntry."Date Received" := WorkDate;
        AmortizationEntry."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        AmortizationEntry."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        AmortizationEntry.Validate(Amount, GenJnlLine.Amount);
        AmortizationEntry."Check No." := GenJnlLine."Check No.";
        AmortizationEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type";
        AmortizationEntry."Check Printed" := GenJnlLine."Check Printed";
        AmortizationEntry."Interest Amount" := Round(GenJnlLine."Interest Amount");
        AmortizationEntry."Interest Amount (LCY)" := Round(GenJnlLine."Interest Amount (LCY)");
        AmortizationEntry."Dimension Set ID" := GenJnlLine."Dimension Set ID";
        AmortizationEntry."Document No." := GenJnlLine."Document No.";
        AmortizationEntry."Bank Account" := GenJnlLine."Bal. Account No.";
        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then begin
            if GenJnlLine."Applies-to ID" <> '' then begin
                CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                if CustLedgEntry.FindSet then
                    repeat
                        CustLedgEntry."Applies-to ID" := AmortizationEntry."Document No.";
                        CustLedgEntry.Modify;
                    until CustLedgEntry.Next = 0;
                AmortizationEntry."Applies-to ID" := AmortizationEntry."Document No.";
            end;
        end else
            if GenJnlLine."Account Type" = GenJnlLine."account type"::Vendor then begin
                if GenJnlLine."Applies-to ID" <> '' then begin
                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                    if VendLedgEntry.FindSet then
                        repeat
                            VendLedgEntry."Applies-to ID" := AmortizationEntry."Document No.";
                            VendLedgEntry.Modify;
                        until VendLedgEntry.Next = 0;
                    AmortizationEntry."Applies-to ID" := AmortizationEntry."Document No.";
                end;
            end;
        if GenJnlLine."Check Printed" then begin
            AmortizationEntry."Bank Account" := GenJnlLine."Bal. Account No.";
            AmortizationEntry."Document No." := GenJnlLine."Document No.";
        end;

        if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then
            AmortizationEntry.Comment := Text1500003
        else
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then
                AmortizationEntry.Comment := Text1500004;

        AmortizationEntry.Insert;
        if GenJnlLine.Find then
            GenJnlLine.Delete;
    end;


    procedure CopySuggestedVendorPayments()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetFilter("Account No.", '<>%1', '');
        if GenJnlLine.FindSet then begin
            repeat
                AmortizationEntry.Reset;
                AmortizationEntry.SetRange("Account Type", GenJnlLine."account type"::Vendor);
                AmortizationEntry.SetRange("Account No.", GenJnlLine."Account No.");
                AmortizationEntry.SetRange("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type");
                AmortizationEntry.SetRange("Applies-to Doc. No.", GenJnlLine."Applies-to Doc. No.");
                if not AmortizationEntry.FindFirst then begin
                    AmortizationEntry.Reset;
                    case GenJnlLine."Account Type" of
                        GenJnlLine."account type"::"G/L Account":
                            AmortizationEntry.SetRange("Account Type", AmortizationEntry."account type"::"G/L Account");
                        GenJnlLine."account type"::Customer:
                            AmortizationEntry.SetRange("Account Type", AmortizationEntry."account type"::Customer);
                        GenJnlLine."account type"::Vendor:
                            AmortizationEntry.SetRange("Account Type", AmortizationEntry."account type"::Vendor);
                    end;
                    AmortizationEntry.SetRange("Account No.", GenJnlLine."Account No.");
                    if AmortizationEntry.FindLast then
                        LineNumber := AmortizationEntry."Line Number" + 10000
                    else
                        LineNumber := 10000;

                    AmortizationEntry.Init;
                    case GenJnlLine."Account Type" of
                        GenJnlLine."account type"::"G/L Account":
                            AmortizationEntry.Validate("Account Type", AmortizationEntry."account type"::"G/L Account");
                        GenJnlLine."account type"::Customer:
                            AmortizationEntry.Validate("Account Type", AmortizationEntry."account type"::Customer);
                        GenJnlLine."account type"::Vendor:
                            AmortizationEntry.Validate("Account Type", AmortizationEntry."account type"::Vendor);
                    end;
                    AmortizationEntry.Validate("Account No.", GenJnlLine."Account No.");
                    AmortizationEntry."Check Date" := GenJnlLine."Document Date";
                    AmortizationEntry."Document No." := GenJnlLine."Document No.";
                    AmortizationEntry."Line Number" := LineNumber;
                    AmortizationEntry.Validate("Currency Code", GenJnlLine."Currency Code");
                    AmortizationEntry."Date Received" := WorkDate;
                    AmortizationEntry."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
                    AmortizationEntry."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
                    AmortizationEntry."Applies-to ID" := GenJnlLine."Applies-to ID";
                    AmortizationEntry.Validate(Amount, GenJnlLine.Amount);
                    AmortizationEntry."Check No." := GenJnlLine."Check No.";
                    AmortizationEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                    if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::"Bank Account" then
                        AmortizationEntry."Bank Account" := GenJnlLine."Bal. Account No.";
                    AmortizationEntry."Interest Amount" := Round(GenJnlLine."Interest Amount");
                    AmortizationEntry."Interest Amount (LCY)" := Round(GenJnlLine."Interest Amount (LCY)");
                    AmortizationEntry."Check Printed" := GenJnlLine."Check Printed";
                    AmortizationEntry.Insert;
                end;
            until GenJnlLine.Next = 0;
            GenJnlLine.DeleteAll;
        end;
    end;


    procedure AssignGenJnlLine(var AmortizationEntry: Record "Amortization Entry")
    begin
        //Win513++
        //with AmortizationEntry do begin
        //Win513--
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then
            GenJnlLine.DeleteAll;
        GenJnlLine."Line No." := AmortizationEntry."Line Number";
        GenJnlLine."Journal Template Name" := GLSetup."Post Dated Journal Template";
        GenJnlLine."Journal Batch Name" := GLSetup."Post Dated Journal Batch";
        GenJnlLine."Account No." := AmortizationEntry."Account No.";
        GenJnlLine."Posting Date" := AmortizationEntry."Check Date";
        GenJnlLine."Document Date" := AmortizationEntry."Check Date";
        GenJnlLine."Document No." := AmortizationEntry."Document No.";
        GenJnlLine.Description := AmortizationEntry.Description;
        GenJnlLine.Validate("Currency Code", AmortizationEntry."Currency Code");
        if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
            GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
            GenJnlLine.Amount := AmortizationEntry.Amount;
            if AmortizationEntry."Currency Code" = '' then
                GenJnlLine."Amount (LCY)" := AmortizationEntry.Amount
            else
                GenJnlLine."Amount (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      AmortizationEntry."Date Received", AmortizationEntry."Currency Code",
                      AmortizationEntry.Amount, AmortizationEntry."Currency Factor"));
        end else
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::"G/L Account" then
                GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account"
            else begin
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then
                    GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;
                GenJnlLine.Validate(Amount, AmortizationEntry.Amount);
                GenJnlLine."Interest Amount" := Round(AmortizationEntry."Interest Amount");
                GenJnlLine."Interest Amount (LCY)" := Round(AmortizationEntry."Interest Amount (LCY)");
            end;

        GenJnlLine."Applies-to Doc. Type" := AmortizationEntry."Applies-to Doc. Type";
        GenJnlLine."Applies-to Doc. No." := AmortizationEntry."Applies-to Doc. No.";
        GenJnlLine."Applies-to ID" := AmortizationEntry."Applies-to ID";
        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Post Dated Check" := true;
        GenJnlLine."Check No." := AmortizationEntry."Check No.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := AmortizationEntry."Bank Account";
        GenJnlLine."Bank Payment Type" := AmortizationEntry."Bank Payment Type";
        GenJnlLine."Check Printed" := AmortizationEntry."Check Printed";
        //Win513++
        //end;
        //Win513--
    end;


    procedure ApplyEntries(var AmortizationEntry: Record "Amortization Entry")
    begin
        GenJnlLine.Init;
        AssignGenJnlLine(AmortizationEntry);
        GenJnlLine.Insert;
        Commit;
        GenJnlApply.Run(GenJnlLine);
        Clear(GenJnlApply);
        if GenJnlLine."Applies-to ID" = AmortizationEntry."Document No." then begin
            AmortizationEntry.Validate(Amount, GenJnlLine.Amount);
            AmortizationEntry.Validate("Applies-to ID", AmortizationEntry."Document No.");
            AmortizationEntry."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
            AmortizationEntry."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
            AmortizationEntry.Modify;
        end;
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then
            GenJnlLine.DeleteAll;
    end;


    procedure SuggestVendorPayments()
    begin
        GLSetup.Get;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := GLSetup."Post Dated Journal Template";
        GenJnlLine."Journal Batch Name" := GLSetup."Post Dated Journal Batch";
        CreateVendorPmtSuggestion.SetGenJnlLine(GenJnlLine);
        CreateVendorPmtSuggestion.RunModal;
        CopySuggestedVendorPayments;
        Clear(CreateVendorPmtSuggestion);
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        if GenJnlLine.FindFirst then
            GenJnlLine.DeleteAll;
    end;


    procedure PreviewCheck(var AmortizationEntry: Record "Amortization Entry")
    begin
        //Win513++
        //with AmortizationEntry do begin
        //Win513--
        if AmortizationEntry."Account Type" <> AmortizationEntry."account type"::Vendor then
            Error(Text1500005);
        GenJnlLine.Init;
        AssignGenJnlLine(AmortizationEntry);
        GenJnlLine.Insert;
        Commit;
        Page.RunModal(Page::"Check Preview", GenJnlLine);
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then
            GenJnlLine.DeleteAll;
        //Win513++
        //end;
        //Win513--
    end;


    procedure PrintCheck(var AmortizationEntry: Record "Amortization Entry")
    begin
        if AmortizationEntry."Account Type" <> AmortizationEntry."account type"::Vendor then
            Error(Text1500005);
        GenJnlLine.Init;
        AssignGenJnlLine(AmortizationEntry);
        GenJnlLine.Insert;
        Commit;
        DocPrint.PrintCheck(GenJnlLine);
        if GenJnlLine.FindFirst then begin
            AmortizationEntry."Check Printed" := GenJnlLine."Check Printed";
            AmortizationEntry."Check No." := GenJnlLine."Document No.";
            AmortizationEntry."Document No." := GenJnlLine."Document No.";
            AmortizationEntry.Modify;
            GenJnlLine.DeleteAll;
        end;
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then
            GenJnlLine.DeleteAll;
    end;


    procedure VoidCheck(var AmortizationEntry: Record "Amortization Entry")
    begin
        //Win513++
        //with AmortizationEntry do begin
        //Win513--
        if AmortizationEntry."Account Type" <> AmortizationEntry."account type"::Vendor then
            Error(Text1500000);
        AmortizationEntry.TestField("Bank Payment Type", "bank payment type"::"Computer Check");
        AmortizationEntry.TestField("Check Printed", true);
        GenJnlLine.Init;
        AssignGenJnlLine(AmortizationEntry);
        GenJnlLine.Insert;
        Commit;
        if Confirm(Text1500006, false, AmortizationEntry."Document No.") then
            CheckManagement.VoidCheck(GenJnlLine);
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then begin
            AmortizationEntry."Check Printed" := GenJnlLine."Check Printed";
            AmortizationEntry.Modify;
            GenJnlLine.DeleteAll;
        end;
        //Win513++
        //end;
        //Win513--
    end;

    local procedure "-----------------------"()
    begin
    end;


    procedure PostJournal(var AmortizationEntry: Record "Amortization Entry"; Post: Boolean)
    var
        RecGenJournalLine: Record "Gen. Journal Line";
        ServiceContractHeader: Record "Service Contract Header";
    begin
        //WIN325..BEGIN
        AmortizationEntry.SetRange(Status, AmortizationEntry.Status::Received); //WIN325
        AmortizationEntry.FindFirst;
        CheckCount := AmortizationEntry.Count;
        repeat
            GenJnlLine.Reset;
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
                SalesSetup.Get;
                SalesSetup.TestField("Post Dated Check Template");
                // WINPDC
                if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then
                    SalesSetup.TestField("PDC Batch For Cash")
                // WINPDC
                else
                    SalesSetup.TestField("Post Dated Check Batch");
                GenJnlLine.SetRange("Journal Template Name", SalesSetup."Post Dated Check Template");
                if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then begin
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", AmortizationEntry."Batch Name")
                    else
                        GenJnlLine.SetRange("Journal Batch Name", SalesSetup."PDC Batch For Cash");
                end else begin
                    // WINPDC
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", AmortizationEntry."Batch Name")
                    else
                        GenJnlLine.SetRange("Journal Batch Name", SalesSetup."Post Dated Check Batch");
                end;
            end else
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then begin
                    PurchSetup.Get;
                    PurchSetup.TestField("Post Dated Check Template");
                    // WINPDC
                    if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then
                        PurchSetup.TestField("PDC Batch For Cash") //WINPDC
                    else
                        PurchSetup.TestField("Post Dated Check Batch");
                    GenJnlLine.SetRange("Journal Template Name", PurchSetup."Post Dated Check Template");
                    // WINPDC
                    if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then begin
                        if AmortizationEntry."Batch Name" <> '' then
                            GenJnlLine.SetRange("Journal Batch Name", AmortizationEntry."Batch Name")
                        else
                            GenJnlLine.SetRange("Journal Batch Name", PurchSetup."PDC Batch For Cash");
                    end else begin
                        // WINPDC
                        if AmortizationEntry."Batch Name" <> '' then
                            GenJnlLine.SetRange("Journal Batch Name", AmortizationEntry."Batch Name")
                        else
                            GenJnlLine.SetRange("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                    end;
                end;

            if GenJnlLine.FindLast then begin
                LineNumber := GenJnlLine."Line No.";
                GenJnlLine2 := GenJnlLine;
            end else
                LineNumber := 0;
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
                GenJnlManagement.OpenJnl(SalesSetup."Post Dated Check Batch", GenJnlLine);
                Commit;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := SalesSetup."Post Dated Check Template";
                // WINPDC
                if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then begin
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", AmortizationEntry."Batch Name")
                    else
                        GenJnlLine.Validate("Journal Batch Name", SalesSetup."PDC Batch For Cash");
                end else begin
                    // WINPDC
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", AmortizationEntry."Batch Name")
                    else
                        GenJnlLine.Validate("Journal Batch Name", SalesSetup."Post Dated Check Batch");
                end;
            end else
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then begin
                    GenJnlManagement.OpenJnl(PurchSetup."Post Dated Check Batch", GenJnlLine);
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := PurchSetup."Post Dated Check Template";
                    if AmortizationEntry."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", AmortizationEntry."Batch Name")
                    else begin
                        if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then // WINPDC
                            GenJnlLine.Validate("Journal Batch Name", PurchSetup."PDC Batch For Cash") // WINPDC
                        else
                            GenJnlLine.Validate("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                    end;
                end;
            GenJnlLine."Line No." := LineNumber + 10000;
            GenJnlLine.SetUpNewLine(GenJnlLine2, 0, true);
            if AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash then // WINPDC
                GenJnlLine.Validate("Posting Date", AmortizationEntry."Date Received")
            else
                GenJnlLine.Validate("Posting Date", AmortizationEntry."Check Date");
            GenJnlLine.Validate("Document Date", AmortizationEntry."Check Date");
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Customer);
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Vendor);
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::"G/L Account" then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
            GenJnlLine.Validate("Account No.", AmortizationEntry."Account No.");
            if AmortizationEntry."Check Cancelled Befoe Posting" = true then
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::" ")
            else
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::Payment);  //win315
                                                                                            //GenJnlLine.VALIDATE("Document Type",GenJnlLine."Document Type"::Payment);
            GenJnlLine."Interest Amount" := Round(AmortizationEntry."Interest Amount");
            GenJnlLine."Interest Amount (LCY)" := Round(AmortizationEntry."Interest Amount (LCY)");
            GenJnlLine."Applies-to Doc. Type" := AmortizationEntry."Applies-to Doc. Type";
            GenJnlLine."Applies-to Doc. No." := AmortizationEntry."Applies-to Doc. No.";
            if (AmortizationEntry."Document No." <> '') or AmortizationEntry."Check Printed" then
                GenJnlLine."Document No." := AmortizationEntry."Document No.";
            if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Customer then begin
                if AmortizationEntry."Applies-to ID" <> '' then begin
                    CustLedgEntry.SetRange("Applies-to ID", AmortizationEntry."Applies-to ID");
                    if CustLedgEntry.FindSet then
                        repeat
                            CustLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                            CustLedgEntry.Modify;
                        until CustLedgEntry.Next = 0;
                    GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                end;
            end
            else
                if AmortizationEntry."Account Type" = AmortizationEntry."account type"::Vendor then begin
                    if AmortizationEntry."Applies-to ID" <> '' then begin
                        VendLedgEntry.SetRange("Applies-to ID", AmortizationEntry."Applies-to ID");
                        if VendLedgEntry.FindSet then
                            repeat
                                VendLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                                VendLedgEntry.Modify;
                            until VendLedgEntry.Next = 0;
                        GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                    end;
                end;

            GenJnlLine.Validate("Currency Code", AmortizationEntry."Currency Code");
            GenJnlLine.Validate(Amount, AmortizationEntry.Amount);
            // WINPDC
            if ((AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::Cash) or (AmortizationEntry."Payment Method" = AmortizationEntry."payment method"::" ")) then begin //win315
                                                                                                                                                                                              //IF (AmortizationEntry."Payment Method" = AmortizationEntry."Payment Method"::Cash) THEN BEGIN
                GenJnlLine."Check No." := '';
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
            end else begin
                // WINPDC
                GenJnlLine."Check No." := AmortizationEntry."Check No.";
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";  //win315
                                                                                                   //GenJnlLine."Bal. Account Type" := AmortizationEntry."Bal. Account Type"; //win315
                                                                                                   //GenJnlLine.MODIFY;
            end;
            // IF AmortizationEntry."Account Type" = AmortizationEntry."Account Type"::Vendor THEN   //win315
            if AmortizationEntry."Bank Account" <> '' then
                GenJnlLine.Validate("Bal. Account No.", AmortizationEntry."Bank Account");
            GenJnlLine."Bank Payment Type" := AmortizationEntry."Bank Payment Type";
            GenJnlLine."Check Printed" := AmortizationEntry."Check Printed";
            GenJnlLine."Post Dated Check" := true;
            GenJnlLine."PDC Document No." := AmortizationEntry."Document No.";//WIN325
            GenJnlLine."PDC Line No." := AmortizationEntry."Line Number"; //WIN325
            GenJnlLine."Check Date" := AmortizationEntry."Check Date"; //win315
            GenJnlLine."Service Contract No." := AmortizationEntry."Contract No."; //win315
            GenJnlLine."Charge Code" := AmortizationEntry."Charge Code"; //win315
            GenJnlLine."Charge Description" := AmortizationEntry."Charge Description"; //win315
                                                                                       //GenJnlLine.ch
            if ServiceContractHeader.Get(ServiceContractHeader."contract type"::Contract, AmortizationEntry."Contract No.") then begin
                GenJnlLine.Validate("Shortcut Dimension 1 Code", ServiceContractHeader."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ServiceContractHeader."Shortcut Dimension 2 Code");
            end;
            GenJnlLine."Bal. VAT Base Amount (LCY)" := Round(GenJnlLine."VAT Base Amount (LCY)");
            GenJnlLine.Insert(true);

            GenJnlLine2 := GenJnlLine;
            if Post then begin
                GenJnlPostLine.RunWithCheck(GenJnlLine); //WIN325
                Commit;
                RecGenJournalLine.Reset;
                RecGenJournalLine.SetRange("Journal Batch Name", SalesSetup."Post Dated Check Batch");
                RecGenJournalLine.SetRange("Journal Template Name", SalesSetup."Post Dated Check Template");
                RecGenJournalLine.SetRange("PDC Document No.", AmortizationEntry."Document No.");
                RecGenJournalLine.SetRange("PDC Line No.", AmortizationEntry."Line Number");
                if RecGenJournalLine.FindSet then
                    RecGenJournalLine.DeleteAll;
            end;
            // WINPDC
            //IF AmortizationEntry."Payment Method" = AmortizationEntry."Payment Method"::Cash THEN
            //AmortizationEntry.Status := AmortizationEntry.Status::Received
            // WINPDC
            AmortizationEntry.Status := AmortizationEntry.Status::Deposited; //WIN325
            AmortizationEntry.Modify;//WIN325
        until AmortizationEntry.Next = 0;

        //AmortizationEntry.DELETEALL; //WIN325

        case GenJnlLine."Account Type" of
            GenJnlLine."account type"::Customer:
                begin
                    if CheckCount > 0 then
                        if not Post then
                            Message(Text1500000, CheckCount, SalesSetup."Post Dated Check Template",
                              SalesSetup."Post Dated Check Batch")
                        else
                            Message(Text1500007, CheckCount, SalesSetup."Post Dated Check Template",
                              SalesSetup."Post Dated Check Batch")
                end;
            GenJnlLine."account type"::Vendor:
                begin
                    if CheckCount > 0 then
                        if not Post then
                            Message(Text1500000, CheckCount, PurchSetup."Post Dated Check Template",
                              PurchSetup."Post Dated Check Batch")
                        else
                            Message(Text1500007, CheckCount, PurchSetup."Post Dated Check Template",
                              PurchSetup."Post Dated Check Batch")
                end;
        end;

        //CASE GenJnlLine."Account Type" OF
        /*GenJnlLine."Account Type"::"G/L Account":
          BEGIN
            //IF CheckCount > 0 THEN
              IF NOT Post THEN
                MESSAGE(Text1500000,CheckCount,SalesSetup."Post Dated Check Template",
                  SalesSetup."Post Dated Check Batch")
              ELSE
                MESSAGE(Text1500007,CheckCount,SalesSetup."Post Dated Check Template",
                  SalesSetup."Post Dated Check Batch")
          END;
        END;*/
        //WIN325..END

        Message('PDC Lines created and Posted Successfully.');    //win315

    end;

    procedure CreateCashJnlandPostEntries(var AmortizationEntry: Record "Amortization Entry"; Post: Boolean)
    //Win593++
    var
        RecGenJournal: Record "Gen. Journal Line";
        RecGenJournalLine: Record "Gen. Journal Line";
        RecGenTemp: Record "Gen. Journal Template";
        LineNo: Integer;
    begin
        //     AmortizationEntryL.Reset();
        //     AmortizationEntryL.SetRange("Document Type", AmortizationEntry."Document Type");
        //     AmortizationEntryL.SetRange("Document No.", AmortizationEntry."Document No.");
        //     AmortizationEntryL.SetRange(AmortizationEntryL.Status, AmortizationEntryL.Status::Received);
        //     if AmortizationEntryL.FindSet() then
        //         repeat
        RecGenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
        RecGenJournalLine.SetRange("Journal Batch Name", 'PDC');
        if RecGenJournalLine.FindLast() then
            LineNo := RecGenJournalLine."Line No.";

        RecGenJournal.Init();
        RecGenJournal."Line No." := LineNo + 10000;
        RecGenJournal."Journal Template Name" := 'CASH RECE';
        RecGenJournal."Journal Batch Name" := 'PDC';
        RecGenJournal."Posting Date" := AmortizationEntry."Check Date";
        RecGenJournal."Document No." := AmortizationEntry."Document No.";
        RecGenJournal."Account Type" := RecGenJournal."Account Type"::"Bank Account";
        RecGenJournal.Validate("Account No.", 'ADCB');
        RecGenJournal.validate("Debit Amount", Round(AmortizationEntry.Amount * -1));
        RecGenJournal."Bal. Account Type" := RecGenJournal."Bal. Account Type"::"G/L Account";
        RecGenJournal.Validate("Bal. Account No.", '2350');
        RecGenJournal.Insert();

        if post then begin
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            Commit;
        end;

        AmortizationEntry.Status := AmortizationEntry.Status::Deposited;
        AmortizationEntry.Modify;
        //until AmortizationEntryL.Next() = 0;
    end;
    //Win593--
}

