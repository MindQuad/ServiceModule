page 50075 "Post Dated Check Card"
{
    // WINPDC : Created new function for Revoke Cheque 'UpdateStatusRevoked' and added new button for the same.
    // WINPDC : Added code on actiosn button 'CreateCashJournal & Post' and 'CreateCashJournal' to check status Revoked.
    // WINPDC : Shown Cheque Dropped field | Created new function for Revoke Cheque 'UpdateChequeDropped' and added new button for the same.
    // WINPDC : Added code on On Assist Trigger on Document No. for No. Series.
    // WINPDC : Added Code on Action Button to change status and create and post journal for cash entries.

    Caption = 'Post Dated Checks Register';
    //DeleteAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Post Dated Check Line";

    layout
    {
        area(content)
        {
            group(PDC)
            {
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document no. for this post-dated check journal.';

                    trigger OnAssistEdit()
                    begin
                        //WINPDC++
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                        //WINPDC--
                    end;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the number of the account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description for the post-dated check journal line.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    Caption = 'Bal. Account No.';
                    ToolTip = 'Specifies the bank account No. where you want to bank the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the check No. for the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Check Date"; Rec."Check Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of the post-dated check when it is supposed to be banked.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Amount of the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Date Received"; Rec."Date Received")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when we received the post-dated check.';
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("PDC Due Date"; Rec."PDC Due Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("System Generated Date"; Rec."Contract Due Date")
                {
                    ApplicationArea = All;
                }
                field("System Generated Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Cancelled Check"; Rec."Cancelled Check")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Dimensions FactBox"; 9083)
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateBalance;
    end;

    var
        CustomerNo: Code[20];
        Customer: Record 18;
        PostDatedCheck: Record "Post Dated Check Line";
        GLAccount: Record 15;
        CustomerList: Page "Customer List";
        //PostDatedCheckMgt: Codeunit 28090;//WIN292
        //ApplicationManagement: Codeunit ApplicationManagement;//WIN292
        CountCheck: Integer;
        LineCount: Integer;
        CustomerBalance: Decimal;
        LineAmount: Decimal;
        DateFilter: Text[250];
        BankDate: Text[30];
        Text001: Label 'Are you sure you want to create Cash Journal Lines?';
        Text002: Label 'There are %1 check(s) to bank.';
        ContractFilter: Code[20];
        StatusFilter: Option " ",Received,Deposited,"Reversed/Cancelled",All;
        MailCU: Codeunit 17;
        Text003: Label 'Are you sure you want to create Cash Journal Lines & Post?';
        Text004: Label 'Do you want to send mail to Legal Department?';
        PaymentMethodFilter: Option " ",Cheque,Bank,Cash,All;
        GeneralLedgerSetup: Record 98;
        NoSeriesMgt: Codeunit 396;
        ReversalCode: Code[20];
        PageReason: Page "Reason Codes";
        ReasonCode: Record 231;
        ReversalComments: Text[100];

        //Commentbox: DotNet Interaction;//WIN292
        ReversalEntry: Record 179;
        PostDatedCheck1: Record "Post Dated Check Line";
        Interaction: Record Interaction;
        CollectionEntries: Page 50076;
        CourtCaseInsertion: Record 50014;
        CourtCaseDetails: Page 50080;
        Custledger: Page 50084;
        CLE: Record 21;


    procedure UpdateBalance()
    begin
        LineAmount := 0;
        LineCount := 0;
        IF Customer.GET(Rec."Account No.") THEN BEGIN
            Customer.CALCFIELDS("Balance (LCY)");
            CustomerBalance := Customer."Balance (LCY)";
        END ELSE
            CustomerBalance := 0;
        PostDatedCheck.RESET;
        PostDatedCheck.SETCURRENTKEY("Account Type", "Account No.");
        IF DateFilter <> '' THEN
            PostDatedCheck.SETFILTER("Check Date", DateFilter);
        PostDatedCheck.SETRANGE("Account Type", PostDatedCheck."Account Type"::Customer);
        IF CustomerNo <> '' THEN
            PostDatedCheck.SETRANGE("Account No.", CustomerNo);
        IF PostDatedCheck.FINDSET THEN BEGIN
            REPEAT
                LineAmount := LineAmount + PostDatedCheck."Amount (LCY)";
            UNTIL PostDatedCheck.NEXT = 0;
            LineCount := PostDatedCheck.COUNT;
        END;
    end;


    procedure UpdateCustomer()
    begin
        IF CustomerNo = '' THEN
            Rec.SETRANGE("Account No.")
        ELSE
            Rec.SETRANGE("Account No.", CustomerNo);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        /* IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
        Rec.SETFILTER("Check Date", DateFilter); *///WIN292
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        Rec.SETFILTER("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure ContractNoOnAfterValidate()
    begin
        //WIN325
        Rec.SETFILTER("Check Date", DateFilter);
        IF ContractFilter = '' THEN
            Rec.SETRANGE("Contract No.")
        ELSE
            Rec.SETRANGE("Contract No.", ContractFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure StatusOnAfterValidate()
    begin
        //WIN325
        Rec.SETFILTER("Check Date", DateFilter);
        IF StatusFilter = StatusFilter::All THEN
            Rec.SETRANGE(Status)
        ELSE
            Rec.SETRANGE(Status, StatusFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure UpdateStatusCollected()
    var
        PDC: Record "Post Dated Check Line";
        lText001: Label 'Do you want to update the Status as Collected?';
    begin
        //WIN325
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        PDC.SETRANGE(Status, PDC.Status::" ");
        IF PDC.FINDSET THEN
            PDC.MODIFYALL(Status, PDC.Status::Received);

        /*
        FILTERGROUP(0);
        RESET;
        SETFILTER("Account Type",'Customer|G/L Account');
        SETFILTER(Status,'<>%1',Status::Deposited);*/

    end;

    local procedure UpdateStatusRevoked()
    var
        lText001: Label 'Do you want to update the Status as Revoke Cheque?';
        PDC: Record "Post Dated Check Line";
    begin
        //WINPDC++
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        IF PDC.FINDSET THEN
            PDC.MODIFYALL(Status, PDC.Status::"Revoke Cheque");
        //WINPDC--
    end;

    local procedure UpdateChequeDropped()
    var
        lText001: Label 'Do you want to Drop Cheque for the selected entries?';
        PDC: Record "Post Dated Check Line";
    begin
        //WINPDC++
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        IF PDC.FINDSET THEN
            PDC.MODIFYALL("Cheque Dropped", TRUE);
        //WINPDC--
    end;

    local procedure PaymentMethodOnAfterValidate()
    begin
        //WINPDC++
        Rec.SETFILTER("Check Date", DateFilter);
        Rec.SETRANGE("Payment Method", PaymentMethodFilter);
        IF PaymentMethodFilter = PaymentMethodFilter::All THEN
            Rec.SETRANGE("Payment Method")
        ELSE
            Rec.SETRANGE("Payment Method", PaymentMethodFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
        //WINPDC--
    end;


    procedure PostPaymentEntry()
    var
        PDCEntries: Record "Post Dated Check Line";
        GenJournalLine: Record 81;
        Num: Integer;
        JournalTemp: Record 80;
        GenJnlPostLine: Codeunit 12;
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETFILTER("Journal Template Name", '%1', 'PAYMENT');
        GenJournalLine.SETFILTER("Journal Batch Name", '%1', 'PDC');
        IF GenJournalLine.FINDLAST THEN
            Num := GenJournalLine."Line No."
        ELSE
            Num := 0;

        //MESSAGE(FORMAT(Num));
        //PDCEntries.SETFILTER(Posted,'%1',FALSE);
        //PDCEntries.SETFILTER("PDC Bounced",'%1',FALSE);
        //PDCEntries.SETFILTER("On Hold",'%1',FALSE);
        //PDCEntries.SETFILTER("Sent for Posting",'%1',FALSE);
        PDCEntries.RESET;
        PDCEntries.SETRANGE(PDCEntries."Document No.", Rec."Document No.");
        PDCEntries.SETFILTER(PDCEntries."Payment Entry", '%1', FALSE);
        IF PDCEntries.FINDSET THEN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", 'PAYMENT');
                GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", 'PDC');
                Num := Num + 10000;
                GenJournalLine."Line No." := Num;
                IF JournalTemp.GET(GenJournalLine."Journal Template Name") THEN
                    GenJournalLine.VALIDATE("Source Code", JournalTemp."Source Code");
                GenJournalLine.VALIDATE("Posting Date", PDCEntries."Check Date");
                GenJournalLine."Document No." := PDCEntries."Document No.";
                GenJournalLine.VALIDATE(GenJournalLine."Document Type", GenJournalLine."Document Type"::" ");
                GenJournalLine.VALIDATE(GenJournalLine."Account Type", PDCEntries."Account Type"::Customer);
                GenJournalLine.VALIDATE(GenJournalLine."Account No.", PDCEntries."Customer No.");
                GenJournalLine.VALIDATE(GenJournalLine.Amount, -(PDCEntries.Amount));
                //GenJournalLine."External Document No.":=PDCEntries."PDC No.";
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.", PDCEntries."Account No.");
                GenJournalLine.VALIDATE(GenJournalLine."Check Date", PDCEntries."Check Date");
                GenJournalLine.VALIDATE(GenJournalLine."Check No", PDCEntries."Check No.");
                GenJournalLine.VALIDATE(GenJournalLine."Service Contract No.", PDCEntries."Contract No.");
                GenJournalLine.INSERT(TRUE);
                //PDCEntries."Sent for Posting":=TRUE;
                //PDCEntries."PDC Status":=PDCEntries."PDC Status"::Closed;
                PDCEntries."Payment Entry" := TRUE;
                PDCEntries.MODIFY;
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            UNTIL PDCEntries.NEXT = 0;

        MESSAGE('Payment entry has been reversed');
    end;


    procedure SendMailtoSP1()
    var
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'Do you want to send mail to Salesperson ?';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lText002: Label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record 231;
        UserSetup: Record 91;
        lUser: Record 2000000120;
        GeneralLedgerSetup: Record 98;
        SalespersonPurchaser: Record 13;
        MarketingSetup: Record 5079;
        FileName: Text;
        FileManagement: Codeunit 419;
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        Text1: Text[250];
    begin
        //win315++

        //SMTPSetup.GET;
        //TESTFIELD("E-Mail");
        //SMTPSetup.TESTFIELD("User ID");
        //SMTPSetup.TESTFIELD("Email Sender To");

        //MarketingSetup.GET;
        //MarketingSetup.TESTFIELD("Email Sender To");

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Finance/Legal User Mail ID");
        Recipients.Add(GeneralLedgerSetup."Finance/Legal User Mail ID");
        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",SMTPSetup."Email Sender To",'Contact No '+FORMAT("No.")+' is assigned','',TRUE);
        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",GeneralLedgerSetup."Finance/Legal User Mail ID", 'Closing Police Case', '', TRUE);//WIN292
        //IF MarketingSetup."Email Sender CC" <> '' THEN
        //SMTPMail.AddCC(MarketingSetup."Email Sender CC");
        //SMTPMail.AppendBody('Hi '+SalespersonPurchaser.Name);
        //SMTPMail.AppendBody('Hi '+ Name);

        // SMTPMail.AppendBody('Dear Sir / Madam ');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // //SMTPMail.AppendBody('Contact No '+FORMAT("No.")+' is assigned to you,please check and start interacting with them');
        // SMTPMail.AppendBody('Police case has been closed for this contract' + ' ' + FORMAT(Rec."Contract No.") + ' ' + 'and PDC No.' + ' ' + FORMAT(Rec."Document No.") + '.');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('NAV Administrator');
        // SMTPMail.AppendBody('<br><br>');

        Subject := 'Closing Police Case';
        Body := 'Dear Sir / Madam, <br><br>  Good day! <br><Br>';
        Body += 'Police case has been closed for this contract' + ' ' + FORMAT(Rec."Contract No.") + ' ' + 'and PDC No.' + ' ' + FORMAT(Rec."Document No.") + '.';
        Body += '<br><Br> Thanks & Regards,<br>NAV Administrator<br><br>';
        /*DocArticles1.RESET;
        DocArticles1.SETRANGE(DocArticles1."Issued To",Rec."No.");
        IF DocArticles1.FINDSET THEN REPEAT
          SMTPMail.AddAttachment(DocArticles1.Link,DocArticles1.Link);
        UNTIL DocArticles1.NEXT =0;*/
        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        MESSAGE('Email has been sent.');

        //win315--

    end;
}

