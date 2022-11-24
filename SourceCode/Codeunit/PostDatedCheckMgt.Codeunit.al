Codeunit 50006 PostDatedCheckMgt
{
    // WINPDC : Added code on function POSTJOURNAL for posting Cash entries.

    Permissions = TableData "Cust. Ledger Entry" = rim,
                  TableData "Vendor Ledger Entry" = rim;

    trigger OnRun()
    begin
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        PostDatedCheck: Record "Post Dated Check Line";
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


    procedure Post(var PostDatedCheck: Record "Post Dated Check Line")
    begin
        PostDatedCheck.FindFirst;
        CheckCount := PostDatedCheck.Count;
        repeat
            GenJnlLine.Reset;
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
                SalesSetup.Get;
                SalesSetup.TestField("Post Dated Check Template");
                SalesSetup.TestField("Post Dated Check Batch");
                GenJnlLine.SetRange("Journal Template Name", SalesSetup."Post Dated Check Template");
                if PostDatedCheck."Batch Name" <> '' then
                    GenJnlLine.SetRange("Journal Batch Name", PostDatedCheck."Batch Name")
                else
                    GenJnlLine.SetRange("Journal Batch Name", SalesSetup."Post Dated Check Batch");
            end else
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then begin
                    PurchSetup.Get;
                    PurchSetup.TestField("Post Dated Check Template");
                    PurchSetup.TestField("Post Dated Check Batch");
                    GenJnlLine.SetRange("Journal Template Name", PurchSetup."Post Dated Check Template");
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", PostDatedCheck."Batch Name")
                    else
                        GenJnlLine.SetRange("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                end;

            if GenJnlLine.FindLast then begin
                LineNumber := GenJnlLine."Line No.";
                GenJnlLine2 := GenJnlLine;
            end else
                LineNumber := 0;
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
                GenJnlManagement.OpenJnl(SalesSetup."Post Dated Check Batch", GenJnlLine);
                Commit;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := SalesSetup."Post Dated Check Template";
                if PostDatedCheck."Batch Name" <> '' then
                    GenJnlLine.Validate("Journal Batch Name", PostDatedCheck."Batch Name")
                else
                    GenJnlLine.Validate("Journal Batch Name", SalesSetup."Post Dated Check Batch");
            end else
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then begin
                    GenJnlManagement.OpenJnl(PurchSetup."Post Dated Check Batch", GenJnlLine);
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := PurchSetup."Post Dated Check Template";
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", PostDatedCheck."Batch Name")
                    else
                        GenJnlLine.Validate("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                end;
            GenJnlLine."Line No." := LineNumber + 10000;
            GenJnlLine.SetUpNewLine(GenJnlLine2, 0, true);
            GenJnlLine.Validate("Posting Date", PostDatedCheck."Check Date");
            GenJnlLine.Validate("Document Date", PostDatedCheck."Check Date");
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Customer);
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Vendor);
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::"G/L Account" then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
            GenJnlLine.Validate("Account No.", PostDatedCheck."Account No.");
            if PostDatedCheck."Check Cancelled Befoe Posting" = true then
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::" ")
            else
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::Payment);
            GenJnlLine."Interest Amount" := PostDatedCheck."Interest Amount";
            GenJnlLine."Interest Amount (LCY)" := PostDatedCheck."Interest Amount (LCY)";
            GenJnlLine."Applies-to Doc. Type" := PostDatedCheck."Applies-to Doc. Type";
            GenJnlLine."Applies-to Doc. No." := PostDatedCheck."Applies-to Doc. No.";
            if (PostDatedCheck."Document No." <> '') or PostDatedCheck."Check Printed" then
                GenJnlLine."Document No." := PostDatedCheck."Document No.";
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
                if PostDatedCheck."Applies-to ID" <> '' then begin
                    CustLedgEntry.SetRange("Applies-to ID", PostDatedCheck."Applies-to ID");
                    if CustLedgEntry.FindSet then
                        repeat
                            CustLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                            CustLedgEntry.Modify;
                        until CustLedgEntry.Next = 0;
                    GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                end;
            end
            else
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then begin
                    if PostDatedCheck."Applies-to ID" <> '' then begin
                        VendLedgEntry.SetRange("Applies-to ID", PostDatedCheck."Applies-to ID");
                        if VendLedgEntry.FindSet then
                            repeat
                                VendLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                                VendLedgEntry.Modify;
                            until VendLedgEntry.Next = 0;
                        GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                    end;
                end;

            GenJnlLine.Validate("Currency Code", PostDatedCheck."Currency Code");
            GenJnlLine.Validate(Amount, PostDatedCheck.Amount);
            GenJnlLine."Check No." := PostDatedCheck."Check No.";
            GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then
                if PostDatedCheck."Bank Account" <> '' then
                    GenJnlLine.Validate("Bal. Account No.", PostDatedCheck."Bank Account");
            GenJnlLine."Bank Payment Type" := PostDatedCheck."Bank Payment Type";
            GenJnlLine."Check Printed" := PostDatedCheck."Check Printed";
            GenJnlLine."Post Dated Check" := true;
            GenJnlLine.Insert(true);
            GenJnlLine2 := GenJnlLine;
        until PostDatedCheck.Next = 0;

        //PostDatedCheck.DELETEALL;


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
        PostDatedCheck.Reset;
        PostDatedCheck.SetCurrentkey("Line Number");
        if PostDatedCheck.FindLast then
            LineNumber := PostDatedCheck."Line Number"
        else
            LineNumber := 0;
        case GenJnlLine."Account Type" of
            GenJnlLine."account type"::"G/L Account":
                PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::"G/L Account");
            GenJnlLine."account type"::Customer:
                PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::Customer);
            GenJnlLine."account type"::Vendor:
                PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::Vendor);
        end;

        PostDatedCheck.Init;
        case GenJnlLine."Account Type" of
            GenJnlLine."account type"::"G/L Account":
                PostDatedCheck.Validate("Account Type", PostDatedCheck."account type"::"G/L Account");
            GenJnlLine."account type"::Customer:
                PostDatedCheck.Validate("Account Type", PostDatedCheck."account type"::Customer);
            GenJnlLine."account type"::Vendor:
                PostDatedCheck.Validate("Account Type", PostDatedCheck."account type"::Vendor);
        end;
        PostDatedCheck.Validate("Batch Name", GenJnlLine."Journal Batch Name");
        PostDatedCheck.Validate("Account No.", GenJnlLine."Account No.");
        PostDatedCheck."Check Date" := GenJnlLine."Document Date";
        PostDatedCheck."Line Number" := LineNumber + 10000;
        PostDatedCheck.Validate("Currency Code", GenJnlLine."Currency Code");
        PostDatedCheck."Date Received" := WorkDate;
        PostDatedCheck."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        PostDatedCheck."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        PostDatedCheck.Validate(Amount, GenJnlLine.Amount);
        PostDatedCheck."Check No." := GenJnlLine."Check No.";
        PostDatedCheck."Bank Payment Type" := GenJnlLine."Bank Payment Type";
        PostDatedCheck."Check Printed" := GenJnlLine."Check Printed";
        PostDatedCheck."Interest Amount" := GenJnlLine."Interest Amount";
        PostDatedCheck."Interest Amount (LCY)" := GenJnlLine."Interest Amount (LCY)";
        PostDatedCheck."Dimension Set ID" := GenJnlLine."Dimension Set ID";
        PostDatedCheck."Document No." := GenJnlLine."Document No.";
        PostDatedCheck."Bank Account" := GenJnlLine."Bal. Account No.";
        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then begin
            if GenJnlLine."Applies-to ID" <> '' then begin
                CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                if CustLedgEntry.FindSet then
                    repeat
                        CustLedgEntry."Applies-to ID" := PostDatedCheck."Document No.";
                        CustLedgEntry.Modify;
                    until CustLedgEntry.Next = 0;
                PostDatedCheck."Applies-to ID" := PostDatedCheck."Document No.";
            end;
        end else
            if GenJnlLine."Account Type" = GenJnlLine."account type"::Vendor then begin
                if GenJnlLine."Applies-to ID" <> '' then begin
                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                    if VendLedgEntry.FindSet then
                        repeat
                            VendLedgEntry."Applies-to ID" := PostDatedCheck."Document No.";
                            VendLedgEntry.Modify;
                        until VendLedgEntry.Next = 0;
                    PostDatedCheck."Applies-to ID" := PostDatedCheck."Document No.";
                end;
            end;
        if GenJnlLine."Check Printed" then begin
            PostDatedCheck."Bank Account" := GenJnlLine."Bal. Account No.";
            PostDatedCheck."Document No." := GenJnlLine."Document No.";
        end;

        if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then
            PostDatedCheck.Comment := Text1500003
        else
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then
                PostDatedCheck.Comment := Text1500004;

        PostDatedCheck.Insert;
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
                PostDatedCheck.Reset;
                PostDatedCheck.SetRange("Account Type", GenJnlLine."account type"::Vendor);
                PostDatedCheck.SetRange("Account No.", GenJnlLine."Account No.");
                PostDatedCheck.SetRange("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type");
                PostDatedCheck.SetRange("Applies-to Doc. No.", GenJnlLine."Applies-to Doc. No.");
                if not PostDatedCheck.FindFirst then begin
                    PostDatedCheck.Reset;
                    case GenJnlLine."Account Type" of
                        GenJnlLine."account type"::"G/L Account":
                            PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::"G/L Account");
                        GenJnlLine."account type"::Customer:
                            PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::Customer);
                        GenJnlLine."account type"::Vendor:
                            PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::Vendor);
                    end;
                    PostDatedCheck.SetRange("Account No.", GenJnlLine."Account No.");
                    if PostDatedCheck.FindLast then
                        LineNumber := PostDatedCheck."Line Number" + 10000
                    else
                        LineNumber := 10000;

                    PostDatedCheck.Init;
                    case GenJnlLine."Account Type" of
                        GenJnlLine."account type"::"G/L Account":
                            PostDatedCheck.Validate("Account Type", PostDatedCheck."account type"::"G/L Account");
                        GenJnlLine."account type"::Customer:
                            PostDatedCheck.Validate("Account Type", PostDatedCheck."account type"::Customer);
                        GenJnlLine."account type"::Vendor:
                            PostDatedCheck.Validate("Account Type", PostDatedCheck."account type"::Vendor);
                    end;
                    PostDatedCheck.Validate("Account No.", GenJnlLine."Account No.");
                    PostDatedCheck."Check Date" := GenJnlLine."Document Date";
                    PostDatedCheck."Document No." := GenJnlLine."Document No.";
                    PostDatedCheck."Line Number" := LineNumber;
                    PostDatedCheck.Validate("Currency Code", GenJnlLine."Currency Code");
                    PostDatedCheck."Date Received" := WorkDate;
                    PostDatedCheck."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
                    PostDatedCheck."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
                    PostDatedCheck."Applies-to ID" := GenJnlLine."Applies-to ID";
                    PostDatedCheck.Validate(Amount, GenJnlLine.Amount);
                    PostDatedCheck."Check No." := GenJnlLine."Check No.";
                    PostDatedCheck."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                    if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::"Bank Account" then
                        PostDatedCheck."Bank Account" := GenJnlLine."Bal. Account No.";
                    PostDatedCheck."Interest Amount" := GenJnlLine."Interest Amount";
                    PostDatedCheck."Interest Amount (LCY)" := GenJnlLine."Interest Amount (LCY)";
                    PostDatedCheck."Check Printed" := GenJnlLine."Check Printed";
                    PostDatedCheck.Insert;
                end;
            until GenJnlLine.Next = 0;
            GenJnlLine.DeleteAll;
        end;
    end;


    procedure AssignGenJnlLine(var PostDatedCheck: Record "Post Dated Check Line")
    begin
        //Win513++
        //with PostDatedCheck do begin
        //Win513--
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then
            GenJnlLine.DeleteAll;
        GenJnlLine."Line No." := PostDatedCheck."Line Number";
        GenJnlLine."Journal Template Name" := GLSetup."Post Dated Journal Template";
        GenJnlLine."Journal Batch Name" := GLSetup."Post Dated Journal Batch";
        GenJnlLine."Account No." := PostDatedCheck."Account No.";
        GenJnlLine."Posting Date" := PostDatedCheck."Check Date";
        GenJnlLine."Document Date" := PostDatedCheck."Check Date";
        GenJnlLine."Document No." := PostDatedCheck."Document No.";
        GenJnlLine.Description := PostDatedCheck.Description;
        GenJnlLine.Validate("Currency Code", PostDatedCheck."Currency Code");
        if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
            GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
            GenJnlLine.Amount := PostDatedCheck.Amount;
            if PostDatedCheck."Currency Code" = '' then
                GenJnlLine."Amount (LCY)" := PostDatedCheck.Amount
            else
                GenJnlLine."Amount (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostDatedCheck."Date Received", PostDatedCheck."Currency Code",
                      PostDatedCheck.Amount, PostDatedCheck."Currency Factor"));
        end else
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::"G/L Account" then
                GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account"
            else begin
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then
                    GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;
                GenJnlLine.Validate(Amount, PostDatedCheck.Amount);
                GenJnlLine."Interest Amount" := PostDatedCheck."Interest Amount";
                GenJnlLine."Interest Amount (LCY)" := PostDatedCheck."Interest Amount (LCY)";
            end;

        GenJnlLine."Applies-to Doc. Type" := PostDatedCheck."Applies-to Doc. Type";
        GenJnlLine."Applies-to Doc. No." := PostDatedCheck."Applies-to Doc. No.";
        GenJnlLine."Applies-to ID" := PostDatedCheck."Applies-to ID";
        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Post Dated Check" := true;
        GenJnlLine."Check No." := PostDatedCheck."Check No.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := PostDatedCheck."Bank Account";
        GenJnlLine."Bank Payment Type" := PostDatedCheck."Bank Payment Type";
        GenJnlLine."Check Printed" := PostDatedCheck."Check Printed";
        //Win513++
        //end;
        //Win513--
    end;


    procedure ApplyEntries(var PostDatedCheckLine: Record "Post Dated Check Line")
    begin
        GenJnlLine.Init;
        AssignGenJnlLine(PostDatedCheckLine);
        GenJnlLine.Insert;
        Commit;
        GenJnlApply.Run(GenJnlLine);
        Clear(GenJnlApply);
        if GenJnlLine."Applies-to ID" = PostDatedCheckLine."Document No." then begin
            PostDatedCheckLine.Validate(Amount, GenJnlLine.Amount);
            PostDatedCheckLine.Validate("Applies-to ID", PostDatedCheckLine."Document No.");
            PostDatedCheckLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
            PostDatedCheckLine."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
            PostDatedCheckLine.Modify;
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


    procedure PreviewCheck(var PostDatedCheckLine: Record "Post Dated Check Line")
    begin
        //Win513++
        //with PostDatedCheckLine do begin
        //Win513--
        if PostDatedCheckLine."Account Type" <> PostDatedCheckLine."account type"::Vendor then
            Error(Text1500005);
        GenJnlLine.Init;
        AssignGenJnlLine(PostDatedCheckLine);
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


    procedure PrintCheck(var PostDatedCheckLine: Record "Post Dated Check Line")
    begin
        if PostDatedCheckLine."Account Type" <> PostDatedCheckLine."account type"::Vendor then
            Error(Text1500005);
        GenJnlLine.Init;
        AssignGenJnlLine(PostDatedCheckLine);
        GenJnlLine.Insert;
        Commit;
        DocPrint.PrintCheck(GenJnlLine);
        if GenJnlLine.FindFirst then begin
            PostDatedCheckLine."Check Printed" := GenJnlLine."Check Printed";
            PostDatedCheckLine."Check No." := GenJnlLine."Document No.";
            PostDatedCheckLine."Document No." := GenJnlLine."Document No.";
            PostDatedCheckLine.Modify;
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


    procedure VoidCheck(var PostDatedCheckLine: Record "Post Dated Check Line")
    begin
        //Win513++
        //with PostDatedCheckLine do begin
        //Win513--
        if PostDatedCheckLine."Account Type" <> PostDatedCheckLine."account type"::Vendor then
            Error(Text1500000);
        PostDatedCheckLine.TestField("Bank Payment Type", "bank payment type"::"Computer Check");
        PostDatedCheckLine.TestField("Check Printed", true);
        GenJnlLine.Init;
        AssignGenJnlLine(PostDatedCheckLine);
        GenJnlLine.Insert;
        Commit;
        if Confirm(Text1500006, false, PostDatedCheckLine."Document No.") then
            CheckManagement.VoidCheck(GenJnlLine);
        GLSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", GLSetup."Post Dated Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", GLSetup."Post Dated Journal Batch");
        GenJnlLine.SetRange("Post Dated Check", true);
        if GenJnlLine.FindFirst then begin
            PostDatedCheckLine."Check Printed" := GenJnlLine."Check Printed";
            PostDatedCheckLine.Modify;
            GenJnlLine.DeleteAll;
        end;
        //Win513++
        //end;
        //Win513--
    end;

    local procedure "-----------------------"()
    begin
    end;


    procedure PostJournal(var PostDatedCheck: Record "Post Dated Check Line"; Post: Boolean)
    var
        RecGenJournalLine: Record "Gen. Journal Line";
        ServiceContractHeader: Record "Service Contract Header";
    begin
        //WIN325..BEGIN
        PostDatedCheck.SetRange(Status, PostDatedCheck.Status::Received); //WIN325
        PostDatedCheck.FindFirst;
        CheckCount := PostDatedCheck.Count;
        repeat
            GenJnlLine.Reset;
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
                SalesSetup.Get;
                SalesSetup.TestField("Post Dated Check Template");
                // WINPDC
                if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then
                    SalesSetup.TestField("PDC Batch For Cash")
                // WINPDC
                else
                    SalesSetup.TestField("Post Dated Check Batch");
                GenJnlLine.SetRange("Journal Template Name", SalesSetup."Post Dated Check Template");
                if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then begin
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", PostDatedCheck."Batch Name")
                    else
                        GenJnlLine.SetRange("Journal Batch Name", SalesSetup."PDC Batch For Cash");
                end else begin
                    // WINPDC
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", PostDatedCheck."Batch Name")
                    else
                        GenJnlLine.SetRange("Journal Batch Name", SalesSetup."Post Dated Check Batch");
                end;
            end else
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then begin
                    PurchSetup.Get;
                    PurchSetup.TestField("Post Dated Check Template");
                    // WINPDC
                    if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then
                        PurchSetup.TestField("PDC Batch For Cash") //WINPDC
                    else
                        PurchSetup.TestField("Post Dated Check Batch");
                    GenJnlLine.SetRange("Journal Template Name", PurchSetup."Post Dated Check Template");
                    // WINPDC
                    if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then begin
                        if PostDatedCheck."Batch Name" <> '' then
                            GenJnlLine.SetRange("Journal Batch Name", PostDatedCheck."Batch Name")
                        else
                            GenJnlLine.SetRange("Journal Batch Name", PurchSetup."PDC Batch For Cash");
                    end else begin
                        // WINPDC
                        if PostDatedCheck."Batch Name" <> '' then
                            GenJnlLine.SetRange("Journal Batch Name", PostDatedCheck."Batch Name")
                        else
                            GenJnlLine.SetRange("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                    end;
                end;

            if GenJnlLine.FindLast then begin
                LineNumber := GenJnlLine."Line No.";
                GenJnlLine2 := GenJnlLine;
            end else
                LineNumber := 0;
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
                GenJnlManagement.OpenJnl(SalesSetup."Post Dated Check Batch", GenJnlLine);
                Commit;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := SalesSetup."Post Dated Check Template";
                // WINPDC
                if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then begin
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", PostDatedCheck."Batch Name")
                    else
                        GenJnlLine.Validate("Journal Batch Name", SalesSetup."PDC Batch For Cash");
                end else begin
                    // WINPDC
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", PostDatedCheck."Batch Name")
                    else
                        GenJnlLine.Validate("Journal Batch Name", SalesSetup."Post Dated Check Batch");
                end;
            end else
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then begin
                    GenJnlManagement.OpenJnl(PurchSetup."Post Dated Check Batch", GenJnlLine);
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := PurchSetup."Post Dated Check Template";
                    if PostDatedCheck."Batch Name" <> '' then
                        GenJnlLine.Validate("Journal Batch Name", PostDatedCheck."Batch Name")
                    else begin
                        if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then // WINPDC
                            GenJnlLine.Validate("Journal Batch Name", PurchSetup."PDC Batch For Cash") // WINPDC
                        else
                            GenJnlLine.Validate("Journal Batch Name", PurchSetup."Post Dated Check Batch");
                    end;
                end;
            GenJnlLine."Line No." := LineNumber + 10000;
            GenJnlLine.SetUpNewLine(GenJnlLine2, 0, true);
            if PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash then // WINPDC
                GenJnlLine.Validate("Posting Date", PostDatedCheck."Date Received")
            else
                GenJnlLine.Validate("Posting Date", PostDatedCheck."Check Date");
            GenJnlLine.Validate("Document Date", PostDatedCheck."Check Date");
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Customer);
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Vendor);
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::"G/L Account" then
                GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
            GenJnlLine.Validate("Account No.", PostDatedCheck."Account No.");
            if PostDatedCheck."Check Cancelled Befoe Posting" = true then
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::" ")
            else
                GenJnlLine.Validate("Document Type", GenJnlLine."document type"::Payment);  //win315
                                                                                            //GenJnlLine.VALIDATE("Document Type",GenJnlLine."Document Type"::Payment);
            GenJnlLine."Interest Amount" := PostDatedCheck."Interest Amount";
            GenJnlLine."Interest Amount (LCY)" := PostDatedCheck."Interest Amount (LCY)";
            GenJnlLine."Applies-to Doc. Type" := PostDatedCheck."Applies-to Doc. Type";
            GenJnlLine."Applies-to Doc. No." := PostDatedCheck."Applies-to Doc. No.";
            if (PostDatedCheck."Document No." <> '') or PostDatedCheck."Check Printed" then
                GenJnlLine."Document No." := PostDatedCheck."Document No.";
            if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Customer then begin
                if PostDatedCheck."Applies-to ID" <> '' then begin
                    CustLedgEntry.SetRange("Applies-to ID", PostDatedCheck."Applies-to ID");
                    if CustLedgEntry.FindSet then
                        repeat
                            CustLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                            CustLedgEntry.Modify;
                        until CustLedgEntry.Next = 0;
                    GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                end;
            end
            else
                if PostDatedCheck."Account Type" = PostDatedCheck."account type"::Vendor then begin
                    if PostDatedCheck."Applies-to ID" <> '' then begin
                        VendLedgEntry.SetRange("Applies-to ID", PostDatedCheck."Applies-to ID");
                        if VendLedgEntry.FindSet then
                            repeat
                                VendLedgEntry."Applies-to ID" := GenJnlLine."Document No.";
                                VendLedgEntry.Modify;
                            until VendLedgEntry.Next = 0;
                        GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                    end;
                end;

            GenJnlLine.Validate("Currency Code", PostDatedCheck."Currency Code");
            GenJnlLine.Validate(Amount, PostDatedCheck.Amount);
            // WINPDC
            if ((PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::Cash) or (PostDatedCheck."Payment Method" = PostDatedCheck."payment method"::" ")) then begin //win315
                                                                                                                                                                                  //IF (PostDatedCheck."Payment Method" = PostDatedCheck."Payment Method"::Cash) THEN BEGIN
                GenJnlLine."Check No." := '';
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
            end else begin
                // WINPDC
                GenJnlLine."Check No." := PostDatedCheck."Check No.";
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";  //win315
                                                                                                   //GenJnlLine."Bal. Account Type" := PostDatedCheck."Bal. Account Type"; //win315
                                                                                                   //GenJnlLine.MODIFY;
            end;
            // IF PostDatedCheck."Account Type" = PostDatedCheck."Account Type"::Vendor THEN   //win315
            if PostDatedCheck."Bank Account" <> '' then
                GenJnlLine.Validate("Bal. Account No.", PostDatedCheck."Bank Account");
            GenJnlLine."Bank Payment Type" := PostDatedCheck."Bank Payment Type";
            GenJnlLine."Check Printed" := PostDatedCheck."Check Printed";
            GenJnlLine."Post Dated Check" := true;
            GenJnlLine."PDC Document No." := PostDatedCheck."Document No.";//WIN325
            GenJnlLine."PDC Line No." := PostDatedCheck."Line Number"; //WIN325
            GenJnlLine."Check Date" := PostDatedCheck."Check Date"; //win315
            GenJnlLine."Service Contract No." := PostDatedCheck."Contract No."; //win315
            GenJnlLine."Charge Code" := PostDatedCheck."Charge Code"; //win315
            GenJnlLine."Charge Description" := PostDatedCheck."Charge Description"; //win315
                                                                                    //GenJnlLine.ch
            if ServiceContractHeader.Get(ServiceContractHeader."contract type"::Contract, PostDatedCheck."Contract No.") then begin
                GenJnlLine.Validate("Shortcut Dimension 1 Code", ServiceContractHeader."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ServiceContractHeader."Shortcut Dimension 2 Code");
            end;
            //GenJnlLine.ch
            GenJnlLine.Insert(true);

            GenJnlLine2 := GenJnlLine;
            if Post then begin
                GenJnlPostLine.RunWithCheck(GenJnlLine); //WIN325
                Commit;
                RecGenJournalLine.Reset;
                RecGenJournalLine.SetRange("Journal Batch Name", SalesSetup."Post Dated Check Batch");
                RecGenJournalLine.SetRange("Journal Template Name", SalesSetup."Post Dated Check Template");
                RecGenJournalLine.SetRange("PDC Document No.", PostDatedCheck."Document No.");
                RecGenJournalLine.SetRange("PDC Line No.", PostDatedCheck."Line Number");
                if RecGenJournalLine.FindSet then
                    RecGenJournalLine.DeleteAll;
            end;
            // WINPDC
            //IF PostDatedCheck."Payment Method" = PostDatedCheck."Payment Method"::Cash THEN
            //PostDatedCheck.Status := PostDatedCheck.Status::Received
            // WINPDC
            PostDatedCheck.Status := PostDatedCheck.Status::Deposited; //WIN325
            PostDatedCheck.Modify;//WIN325
        until PostDatedCheck.Next = 0;

        //PostDatedCheck.DELETEALL; //WIN325

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
}

