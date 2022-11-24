codeunit 50008 "RDK Single Instance CU"
{
    //Win593++
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGLAcc', '', true, true)]
    local procedure OnBeforePostGLAcc(GenJournalLine: Record "Gen. Journal Line")
    var
        ServiceHeader: Record "Service Header";
    begin
        if GenJournalLine."Source Code" = 'SERVICE' then begin
            if not ServiceHeader.Get(ServiceHeader."Document Type"::Invoice, GenJournalLine."External Document No.") then
                exit;

            IsPostGLAcc := true;
            ServiceContractNo := ServiceHeader."Contract No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostDeferralPostBuffer', '', true, true)]
    local procedure OnBeforePostDeferralPostBuffer(var GenJournalLine: Record "Gen. Journal Line")
    var
        ServiceContract: Record "Service Contract Header";
        DeferralPostBuffer: Record "Deferral Posting Buffer";
        DefferalTemplate: Record "Deferral Template";
        DefLineNo: Integer;
        Counter: Integer;
        Amt: Decimal;
        GLAcc: Code[20];
        BalGLAcc: Code[20];
        PostDate: Date;
    begin
        if not IsPostGLAcc then
            exit;

        if not DefferalTemplate.Get(GenJournalLine."Deferral Code") then
            exit;

        if not ServiceContract.Get(ServiceContract."Contract Type"::Contract, ServiceContractNo) then
            exit;

        //Need to add Account No. in setup
        if ServiceContract."Tenancy Type" = ServiceContract."Tenancy Type"::Residential then begin
            GLAcc := '6956';
            BalGLAcc := '5315';
        end else
            if ServiceContract."Tenancy Type" = ServiceContract."Tenancy Type"::Commercial then begin
                GLAcc := '6955';
                BalGLAcc := '5316';
            end;

        if DefferalTemplate."No. of Periods" > 0 then
            Amt := Round(GenJournalLine.Amount / DefferalTemplate."No. of Periods");

        for Counter := 1 to DefferalTemplate."No. of Periods" do begin
            DefLineNo += 10000;
            if PostDate = 0D then
                PostDate := GenJournalLine."Posting Date"
            else
                PostDate := CalcDate('1M', PostDate);

            DeferralPostBuffer.Init();
            DeferralPostBuffer."Deferral Doc. Type" := "Deferral Document Type"::Service;
            DeferralPostBuffer."Document No." := GenJournalLine."Document No.";
            DeferralPostBuffer.Type := DeferralPostBuffer.Type::"G/L Account";
            DeferralPostBuffer."System-Created Entry" := true;
            DeferralPostBuffer."Global Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
            DeferralPostBuffer."Global Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
            DeferralPostBuffer."Dimension Set ID" := GenJournalLine."Dimension Set ID";
            DeferralPostBuffer."Job No." := GenJournalLine."Job No.";
            DeferralPostBuffer."Tax Area Code" := GenJournalLine."Tax Area Code";
            DeferralPostBuffer."Tax Group Code" := GenJournalLine."Tax Group Code";
            DeferralPostBuffer."Tax Liable" := GenJournalLine."Tax Liable";
            DeferralPostBuffer."Use Tax" := false;
            DeferralPostBuffer."Deferral Code" := GenJournalLine."Deferral Code";
            DeferralPostBuffer."Amount (LCY)" := Amt;
            DeferralPostBuffer.Amount := Amt;
            DeferralPostBuffer."Sales/Purch Amount (LCY)" := Amt;
            DeferralPostBuffer."Sales/Purch Amount" := Amt;
            DeferralPostBuffer."Posting Date" := PostDate;
            DeferralPostBuffer.Description := GenJournalLine.Description;
            DeferralPostBuffer."G/L Account" := GLAcc;
            DeferralPostBuffer."Deferral Account" := BalGLAcc;
            DeferralPostBuffer."Deferral Line No." := DefLineNo;
            DeferralPostBuffer.Update(DeferralPostBuffer);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDeferralPostBufferOnAfterSetFilters', '', true, true)]
    local procedure OnPostDeferralPostBufferOnAfterSetFilters(var DeferralPostBuffer: Record "Deferral Posting Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
        if not IsPostGLAcc then
            exit;

        DeferralPostBuffer.SetRange("Deferral Doc. Type", DeferralPostBuffer."Deferral Doc. Type"::Service);
        DeferralPostBuffer.SetRange("Document No.", GenJournalLine."Document No.");
        DeferralPostBuffer.SetRange("Deferral Line No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', true, true)]
    local procedure OnBeforeDeferralPosting(var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry")
    begin
        IsPostGLAcc := false;
        ServiceContractNo := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', true, true)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        if SalesHeader."Loan Type" <> SalesHeader."Loan Type"::"RDK Loan" then
            exit;

        SalesHeader.CalcFields("RDK Loan Intrest Amount");
        GenJnlLine.Validate(Amount, GenJnlLine.Amount + SalesHeader."RDK Loan Intrest Amount");
        GenJnlLine."Bal. Account No." := '2330';
        GenJnlLine."Interest Amount" := SalesHeader."RDK Loan Intrest Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnBeforeInsertGLEntry', '', true, true)]
    local procedure OnPostGLAccOnBeforeInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        if GenJournalLine."Interest Amount" = 0 then
            exit;

        GLEntry.Validate(Amount, -GenJournalLine."Interest Amount");
    end;
    //Win593--


    var
        IsPostGLAcc: Boolean;
        ServiceContractNo: Code[20];
        PassIntrestEntryOneTime: Boolean;
}