codeunit 50100 "All Subscriber"
{
    Permissions = tabledata "Service Ledger Entry" = RIMD;//supriya

    trigger OnRun()
    begin
    end;


    var
        ServiceLinePostingDate: Date;
        SCM: Codeunit 5940;
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        UserLocation: Code[10];
        UserRespCenter: Code[10];
        SalesUserRespCenter: Code[10];
        PurchUserRespCenter: Code[10];
        ServUserRespCenter: Code[10];
        HasGotSalesUserSetup: Boolean;
        HasGotPurchUserSetup: Boolean;
        HasGotServUserSetup: Boolean;
        ServContractDocSendForApprovalEventDescTxt: Label 'Approval of a Service Contract document is requested.';
        ApprovalEntry: Record "Approval Entry";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ReleaseIncomingDocument: Codeunit "Release Incoming Document";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        AllSubs: Codeunit "All Subscriber";
        variant: Boolean;
        DefUtilities: Codeunit "Deferral Utilities";
        WEH: Codeunit "Workflow Event Handling";
        DeferSchedOutOfBoundsErr: Label 'The deferral schedule falls outside the accounting periods that have been set up for the company.';
        WRH: Codeunit "Workflow Response Handling";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
        PrePostCheckErr: Label '%1 %2 must be approved and released before you can perform this action.';
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        PendingApprovalMsg: Label 'An approval request has been sent.';
        ServiceDeferral: Boolean;
        AccountingPeriod: Record "Accounting Period";
        FALedgEntry: Record "FA Ledger Entry";
        AppMgmt: Codeunit "Approvals Mgmt.";
        RECORDID: RecordId;
        ServiceHeader1: Record 5900;
        ServiceContractHeader1: Record 5965;
        InvalidPostingDateErr: LAbel '%1 is not within the range of posting dates for your company.';
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        AmountRoundingPrecision: Decimal;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Text007: Label 'Invoice cannot be created because amount to invoice for this invoice period is zero.';
        DimMgt: Codeunit DimensionManagement;
        ServDocSendForApprovalEventDescTxt: Label 'Approval of a Service document is requested.';
        ServContractDocSendForApprovalEventDesc: Label 'Approval of a Service Contract document is requested.';
        ServDocApprReqCancelledEventDescTxt: Label 'An approval request for a Service document is canceled.';
        ServContractDocApprReqCancelledEventDescTxt: Label 'An approval request for a Service Contract document is canceled.';

        ServInvPostEventDescTxt: Label 'A Service invoice is posted.';
        ServContractInvPostEventDescTxt: Label 'A Service Contract invoice is posted.';
        ServDocReleasedEventDescTxt: Label 'A Service document is released.';
        ServContractDocReleasedEventDescTxt: Label 'A Service Contract document is released.';
        NextLine: Integer;
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.';
        Text015: Label '%1 %2 for the existing %3 %4 for %5 %6 differs from the newly calculated %1 %7. Do you want to use the existing %1?';
        Text005: Label '%1 %2 removed';
        WDate: Date;
        ServLedgEntry: Record "Service Ledger Entry";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AmountType: Option " ",Amount,DiscAmount,UnitPrice,UnitCost;
        ServContractAccGr: Record "Service Contract Account Group";
        CheckMParts: Boolean;
        NextEntry: Integer;
        Text010: Label 'You cannot create an invoice for contract %1 before the service under this contract is completed because the %2 check box is selected.';
        InvoicingStartingPeriod: Boolean;
        SrcCode: Code[10];
        DeFPostingDate: Date;
        DeferralLine: Record 1702;
        PostingDate: Date;
        Index: Integer;
        Divisor: Integer;
        InvoiceFrom: Date;
        InvoiceTo: Date;
        AppliedGLAccount: Code[20];
        ServiceApplyEntry: Integer;
        ServHeader: record "service header";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ServiceHeader: Record "Service Header";
        ServMgtSetup: Record "Service Mgt. Setup";
        ServContractHeader: record "Service Contract Header";
        GLAcc: Record "G/L Account";
        NoOfPayments: Integer;
        CountOfEntryLoop: Integer;

        DeferraleaderSource: Record 1701;
        DeferraleaderDest: Record 1701;
        DeferralLineSource: Record 1702;
        DeferralLIneDest: Record 1702;
        DeferralUtilities: Codeunit 1720;
        DeferralHeaderVar: Record 1701;
        ServContHdr: Record 5965;
        InitialAmt: Decimal;
        EndDate: Date;
        Days: Integer;
        PerDay: Decimal;
        ServLine: Record "Service Line";
        DefDocType: Enum "Deferral Document Type";
        FirstPartial: Boolean;
        vInvdateFilter: Text;
        DefferralInv: Boolean;
        ForSubstituteInv: Boolean;
        DeferralTemplate: Record 1700;
        OldFirstLineEntryNo: Integer;
        CrAmttoDefer: Decimal;
        GlbSingleCrMemo: Boolean;
        GlbContractStartDate: Date;
        GlbDealDate: Date;
        DeferralHeader: Record 1701;
        ServContrLine: Record 5964;
        ServCon: Record 5965;
        TodateDesc: Date;
        ServiceContractHeader: Record 5965;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"
    (
        var GLEntry: Record "G/L Entry";
        var GenJournalLine: Record "Gen. Journal Line"
    )
    begin
        GLEntry.Narration := GenJournalLine.Narration;
        GLEntry."Check No." := GenJournalLine."Check No";
        GLEntry."Check Date" := GenJournalLine."Check Date";
        GLEntry."Creation Date" := TODAY;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnShowContactOnBeforeOpenContactList', '', true, true)]
    local procedure "Customer_OnShowContactOnBeforeOpenContactList"
    (
        var Contact: Record "Contact";
        var ContactPageID: Integer
    )
    begin
        PAGE.RUN(PAGE::"Contact List1", Contact);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Contact", 'OnCreateCustomerOnBeforeCustomerModify', '', true, true)]
    local procedure "Contact_OnCreateCustomerOnBeforeCustomerModify"
    (
        var Customer: Record "Customer";
        Contact: Record "Contact"
    )
    begin
        Customer."Primary Contact No." := Contact."No.";  //win315++
        Customer.Blocked := Customer.Blocked::" ";    //win315
                                                      // Cust Data Feeling - Temp

        Customer.Address := Contact.Address;
        Customer."Building No." := Contact."Building No.";
        //Cust."Building Name" := "Building Name";
        //Cust."Unit Code" := "Unit No.";
        Customer."Address 2" := Contact."Address 2";
        Customer."Post Code" := Contact."Post Code";
        Customer."Country/Region Code" := Contact."Country/Region Code";
        Customer.County := Contact.County;
        Customer.City := Contact.City;
        Customer."Phone No." := Contact."Phone No.";
        Customer."Fax No." := Contact."Fax No.";
        Customer."Home Page" := Contact."Home Page";
        Customer."Trade License No." := Contact."Trade License No.";

        //Cust."Passport No 1" := "Marital Status";   

        Customer."Source of Lead" := Contact."Source of Lead";
        Customer."Mobile Phone No." := Contact."Mobile Phone No.";
        Customer."VAT Reg. No." := Contact."VAT Reg. No.";
        Customer."E-Mail" := Contact."E-Mail";
        Customer."Marital Status" := Contact."Marital Status";
        Customer."Emergency Contact Name" := Contact."Emergency Contact Name";
        Customer."Contact Creation User Id" := Contact."Creation User ID";
        // RealEstateCR
        Customer.Nationality := Contact.Nationality;
        Customer."Employer Name & Add." := Contact."Employer Name & Add.";
        Customer."Employer's Contact & Email" := Contact."Employer's Contact & Email";

        // RealEstateCR
        //Cust.VALIDATE("Post Code","Post Code");   

        // Cust Data Feeling - Temp


    end;




    [EventSubscriber(ObjectType::Table, Database::"Contact", 'OnCreateCustomerFromTemplateOnAfterApplyCustomerTemplate', '', true, true)]
    local procedure "Contact_OnCreateCustomerFromTemplateOnAfterApplyCustomerTemplate"
    (
        var Customer: Record "Customer";
        CustomerTemplate: Record "Customer Templ.";
        var Contact: Record "Contact"
    )
    begin
        Customer."Building No." := CustomerTemplate."Building No."; //win315
        Customer."Tenancy Type" := CustomerTemplate."Tenancy Type"; //win315
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnAfterInsertServiceHeader', '', true, true)]
    local procedure "ServContractManagement_OnAfterInsertServiceHeader"
    (
        var ServiceHeader: Record "Service Header";
        var ServiceContractHeader: Record "Service Contract Header"
    )
    begin
        // To Capture Creation By and Creation Date
        ServiceHeader."Created By" := USERID;
        ServiceHeader."Creation date" := TODAY;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Service Contract Line", 'OnValidateServiceItemNoOnBeforeCheckSameCustomer', '', true, true)]
    local procedure "Service Contract Line_OnValidateServiceItemNoOnBeforeCheckSameCustomer"
    (
        ServItem: Record "Service Item";
        var ServContractHeader: Record "Service Contract Header";
        var IsHandled: Boolean
    )
    begin
        IF ServItem."Customer No." <> ServContractHeader."Customer No." THEN BEGIN  //win315 ++
            ServItem."Customer No." := ServContractHeader."Customer No.";

            ServItem.MODIFY;

        end;

    end;

    [EventSubscriber(ObjectType::Report, Report::"Update Contract Prices", 'OnBeforeServiceContractLineModify', '', true, true)]
    local procedure "Update Contract Prices_OnBeforeServiceContractLineModify"
(
    var ServiceContractLine: Record "Service Contract Line";
    ServiceContractHeader: Record "Service Contract Header";
    UpdateToDate: Date;
    PriceUpdPct: Decimal
)
    begin
        ServiceContractLine."Contract Expiration Date" := ServiceContractHeader."Expiration Date";   //PPG

        ServiceContractLine.GetServContractHeader;
        ServiceContractHeader."Annual Amount" := ServiceContractLine."Line Amount" + ServiceContractLine."Line Amount";
        ServiceContractHeader.VALIDATE("Invoice Period", ServiceContractHeader."Invoice Period");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnBeforeApplyServiceContractQuoteTemplate', '', true, true)]
    local procedure "Service Contract Header_OnBeforeApplyServiceContractQuoteTemplate"
    (
        var ServiceContractHeader: Record "Service Contract Header";
        var IsHandled: Boolean
    )
    begin
        ServiceContractHeader."Deal Closing Date" := WORKDATE;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Documents Mgt.", 'OnAfterPostDocumentLines', '', true, true)]
    local procedure "Serv-Documents Mgt._OnAfterPostDocumentLines"
    (
        var ServHeader: Record "Service Header";
        var ServInvHeader: Record "Service Invoice Header";
        var ServInvLine: Record "Service Invoice Line";
        var ServCrMemoHeader: Record "Service Cr.Memo Header";
        var ServCrMemoLine: Record "Service Cr.Memo Line"
    )
    begin



    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Posting Journals Mgt.", 'OnBeforePostInvoicePostBuffer', '', true, true)]
    local procedure "Serv-Posting Journals Mgt._OnBeforePostInvoicePostBuffer"
    (
        var GenJournalLine: Record "Gen. Journal Line";
        //Win513++
        var InvoicePostBuffer: Record "Invoice Post. Buffer";
        //var InvoicePostBuffer: Record "Invoice Post. Buffer New";
        //Win513++
        ServiceHeader: Record "Service Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"
    )
    begin
        IF (ServiceHeader."Defferal Code" <> '') AND (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") THEN BEGIN
            GenJournalLine.SetServiceDeferral;
            GenJournalLine."Deferral Code" := ServiceHeader."Defferal Code";

            //Win593++
            //DeferraleaderSource.GET(2, '', '', 0, ServiceHeader."No.", 0);
            DeferraleaderSource.SetRange("Document No.", ServiceHeader."No.");
            DeferraleaderSource.FindFirst();
            //Win593--
            DeferraleaderDest.INIT;
            //Win593++
            //Win513++
            DeferraleaderDest."Deferral Doc. Type" := 2;
            //DeferraleaderDest."Deferral Doc. Type" := DeferraleaderDest."Deferral Doc. Type"::Sales;
            //Win513--
            //Win593--
            DeferraleaderDest."Gen. Jnl. Template Name" := GenJournalLine."Journal Template Name";
            DeferraleaderDest."Gen. Jnl. Batch Name" := GenJournalLine."Journal Batch Name";
            DeferraleaderDest."Document Type" := 0;
            DeferraleaderDest."Document No." := '';//GenJnlLine."Document No.";//while posting gnl deferals system explicitly makes the document no. blank
            DeferraleaderDest."Line No." := GenJournalLine."Line No.";

            DeferraleaderDest."Deferral Code" := DeferraleaderSource."Deferral Code";
            DeferraleaderDest."Amount to Defer" := DeferraleaderSource."Amount to Defer";
            DeferraleaderDest."Amount to Defer (LCY)" := DeferraleaderSource."Amount to Defer (LCY)";
            DeferraleaderDest."Calc. Method" := DeferraleaderSource."Calc. Method";
            DeferraleaderDest."Start Date" := DeferraleaderSource."Start Date";
            DeferraleaderDest."No. of Periods" := DeferraleaderSource."No. of Periods";
            DeferraleaderDest."Schedule Description" := DeferraleaderSource."Schedule Description";
            DeferraleaderDest."Initial Amount to Defer" := DeferraleaderSource."Initial Amount to Defer";
            DeferraleaderDest."Currency Code" := DeferraleaderSource."Currency Code";
            DeferraleaderDest."Schedule Line Total" := DeferraleaderSource."Schedule Line Total";
            DeferraleaderDest.INSERT;

            DeferralLineSource.RESET;
            DeferralLineSource.SETRANGE(DeferralLineSource."Deferral Doc. Type", 2);
            DeferralLineSource.SETRANGE(DeferralLineSource."Gen. Jnl. Template Name", '');
            DeferralLineSource.SETRANGE(DeferralLineSource."Gen. Jnl. Batch Name", '');
            DeferralLineSource.SETRANGE(DeferralLineSource."Document Type", 0);
            DeferralLineSource.SETRANGE(DeferralLineSource."Document No.", ServiceHeader."No.");
            DeferralLineSource.SETRANGE(DeferralLineSource."Line No.", 0);
            IF DeferralLineSource.FINDSET THEN
                REPEAT
                    DeferralLIneDest.INIT;
                    //Win513++
                    //DeferralLIneDest."Deferral Doc. Type" := 2;
                    DeferralLIneDest."Deferral Doc. Type" := DeferralLIneDest."Deferral Doc. Type"::Sales;
                    //Win513++
                    DeferralLIneDest."Gen. Jnl. Template Name" := GenJournalLine."Journal Template Name";
                    DeferralLIneDest."Gen. Jnl. Batch Name" := GenJournalLine."Journal Batch Name";
                    DeferralLIneDest."Document Type" := 0;
                    DeferralLIneDest."Document No." := '';//GenJnlLine."Document No.";//while posting gnl deferals system explicitly makes the document no. blank
                    DeferralLIneDest."Line No." := GenJournalLine."Line No.";
                    DeferralLIneDest."Posting Date" := GenJournalLine."Posting Date";
                    DeferralLIneDest.Description := GenJournalLine.Description;
                    DeferralLIneDest.Amount := DeferralLineSource.Amount;
                    DeferralLIneDest."Amount (LCY)" := DeferralLineSource."Amount (LCY)";
                    DeferralLIneDest."Currency Code" := DeferralLineSource."Currency Code";
                    DeferralLIneDest.INSERT;

                UNTIL DeferralLineSource.NEXT = 0;
        END;
    EnD;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Posting Journals Mgt.", 'OnAfterPostInvoicePostBuffer', '', true, true)]
    local procedure "Serv-Posting Journals Mgt._OnAfterPostInvoicePostBuffer"
    (
        var GenJournalLine: Record "Gen. Journal Line";
        //Win513++
        var InvoicePostBuffer: Record "Invoice Post. Buffer";
        //var InvoicePostBuffer: Record "Invoice Post. Buffer New";
        //Win513--
        ServiceHeader: Record "Service Header";
        GLEntryNo: Integer;
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"
    )
    begin
        DeferralHeaderVar.RESET;
        IF DeferralHeaderVar.GET(2, '', '', 0, '', 0) THEN
            DeferralHeaderVar.DELETE(TRUE);

    end;

    //Win513++
    //Procedure PostBalancingEntry1(VAR TotalServiceLine: Record 5902; VAR TotalServiceLineLCY: Record 5902; DocType: Integer; DocNo: Code[20]; ExtDocNo: Code[20])
    Procedure PostBalancingEntry1(VAR TotalServiceLine: Record 5902; VAR TotalServiceLineLCY: Record 5902; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Code[20])
    //Win513--
    VAR
        CustLedgEntry: Record 21;
        GenJnlLine: Record 81;
        PaymentMethod: Record 289;
        //ServiceHeader: Record "Service Header";
        SPJM: Codeunit "Serv-Posting Journals Mgt.";
    BEGIN
        //WIN 315

        CustLedgEntry.FINDLAST;
        //Win513++
        //WITH GenJnlLine DO BEGIN
        //Win513--
        GenJnlLine.InitNewLine(
           ServiceLinePostingDate, ServiceHeader."Document Date", ServiceHeader."Posting Description",
           ServiceHeader."Shortcut Dimension 1 Code", ServiceHeader."Shortcut Dimension 2 Code",
           ServiceHeader."Dimension Set ID", ServiceHeader."Reason Code");

        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" THEN
            GenJnlLine.CopyDocumentFields(GenJnlLine."Document Type"::Refund, DocNo, ExtDocNo, SrcCode, '')
        ELSE
            GenJnlLine.CopyDocumentFields(GenJnlLine."Document Type"::Payment, DocNo, ExtDocNo, SrcCode, '');

        GenJnlLine.CopyFromServiceHeader(ServiceHeader);
        //  "Account Type" := "Account Type"::Customer;
        //  "Account No." := ServiceHeader."Bill-to Customer No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        IF PaymentMethod.GET(ServiceHeader."Payment Method Code") THEN
            GenJnlLine."Account No." := PaymentMethod."Bal. Account No.";

        GenJnlLine."Currency Code" := ServiceHeader."Currency Code";
        IF ServiceHeader."Currency Code" = '' THEN
            GenJnlLine."Currency Factor" := 1
        ELSE
            GenJnlLine."Currency Factor" := ServiceHeader."Currency Factor";

        SetApplyToDocNo(ServiceHeader, GenJnlLine, DocType, DocNo);//WIN292

        GenJnlLine.Amount := ABS(TotalServiceLine."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible");
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        CustLedgEntry.CALCFIELDS(Amount);
        IF CustLedgEntry.Amount = 0 THEN
            GenJnlLine."Amount (LCY)" := ABS(TotalServiceLineLCY."Amount Including VAT")
        ELSE
            GenJnlLine."Amount (LCY)" :=
               ABS(TotalServiceLineLCY."Amount Including VAT" +
              ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor"));


        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
        GenJnlLine."Bal. Account No." := ServiceHeader."Bill-to Customer No.";
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        //Win513++
        //END;
        //Win513--
    End;

    //Win513++
    //procedure SetApplyToDocNo(ServiceHeader: Record "Service Header"; VAR GenJnlLine: Record "Gen. Journal Line"; DocType: Option; DocNo: Code[20])
    procedure SetApplyToDocNo(ServiceHeader: Record "Service Header"; VAR GenJnlLine: Record "Gen. Journal Line"; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20])
    //Win513--
    begin
        //Win513++
        //WITH GenJnlLine DO BEGIN
        //Win513--
        IF ServiceHeader."Bal. Account Type" = ServiceHeader."Bal. Account Type"::"Bank Account" THEN
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := ServiceHeader."Bal. Account No.";
        GenJnlLine."Applies-to Doc. Type" := DocType;
        GenJnlLine."Applies-to Doc. No." := DocNo;
        //Win513++
        //END;
        //Win513--
    End;

    //Win513++
    //Procedure PostPenaltyEntry(VAR PenaltyAmt: Decimal; VAR PenaltyAmtLCY: Decimal; DocType: Integer; DocNo: Code[20]; ExtDocNo: Code[20])
    Procedure PostPenaltyEntry(VAR PenaltyAmt: Decimal; VAR PenaltyAmtLCY: Decimal; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Code[20])
    //Win513--
    var
        CustLedgEntry: Record 21;
        GenJnlLine: Record 81;
        PaymentMethod: Record 289;
        ServiceMgtSetup: Record "Service Mgt. Setup";
    Begin
        CustLedgEntry.FINDLAST;
        //Win513++
        //WITH GenJnlLine DO BEGIN
        //Win513--
        GenJnlLine.InitNewLine(
          ServiceLinePostingDate, ServiceHeader."Document Date", ServiceHeader."Posting Description",
          ServiceHeader."Shortcut Dimension 1 Code", ServiceHeader."Shortcut Dimension 2 Code",
          ServiceHeader."Dimension Set ID", ServiceHeader."Reason Code");
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" THEN
            GenJnlLine.CopyDocumentFields(GenJnlLine."Document Type"::Refund, DocNo, ExtDocNo, SrcCode, '')
        ELSE
            GenJnlLine.CopyDocumentFields(GenJnlLine."Document Type"::" ", DocNo, ExtDocNo, SrcCode, '');
        GenJnlLine.CopyFromServiceHeader(ServiceHeader);
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := ServiceHeader."Bill-to Customer No.";
        ServiceMgtSetup.GET;
        ServiceMgtSetup.TESTFIELD("Penalty Account");
        GenJnlLine."Currency Code" := ServiceHeader."Currency Code";
        IF ServiceHeader."Currency Code" = '' THEN
            GenJnlLine."Currency Factor" := 1
        ELSE
            GenJnlLine."Currency Factor" := ServiceHeader."Currency Factor";
        SetApplyToDocNo(ServiceHeader, GenJnlLine, DocType, DocNo);
        GenJnlLine.Amount := PenaltyAmt;
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := ServiceMgtSetup."Penalty Account";
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        //Win513++
        //END;
        //Win513--
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnBeforeSignContractQuote', '', true, true)]
    local procedure "SignServContractDoc_OnBeforeSignContractQuote"
    (
        var ServiceContractHeader: Record "Service Contract Header";
        var HideDialog: Boolean
    )
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnSignContractOnAfterServContractLineNewLineFalse', '', true, true)]

    local procedure "SignServContractDoc_OnSignContractOnAfterServContractLineNewLineFalse"(var ServContractLine: Record "Service Contract Line")
    var
        ToServContractHeader: Record "Service Contract Header";
    begin
        if ToServContractHeader.Get(ServContractLine."Contract Type", ServContractLine."Contract No.") then
            ServContractLine."Contract Expiration Date" := ToServContractHeader."Expiration Date";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnAfterSignContractQuote', '', true, true)]
    local procedure "SignServContractDoc_OnAfterSignContractQuote"
    (
        var SourceServiceContractHeader: Record "Service Contract Header";
        var DestServiceContractHeader: Record "Service Contract Header"
    )
    begin
        MESSAGE('Service Contract %1 has been created.', SourceServiceContractHeader."Contract No.");
        IF CONFIRM('Do you want to open service contract %1', TRUE, SourceServiceContractHeader."Contract No.") THEN
            PAGE.RUN(6050, SourceServiceContractHeader)
        ELSE
            EXIT;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnBeforeServContractHeaderModify', '', true, true)]
    local procedure "SignServContractDoc_OnBeforeServContractHeaderModify"
    (
        var ServiceContractHeader: Record "Service Contract Header";
        FromServiceContractHeader: Record "Service Contract Header"
    )
    begin
        ServiceContractHeader."Signature Datetime" := CURRENTDATETIME;
        ServiceContractHeader."Signed By" := USERID;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnAfterToServContractHeaderInsert', '', true, true)]
    local procedure "SignServContractDoc_OnAfterToServContractHeaderInsert"
    (
        var ToServiceContractHeader: Record "Service Contract Header";
        FromServiceContractHeader: Record "Service Contract Header"
    )
    begin
        ToServiceContractHeader.UpdateCustServiceItem;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnBeforeCheckServContractQuote', '', true, true)]
    local procedure "SignServContractDoc_OnBeforeCheckServContractQuote"(var ServiceContractHeader: Record "Service Contract Header")
    begin
        ServiceContractHeader.TESTFIELD("Invoice Generation");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeCreateInvoice', '', true, true)]
    local procedure "ServContractManagement_OnBeforeCreateInvoice"(var ServiceContractHeader: Record "Service Contract Header")
    begin
        ForSubstituteInv := TRUE;
        ServiceContractHeader.TESTFIELD("Contract Lines on Invoice", TRUE);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnCreateServiceLedgerEntryOnBeforeInsertMultipleServLedgEntries', '', true, true)]
    local procedure "ServContractManagement_OnCreateServiceLedgerEntryOnBeforeInsertMultipleServLedgEntries"
    (
        var NextInvDate: Date;
        ServContractHeader: Record "Service Contract Header";
        ServContractLine: Record "Service Contract Line"
    )
    begin
        IF ForSubstituteInv THEN BEGIN
            NoOfPayments := 1;
            CountOfEntryLoop := 2;
        END;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeServHeaderModify', '', true, true)]
    local procedure "ServContractManagement_OnBeforeServHeaderModify"
    (
        var ServiceHeader: Record "Service Header";
        ServiceContractHeader: Record "Service Contract Header"
    )
    begin
        ServiceHeader."Work Description" := ServiceContractHeader."Work Description";
        ServiceHeader."Building No." := ServiceContractHeader."Building No.";

        // Penalty Transfer
        IF ServiceHeader."Penalty Amount" <> 0 THEN BEGIN
            ServiceHeader."Penalty Amount" := ServiceHeader."Penalty Amount";
            ServiceHeader."Penalty Exist" := TRUE;
        END;
        // Penalty Transfer

        //To flow deferal code from service contract to servcice invoice>>
        IF FirstPartial = FALSE THEN BEGIN
            ServiceHeader."Defferal Code" := ServiceContractHeader."Defferal Code";
            ServiceHeader.VALIDATE("Posting Date", ServiceContractHeader."Deal Closing Date");   //win315 added date code
            ServiceHeader.VALIDATE("Payment Method Code", 'PDC'); //win315
        END ELSE
            ServiceHeader."First Partial Invoice" := TRUE;
        //WINS-PPG End<<To flow deferal code from service contract to servcice invoice>>
        IF ForSubstituteInv THEN BEGIN
            ServiceHeader."Defferal Code" := '';
            //ServiceHeader.VALIDATE("Posting Date",PostDate); //WIN292
            ServiceHeader.VALIDATE(ServiceHeader."Payment Method Code", ''); //win315
        END;


        IF GlbSingleCrMemo THEN
            ServiceHeader.VALIDATE("Payment Method Code", 'PDC');

        ServiceHeader."Defferal Code" := ServiceContractHeader."Defferal Code"; // To Reverse Defferral
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnAfterCreateServHeader', '', true, true)]
    local procedure "ServContractManagement_OnAfterCreateServHeader"
    (
        var ServiceHeader: Record "Service Header";
        ServiceContractHeader: Record "Service Contract Header"
    )
    begin
        IF ServiceHeader."Defferal Code" <> '' THEN BEGIN
            IF NOT DeferralHeader.GET(2, '', '', ServiceHeader."Document Type", ServiceHeader."No.", 0) THEN BEGIN
                // Need to create the header record.
                //Win593++
                //Win513++
                DeferralHeader."Deferral Doc. Type" := 2;
                //DeferralHeader."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type"::Sales;
                //Win513--
                //Win593--
                DeferralHeader."Gen. Jnl. Template Name" := '';
                DeferralHeader."Gen. Jnl. Batch Name" := '';
                DeferralHeader."Document Type" := 0;
                DeferralHeader."Document No." := ServiceHeader."No.";
                DeferralHeader."Line No." := 0;
                DeferralHeader.INSERT;
            end;
        end;
        IF DefferralInv THEN BEGIN
            ServiceContractHeader.CALCFIELDS("Calcd. Annual Amount");
            DeferralHeader."Amount to Defer" := -ServiceContractHeader."Calcd. Annual Amount"
        END ELSE
            DeferralHeader."Amount to Defer" := -ServiceContractHeader."Amount per Period";

        // DeferralHeader."Start Date" := ServContract2."Next Invoice Date";
        DeferralHeader."Start Date" := ServiceContractHeader."Starting Date";
        DeferralTemplate.RESET;
        DeferralTemplate.GET(ServiceContractHeader."Defferal Code");
        DeferralHeader."Calc. Method" := DeferralTemplate."Calc. Method";
        DeferralHeader."No. of Periods" := DeferralTemplate."No. of Periods";
        DeferralHeader."Schedule Description" := DeferralTemplate."Period Description";
        DeferralHeader."Deferral Code" := DeferralTemplate."Deferral Code";
        DeferralHeader."Currency Code" := ServiceContractHeader."Currency Code";
        DeferralHeader.MODIFY;



        IF DeferralHeader.GET(2, '', '', 0, ServiceHeader."No.", 0) THEN BEGIN
            DeferralHeader.CALCFIELDS("Schedule Line Total");
            DeferralHeader."Amount to Defer" := DeferralHeader."Schedule Line Total";
            DeferralHeader.MODIFY;
        END;
    End;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeInitServiceLineAppliedGLAccount', '', true, true)]
    local procedure "ServContractManagement_OnBeforeInitServiceLineAppliedGLAccount"
    (
        var ServLine: Record "Service Line";
        AppliedGLAccount: Code[20];
        var IsHandled: Boolean

    )
    begin
        IF ForSubstituteInv THEN BEGIN
            ServContractHeader.Get(Servline."Contract No.");
            ServContractHeader.TESTFIELD("Defferal Code");
            DeferralTemplate.GET(ServContractHeader."Defferal Code");
            DeferralTemplate.TESTFIELD("Deferral Account");
            GlAcc.GET(DeferralTemplate."Deferral Account");
            GlAcc.TESTFIELD("Direct Posting");
        END;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnServLedgEntryToServiceLineOnBeforeServLineInsert', '', true, true)]
    local procedure "ServContractManagement_OnServLedgEntryToServiceLineOnBeforeServLineInsert"
    (
        var ServiceLine: Record "Service Line";
        TotalServiceLine: Record "Service Line";
        TotalServiceLineLCY: Record "Service Line";
        ServiceHeader: Record "Service Header";
        ServiceLedgerEntry: Record "Service Ledger Entry";
        ServiceLedgerEntryParm: Record "Service Ledger Entry";
        var IsHandled: Boolean;
        InvFrom: Date;
        InvTo: Date
    )
    begin
        // Commented for time being - Test

        // IF ServiceLine."Non-VAT" THEN BEGIN
        //     ServiceLine.VALIDATE("VAT Prod. Posting Group", 'NO VAT');
        //     ServiceLine.MODIFY;
        // END;


        // IF ServiceLedgerEntry."Penalty Entry" THEN
        //     ServiceLine.VALIDATE("No.", ServMgtSetup."Penalty Account")
        // ELSE
        //     ServiceLine.VALIDATE("No.", AppliedGLAccount);
        // IF ServCon.GET(ServCon."Contract Type"::Contract, ServHeader."Contract No.") THEN
        //     IF ServCon."Invoice Generation" = ServCon."Invoice Generation"::"Single Invoice" THEN
        //         ServiceLine.VALIDATE("VAT Prod. Posting Group", ServCon."VAT Prod. Posting Group");


        // IF ServCon."Expiration Date" < InvTo THEN
        //     TodateDesc := ServCon."Expiration Date"
        // ELSE
        //     TodateDesc := InvTo;


        // ServiceLine."Non-VAT" := ServiceLedgerEntry."Non-VAT";

        // IF (ServHeader."Defferal Code" <> '') AND (NOT ForSubstituteInv) AND (NOT ServiceLedgerEntry."Penalty Entry") THEN BEGIN
        //     DeFPostingDate := 0D;
        //     DeferralTemplate.RESET;
        //     DeferralTemplate.GET(ServHeader."Defferal Code");
        //     DeferralLine.INIT;
        //     //Win513++
        //     //DeferralLine."Deferral Doc. Type" := 2;
        //     DeferralLine."Deferral Doc. Type" := DeferralLine."Deferral Doc. Type"::Sales;
        //     //Win513--
        //     DeferralLine."Gen. Jnl. Template Name" := '';
        //     DeferralLine."Gen. Jnl. Batch Name" := '';
        //     DeferralLine."Document Type" := 0;
        //     DeferralLine."Document No." := ServHeader."No.";
        //     DeferralLine."Line No." := 0;
        //     DeferralLine."Currency Code" := ServHeader."Currency Code";
        //     //DeferralLine.VALIDATE("Posting Date",InvFrom);

        //     DeFPostingDate := InvFrom;
        //     DeferralLine.VALIDATE("Posting Date", DeFPostingDate); // To get 1st Date of Next Period.
        //     DeferralLine.Description := DeferralUtilities.CreateRecurringDescription(InvFrom, DeferralTemplate."Period Description");
        //     DeferralLine.VALIDATE(Amount, -ServiceLine."Line Amount");
        //     DeferralLine.INSERT;


        // end;
    End;

    //Win593++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnServLedgEntryToServiceLineOnBeforeServLineInsert', '', true, true)]
    local procedure "OnServLedgEntryToServiceLineOnBeforeServLineInsert"(var ServiceLine: Record "Service Line"; InvFrom: Date; ServiceHeader: Record "Service Header")
    var
        ServContractHdr: Record "Service Contract Header";
        TenanyType: Record "Tenancy Type";
    begin
        ServiceLine."Posting Date" := InvFrom;
        if ServContractHdr.Get(ServContractHdr."Contract Type"::Contract, ServiceHeader."Contract No.") then begin
            TenanyType.Get(ServContractHdr."Tenancy Type");
            ServiceLine."No." := TenanyType."GL Account";
        end;
    end;
    //Win593--

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeLastServLineModify', '', true, true)]
    local procedure "ServContractManagement_OnBeforeLastServLineModify"(var ServiceLine: Record "Service Line")
    begin
        if ServiceHeader.Get(ServLine."Contract No.") then
            ServLine."Deferral Code" := ServiceHeader."Defferal Code";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnCreateOrGetCreditHeaderOnBeforeCalcCurrencyFactor', '', true, true)]
    local procedure "ServContractManagement_OnCreateOrGetCreditHeaderOnBeforeCalcCurrencyFactor"
    (
        ServiceHeader: Record "Service Header";
        var CurrExchRate: Record "Currency Exchange Rate"
    )
    begin
        IF GlbSingleCrMemo THEN // For Posting Single Cr Memo for Contract
            ServiceHeader.VALIDATE("Posting Date", GlbDealDate);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnAfterCreateOrGetCreditHeader', '', true, true)]
    local procedure "ServContractManagement_OnAfterCreateOrGetCreditHeader"
    (
        var ServiceHeader: Record "Service Header";
        ServiceContractHeader: Record "Service Contract Header"
    )
    begin
        //WINS-PPG Start<<create schedule header for service invoice manually when service invoice is created from service contract
        IF ServiceHeader."Defferal Code" <> '' THEN BEGIN
            IF NOT DeferralHeader.GET(2, '', '', ServiceHeader."Document Type", ServiceHeader."No.", 0) THEN BEGIN
                // Need to create the header record.
                //Win513++
                //DeferralHeader."Deferral Doc. Type" := 2;
                DeferralHeader."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type"::Sales;
                //Win513--
                DeferralHeader."Gen. Jnl. Template Name" := '';
                DeferralHeader."Gen. Jnl. Batch Name" := '';
                DeferralHeader."Document Type" := 0;
                DeferralHeader."Document No." := ServiceHeader."No.";
                DeferralHeader."Line No." := 0;
                DeferralHeader.INSERT;
            END;
            //realestatecr

            DeferralHeader."Amount to Defer" := CrAmttoDefer;
            DeferralHeader."Start Date" := ServiceContractHeader."Starting Date";
            DeferralTemplate.RESET;
            DeferralTemplate.GET(ServiceHeader."Defferal Code");
            DeferralHeader."Calc. Method" := DeferralTemplate."Calc. Method";
            DeferralHeader."No. of Periods" := DeferralTemplate."No. of Periods";
            DeferralHeader."Schedule Description" := DeferralTemplate."Period Description";
            DeferralHeader."Deferral Code" := DeferralTemplate."Deferral Code";
            DeferralHeader."Currency Code" := ServiceContractHeader."Currency Code";
            DeferralHeader.MODIFY;
        END;
        //WINS-PPG end>>
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeServLineInsert', '', true, true)]
    local procedure "ServContractManagement_OnBeforeServLineInsert"
    (
        var ServiceLine: Record "Service Line";
        ServiceHeader: Record "Service Header";
        ServiceContractHeader: Record "Service Contract Header"
    )
    begin
        IF ServiceContractHeader."Invoice Generation" = ServiceContractHeader."Invoice Generation"::"Single Invoice" THEN
            ServiceLine.VALIDATE("VAT Prod. Posting Group", ServiceContractHeader."VAT Prod. Posting Group");

        //WINS-PPG start<<create schedule Line for service invoice manually when service invoice is created from service contract
        IF (ServiceHeader."Defferal Code" <> '') THEN BEGIN
            DeFPostingDate := 0D;
            DeferralTemplate.RESET;
            DeferralTemplate.GET(ServiceHeader."Defferal Code");
            DeferralLine.INIT;
            //Win513++
            //DeferralLine."Deferral Doc. Type" := 2;
            DeferralLine."Deferral Doc. Type" := DeferralLine."Deferral Doc. Type"::Sales;
            //Win513--
            DeferralLine."Gen. Jnl. Template Name" := '';
            DeferralLine."Gen. Jnl. Batch Name" := '';
            DeferralLine."Document Type" := 0;
            DeferralLine."Document No." := ServiceHeader."No.";
            DeferralLine."Line No." := 0;
            DeferralLine."Currency Code" := ServiceHeader."Currency Code";
            //DeferralLine.VALIDATE("Posting Date",InvFrom);
            //DeFPostingDate := PeriodStarts;//WIN292
            DeferralLine.VALIDATE("Posting Date", DeFPostingDate); // To get 1st Date of Next Period.
            //DeferralLine.Description := DeferralUtilities.CreateRecurringDescription(PeriodStarts, DeferralTemplate."Period Description");//WIN292
            DeferralLine.VALIDATE(Amount, ServiceLine."Line Amount");
            DeferralLine.INSERT;

        end;
    END;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeCreateRemainingPeriodInvoice', '', true, true)]
    local procedure "ServContractManagement_OnBeforeCreateRemainingPeriodInvoice"(var ServiceContractHeader: Record "Service Contract Header")
    var
        InvFrom: date;
        InvTo: Date;
    begin
        IF ServiceContractHeader."Termination Date" = 0D THEN BEGIN

            InvFrom := ServiceContractHeader."Starting Date";
            InvTo := ServiceContractHeader."Termination Date";

            IF DefferralInv THEN
                GetContractPeriod(ServiceContractHeader, InvoiceFrom, InvoiceTo)    // To Control Single and Multiple Invoice Generation

        END;
    end;





    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeServContractHeaderModify', '', true, true)]
    local procedure "ServContractManagement_OnBeforeServContractHeaderModify"(var ServiceContractHeader: Record "Service Contract Header")
    begin
        if ServHeader.Get(ServiceContractHeader."Contract No.") then begin
            ServHeader."Defferal Code" := '';
            ServHeader."First Partial Invoice" := TRUE;
            ServHeader.MODIFY;
        end;
    end;

    procedure GetContractPeriod(InvoicedServContractHeader: Record "Service Contract Header"; VAR InvFrom: Date; VAR InvTo: Date)
    begin
        IF InvoicedServContractHeader."Termination Date" <> 0D THEN BEGIN
            InvFrom := InvoicedServContractHeader."Starting Date";
            InvTo := InvoicedServContractHeader."Termination Date";
        END ELSE BEGIN
            InvFrom := InvoicedServContractHeader."Starting Date";
            InvTo := InvoicedServContractHeader."Expiration Date";
        END;
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnCreateAllServLinesOnAfterCreateDetailedServLine', '', true, true)]
    local procedure "ServContractManagement_OnCreateAllServLinesOnAfterCreateDetailedServLine"
    (
        ServiceContractHeader: Record "Service Contract Header";
        ServHeader: Record "Service Header";
        ServContractLine: Record "Service Contract Line"
    )
    begin
        //Win593
        // Commented for time being - Test
        // GetContractPeriod(ServiceContractHeader, InvoiceFrom, InvoiceTo);
        // IF (ServiceContractHeader."Invoice Generation" = ServiceContractHeader."Invoice Generation"::"Single Invoice") OR (DefferralInv) THEN // Added condition for Single Invoice Generation
        //     ServiceApplyEntry :=
        //       CreateServiceLedgerEntryForSingleInvoice(
        //         ServHeader, ServContractLine."Contract Type", ServContractLine."Contract No.", InvoiceFrom, InvoiceTo,
        //         FALSE, FALSE, ServContractLine."Line No.")
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServContractManagement", 'OnBeforeUpdateServLedgEntryAmounts', '', true, true)]
    local procedure "ServContractManagement_OnBeforeUpdateServLedgEntryAmounts"
    (
        var ServiceContractLine: Record "Service Contract Line";
        var ServLedgEntry: Record "Service Ledger Entry";
        //       InvRoundedAmount: Decimal;
        LineInvoiceFrom: Date;
        InvoiceTo: Date;
        var IsHandled: Boolean
    )
    begin
        IF ForSubstituteInv THEN BEGIN        // Added Condition for Substitute invoice generation for -ve sign
            Divisor := NoOfPayments + 1 - Index;
            IF NoOfPayments + 1 - Index = 0 THEN
                Divisor := -1;
        end;
    End;

    PROCEDURE SetFirstPartial();
    BEGIN
        FirstPartial := TRUE;
    END;



    PROCEDURE CreateSingleInvoice(ServContractToInvoice: Record 5965) InvNo: Code[20];

    VAR
        InvoicedAmount: Decimal;
        InvoiceFrom: Date;
        InvoiceTo: Date;

    BEGIN
        ServContractToInvoice.TESTFIELD("Change Status", ServContractToInvoice."Change Status"::Locked);
        ServContractToInvoice.TESTFIELD("Contract Lines on Invoice", TRUE);
        //ServContractToInvoice.TESTFIELD("Invoice Generation",ServContractToInvoice."Invoice Generation"::"Single Invoice");
        // GetNextInvoicePeriod(ServContractToInvoice,InvoiceFrom,InvoiceTo);
        GetContractPeriod(ServContractToInvoice, InvoiceFrom, InvoiceTo);
        IF ServContractToInvoice.Prepaid THEN
            PostingDate := InvoiceFrom
        ELSE
            PostingDate := InvoiceTo;
        InvoicedAmount := SCM.CalcContractAmount(ServContractToInvoice, InvoiceFrom, InvoiceTo);

        IF InvoicedAmount = 0 THEN
            ERROR(Text007);
        // InvNo := CreateRemainingPeriodInvoice(ServContractToInvoice);
        //vInvdateFilter := FORMAT(InvoiceFrom) +'..'+FORMAT(InvoiceTo); //WIN-394

        IF InvNo = '' THEN
            InvNo := SCM.CreateServHeader(ServContractToInvoice, PostingDate, FALSE);

        IF InvoicingStartingPeriod THEN BEGIN
            SCM.GetNextInvoicePeriod(ServContractToInvoice, InvoiceFrom, InvoiceTo);
            PostingDate := InvoiceFrom;
            InvoicedAmount := SCM.CalcContractAmount(ServContractToInvoice, InvoiceFrom, InvoiceTo);
        END;

        IF NOT SCM.CheckIfServiceExist(ServContractToInvoice) THEN
            ERROR(
              Text010,
              ServContractToInvoice."Contract No.",
              ServContractToInvoice.FIELDCAPTION("Invoice after Service"));

        SCM.CreateAllServLines(InvNo, ServContractToInvoice);
    END;



    PROCEDURE NoOfMonthsAndMPartsInPeriodForSingleInv(Day1: Date; Day2: Date) MonthsAndMParts: Decimal;
    VAR
        WDate: Date;
        OldWDate: Date;
    BEGIN
        IF Day1 > Day2 THEN
            EXIT;
        IF (Day1 = 0D) OR (Day2 = 0D) THEN
            EXIT;
        MonthsAndMParts := 0;

        // WDate := CALCDATE('<-CM>',Day1); // WIN210
        WDate := Day1; // WIN210
        REPEAT
            OldWDate := CALCDATE('<+1M-1D>', WDate); // WIN210
            IF WDate < Day1 THEN
                WDate := Day1;
            IF OldWDate > Day2 THEN
                OldWDate := Day2;
            // IF (WDate <> CALCDATE('<-CM>',WDate)) OR (OldWDate <> CALCDATE('<CM>',OldWDate)) THEN // WIN210
            IF (WDate <> WDate) OR (OldWDate <> CALCDATE('<+1M-1D>', WDate)) THEN // WIN210
                MonthsAndMParts := MonthsAndMParts +
                  (OldWDate - WDate + 1) / (CALCDATE('<CM>', OldWDate) - CALCDATE('<-CM>', WDate) + 1)
            ELSE
                MonthsAndMParts := MonthsAndMParts + 1;
            // WDate := CALCDATE('<CM>',OldWDate) + 1; // WIN210
            WDate := OldWDate + 1; // WIN210 // After Modification need to check for Cr Memo
            IF MonthsAndMParts <> ROUND(MonthsAndMParts, 1) THEN
                CheckMParts := TRUE;
        UNTIL WDate > Day2;
    END;

    //Win513++
    //PROCEDURE CreateServiceLedgerEntryForSingleInvoice(ServHeader2: Record 5900; ContractType: Integer; ContractNo: Code[20]; InvFrom: Date; InvTo: Date; SigningContract: Boolean; AddingNewLines: Boolean; LineNo: Integer) ReturnLedgerEntry: Integer;
    PROCEDURE CreateServiceLedgerEntryForSingleInvoice(ServHeader2: Record 5900; ContractType: Enum "Service Contract Type"; ContractNo: Code[20]; InvFrom: Date; InvTo: Date; SigningContract: Boolean; AddingNewLines: Boolean; LineNo: Integer) ReturnLedgerEntry: Integer;
    //Win513--
    VAR
        ServContractLine: Record 5964;
        ServContractHeader: Record 5965;
        Currency: Record 4;
        LastEntry: Integer;
        FirstLineEntry: Integer;
        NoOfPayments: Integer;
        DueDate: Date;
        Days: Integer;
        InvTo2: Date;
        LineInvFrom: Date;
        PartInvFrom: Date;
        PartInvTo: Date;
        NewInvFrom: Date;
        NextInvDate: Date;
        ProcessSigningSLECreation: Boolean;
        NonDistrAmount: ARRAY[4] OF Decimal;
        InvAmount: ARRAY[4] OF Decimal;
        InvRoundedAmount: ARRAY[4] OF Decimal;
        CountOfEntryLoop: Integer;
        YearContractCorrection: Boolean;
        ServiceContractHeaderFound: Boolean;
    BEGIN

        ServiceContractHeaderFound := ServContractHeader.GET(ContractType, ContractNo);
        IF NOT ServiceContractHeaderFound OR (ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None) THEN
            EXIT;

        ServContractHeader.CALCFIELDS("Calcd. Annual Amount");
        SCM.CheckServiceContractHeaderAmts(ServContractHeader);
        Currency.InitRoundingPrecision;
        ReturnLedgerEntry := NextEntry;
        CLEAR(ServLedgEntry);
        SCM.InitServLedgEntry(ServLedgEntry, ServContractHeader, ServHeader2."No.");
        CLEAR(NonDistrAmount);
        CLEAR(InvAmount);
        CLEAR(InvRoundedAmount);

        IF ServContractHeader.Prepaid AND NOT SigningContract THEN BEGIN
            ServLedgEntry."Moved from Prepaid Acc." := FALSE;
            FirstLineEntry := NextEntry;
            OldFirstLineEntryNo := FirstLineEntry;
            //Win513++
            // SCM.FilterServContractLine(
            //   ServContractLine, ServContractHeader."Contract No.", ServContractHeader."Contract Type", LineNo);
            SCM.FilterServiceContractLine(
              ServContractLine, ServContractHeader."Contract No.", ServContractHeader."Contract Type", LineNo);
            //Win513--
            IF AddingNewLines THEN
                ServContractLine.SETRANGE("New Line", TRUE)
            ELSE
                ServContractLine.SETFILTER("Starting Date", '<=%1|%2..%3', ServContractHeader."Next Invoice Date",
                  ServContractHeader."Next Invoice Period Start", ServContractHeader."Next Invoice Period End");
            IF ServContractLine.FIND('-') THEN BEGIN
                REPEAT
                    YearContractCorrection := FALSE;
                    Days := 0;
                    // WDate := CALCDATE('<-CM>',InvFrom);
                    WDate := InvFrom; // WIN210 // Added for generation of correct Single invoice.
                    IF (InvFrom <= ServContractLine."Contract Expiration Date") OR
                       (ServContractLine."Contract Expiration Date" = 0D)
                    THEN BEGIN
                        NoOfPayments := 0;
                        REPEAT
                            NoOfPayments := NoOfPayments + 1;
                            WDate := CALCDATE('<1M>', WDate);
                        UNTIL (WDate >= InvTo) OR
                              ((WDate > ServContractLine."Contract Expiration Date") AND
                               (ServContractLine."Contract Expiration Date" <> 0D));
                        CountOfEntryLoop := NoOfPayments;

                        // Partial period ranged by "Starting Date" and end of month. Full period is shifted by one month
                        IF ServContractLine."Starting Date" > InvFrom THEN BEGIN
                            Days := CALCDATE('<CM>', InvFrom) - ServContractLine."Starting Date";
                            PartInvFrom := ServContractLine."Starting Date";
                            PartInvTo := CALCDATE('<CM>', InvFrom);
                            InvFrom := PartInvFrom;
                            NewInvFrom := CALCDATE('<CM+1D>', InvFrom);
                            CountOfEntryLoop := CountOfEntryLoop - 1;
                            NoOfPayments := NoOfPayments - 1;
                        END;

                        IF ServContractLine."Contract Expiration Date" <> 0D THEN
                            IF CALCDATE('<1D>', ServContractLine."Contract Expiration Date") < WDate THEN
                                IF Days = 0 THEN BEGIN
                                    Days := DATE2DMY(ServContractLine."Contract Expiration Date", 1);
                                    CountOfEntryLoop := CountOfEntryLoop - 1;
                                    PartInvFrom := CALCDATE('<-CM>', ServContractLine."Contract Expiration Date");
                                    PartInvTo := ServContractLine."Contract Expiration Date";
                                END ELSE
                                    IF ServContractLine."Contract Expiration Date" < PartInvTo THEN BEGIN
                                        // Partial period ranged by "Starting Date" from the beginning and "Contract Expiration Date" from the end

                                        PartInvTo := ServContractLine."Contract Expiration Date";
                                        Days := PartInvTo - PartInvFrom;
                                        CountOfEntryLoop := 0;
                                    END ELSE BEGIN

                                        // Post previous partial period before new one with Contract Expiration Date
                                        PostPartialServLedgEntry(
                                          InvRoundedAmount, ServContractLine, ServHeader2, PartInvFrom, PartInvTo,
                                          ServContractHeader."Next Invoice Date", Currency."Amount Rounding Precision");
                                        Days := DATE2DMY(ServContractLine."Contract Expiration Date", 1);
                                        CountOfEntryLoop := CountOfEntryLoop - 1;
                                        NoOfPayments := NoOfPayments - 1;
                                        PartInvFrom := CALCDATE('<-CM>', ServContractLine."Contract Expiration Date");
                                        PartInvTo := ServContractLine."Contract Expiration Date";
                                    END;

                        WDate := InvTo;
                        IF (WDate > ServContractLine."Contract Expiration Date") AND
                           (ServContractLine."Contract Expiration Date" <> 0D)
                        THEN
                            WDate := ServContractLine."Contract Expiration Date";

                        DueDate := WDate;
                        // Calculate invoice amount for initial period and go ahead with shifted InvFrom
                        SCM.CalcInvAmounts(InvAmount, ServContractLine, InvFrom, WDate);
                        IF NewInvFrom = 0D THEN
                            NextInvDate := ServContractHeader."Next Invoice Date"
                        ELSE BEGIN
                            InvFrom := NewInvFrom;
                            NextInvDate := CALCDATE('<1M>', ServContractHeader."Next Invoice Date");
                        END;


                        InsertMultipleServLedgEntriesForSingleInv(
                          NoOfPayments, DueDate, NonDistrAmount, InvRoundedAmount, ServHeader2, InvFrom, NextInvDate,
                          AddingNewLines, CountOfEntryLoop, ServContractLine, Currency."Amount Rounding Precision");
                        IF (Days = 0) OR (ServContractHeader."Invoice Period"::Other = ServContractHeader."Invoice Period"::Other) THEN  //win271119
                            YearContractCorrection := FALSE
                        ELSE
                            YearContractCorrection :=
                              PostPartialServLedgEntry(
                                InvRoundedAmount, ServContractLine, ServHeader2,
                                PartInvFrom, PartInvTo, PartInvFrom, Currency."Amount Rounding Precision");
                        //MESSAGE('Out Entry No.'+FORMAT(ServLedgEntry."Entry No.")); // WIN210 Temp   //win271119
                        LastEntry := ServLedgEntry."Entry No.";
                        SCM.CalcInvoicedToDate(ServContractLine, InvFrom, InvTo);
                        ServContractLine.MODIFY;
                    END ELSE BEGIN
                        YearContractCorrection := FALSE;
                        ReturnLedgerEntry := 0;
                    END;
                UNTIL ServContractLine.NEXT = 0;
                UpdateApplyUntilEntryNoInServLedgEntry(ReturnLedgerEntry, FirstLineEntry, LastEntry);
            END;
        END ELSE BEGIN
            YearContractCorrection := FALSE;
            ServLedgEntry."Moved from Prepaid Acc." := TRUE;
            ServLedgEntry."Posting Date" := ServHeader2."Posting Date";
            //Win513++
            // SCM.FilterServContractLine(
            //   ServContractLine, ServContractHeader."Contract No.", ServContractHeader."Contract Type", LineNo);
            SCM.FilterServiceContractLine(
              ServContractLine, ServContractHeader."Contract No.", ServContractHeader."Contract Type", LineNo);
            //Win513++
            IF AddingNewLines THEN
                ServContractLine.SETRANGE("New Line", TRUE)
            ELSE
                IF NOT SigningContract THEN BEGIN
                    IF ServContractHeader."Last Invoice Date" <> 0D THEN
                        ServContractLine.SETFILTER("Invoiced to Date", '%1|%2', ServContractHeader."Last Invoice Date", 0D)
                    ELSE
                        ServContractLine.SETRANGE("Invoiced to Date", 0D);
                    ServContractLine.SETFILTER("Starting Date", '<=%1|%2..%3', InvFrom,
                      ServContractHeader."Next Invoice Period Start", ServContractHeader."Next Invoice Period End");
                END ELSE
                    ServContractLine.SETFILTER("Starting Date", '<=%1', InvTo);
            FirstLineEntry := NextEntry;
            InvTo2 := InvTo;
            IF ServContractLine.FIND('-') THEN BEGIN
                REPEAT
                    IF SigningContract THEN BEGIN
                        IF ServContractLine."Invoiced to Date" = 0D THEN
                            ProcessSigningSLECreation := TRUE
                        ELSE
                            IF (ServContractLine."Invoiced to Date" <> 0D) AND
                               (ServContractLine."Invoiced to Date" <> CALCDATE('<CM>', ServContractLine."Invoiced to Date"))
                            THEN
                                ProcessSigningSLECreation := TRUE
                    END ELSE
                        ProcessSigningSLECreation := TRUE;
                    IF ((InvFrom <= ServContractLine."Contract Expiration Date") OR
                        (ServContractLine."Contract Expiration Date" = 0D)) AND ProcessSigningSLECreation
                    THEN BEGIN
                        IF (ServContractLine."Contract Expiration Date" >= InvFrom) AND
                           (ServContractLine."Contract Expiration Date" < InvTo)
                        THEN
                            InvTo := ServContractLine."Contract Expiration Date";
                        ServLedgEntry."Service Item No. (Serviced)" := ServContractLine."Service Item No.";
                        ServLedgEntry."Item No. (Serviced)" := ServContractLine."Item No.";
                        ServLedgEntry."Serial No. (Serviced)" := ServContractLine."Serial No.";
                        LineInvFrom := CountLineInvFrom(SigningContract, ServContractLine, InvFrom);
                        IF (LineInvFrom <> 0D) AND (LineInvFrom <= InvTo) THEN BEGIN
                            SCM.SetServLedgEntryAmounts(
                              ServLedgEntry, InvRoundedAmount,
                              -SCM.CalcContractLineAmount(ServContractLine."Line Amount", LineInvFrom, InvTo),
                              -SCM.CalcContractLineAmount(ServContractLine."Line Value", LineInvFrom, InvTo),
                              SCM.CalcContractLineAmount(ServContractLine."Line Cost", LineInvFrom, InvTo),
                              SCM.CalcContractLineAmount(ServContractLine."Line Discount Amount", LineInvFrom, InvTo),
                              Currency."Amount Rounding Precision");
                            ServLedgEntry."Cost Amount" := ServLedgEntry."Unit Cost" * ServLedgEntry."Charged Qty.";
                            SCM.UpdateServLedgEntryAmount(ServLedgEntry, ServHeader2);
                            ServLedgEntry."Entry No." := NextEntry;
                            SCM.CalcInvAmounts(InvAmount, ServContractLine, LineInvFrom, InvTo);
                            ServLedgEntry.INSERT;

                            LastEntry := ServLedgEntry."Entry No.";
                            NextEntry := NextEntry + 1;
                            InvTo := InvTo2;
                        END ELSE
                            ReturnLedgerEntry := 0;
                        SCM.CalcInvoicedToDate(ServContractLine, InvFrom, InvTo);
                        ServContractLine.MODIFY;
                    END ELSE
                        ReturnLedgerEntry := 0;
                UNTIL ServContractLine.NEXT = 0;
                UpdateApplyUntilEntryNoInServLedgEntry(ReturnLedgerEntry, FirstLineEntry, LastEntry);
            END;
        END;
        IF ServLedgEntry.GET(LastEntry) AND (NOT YearContractCorrection)
        THEN BEGIN
            ServLedgEntry."Amount (LCY)" := ServLedgEntry."Amount (LCY)" + InvRoundedAmount[AmountType::Amount] -
              ROUND(InvAmount[AmountType::Amount], Currency."Amount Rounding Precision");
            ServLedgEntry."Unit Price" := ServLedgEntry."Unit Price" + InvRoundedAmount[AmountType::UnitPrice] -
              ROUND(InvAmount[AmountType::UnitPrice], Currency."Unit-Amount Rounding Precision");
            ServLedgEntry."Cost Amount" := ServLedgEntry."Cost Amount" + InvRoundedAmount[AmountType::UnitCost] -
              ROUND(InvAmount[AmountType::UnitCost], Currency."Amount Rounding Precision");
            SCM.SetServiceLedgerEntryUnitCost(ServLedgEntry);
            ServLedgEntry."Contract Disc. Amount" :=
              ServLedgEntry."Contract Disc. Amount" - InvRoundedAmount[AmountType::DiscAmount] +
              ROUND(InvAmount[AmountType::DiscAmount], Currency."Amount Rounding Precision");
            ServLedgEntry."Discount Amount" := ServLedgEntry."Contract Disc. Amount";
            SCM.CalcServLedgEntryDiscountPct(ServLedgEntry);
            SCM.UpdateServLedgEntryAmount(ServLedgEntry, ServHeader2);
            ServLedgEntry.MODIFY;
        END;
    END;

    PROCEDURE CreateDefferalInvoice(ServContractToInvoice: Record 5965) InvNo: Code[20];
    VAR
        InvoicedAmount: Decimal;
        InvoiceFrom: Date;
        InvoiceTo: Date;
    BEGIN
        IF ServContractToInvoice."Defferral Invoice Posted" THEN
            EXIT;
        DefferralInv := TRUE;
        ServContractToInvoice.TESTFIELD("Change Status", ServContractToInvoice."Change Status"::Locked);
        ServContractToInvoice.TESTFIELD("Contract Lines on Invoice", TRUE);
        ServContractToInvoice.TESTFIELD("Invoice Generation", ServContractToInvoice."Invoice Generation"::"Multiple Invoice");
        GetContractPeriod(ServContractToInvoice, InvoiceFrom, InvoiceTo);
        IF ServContractToInvoice.Prepaid THEN
            PostingDate := InvoiceFrom
        ELSE
            PostingDate := InvoiceTo;
        InvoicedAmount := SCM.CalcContractAmount(ServContractToInvoice, InvoiceFrom, InvoiceTo);

        IF InvoicedAmount = 0 THEN
            ERROR(Text007);
        // InvNo := CreateRemainingPeriodInvoice(ServContractToInvoice);

        IF InvNo = '' THEN
            InvNo := SCM.CreateServHeader(ServContractToInvoice, PostingDate, FALSE);

        IF NOT SCM.CheckIfServiceExist(ServContractToInvoice) THEN
            ERROR(
              Text010,
              ServContractToInvoice."Contract No.",
              ServContractToInvoice.FIELDCAPTION("Invoice after Service"));

        SCM.CreateAllServLines(InvNo, ServContractToInvoice);
    END;

    PROCEDURE CreateSingleContractLineCreditMemo(VAR FromContractLine: Record 5964; Deleting: Boolean) CreditMemoNo: Code[20];
    VAR
        ServItem: Record 5940;
        ServContractHeader: Record 5965;
        StdText: Record 7;
        Currency: Record 4;
        ServiceContract: Page 6050;
        ServiceCreditMemo: Page 5935;
        ServiceInvoice: Page 5933;
        CreditAmount: Decimal;
        FirstPrepaidPostingDate: Date;
        LastIncomePostingDate: Date;
        WDate: Date;
        LineDescription: Text[50];
    BEGIN
        CreditMemoNo := '';
        //Win513++
        //WITH FromContractLine DO BEGIN
        //Win513--
        ServContractHeader.GET(FromContractLine."Contract Type", FromContractLine."Contract No.");
        FromContractLine.TESTFIELD("Contract Expiration Date");
        FromContractLine.TESTFIELD("Credit Memo Date");
        ServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
        ServContractAccGr.GET(ServContractHeader."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
        GlAcc.GET(ServContractAccGr."Non-Prepaid Contract Acc.");
        GlAcc.TESTFIELD("Direct Posting");
        IF ServContractHeader.Prepaid THEN BEGIN
            ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
            GlAcc.GET(ServContractAccGr."Prepaid Contract Acc.");
            GlAcc.TESTFIELD("Direct Posting");
        END;

        Currency.InitRoundingPrecision;

        IF FromContractLine."Line Amount" > 0 THEN BEGIN
            ServMgtSetup.GET;
            IF ServMgtSetup."Contract Credit Line Text Code" <> '' THEN BEGIN
                StdText.GET(ServMgtSetup."Contract Credit Line Text Code");
                LineDescription := COPYSTR(STRSUBSTNO('%1 %2', StdText.Description, FromContractLine."Service Item No."), 1, 50);
            END ELSE
                IF FromContractLine."Service Item No." <> '' THEN
                    LineDescription := COPYSTR(STRSUBSTNO(Text005, ServItem.TABLECAPTION, FromContractLine."Service Item No."), 1, 50)
                ELSE
                    LineDescription := COPYSTR(STRSUBSTNO(Text005, FromContractLine.TABLECAPTION, FromContractLine."Line No."), 1, 50);
            IF FromContractLine."Invoiced to Date" >= FromContractLine."Contract Expiration Date" THEN BEGIN
                IF ServContractHeader.Prepaid THEN BEGIN
                    FirstPrepaidPostingDate := SCM.FindFirstPrepaidTransaction(FromContractLine."Contract No.");
                END ELSE
                    FirstPrepaidPostingDate := 0D;

                LastIncomePostingDate := FromContractLine."Invoiced to Date";
                IF FirstPrepaidPostingDate <> 0D THEN
                    LastIncomePostingDate := FirstPrepaidPostingDate - 1;
                // WDate := "Contract Expiration Date"; // To Reverse Entire Invoice Amt
                // WDate := "Starting Date";
                IF GlbSingleCrMemo THEN
                    WDate := GlbContractStartDate
                ELSE
                    WDate := ServContractHeader."Termination Date" + 1;
                CreditAmount :=
                  ROUND(
                    SCM.CalcContractLineAmount(FromContractLine."Line Amount",
                      WDate, FromContractLine."Invoiced to Date"),
                    Currency."Amount Rounding Precision");
                CrAmttoDefer := CreditAmount;    //win-271119
                IF CreditAmount > 0 THEN BEGIN
                    CreditMemoNo := CreateOrGetCreditHeader(ServContractHeader, FromContractLine."Credit Memo Date");
                    CreateAllCreditLines(
                      CreditMemoNo,
                      FromContractLine."Line Amount",
                      WDate,
                      FromContractLine."Invoiced to Date",
                      LineDescription,
                      FromContractLine."Service Item No.",
                      FromContractLine."Item No.",
                      ServContractHeader,
                      FromContractLine."Line Cost",
                      FromContractLine."Line Value",
                      LastIncomePostingDate,
                      FromContractLine."Starting Date")
                END;
            END;
        END;
        IF (CreditMemoNo <> '') AND NOT Deleting THEN BEGIN
            FromContractLine.Credited := TRUE;
            FromContractLine.MODIFY;
        END;
        //Win513++
        //END;
        //Win513--
    END;

    PROCEDURE InsertMultipleServLedgEntriesForSingleInv(VAR NoOfPayments: Integer; VAR DueDate: Date; VAR NonDistrAmount: ARRAY[4] OF Decimal; VAR InvRoundedAmount: ARRAY[4] OF Decimal; VAR ServHeader: Record 5900; InvFrom: Date; NextInvDate: Date; AddingNewLines: Boolean; CountOfEntryLoop: Integer; ServContractLine: Record 5964; AmountRoundingPrecision: Decimal);
    VAR
        ServContractHeader: Record 5965;
        Index: Integer;
        Divisor: Integer;
        LoopStartDate: Date;
        LoopEndDate: Date;
        Days: Integer;
        Currency: Record 4;
        InvPeriod: Integer;
        i: Integer;
        AppliedLineAmount: Decimal;
        AppliedLineCost: Decimal;
        AppliedLineUnitCost: Decimal;
        TotalAmt: Decimal;
        ServiceLedgerEntry: Record "Service Ledger Entry";
        EntryNo: Integer;
    BEGIN
        //Supriya
        if ServiceLedgerEntry.FindLast() then
            NextEntry := ServiceLedgerEntry."Entry No." + 1;

        // Loop Start Date
        LoopStartDate := InvFrom;
        LoopEndDate := DueDate;
        ServContractHeader.GET(ServContractLine."Contract Type", ServContractLine."Contract No.");
        Days := DATE2DMY(LoopStartDate, 1);
        Currency.InitRoundingPrecision;
        IF ServContractHeader.Prepaid THEN
            InvPeriod := 1
        ELSE
            CASE ServContractHeader."Invoice Period" OF
                ServContractHeader."Invoice Period"::Month:
                    InvPeriod := 1;
                ServContractHeader."Invoice Period"::"Two Months":
                    InvPeriod := 2;
                ServContractHeader."Invoice Period"::Quarter:
                    InvPeriod := 3;
                ServContractHeader."Invoice Period"::"Half Year":
                    InvPeriod := 6;
                ServContractHeader."Invoice Period"::Year:
                    InvPeriod := 12;
                ServContractHeader."Invoice Period"::Other:
                    InvPeriod := ServContractHeader.FindNoOfMonths(ServContractHeader."Starting Date", ServContractHeader."Expiration Date");  //win-271119
                ServContractHeader."Invoice Period"::None:
                    InvPeriod := 0;
            END;
        ServLedgEntry."Service Item No. (Serviced)" := ServContractLine."Service Item No.";
        ServLedgEntry."Item No. (Serviced)" := ServContractLine."Item No.";
        ServLedgEntry."Serial No. (Serviced)" := ServContractLine."Serial No.";

        REPEAT
            LoopEndDate := CALCDATE('<CM>', LoopStartDate);
            IF Days <> 1 THEN
                Days := 1
            ELSE BEGIN
                FOR i := 1 TO InvPeriod DO
                    LoopEndDate := CALCDATE('<CM>', LoopEndDate) + 1;
                LoopEndDate := LoopEndDate - 1;
            END;
            IF LoopEndDate >= InvFrom THEN BEGIN
                IF LoopStartDate < InvFrom THEN
                    LoopStartDate := InvFrom;
                IF LoopEndDate > DueDate THEN
                    LoopEndDate := DueDate;

                NonDistrAmount[AmountType::Amount] :=
                  -ROUND(SCM.CalcContractLineAmount(ServContractLine."Line Amount", LoopStartDate, LoopEndDate), Currency."Amount Rounding Precision");
                NonDistrAmount[AmountType::UnitPrice] :=
                  -ROUND(SCM.CalcContractLineAmount(ServContractLine."Line Value", LoopStartDate, LoopEndDate), Currency."Amount Rounding Precision");
                NonDistrAmount[AmountType::UnitCost] :=
                  ROUND(SCM.CalcContractLineAmount(ServContractLine."Line Cost", LoopStartDate, LoopEndDate), Currency."Amount Rounding Precision");
                NonDistrAmount[AmountType::DiscAmount] :=
                  ROUND(SCM.CalcContractLineAmount(ServContractLine."Line Discount Amount", LoopStartDate, LoopEndDate), Currency."Amount Rounding Precision");
                SCM.SetServLedgEntryAmounts(
                  ServLedgEntry, InvRoundedAmount,
                  NonDistrAmount[AmountType::Amount],
                  NonDistrAmount[AmountType::UnitPrice],
                  NonDistrAmount[AmountType::UnitCost],
                  NonDistrAmount[AmountType::DiscAmount],
                  AmountRoundingPrecision);
            END;

            ServLedgEntry."Entry No." := NextEntry;
            SCM.UpdateServLedgEntryAmount(ServLedgEntry, ServHeader);
            ServLedgEntry."Posting Date" := LoopStartDate;
            ServLedgEntry.Prepaid := TRUE;
            ServLedgEntry.INSERT;
            NextEntry += 1;
            LoopStartDate := CALCDATE('<CM>', LoopEndDate) + 1;
        UNTIL (LoopEndDate >= DueDate);
        // Loop End Date
    END;



    PROCEDURE SetCreditMemo(SingleCreditMemo: Boolean; ContractStartDate: Date; ContractDealDate: Date);
    BEGIN
        GlbSingleCrMemo := SingleCreditMemo;
        GlbContractStartDate := ContractStartDate;
        GlbDealDate := ContractDealDate;
    END;

    Procedure CreateOrGetCreditHeader(ServContract: Record "Service Contract Header"; CrMemoDate: Date) ServInvoiceNo: Code[20]
    var

        GLSetup: Record "General Ledger Setup";
        ServHeader2: Record "Service Header";
        Cust: Record Customer;
        ServDocReg: Record "Service Document Register";
        CurrExchRate: Record "Currency Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
        CreditMemoForm: Page "Service Credit Memo";
        ServContractForm: Page "Service Contract";
        LocationCode: Code[10];
        DeferralHeader: Record "Deferral Header";
    Begin
        CLEAR(ServHeader2);
        ServDocReg.RESET;
        ServDocReg.SETRANGE("Source Document Type", ServDocReg."Source Document Type"::Contract);
        ServDocReg.SETRANGE("Source Document No.", ServContract."Contract No.");
        ServDocReg.SETRANGE("Destination Document Type", ServDocReg."Destination Document Type"::"Credit Memo");
        ServInvoiceNo := '';
        IF ServDocReg.FIND('-') THEN
            REPEAT
                ServInvoiceNo := ServDocReg."Destination Document No.";
            UNTIL (ServDocReg.NEXT = 0) OR (ServDocReg."Destination Document No." <> '');

        IF ServInvoiceNo <> '' THEN BEGIN
            ServHeader2.GET(ServHeader2."Document Type"::"Credit Memo", ServInvoiceNo);
            Cust.GET(ServHeader2."Bill-to Customer No.");
            LocationCode := UserMgt.GetLocation(2, Cust."Location Code", ServContract."Responsibility Center");
            IF ServHeader2."Location Code" <> LocationCode THEN
                IF NOT CONFIRM(
                     STRSUBSTNO(
                       Text015,
                       ServHeader2.FIELDCAPTION("Location Code"),
                       ServHeader2."Location Code",
                       CreditMemoForm.CAPTION,
                       ServInvoiceNo,
                       ServContractForm.CAPTION,
                       ServContract."Contract No.",
                       LocationCode))
                THEN
                    ERROR('');
            EXIT;
        END;

        CLEAR(ServHeader2);
        ServHeader2.INIT;
        ServHeader2.SetHideValidationDialog(TRUE);
        ServHeader2."Document Type" := ServHeader2."Document Type"::"Credit Memo";
        ServMgtSetup.GET;
        ServMgtSetup.TESTFIELD("Contract Credit Memo Nos.");
        NoSeriesMgt.InitSeries(
          ServMgtSetup."Contract Credit Memo Nos.", ServHeader2."No. Series", 0D,
          ServHeader2."No.", ServHeader2."No. Series");
        ServHeader2.INSERT(TRUE);
        ServInvoiceNo := ServHeader2."No.";

        GLSetup.GET;
        ServHeader2.Correction := GLSetup."Mark Cr. Memos as Corrections";
        ServHeader2."Posting Description" := FORMAT(ServHeader2."Document Type") + ' ' + ServHeader2."No.";
        ServHeader2.VALIDATE("Bill-to Customer No.", ServContract."Bill-to Customer No.");
        ServHeader2."Prices Including VAT" := FALSE;
        ServHeader2."Customer No." := ServContract."Customer No.";
        ServHeader2."Responsibility Center" := ServContract."Responsibility Center";
        Cust.GET(ServHeader2."Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, ServHeader2."Document Type", FALSE, FALSE);
        Cust.TESTFIELD("Gen. Bus. Posting Group");
        ServHeader2.Name := Cust.Name;
        ServHeader2."Name 2" := Cust."Name 2";
        ServHeader2.Address := Cust.Address;
        ServHeader2."Address 2" := Cust."Address 2";
        ServHeader2.City := Cust.City;
        ServHeader2."Post Code" := Cust."Post Code";
        ServHeader2.County := Cust.County;
        ServHeader2."Country/Region Code" := Cust."Country/Region Code";
        ServHeader2."Contact Name" := ServContract."Contact Name";
        ServHeader2."Contact No." := ServContract."Contact No.";
        ServHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No." THEN
            ServHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
        ServHeader2.VALIDATE("Ship-to Code", ServContract."Ship-to Code");
        IF CrMemoDate <> 0D THEN
            ServHeader2.VALIDATE("Posting Date", CrMemoDate)
        ELSE
            ServHeader2.VALIDATE("Posting Date", WORKDATE);
        IF GlbSingleCrMemo THEN // For Posting Single Cr Memo for Contract
            ServHeader2.VALIDATE("Posting Date", GlbDealDate); // For Posting Single Cr Memo for Contract
        ServHeader2."Contract No." := ServContract."Contract No.";
        ServHeader2."Currency Code" := ServContract."Currency Code";
        ServHeader2."Currency Factor" :=
          CurrExchRate.ExchangeRate(
            ServHeader2."Posting Date", ServHeader2."Currency Code");
        ServHeader2."Payment Terms Code" := ServContract."Payment Terms Code";
        ServHeader2."Your Reference" := ServContract."Your Reference";
        ServHeader2."Salesperson Code" := ServContract."Salesperson Code";
        ServHeader2."Shortcut Dimension 1 Code" := ServContract."Shortcut Dimension 1 Code";
        ServHeader2."Shortcut Dimension 2 Code" := ServContract."Shortcut Dimension 2 Code";
        ServHeader2."Dimension Set ID" := ServContract."Dimension Set ID";
        // WIN210
        IF GlbSingleCrMemo THEN
            ServHeader2.VALIDATE("Payment Method Code", 'PDC');
        // WIN210
        ServHeader2.VALIDATE("Location Code",
          UserMgt.GetLocation(2, Cust."Location Code", ServContract."Responsibility Center"));
        ServHeader2."Defferal Code" := ServContract."Defferal Code"; // To Reverse Defferral
        ServHeader2.MODIFY;

        CLEAR(ServDocReg);
        //Win513++
        // ServDocReg.InsertServSalesDocument(
        //   ServDocReg."Source Document Type"::Contract,
        //   ServContract."Contract No.",
        //   ServDocReg."Destination Document Type"::"Credit Memo",
        //   ServHeader2."No.");
        ServDocReg.InsertServiceSalesDocument(
        ServDocReg."Source Document Type"::Contract,
        ServContract."Contract No.",
        ServDocReg."Destination Document Type"::"Credit Memo",
        ServHeader2."No.");
        //Win513--

        //WINS-PPG Start<<create schedule header for service invoice manually when service invoice is created from service contract
        IF ServHeader2."Defferal Code" <> '' THEN BEGIN
            IF NOT DeferralHeader.GET(2, '', '', ServHeader2."Document Type", ServHeader2."No.", 0) THEN BEGIN
                // Need to create the header record.
                //Win513++
                //DeferralHeader."Deferral Doc. Type" := 2;
                DeferralHeader."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type"::Sales;
                //Win513--
                DeferralHeader."Gen. Jnl. Template Name" := '';
                DeferralHeader."Gen. Jnl. Batch Name" := '';
                DeferralHeader."Document Type" := 0;
                DeferralHeader."Document No." := ServHeader2."No.";
                DeferralHeader."Line No." := 0;
                DeferralHeader.INSERT;
            END;
            //realestatecr

            DeferralHeader."Amount to Defer" := CrAmttoDefer;                         //win-27/11/19
                                                                                      // DeferralHeader."Start Date" := ServContract2."Next Invoice Date";
            DeferralHeader."Start Date" := ServContract."Starting Date";
            DeferralTemplate.RESET;
            DeferralTemplate.GET(ServHeader2."Defferal Code");
            DeferralHeader."Calc. Method" := DeferralTemplate."Calc. Method";
            ;
            DeferralHeader."No. of Periods" := DeferralTemplate."No. of Periods";
            DeferralHeader."Schedule Description" := DeferralTemplate."Period Description";
            DeferralHeader."Deferral Code" := DeferralTemplate."Deferral Code";
            DeferralHeader."Currency Code" := ServContract."Currency Code";
            DeferralHeader.MODIFY;
        END;
    End;

    Procedure CreateAllCreditLines(CreditNo: Code[20]; ContractLineAmount: Decimal; PeriodStarts: Date; PeriodEnds: Date; LineDescription: Text[50]; ServItemNo: Code[20]; ItemNo: Code[20]; ServContract: Record "Service Contract Header"; ContractLineCost: Decimal; ContractLineUnitPrice: Decimal; LastIncomePostingDate: Date; ContractLineStartingDate: Date)
    var
        Currency: Record Currency;
        ServContractAccGr: Record "Service Contract Account Group";
        AccountNo: Code[20];
        WDate: Date;
        OldWDate: Date;
        i: Integer;
        Days: Integer;
        InvPeriod: Integer;
        AppliedCreditLineAmount: Decimal;
        AppliedCreditLineCost: Decimal;
        AppliedCreditLineUnitCost: Decimal;
        AppliedCreditLineDiscAmount: Decimal;
        ApplyServiceLedgerEntryAmounts: Boolean;
        ServLedgEntryNo: Integer;




    Begin
        Days := DATE2DMY(ContractLineStartingDate, 1);
        Currency.InitRoundingPrecision;
        IF ServContract.Prepaid THEN
            InvPeriod := 1
        ELSE
            CASE ServContract."Invoice Period" OF
                ServContract."Invoice Period"::Month:
                    InvPeriod := 1;
                ServContract."Invoice Period"::"Two Months":
                    InvPeriod := 2;
                ServContract."Invoice Period"::Quarter:
                    InvPeriod := 3;
                ServContract."Invoice Period"::"Half Year":
                    InvPeriod := 6;
                ServContract."Invoice Period"::Year:
                    InvPeriod := 12;
                ServContract."Invoice Period"::None:
                    InvPeriod := 0;
            END;
        ServContract.TESTFIELD("Serv. Contract Acc. Gr. Code");
        ServContractAccGr.GET(ServContract."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
        WDate := ContractLineStartingDate;
        REPEAT
            OldWDate := CALCDATE('<CM>', WDate);
            IF Days <> 1 THEN
                Days := 1
            ELSE BEGIN
                FOR i := 1 TO InvPeriod DO
                    OldWDate := CALCDATE('<CM>', OldWDate) + 1;
                OldWDate := OldWDate - 1;
            END;
            IF OldWDate >= PeriodStarts THEN BEGIN
                IF WDate < PeriodStarts THEN
                    WDate := PeriodStarts;
                IF OldWDate > PeriodEnds THEN
                    OldWDate := PeriodEnds;
                IF OldWDate > LastIncomePostingDate THEN
                    AccountNo := ServContractAccGr."Prepaid Contract Acc."
                ELSE
                    AccountNo := ServContractAccGr."Non-Prepaid Contract Acc.";
                ApplyServiceLedgerEntryAmounts :=
                  LookUpAmountToCredit(
                    ServContract,
                    ServItemNo,
                    ItemNo,
                    WDate,
                    AppliedCreditLineAmount,
                    AppliedCreditLineCost,
                    AppliedCreditLineUnitCost,
                    AppliedCreditLineDiscAmount,
                    ServLedgEntryNo);
                //IF NOT ApplyServiceLedgerEntryAmounts THEN BEGIN
                AppliedCreditLineAmount :=
                  ROUND(SCM.CalcContractLineAmount(ContractLineAmount, WDate, OldWDate), Currency."Amount Rounding Precision");
                AppliedCreditLineCost :=
                  ROUND(SCM.CalcContractLineAmount(ContractLineCost, WDate, OldWDate), Currency."Amount Rounding Precision");
                AppliedCreditLineUnitCost :=
                  ROUND(SCM.CalcContractLineAmount(ContractLineUnitPrice, WDate, OldWDate), Currency."Amount Rounding Precision");
                //END;
                CreateCreditLine(
                  CreditNo,
                  AccountNo,
                  AppliedCreditLineAmount,
                  WDate,
                  OldWDate,
                  LineDescription,
                  ServItemNo,
                  ServContract,
                  AppliedCreditLineCost,
                  AppliedCreditLineUnitCost,
                  AppliedCreditLineDiscAmount,
                  ApplyServiceLedgerEntryAmounts,
                  ServLedgEntryNo);
            END;
            WDate := CALCDATE('<CM>', OldWDate) + 1;
        UNTIL (OldWDate >= PeriodEnds);


    End;

    Procedure LookUpAmountToCredit(ServiceContractHeader: Record "Service Contract Header"; ServItemNo: Code[20]; ItemNo: Code[20]; PostingDate: Date; VAR LineAmount: Decimal; VAR CostAmount: Decimal; VAR UnitPrice: Decimal; VAR DiscountAmt: Decimal; VAR ServLedgEntryNo: Integer): Boolean
    var

        ServiceLedgerEntry: Record "Service Ledger Entry";
    begin
        LineAmount := 0;
        CostAmount := 0;
        UnitPrice := 0;
        DiscountAmt := 0;
        ServLedgEntryNo := 0;
        ServiceLedgerEntry.SETCURRENTKEY("Service Contract No.");
        ServiceLedgerEntry.SETRANGE("Service Contract No.", ServiceContractHeader."Contract No.");
        IF ServItemNo <> '' THEN
            ServiceLedgerEntry.SETRANGE("Service Item No. (Serviced)", ServItemNo);
        IF ItemNo <> '' THEN
            ServiceLedgerEntry.SETRANGE("Item No. (Serviced)", ItemNo);
        ServiceLedgerEntry.SETRANGE("Posting Date", PostingDate);
        IF NOT ServiceLedgerEntry.FINDFIRST THEN
            EXIT(FALSE);
        LineAmount := -ServiceLedgerEntry."Amount (LCY)";
        CostAmount := ServiceLedgerEntry."Cost Amount";
        UnitPrice := -ServiceLedgerEntry."Unit Price";
        DiscountAmt := ServiceLedgerEntry."Discount Amount";
        ServLedgEntryNo := ServiceLedgerEntry."Entry No.";
        EXIT(TRUE);
    end;

    /* LOCAL CheckServiceContractHeaderAmts(ServiceContractHeader: Record "Service Contract Header")
IF ServiceContractHeader."Calcd. Annual Amount" <> ServiceContractHeader."Annual Amount" THEN
  ERROR(
    Text000,
    ServLedgEntry2.TABLECAPTION,
    ServiceContractHeader."Contract No.",
    ServiceContractHeader.FIELDCAPTION("Calcd. Annual Amount"),
    ServiceContractHeader.FIELDCAPTION("Annual Amount")); */
    procedure CreateCreditLine(CreditNo: Code[20]; AccountNo: Code[20]; CreditAmount: Decimal; PeriodStarts: Date; PeriodEnds: Date; LineDescription: Text[50]; ServItemNo: Code[20]; ServContract: Record "Service Contract Header"; CreditCost: Decimal; CreditUnitPrice: Decimal; DiscAmount: Decimal; ApplyDiscAmt: Boolean; ServLedgEntryNo: Integer)
    var

        ServHeader2: Record "Service Header";

        ServLine2: Record "Service Line";
        Cust: Record Customer;
        DeFPostingDate: Date;
        DeferralLine: Record "Deferral Line";
        DeferralUtilities: Codeunit "Deferral Utilities";
        //Win513++
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    //Win513--
    begin
        ServHeader2.GET(ServHeader2."Document Type"::"Credit Memo", CreditNo);
        Cust.GET(ServHeader2."Bill-to Customer No.");

        CLEAR(ServLine2);
        ServLine2.SETRANGE("Document Type", ServHeader2."Document Type");
        ServLine2.SETRANGE("Document No.", CreditNo);
        IF ServLine2.FINDLAST THEN
            NextLine := ServLine2."Line No." + 10000
        ELSE
            NextLine := 10000;
        CLEAR(ServLine2);
        ServLine2.INIT;
        ServLine2."Document Type" := ServHeader2."Document Type";
        ServLine2."Document No." := ServHeader2."No.";
        //ServLine2.Type := ServLine2.Type::" ";
        //ServLine2.Description := STRSUBSTNO('%1 - %2',FORMAT(PeriodStarts),FORMAT(PeriodEnds));
        ServLine2."Line No." := NextLine;
        ServLine2."Posting Date" := PeriodStarts;
        //ServLine2.INSERT; // Not Require

        //NextLine := NextLine + 10000;
        ServLine2."Customer No." := ServHeader2."Customer No.";
        ServLine2."Location Code" := ServHeader2."Location Code";
        ServLine2."Shortcut Dimension 1 Code" := ServHeader2."Shortcut Dimension 1 Code";
        ServLine2."Shortcut Dimension 2 Code" := ServHeader2."Shortcut Dimension 2 Code";
        ServLine2."Dimension Set ID" := ServHeader2."Dimension Set ID";
        ServLine2."Gen. Bus. Posting Group" := ServHeader2."Gen. Bus. Posting Group";
        ServLine2."Transaction Specification" := ServHeader2."Transaction Specification";
        ServLine2."Transport Method" := ServHeader2."Transport Method";
        ServLine2."Exit Point" := ServHeader2."Exit Point";
        ServLine2.Area := ServHeader2.Area;
        ServLine2."Transaction Specification" := ServHeader2."Transaction Specification";
        ServLine2."Line No." := NextLine;
        ServLine2.Type := ServLine.Type::"G/L Account";
        ServLine2.VALIDATE("No.", AccountNo);
        IF ServContract."Invoice Generation" = ServContract."Invoice Generation"::"Single Invoice" THEN //win315
            ServLine2.VALIDATE("VAT Prod. Posting Group", ServContract."VAT Prod. Posting Group");  //win315
        ServLine2.VALIDATE(Quantity, 1);
        IF ServHeader2."Currency Code" <> '' THEN BEGIN
            ServLine2.VALIDATE("Unit Price", AmountToFCY(CreditUnitPrice, ServHeader2));
            ServLine2.VALIDATE("Line Amount", AmountToFCY(CreditAmount, ServHeader2));
        END ELSE BEGIN
            ServLine2.VALIDATE("Unit Price", CreditUnitPrice);
            ServLine2.VALIDATE("Line Amount", CreditAmount);
        END;
        //ServLine2.Description := LineDescription; // Not Require instead put Period Details
        ServLine2.Description := STRSUBSTNO('%1 - %2', FORMAT(PeriodStarts), FORMAT(PeriodEnds));
        ServLine2."Contract No." := ServContract."Contract No.";
        ServLine2."Service Item No." := ServItemNo;
        ServLine2."Appl.-to Service Entry" := ServLedgEntryNo;
        ServLine2."Unit Cost (LCY)" := CreditCost;
        ServLine2."Posting Date" := PeriodStarts;
        IF ApplyDiscAmt THEN
            ServLine2.VALIDATE("Line Discount Amount", DiscAmount);
        ServLine2.INSERT;

        NextLine := NextLine + 10000; // WIN210

        //Win513++
        //WITH ServLine2 DO
        //WITH ServLine2 DO

        // ServLine2.CreateDim(
        //   DimMgt.TypeToTableID5(ServLine2.Type), ServLine2."No.",
        //   DATABASE::Job, ServLine2."Job No.",
        //   DATABASE::"Responsibility Center", ServLine2."Responsibility Center");
        DimMgt.AddDimSource(DefaultDimSource, DimMgt.TypeToTableID5(ServLine2.Type.AsInteger()), ServLine2."No.");
        DimMgt.AddDimSource(DefaultDimSource, DATABASE::Job, ServLine2."Job No.");
        DimMgt.AddDimSource(DefaultDimSource, DATABASE::"Responsibility Center", ServLine2."Responsibility Center");

        servline2.CreateDim(DefaultDimSource);
        //Win513--
        //WINS-PPG start<<create schedule Line for service invoice manually when service invoice is created from service contract
        IF (ServHeader2."Defferal Code" <> '') THEN BEGIN
            DeFPostingDate := 0D;
            DeferralTemplate.RESET;
            DeferralTemplate.GET(ServHeader2."Defferal Code");
            DeferralLine.INIT;
            //Win513++
            //DeferralLine."Deferral Doc. Type" := 2;
            DeferralLine."Deferral Doc. Type" := DeferralLine."Deferral Doc. Type"::Sales;
            //Win513--
            DeferralLine."Gen. Jnl. Template Name" := '';
            DeferralLine."Gen. Jnl. Batch Name" := '';
            DeferralLine."Document Type" := 0;
            DeferralLine."Document No." := ServHeader2."No.";
            DeferralLine."Line No." := 0;
            DeferralLine."Currency Code" := ServHeader2."Currency Code";
            //DeferralLine.VALIDATE("Posting Date",InvFrom);

            DeFPostingDate := PeriodStarts;
            DeferralLine.VALIDATE("Posting Date", DeFPostingDate); // To get 1st Date of Next Period.
            DeferralLine.Description := DeferralUtilities.CreateRecurringDescription(PeriodStarts, DeferralTemplate."Period Description");
            DeferralLine.VALIDATE(Amount, ServLine2."Line Amount");
            DeferralLine.INSERT;
        END;
    end;

    procedure AmountToFCY(AmountLCY: Decimal; VAR ServHeader3: Record "Service Header"): Decimal
    var

        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    Begin
        Currency.GET(ServHeader3."Currency Code");
        Currency.TESTFIELD("Unit-Amount Rounding Precision");
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              ServHeader3."Posting Date", ServHeader3."Currency Code",
              AmountLCY, ServHeader3."Currency Factor"),
            Currency."Unit-Amount Rounding Precision"));
    End;

    procedure PostPartialServLedgEntry(VAR InvAmountRounded: ARRAY[4] OF Decimal; ServContractLine: Record "Service Contract Line"; ServHeader: Record "Service Header"; InvFrom: Date; InvTo: Date; DueDate: Date; AmtRoundingPrecision: Decimal) YearContractCorrection: Boolean
    var
    Begin
        ServLedgEntry."Service Item No. (Serviced)" := ServContractLine."Service Item No.";
        ServLedgEntry."Item No. (Serviced)" := ServContractLine."Item No.";
        ServLedgEntry."Serial No. (Serviced)" := ServContractLine."Serial No.";
        IF YearContract(ServContractLine."Contract Type", ServContractLine."Contract No.") THEN BEGIN
            YearContractCorrection := TRUE;
            CalcServLedgEntryAmounts(ServContractLine, InvAmountRounded);
            ServLedgEntry."Entry No." := NextEntry;
            SCM.UpdateServLedgEntryAmount(ServLedgEntry, ServHeader);
        END ELSE BEGIN
            YearContractCorrection := FALSE;
            SCM.SetServLedgEntryAmounts(
              ServLedgEntry, InvAmountRounded,
              -SCM.CalcContractLineAmount(ServContractLine."Line Amount", InvFrom, InvTo),
              -SCM.CalcContractLineAmount(ServContractLine."Line Value", InvFrom, InvTo),
              -SCM.CalcContractLineAmount(ServContractLine."Line Cost", InvFrom, InvTo),
              -SCM.CalcContractLineAmount(ServContractLine."Line Discount Amount", InvFrom, InvTo),
              AmtRoundingPrecision);
            ServLedgEntry."Entry No." := NextEntry;
            SCM.UpdateServLedgEntryAmount(ServLedgEntry, ServHeader);
        END;
        ServLedgEntry."Posting Date" := DueDate;
        ServLedgEntry.Prepaid := TRUE;
        ServLedgEntry.INSERT;
        NextEntry := NextEntry + 1;
        EXIT(YearContractCorrection);
    End;

    //Win513++
    //Procedure YearContract(ContrType: Integer; ContrNo: Code[20]): Boolean
    Procedure YearContract(ContrType: Enum "Service Contract Type"; ContrNo: Code[20]): Boolean
    //Win513--
    var

        ServContrHeader: Record "Service Contract Header";
    begin
        IF NOT ServContrHeader.GET(ContrType, ContrNo) THEN
            EXIT(FALSE);
        EXIT(ServContrHeader."Expiration Date" = CALCDATE('<1Y-1D>', ServContrHeader."Starting Date"));
    end;

    procedure CalcServLedgEntryAmounts(VAR ServContractLine: Record "Service Contract Line"; VAR InvAmountRounded: ARRAY[4] OF Decimal)
    var
        ServLedgEntry2: Record "Service Ledger Entry";
        AccumulatedAmts: Array[4] of Decimal;
        i: Integer;
    Begin
        ServLedgEntry2.SETCURRENTKEY("Service Contract No.");
        ServLedgEntry2.SETRANGE("Service Contract No.", ServContractLine."Contract No.");
        ServLedgEntry2.SETRANGE("Service Item No. (Serviced)", ServContractLine."Service Item No.");
        ServLedgEntry2.SETRANGE("Entry Type", ServLedgEntry2."Entry Type"::Sale);
        FOR i := 1 TO 4 DO
            AccumulatedAmts[i] := 0;
        IF ServLedgEntry2.FINDSET THEN
            REPEAT
                AccumulatedAmts[AmountType::UnitCost] :=
                  AccumulatedAmts[AmountType::UnitCost] + ServLedgEntry2."Cost Amount";
                AccumulatedAmts[AmountType::Amount] :=
                  AccumulatedAmts[AmountType::Amount] - ServLedgEntry2."Amount (LCY)";
                AccumulatedAmts[AmountType::DiscAmount] :=
                  AccumulatedAmts[AmountType::DiscAmount] + ServLedgEntry2."Discount Amount";
                AccumulatedAmts[AmountType::UnitPrice] :=
                  AccumulatedAmts[AmountType::UnitPrice] - ServLedgEntry2."Unit Price";
            UNTIL ServLedgEntry2.NEXT = 0;
        ServLedgEntry."Cost Amount" := -ROUND(ServContractLine."Line Cost" + AccumulatedAmts[AmountType::UnitCost]);
        SCM.SetServiceLedgerEntryUnitCost(ServLedgEntry);
        ServLedgEntry."Amount (LCY)" := AccumulatedAmts[AmountType::Amount] - ServContractLine."Line Amount";
        ServLedgEntry."Discount Amount" := ServContractLine."Line Discount Amount" - AccumulatedAmts[AmountType::DiscAmount];
        ServLedgEntry."Contract Disc. Amount" := ServLedgEntry."Discount Amount";
        ServLedgEntry."Unit Price" := AccumulatedAmts[AmountType::UnitPrice] - ServContractLine."Line Value";
        SCM.CalcServLedgEntryDiscountPct(ServLedgEntry);
        InvAmountRounded[AmountType::Amount] -= ServLedgEntry."Amount (LCY)";
        InvAmountRounded[AmountType::UnitPrice] -= ServLedgEntry."Unit Price";
        InvAmountRounded[AmountType::UnitCost] += ServLedgEntry."Unit Cost";
        InvAmountRounded[AmountType::DiscAmount] += ServLedgEntry."Contract Disc. Amount";
    End;

    Procedure UpdateApplyUntilEntryNoInServLedgEntry(ReturnLedgerEntry: Integer; FirstLineEntry: Integer; LastEntry: Integer)
    var
    begin
        IF ReturnLedgerEntry <> 0 THEN BEGIN
            ServLedgEntry.GET(FirstLineEntry);
            ServLedgEntry."Apply Until Entry No." := LastEntry;
            ServLedgEntry.MODIFY;
        END;
    end;

    Procedure CountLineInvFrom(SigningContract: Boolean; VAR ServContractLine: Record "Service Contract Line"; InvFrom: Date) LineInvFrom: Date
    var
    begin
        IF SigningContract THEN BEGIN
            IF ServContractLine."Invoiced to Date" = 0D THEN
                LineInvFrom := ServContractLine."Starting Date"
            ELSE
                IF ServContractLine."Invoiced to Date" <> CALCDATE('<CM>', ServContractLine."Invoiced to Date") THEN
                    LineInvFrom := ServContractLine."Invoiced to Date" + 1
        END ELSE
            IF ServContractLine."Invoiced to Date" = 0D THEN BEGIN
                IF ServContractLine."Starting Date" >= CALCDATE('<-CM>', ServContractLine."Starting Date") THEN
                    LineInvFrom := ServContractLine."Starting Date"
                ELSE
                    IF ServContractLine."Starting Date" <= InvFrom THEN
                        LineInvFrom := CALCDATE('<CM+1D>', ServContractLine."Starting Date")
                    ELSE
                        LineInvFrom := 0D;
            END ELSE
                LineInvFrom := InvFrom;
    end;


    procedure CheckServiceContractHeaderAmts(ServiceContractHeader: Record "Service Contract Header")
    var

        ServLedgEntry2: Record "Service Ledger Entry";

        Text000: Label '%1 cannot be created for service contract  %2, because %3 and %4 are not equal.';
    begin
        IF ServiceContractHeader."Calcd. Annual Amount" <> ServiceContractHeader."Annual Amount" THEN
            ERROR(
              Text000,
              ServLedgEntry2.TABLECAPTION,
              ServiceContractHeader."Contract No.",
              ServiceContractHeader.FIELDCAPTION("Calcd. Annual Amount"),
              ServiceContractHeader.FIELDCAPTION("Annual Amount"));
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Quote to Order", 'OnAfterInsertServiceLine', '', true, true)]
    local procedure "Service-Quote to Order_OnAfterInsertServiceLine"
    (
        var ServiceItemLine2: Record "Service Item Line";
        ServiceItemLine: Record "Service Item Line"
    )
    begin
        ApprovalsMgmt.CopyApprovalEntryQuoteToOrder(ServiceItemLine.RECORDID, ServiceItemLine."No.", RECORDID);
        ApprovalsMgmt.DeleteApprovalEntries(ServiceItemLine.RECORDID);
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Depreciation Calculation", 'OnAfterDeprDays', '', true, true)]
    local procedure "Depreciation Calculation_OnAfterDeprDays"
    (
        StartingDate: Date;
        EndingDate: Date;
        var NumberOfDeprDays: Integer
    )
    begin
        FALedgEntry.SETRANGE(Reversed, FALSE);
    end;






    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SegManagement", 'OnBeforeInteractLogEntryInsert', '', true, true)]
    local procedure "SegManagement_OnBeforeInteractLogEntryInsert"
    (
        var InteractionLogEntry: Record "Interaction Log Entry";
        SegmentLine: Record "Segment Line"
    )
    begin
        // To Capture building and Unit Details in Log entry // WIN
        InteractionLogEntry."Building Code" := SegmentLine."Building Code";
        InteractionLogEntry."Building Name" := SegmentLine."Building Name";
        InteractionLogEntry."Unit No." := SegmentLine."Unit No.";
        InteractionLogEntry."Unit Description" := SegmentLine."Unit Description";
        InteractionLogEntry."Rent Amount" := SegmentLine."Rent Amount";
        InteractionLogEntry."Discussion Date" := SegmentLine."Discussion Date";  //win315
        InteractionLogEntry."Rent Amt" := SegmentLine."Rent Amt";  //win315
        InteractionLogEntry."Court Case No." := SegmentLine."Court Case No."; // WIN210
        InteractionLogEntry."Service Contract No." := SegmentLine."Service Contract No."; // WIN210
        InteractionLogEntry.Notes := SegmentLine.Notes; // WIN210
                                                        // To Capture building and Unit Details in Log entry // WIN
    end;

    procedure CreateServiceDeferralSchedule(DeferralCode: Code[10]; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; AmountToDefer: Decimal; CalcMethod: Enum "Deferral Calculation Method"; StartDate: Date; NoOfPeriods: Integer; ApplyDeferralPercentage: Boolean; DeferralDescription: Text[50]; AdjustStartDate: Boolean; CurrencyCode: Code[10])
    var
        DeferralTemplate: Record "Deferral Template";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        AdjustedStartDate: Date;
        AdjustedDeferralAmount: Decimal;

    begin
        InitCurrency(CurrencyCode);
        DeferralTemplate.GET(DeferralCode);

        // "Start Date" passed in needs to be adjusted based on the Deferral Code's Start Date setting
        IF AdjustStartDate THEN
            AdjustedStartDate := SetStartDate(DeferralTemplate, StartDate)
        ELSE
            AdjustedStartDate := StartDate;

        AdjustedDeferralAmount := AmountToDefer;
        IF ApplyDeferralPercentage THEN
            AdjustedDeferralAmount := ROUND(AdjustedDeferralAmount * (DeferralTemplate."Deferral %" / 100), AmountRoundingPrecision);

        DefUtilities.SetDeferralRecords(DeferralHeader, DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo,
          CalcMethod, NoOfPeriods, AdjustedDeferralAmount, AdjustedStartDate,
          DeferralCode, DeferralDescription, AmountToDefer, AdjustStartDate, CurrencyCode);

        CASE CalcMethod OF
            CalcMethod::"Straight-Line":
                CalculateStraightline(DeferralHeader, DeferralLine, DeferralTemplate);
            CalcMethod::"Equal per Period":
                CalculateEqualPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
            CalcMethod::"Days per Period":
                CalculateDaysPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
            CalcMethod::"User-Defined":
                CalculateUserDefined(DeferralHeader, DeferralLine, DeferralTemplate);
        END;
    end;

    procedure InitCurrency(CurrencyCode: Code[10])
    var
        Currency: Record Currency;
    begin
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    procedure SetStartDate(DeferralTemplate: Record "Deferral Template"; StartDate: Date) AdjustedStartDate: Date
    var

        DeferralStartOption: Option "Posting Date","Beginning of Period","End of Period","Beginning of Next Period";
    begin
        // "Start Date" passed in needs to be adjusted based on the Deferral Code's Start Date setting;
        //Win513++
        //CASE DeferralTemplate."Start Date") OF
        CASE DeferralTemplate."Start Date".AsInteger() OF
            ///Win513--
            DeferralStartOption::"Posting Date":
                AdjustedStartDate := StartDate;
            DeferralStartOption::"Beginning of Period":
                BEGIN
                    AccountingPeriod.SETRANGE("Starting Date", 0D, StartDate);
                    IF AccountingPeriod.FINDLAST THEN
                        AdjustedStartDate := AccountingPeriod."Starting Date";
                END;
            DeferralStartOption::"End of Period":
                BEGIN
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', StartDate);
                    IF AccountingPeriod.FINDFIRST THEN
                        AdjustedStartDate := CALCDATE('<-1D>', AccountingPeriod."Starting Date");
                END;
            DeferralStartOption::"Beginning of Next Period":
                BEGIN
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', StartDate);
                    IF AccountingPeriod.FINDFIRST THEN
                        AdjustedStartDate := AccountingPeriod."Starting Date";
                END;
        END;
    end;

    Procedure SetServiceDeferral(ServiceDeferralPar: Boolean)
    begin
        ServiceDeferral := ServiceDeferralPar;//WINS-PPG
    end;

    procedure CalculateStraightline(DeferralHeader: Record "Deferral Header"; VAR DeferralLine: Record "Deferral Line"; DeferralTemplate: Record "Deferral Template")
    var

        AmountToDefer: Decimal;
        AmountToDeferFirstPeriod: Decimal;
        FractionOfPeriod: Decimal;
        PeriodicDeferralAmount: Decimal;
        RunningDeferralTotal: Decimal;
        PeriodicCount: Integer;
        HowManyDaysLeftInPeriod: Integer;
        NumberOfDaysInPeriod: Integer;
        PostDate: Date;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        PerDiffSum: Decimal;
    Begin
        // If the Start Date passed in matches the first date of a financial period, this is essentially the same
        // as the "Equal Per Period" deferral method, so call that function.

        AccountingPeriod.SETFILTER("Starting Date", '>=%1', DeferralHeader."Start Date");
        IF AccountingPeriod.FINDFIRST THEN BEGIN
            IF AccountingPeriod."Starting Date" = DeferralHeader."Start Date" THEN BEGIN
                CalculateEqualPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
                EXIT;
            END
        END ELSE
            ERROR(DeferSchedOutOfBoundsErr);

        PeriodicDeferralAmount := ROUND(DeferralHeader."Amount to Defer" / DeferralHeader."No. of Periods", AmountRoundingPrecision);

        FOR PeriodicCount := 1 TO (DeferralHeader."No. of Periods" + 1) DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            IF (PeriodicCount = 1) OR (PeriodicCount = (DeferralHeader."No. of Periods" + 1)) THEN BEGIN
                IF PeriodicCount = 1 THEN BEGIN
                    CLEAR(RunningDeferralTotal);

                    // Get the starting date of the accounting period of the posting date is in
                    AccountingPeriod.SETFILTER("Starting Date", '<%1', PostDate);
                    IF AccountingPeriod.FINDLAST THEN
                        FirstPeriodDate := AccountingPeriod."Starting Date"
                    ELSE
                        ERROR(DeferSchedOutOfBoundsErr);

                    // Get the starting date of the next accounting period
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', PostDate);
                    IF AccountingPeriod.FINDFIRST THEN
                        SecondPeriodDate := AccountingPeriod."Starting Date"
                    ELSE
                        ERROR(DeferSchedOutOfBoundsErr);

                    HowManyDaysLeftInPeriod := (SecondPeriodDate - DeferralHeader."Start Date");
                    NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);
                    FractionOfPeriod := (HowManyDaysLeftInPeriod / NumberOfDaysInPeriod);

                    AmountToDeferFirstPeriod := (PeriodicDeferralAmount * FractionOfPeriod);
                    AmountToDefer := ROUND(AmountToDeferFirstPeriod, AmountRoundingPrecision);
                    RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
                END ELSE
                    // Last period
                    AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);
            END ELSE BEGIN
                AmountToDefer := ROUND(PeriodicDeferralAmount, AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            END;

            DeferralLine."Posting Date" := PostDate;
            DeferralLine.Description := DefUtilities.CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                ERROR(InvalidPostingDateErr, PostDate);

            PerDiffSum := PerDiffSum + ROUND(AmountToDefer / DeferralHeader."No. of Periods", AmountRoundingPrecision);

            DeferralLine.Amount := AmountToDefer;

            DeferralLine.INSERT;
        END;
    End;

    procedure CalculateEqualPerPeriod(DeferralHeader: Record "Deferral Header"; VAR DeferralLine: Record "Deferral Line"; DeferralTemplate: Record "Deferral Template")
    var

        PeriodicCount: Integer;
        PostDate: Date;
        AmountToDefer: Decimal;
        RunningDeferralTotal: Decimal;

    begin
        FOR PeriodicCount := 1 TO DeferralHeader."No. of Periods" DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            DeferralLine.VALIDATE("Posting Date", PostDate);
            DeferralLine.Description := DefUtilities.CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            AmountToDefer := DeferralHeader."Amount to Defer";
            IF PeriodicCount = 1 THEN
                CLEAR(RunningDeferralTotal);

            IF PeriodicCount <> DeferralHeader."No. of Periods" THEN BEGIN
                AmountToDefer := ROUND(AmountToDefer / DeferralHeader."No. of Periods", AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            END ELSE
                AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);

            DeferralLine.Amount := AmountToDefer;
            DeferralLine.INSERT;
        END;
    end;

    procedure InitializeDeferralHeaderAndSetPostDate(VAR DeferralLine: Record "Deferral Line"; DeferralHeader: Record "Deferral Header"; PeriodicCount: Integer; VAR PostDate: Date)
    var

    Begin
        DeferralLine.INIT;
        DeferralLine."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type";
        DeferralLine."Gen. Jnl. Template Name" := DeferralHeader."Gen. Jnl. Template Name";
        DeferralLine."Gen. Jnl. Batch Name" := DeferralHeader."Gen. Jnl. Batch Name";
        DeferralLine."Document Type" := DeferralHeader."Document Type";
        DeferralLine."Document No." := DeferralHeader."Document No.";
        DeferralLine."Line No." := DeferralHeader."Line No.";
        DeferralLine."Currency Code" := DeferralHeader."Currency Code";

        IF PeriodicCount = 1 THEN BEGIN
            AccountingPeriod.SETFILTER("Starting Date", '..%1', DeferralHeader."Start Date");
            IF NOT AccountingPeriod.FINDFIRST THEN
                ERROR(DeferSchedOutOfBoundsErr);

            PostDate := DeferralHeader."Start Date";
        END ELSE BEGIN
            AccountingPeriod.SETFILTER("Starting Date", '>%1', PostDate);
            IF AccountingPeriod.FINDFIRST THEN
                PostDate := AccountingPeriod."Starting Date"
            ELSE
                ERROR(DeferSchedOutOfBoundsErr);
        END;
    End;

    procedure CalculateDaysPerPeriod(DeferralHeader: Record "Deferral Header"; VAR DeferralLine: Record "Deferral Line"; DeferralTemplate: Record "Deferral Template")
    var

        AmountToDefer: Decimal;
        PeriodicCount: Integer;
        NumberOfDaysInPeriod: Integer;
        NumberOfDaysInSchedule: Integer;
        NumberOfDaysIntoCurrentPeriod: Integer;
        NumberOfPeriods: Integer;
        PostDate: Date;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        EndDate: Date;
        TempDate: Date;
        NoExtraPeriod: Boolean;
        DailyDeferralAmount: Decimal;
        RunningDeferralTotal: Decimal;
    Begin
        AccountingPeriod.SETFILTER("Starting Date", '>=%1', DeferralHeader."Start Date");
        IF AccountingPeriod.FINDFIRST THEN BEGIN
            IF AccountingPeriod."Starting Date" = DeferralHeader."Start Date" THEN
                NoExtraPeriod := TRUE
            ELSE
                NoExtraPeriod := FALSE
        END ELSE
            ERROR(DeferSchedOutOfBoundsErr);

        // If comparison used <=, it messes up the calculations
        IF NOT NoExtraPeriod THEN BEGIN
            AccountingPeriod.SETFILTER("Starting Date", '<%1', DeferralHeader."Start Date");
            AccountingPeriod.FINDLAST;

            NumberOfDaysIntoCurrentPeriod := (DeferralHeader."Start Date" - AccountingPeriod."Starting Date");
        END ELSE
            NumberOfDaysIntoCurrentPeriod := 0;

        IF NoExtraPeriod THEN
            NumberOfPeriods := DeferralHeader."No. of Periods"
        ELSE
            NumberOfPeriods := (DeferralHeader."No. of Periods" + 1);

        FOR PeriodicCount := 1 TO NumberOfPeriods DO BEGIN
            // Figure out the end date...
            IF PeriodicCount = 1 THEN
                TempDate := DeferralHeader."Start Date";

            IF PeriodicCount <> NumberOfPeriods THEN BEGIN
                AccountingPeriod.SETFILTER("Starting Date", '>%1', TempDate);
                IF AccountingPeriod.FINDFIRST THEN
                    TempDate := AccountingPeriod."Starting Date"
                ELSE
                    ERROR(DeferSchedOutOfBoundsErr);
            END ELSE
                // Last Period, special case here...
                IF NoExtraPeriod THEN BEGIN
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', TempDate);
                    IF AccountingPeriod.FINDFIRST THEN
                        TempDate := AccountingPeriod."Starting Date"
                    ELSE
                        ERROR(DeferSchedOutOfBoundsErr);
                    EndDate := TempDate;
                END ELSE
                    EndDate := (TempDate + NumberOfDaysIntoCurrentPeriod);
        END;
        NumberOfDaysInSchedule := (EndDate - DeferralHeader."Start Date");
        DailyDeferralAmount := (DeferralHeader."Amount to Defer" / NumberOfDaysInSchedule);

        FOR PeriodicCount := 1 TO NumberOfPeriods DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            IF PeriodicCount = 1 THEN BEGIN
                CLEAR(RunningDeferralTotal);
                FirstPeriodDate := DeferralHeader."Start Date";

                // Get the starting date of the next accounting period
                AccountingPeriod.SETFILTER("Starting Date", '>%1', PostDate);
                AccountingPeriod.FINDFIRST;
                SecondPeriodDate := AccountingPeriod."Starting Date";
                NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);

                AmountToDefer := ROUND(NumberOfDaysInPeriod * DailyDeferralAmount, AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            END ELSE BEGIN
                // Get the starting date of the accounting period of the posting date is in
                AccountingPeriod.SETFILTER("Starting Date", '<=%1', PostDate);
                AccountingPeriod.FINDLAST;
                FirstPeriodDate := AccountingPeriod."Starting Date";

                // Get the starting date of the next accounting period
                AccountingPeriod.SETFILTER("Starting Date", '>%1', PostDate);
                AccountingPeriod.FINDFIRST;
                SecondPeriodDate := AccountingPeriod."Starting Date";

                NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);

                IF PeriodicCount <> NumberOfPeriods THEN BEGIN
                    // Not the last period
                    AmountToDefer := ROUND(NumberOfDaysInPeriod * DailyDeferralAmount, AmountRoundingPrecision);
                    RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
                END ELSE
                    AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);
            END;

            DeferralLine."Posting Date" := PostDate;
            DeferralLine.Description := DefUtilities.CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                ERROR(InvalidPostingDateErr, PostDate);

            DeferralLine.Amount := AmountToDefer;

            DeferralLine.INSERT;
        END;
    End;

    procedure CalculateUserDefined(DeferralHeader: Record "Deferral Header"; VAR DeferralLine: Record "Deferral Line"; DeferralTemplate: Record "Deferral Template")
    var
        PeriodicCount: Integer;
        PostDate: Date;
    Begin
        FOR PeriodicCount := 1 TO DeferralHeader."No. of Periods" DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            DeferralLine."Posting Date" := PostDate;
            DeferralLine.Description := DefUtilities.CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                ERROR(InvalidPostingDateErr, PostDate);

            // For User-Defined, user must enter in deferral amounts
            DeferralLine.INSERT;
        END;
    End;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterRejectSelectedApprovalRequest', '', true, true)]
    local procedure "Approvals Mgmt._OnAfterRejectSelectedApprovalRequest"(var ApprovalEntry: Record "Approval Entry")
    var

        ApprovalEntry2: Record "Approval Entry";
    begin
        ApprovalEntry2.RESET;
        ApprovalEntry2.SETRANGE("Entry No.", ApprovalEntry."Entry No.");
        IF ApprovalEntry2.FINDFIRST THEN BEGIN
            ApprovalEntry2.Status := ApprovalEntry.Status::Rejected;
            ApprovalEntry2."Last Modified By User ID" := USERID;
            ApprovalEntry2."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
            //COMMIT;
            ApprovalEntry2.MODIFY;
        END;
    end;

    PROCEDURE ShowServApprovalStatus(ServiceHeader: Record 5900);
    BEGIN
        //S001
        ServiceHeader.FIND;

        CASE ServiceHeader."Approval Status" OF
            ServiceHeader."Approval Status"::Released:
                MESSAGE(DocStatusChangedMsg, ServiceHeader."Document Type", ServiceHeader."No.", ServiceHeader."Approval Status");
            ServiceHeader."Approval Status"::"Pending Approval":
                IF AppMgmt.HasOpenOrPendingApprovalEntries(ServiceHeader.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
        END;
    END;

    PROCEDURE ShowServContractApprovalStatus(ServiceContractHeader: Record 5965);
    BEGIN
        //S002
        ServiceContractHeader.FIND;

        CASE ServiceContractHeader."Approval Status" OF
            ServiceContractHeader."Approval Status"::Released:
                MESSAGE(DocStatusChangedMsg, ServiceContractHeader."Contract Type", ServiceContractHeader."Contract No.", ServiceContractHeader."Approval Status");
            ServiceContractHeader."Approval Status"::"Pending Approval":
                IF AppMgmt.HasOpenOrPendingApprovalEntries(ServiceContractHeader.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
        END;
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequestsForRecordOnAfterCreateApprovalEntryNotification', '', true, true)]
    local procedure "Approvals Mgmt._OnRejectApprovalRequestsForRecordOnAfterCreateApprovalEntryNotification"
    (
        var ApprovalEntry: Record "Approval Entry";
        WorkflowStepInstance: Record "Workflow Step Instance";
        OldStatus: Enum "Approval Status"
    )
    begin
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.FINDFIRST;
        IF ApprovalEntry."Approver ID" <> ApprovalEntry."Sender ID" THEN BEGIN
            ApprovalEntry."Approver ID" := ApprovalEntry."Sender ID";
            AppMgmt.CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
        END;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure "Approvals Mgmt._OnPopulateApprovalEntryArgument"
    (
        var RecRef: RecordRef;
        var ApprovalEntryArgument: Record "Approval Entry";
        WorkflowStepInstance: Record "Workflow Step Instance"

    )
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Service Header":                   //S001
                BEGIN
                    RecRef.SETTABLE(ServiceHeader1);
                    ApprovalEntryArgument."Document Type" := ServiceHeader1."Document Type";
                    ApprovalEntryArgument."Document No." := ServiceHeader1."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := ServiceHeader1."Salesperson Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := ServiceHeader1."Currency Code";
                END;
            DATABASE::"Service Contract Header":                   //S002
                BEGIN
                    RecRef.SETTABLE(ServiceContractHeader1);
                    //  ApprovalEntryArgument."Document Type" := ServiceHeader."Document Type";
                    ApprovalEntryArgument."Document No." := ServiceContractHeader1."Contract No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := ServiceContractHeader1."Salesperson Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := ServiceContractHeader1."Currency Code";
                END;
        end;
    End;

    PROCEDURE IsSufficientServApprover(UserSetup: Record 91; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean;
    VAR
        ServiceHeader: Record 5900;
    BEGIN
        //S001
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

    END;

    PROCEDURE IsSufficientServContractApprover(UserSetup: Record 91; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean;
    VAR
        ServiceContractHeader: Record 5965;
    BEGIN
        //S002
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

    END;

    PROCEDURE PrePostApprovalCheckService(VAR ServiceHeader: Record 5900): Boolean;
    BEGIN
        // S001
        IF (ServiceHeader."Approval Status" = ServiceHeader."Approval Status"::Open) AND IsServiceApprovalsWorkflowEnabled(ServiceHeader) THEN
            ERROR(PrePostCheckErr, ServiceHeader."Document Type", ServiceHeader."No.");

        EXIT(TRUE);
    END;

    Procedure IsSalesApprovalsWorkflowEnabled(VAR SalesHeader: Record "Sales Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(SalesHeader, WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode));
    end;

    PROCEDURE PrePostApprovalCheckServiceContract(VAR ServiceContractHeader: Record 5965): Boolean;
    BEGIN
        // S002
        IF (ServiceContractHeader."Approval Status" = ServiceContractHeader."Approval Status"::Open) AND IsServiceContractApprovalsWorkflowEnabled(ServiceContractHeader) THEN
            ERROR(PrePostCheckErr, ServiceContractHeader."Contract Type", ServiceContractHeader."Contract No.");

        EXIT(TRUE);
    END;

    Procedure IsServiceContractApprovalsWorkflowEnabled(VAR ServiceContractHeader: Record "Service Contract Header"): Boolean
    Begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ServiceContractHeader, RunWorkflowOnSendServiceContractDocForApprovalCode));
    End;

    PROCEDURE IsServiceApprovalsWorkflowEnabled(VAR ServiceHeader: Record 5900): Boolean;
    BEGIN

        EXIT(WorkflowManagement.CanExecuteWorkflow(ServiceHeader, RunWorkflowOnSendServiceDocForApprovalCode));
    END;



    PROCEDURE CheckServiceApprovalPossible(VAR ServiceHeader: Record 5900): Boolean;
    BEGIN
        //S001
        IF NOT IsServiceApprovalsWorkflowEnabled(ServiceHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        //IF NOT PurchaseHeader.PurchLinesExist THEN
        // ERROR(NothingToApproveErr);

        EXIT(TRUE);
    END;

    PROCEDURE CheckServiceContractApprovalPossible(VAR ServiceContractHeader: Record 5965): Boolean;
    BEGIN
        //S002
        IF NOT IsServiceContractApprovalsWorkflowEnabled(ServiceContractHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        //IF NOT PurchaseHeader.PurchLinesExist THEN
        // ERROR(NothingToApproveErr);

        EXIT(TRUE);
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure "Approvals Mgmt._OnSetStatusToPendingApproval"
    (
        RecRef: RecordRef;
        var Variant: Variant;
        var IsHandled: Boolean
    )
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Service Header":
                BEGIN
                    RecRef.SETTABLE(ServiceHeader);
                    ServiceHeader.VALIDATE("Approval Status", ServiceHeader."Approval Status"::"Pending Approval");
                    ServiceHeader.MODIFY(TRUE);
                    Variant := ServiceHeader;
                END;
            DATABASE::"Service Contract Header":
                BEGIN
                    RecRef.SETTABLE(ServiceContractHeader);
                    ServiceContractHeader.VALIDATE("Approval Status", ServiceContractHeader."Approval Status"::"Pending Approval");
                    ServiceContractHeader.MODIFY(TRUE);
                    Variant := ServiceContractHeader;
                END;
        end;

    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeRunApprovalCommentsPage', '', true, true)]
    local procedure "Approvals Mgmt._OnBeforeRunApprovalCommentsPage"
    (
        var ApprovalCommentLine: Record "Approval Comment Line";
        WorkflowStepInstanceID: Guid;
        var IsHandle: Boolean
    )
    begin

    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnShowApprovalCommentsOnAfterSetApprovalCommentLineFilters', '', true, true)]
    local procedure "Approvals Mgmt._OnShowApprovalCommentsOnAfterSetApprovalCommentLineFilters"
    (
        var ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef
    )
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Service Header":    //S001
                BEGIN
                    ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    AppMgmt.FindApprovalEntryForCurrUser(ApprovalEntry, RecRef.RECORDID);
                END;
            DATABASE::"Service Contract Header":    //S002
                BEGIN
                    ApprovalCommentLine.FILTERGROUP(2);   //win315
                    ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    ApprovalsMgmt.FindApprovalEntryForCurrUser(ApprovalEntry, RecRef.RECORDID); // win315
                    ApprovalCommentLine.FILTERGROUP(0);   //win315
                END;


        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDeleteRecordInApprovalRequest', '', true, true)]
    local procedure "Approvals Mgmt._OnDeleteRecordInApprovalRequest"(RecordIDToApprove: RecordId)
    begin
        AppMgmt.DeleteApprovalCommentLines(RecordIDToApprove);
    end;

    PROCEDURE CheckPayElementApprovalsWorkflowEnabled(): Boolean;
    BEGIN

        EXIT(TRUE);
    END;


    PROCEDURE OnSendPayElementForApproval();
    BEGIN
    END;

    PROCEDURE IsPayrollApprovalsWorkflowEnabled(VAR PurchaseHeader: Record "Purchase Header"): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(PurchaseHeader, WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode));
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure "Workflow Response Handling_OnAddWorkflowResponsePredecessorsToLibrary"(ResponseFunctionName: Code[128])
    begin
        CASE ResponseFunctionName OF
            WRH.SetStatusToPendingApprovalCode:

                BEGIN
                    WRH.AddResponsePredecessor(WRH.SetStatusToPendingApprovalCode, RunWorkflowOnSendServiceDocForApprovalCode);  //S001
                    WRH.AddResponsePredecessor(WRH.SetStatusToPendingApprovalCode, RunWorkflowOnSendServiceContractDocForApprovalCode);
                end;

            WRH.CreateApprovalRequestsCode:
                begin
                    WRH.AddResponsePredecessor(WRH.CreateApprovalRequestsCode, RunWorkflowOnSendServiceDocForApprovalCode);   //S001
                    WRH.AddResponsePredecessor(WRH.CreateApprovalRequestsCode, RunWorkflowOnSendServiceContractDocForApprovalCode);
                end;

            WRH.SendApprovalRequestForApprovalCode:
                begin
                    WRH.AddResponsePredecessor(
                    WRH.SendApprovalRequestForApprovalCode, RunWorkflowOnSendServiceDocForApprovalCode);  //S001

                    WRH.AddResponsePredecessor(
                    WRH.SendApprovalRequestForApprovalCode, RunWorkflowOnSendServiceContractDocForApprovalCode);  //S002
                end;

            WRH.OpenDocumentCode:
                begin
                    WRH.AddResponsePredecessor(WRH.OpenDocumentCode, RunWorkflowOnCancelServiceApprovalRequestCode); //S001
                    WRH.AddResponsePredecessor(WRH.OpenDocumentCode, RunWorkflowOnCancelServiceContractApprovalRequestCode); //S002      
                end;

            WRH.CancelAllApprovalRequestsCode:
                begin
                    WRH.AddResponsePredecessor(WRH.CancelAllApprovalRequestsCode, RunWorkflowOnCancelServiceApprovalRequestCode); //S001
                    WRH.AddResponsePredecessor(WRH.CancelAllApprovalRequestsCode, RunWorkflowOnCancelServiceContractApprovalRequestCode); //S002
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure "Workflow Response Handling_OnReleaseDocument"
    (
        RecRef: RecordRef;
        var Handled: Boolean
    )


    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Service Header":

                AllSubs.ReleaseServiceDocument(ServHeader);
            DATABASE::"Service Contract Header":                                    //S002
                AllSubs.ReleaseServiceContractDocument(ServContractHeader);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure "Workflow Response Handling_OnOpenDocument"
    (
        RecRef: RecordRef;
        var Handled: Boolean
    )
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Service Header":  // S001
                AllSubs.ReopenServicedocument(ServHeader);
            DATABASE::"Service Contract Header":  // S002
                AllSubs.ReopenServiceContractdocument(ServContractHeader);
        end;
    ENd;

    Procedure ReleaseServiceDocument(VAR ServiceHeader: Record "Service Header")
    begin
        // S001
        //Win513++
        //WITH ServiceHeader DO BEGIN
        //Win513--
        ServiceHeader."Approval Status" := ServiceHeader."Approval Status"::Released;
        ServiceHeader.MODIFY(TRUE);
        //Win513++
        //END;
        //Win513--
    end;


    procedure ReleaseServiceContractDocument(VAR ServiceContractHeader: Record "Service Contract Header")
    begin
        // S002
        //Win513++
        //WITH ServiceContractHeader DO BEGIN
        //Win513--
        ServiceContractHeader."Approval Status" := ServiceContractHeader."Approval Status"::Released;
        //"Change Status" := "Change Status"::Locked; //win315
        ServiceContractHeader.MODIFY(TRUE);
        //Win513++
        //END;
        //Win513--
    end;

    Procedure ReopenServicedocument(VAR ServiceHeader: Record "Service Header")
    begin
        //S001
        //Win513++
        //WITH ServiceHeader DO BEGIN
        //Win513--
        IF ServiceHeader."Approval Status" = ServiceHeader."Approval Status"::Open THEN
            EXIT;
        ServiceHeader."Approval Status" := ServiceHeader."Approval Status"::Open;
        ServiceHeader.MODIFY(TRUE);
        //Win513++
        //END;
        //Win513--
    end;

    Procedure ReopenServiceContractdocument(VAR ServiceContractHeader: Record "Service Contract Header")
    begin
        //S002
        //Win513++
        //WITH ServiceContractHeader DO BEGIN
        //Win513--
        IF ServiceContractHeader."Approval Status" = ServiceContractHeader."Approval Status"::Open THEN
            EXIT;
        ServiceContractHeader."Approval Status" := ServiceContractHeader."Approval Status"::Open;
        ServiceContractHeader."Change Status" := ServiceContractHeader."Change Status"::Open; //win315
        ServiceContractHeader.MODIFY(TRUE);
        //Win513++
        //END;
        //Win513--
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure "Workflow Event Handling_OnAddWorkflowEventsToLibrary"()
    begin
        WEH.AddEventToLibrary(
        RunWorkflowOnSendServiceDocForApprovalCode, DATABASE::"Service Header", ServDocSendForApprovalEventDescTxt, 0, FALSE);  //S001

        WEH.AddEventToLibrary(
          RunWorkflowOnSendServiceContractDocForApprovalCode, DATABASE::"Service Contract Header", ServContractDocSendForApprovalEventDescTxt, 0, FALSE);  //S002

        WEH.AddEventToLibrary(RunWorkflowOnCancelServiceApprovalRequestCode, DATABASE::"Service Header",
        ServDocApprReqCancelledEventDescTxt, 0, FALSE);    //S001

        WEH.AddEventToLibrary(RunWorkflowOnCancelServiceContractApprovalRequestCode, DATABASE::"Service Contract Header",
          ServContractDocApprReqCancelledEventDescTxt, 0, FALSE);    //S002

        WEH.AddEventToLibrary(RunWorkflowOnAfterReleaseServiceDocCode, DATABASE::"Service Header",
      ServDocReleasedEventDescTxt, 0, FALSE);            //S001

        WEH.AddEventToLibrary(RunWorkflowOnAfterReleaseServiceContractDocCode, DATABASE::"Service Contract Header",
          ServContractDocReleasedEventDescTxt, 0, FALSE);            //S002

        WEH.AddEventToLibrary(RunWorkflowOnAfterPostServiceDocCode, DATABASE::"Service Header",
      ServInvPostEventDescTxt, 0, FALSE); ///S001

        WEH.AddEventToLibrary(RunWorkflowOnAfterPostServiceContractDocCode, DATABASE::"Service Contract Header",
          ServContractInvPostEventDescTxt, 0, FALSE); ///S002
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure "Workflow Event Handling_OnAddWorkflowEventPredecessorsToLibrary"(EventFunctionName: Code[128])
    begin
        CASE EventFunctionName OF
            RunWorkflowOnAfterPostServiceDocCode:
                WEH.AddEventPredecessor(RunWorkflowOnAfterPostServiceDocCode, RunWorkflowOnAfterReleaseServiceDocCode);   //S001
            RunWorkflowOnAfterPostServiceContractDocCode:
                WEH.AddEventPredecessor(RunWorkflowOnAfterPostServiceContractDocCode, RunWorkflowOnAfterReleaseServiceContractDocCode);   //S002

            RunWorkflowOnCancelServiceApprovalRequestCode:
                WEH.AddEventPredecessor(RunWorkflowOnCancelServiceApprovalRequestCode, RunWorkflowOnSendServiceDocForApprovalCode);  //S001
            RunWorkflowOnCancelServiceContractApprovalRequestCode:
                WEH.AddEventPredecessor(RunWorkflowOnCancelServiceContractApprovalRequestCode, RunWorkflowOnSendServiceContractDocForApprovalCode);  //S002     

            WEH.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WEH.AddEventPredecessor(WEH.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendServiceDocForApprovalCode);  //S001
                    WEH.AddEventPredecessor(WEH.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendServiceContractDocForApprovalCode);  //S002
                end;

            WEH.RunWorkflowOnRejectApprovalRequestCode:
                BEGIN
                    WEH.AddEventPredecessor(WEH.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendServiceDocForApprovalCode);  //S001
                    WEH.AddEventPredecessor(WEH.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendServiceContractDocForApprovalCode);  //S002
                ENd;

            WEH.RunWorkflowOnDelegateApprovalRequestCode:
                BEGIN
                    WEH.AddEventPredecessor(WEH.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendServiceDocForApprovalCode); //S001
                    WEH.AddEventPredecessor(WEH.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendServiceContractDocForApprovalCode); //S002
                END;

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertOfServiceInvoice(var Rec: Record "Service Header")
    begin
        if Rec."Bal. Account No." <> '' then
            if Rec."Payment Method Code" = 'PDC' then begin
                Rec."Bal. Account No." := '';
                Rec.Modify()
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyOfServiceInvoice(var Rec: Record "Service Header")
    begin
        if Rec."Bal. Account No." <> '' then
            if Rec."Payment Method Code" = 'PDC' then begin
                Rec."Bal. Account No." := '';
                Rec.Modify()
            end;
    end;

    procedure RunWorkflowOnSendServiceDocForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendServiceDocForApproval'));  //S001
    end;

    procedure RunWorkflowOnSendServiceContractDocForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendServiceContractDocForApproval'));  //S002
    end;

    procedure RunWorkflowOnCancelServiceApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelServiceApprovalRequest'));  //S001
    end;

    procedure RunWorkflowOnCancelServiceContractApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelServiceContractApprovalRequest'));  //S002
    end;

    procedure RunWorkflowOnAfterReleaseServiceDocCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseServiceDoc'));   //S001
    End;

    procedure RunWorkflowOnAfterReleaseServiceContractDocCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseServiceContractDoc'));
    end;

    procedure RunWorkflowOnAfterPostServiceDocCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterPostServiceDoc'));  //S001
    end;

    Procedure RunWorkflowOnAfterPostServiceContractDocCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterPostServiceContractDoc'));  //S002
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendServiceContractDocForApproval(VAR ServiceContractHeader: Record "Service Contract Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelServiceContractApprovalRequest(VAR ServiceContractHeader: Record "Service Contract Header")
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeGetDeferralAmount', '', true, true)]
    local procedure "Gen. Journal Line_OnBeforeGetDeferralAmount"
    (
        var GenJournalLine: Record "Gen. Journal Line";
        var DeferralAmount: Decimal;
        var IsHandled: Boolean
    )
    begin
        AllSubs.SetServiceDeferral(ServiceDeferral);
    end;

    procedure CheckRespCenter2(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[20]; UserCode: Code[50]): Boolean
    begin
        CASE DocType OF
            DocType::Sales:
                UserRespCenter := GetSalesFilter2(UserCode);
            DocType::Purchase:
                UserRespCenter := GetPurchasesFilter2(UserCode);
            DocType::Service:
                UserRespCenter := GetServiceFilter2(UserCode);
        END;
        IF (UserRespCenter <> '') AND
           (AccRespCenter <> UserRespCenter)
        THEN
            EXIT(FALSE);

        EXIT(TRUE);

    end;

    procedure GetSalesFilter2(UserCode: Code[50]): Code[10]
    begin
        IF NOT HasGotSalesUserSetup THEN BEGIN
            CompanyInfo.GET;
            SalesUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF UserSetup.GET(UserCode) AND (UserCode <> '') THEN
                IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                    SalesUserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
            HasGotSalesUserSetup := TRUE;
        END;
        EXIT(SalesUserRespCenter);
    end;


    procedure GetPurchasesFilter2(UserCode: Code[50]): Code[10]
    begin
        IF NOT HasGotPurchUserSetup THEN BEGIN
            CompanyInfo.GET;
            PurchUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF UserSetup.GET(UserCode) AND (UserCode <> '') THEN
                IF UserSetup."Purchase Resp. Ctr. Filter" <> '' THEN
                    PurchUserRespCenter := UserSetup."Purchase Resp. Ctr. Filter";
            HasGotPurchUserSetup := TRUE;
        END;
        EXIT(PurchUserRespCenter);
    end;

    procedure GetServiceFilter2(UserCode: Code[50]): Code[10]
    begin
        IF NOT HasGotServUserSetup THEN BEGIN
            CompanyInfo.GET;
            ServUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF UserSetup.GET(UserCode) AND (UserCode <> '') THEN
                IF UserSetup."Service Resp. Ctr. Filter" <> '' THEN
                    ServUserRespCenter := UserSetup."Service Resp. Ctr. Filter";
            HasGotServUserSetup := TRUE;
        END;
        EXIT(ServUserRespCenter);
    end;

    procedure GetRecordFiltersWithCaptions(RecVariant: Variant) Filters: Text
    var

        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldFilter: Text;
        Name: Text;
        Cap: Text;
        Pos: Integer;
        i: Integer;
    begin
        RecRef.GETTABLE(RecVariant);
        Filters := RecRef.GETFILTERS;
        IF Filters = '' THEN
            EXIT;

        FOR i := 1 TO RecRef.FIELDCOUNT DO BEGIN
            FieldRef := RecRef.FIELDINDEX(i);
            FieldFilter := FieldRef.GETFILTER;
            IF FieldFilter <> '' THEN BEGIN
                Name := STRSUBSTNO('%1: ', FieldRef.NAME);
                Cap := STRSUBSTNO('%1: ', FieldRef.CAPTION);
                Pos := STRPOS(Filters, Name);
                IF Pos <> 0 THEN
                    Filters := INSSTR(DELSTR(Filters, Pos, STRLEN(Name)), Cap, Pos);
            END;
        END;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnCalcInvPeriodDurationCaseElse', '', true, true)]
    local procedure "Service Contract Header_OnCalcInvPeriodDurationCaseElse"
    (
        var ServiceContractHeader: Record "Service Contract Header";
        InvPeriodDuration: DateFormula
    )
    begin
        IF ServiceContractHeader."Invoice Period" <> ServiceContractHeader."Invoice Period"::None THEN
            CASE ServiceContractHeader."Invoice Period" OF
                ServiceContractHeader."Invoice Period"::Other:
                    BEGIN // WIN210            //win-271119++
                          /*                        NoOfMonths := DateandTime.DateDiff('M', "Starting Date", "Expiration Date", DayOfWeekInput, WeekOfYearInput);
                                                 EVALUATE(InvPeriodDuration, '<' + FORMAT(NoOfMonths) + 'M>');
                                                 ServiceContractHeader."Service Period In months" := NoOfMonths;         //win-271119--
                           */
                    END;
            end;

    end;


























    var
        myInt: Integer;
}