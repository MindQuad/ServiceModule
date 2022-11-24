PageExtension 50306 pageextension50306 extends "Service Contract"
{
    Caption = 'Service Contract';
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on "Description(Control 48)".

        modify(Name)
        {
            ApplicationArea = All;
            Editable = true;
        }

        modify(ServContractLines)
        {
            Caption = 'Contract Amounts';
        }
        modify(Shipping)
        {
            Caption = 'Tenancy';

        }
        modify(Service)
        {
            Caption = 'Service';
        }
        modify("Invoice Details")
        {
            Caption = 'Invoice Details';
        }


        modify(NextInvoiceDate)
        {
            Visible = false;
        }

        addafter("Customer No.")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Description)
        {
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
                Caption = 'Unit No.';
            }
            field("Service Item No."; Rec."Service Item No.")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item No.';
            }
        }
        addafter("Contact No.")
        {
            field("Tenant Name"; Rec."Tenant Name")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Phone No.")
        {
            field("Previous Contract No."; Rec."Previous Contract No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Salesperson Code")
        {
            field("Parking No."; Rec."Parking No.")
            {
                ApplicationArea = Basic;
            }

            field("Contract Period"; Rec."Contract Period")
            {
                ApplicationArea = Basic;
            }
            field("Deal Closing Date"; Rec."Deal Closing Date")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    //win315++
                    if Rec."Deal Closing Date" > Rec."Starting Date" then
                        Error('Deal Closing Date should not be greater than Starting Date');
                    //win315--
                end;
            }
        }
        modify("Expiration Date")
        {


            trigger OnAfterValidate()
            begin
                //win315++
                if Rec."Expiration Date" < Rec."Starting Date" then
                    Error('Expiration Date should not be lesser than Starting Date');
                //win315--
            end;
        }
        addafter("Starting Date")
        {

        }
        addafter("Responsibility Center")
        {

            field("Amount per Period"; Rec."Amount per Period")
            {
                ApplicationArea = Basic;
            }
            field("VAT Amount"; Rec."VAT Amount")
            {
                ApplicationArea = Basic;
            }
            field("Contact Amt Incl VAT"; Rec."Contact Amt Incl VAT")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Change Status")
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = Basic;
            }
            field(Active; Rec.Active)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter(Prepaid)
        {

            field("Mode of Payment"; Rec."Mode of Payment")
            {
                ApplicationArea = Basic;
            }

            field("Defferal Code"; Rec."Defferal Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(InvoicePeriod)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = Basic;
            }
            field("Special Condition"; Rec."Special Condition")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Invoice Generation"; Rec."Invoice Generation")
            {
                ApplicationArea = Basic;
            }
            field("Contract Document Status"; Rec."Contract Document Status")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Status';
                Visible = false;
            }
            field("No. of Cheque"; Rec."No. of Cheque")
            {
                ApplicationArea = Basic;
                Visible = false;
            }

        }
        addafter("No. of Posted Credit Memos")
        {
            field("No. of Credit Memo Posted"; Rec."No. of Credit Memo Posted")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Ship-to Country/Region Code")
        {
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Tenancy Type"; Rec."Tenancy Type")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addfirst(Invoicing)
        {
            field("Next Invoice Date"; Rec."Next Invoice Date")
            {
                ApplicationArea = Basic;
            }

        }
        addafter("Currency Code")
        {
            group("Termination and Closing")
            {
                field(Terminated; Rec.Terminated)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //win315++
                        if Rec."Termination Date" < Rec."Starting Date" then
                            Error('Termination Date should not be less than Starting Date');
                        //win315--
                    end;
                }
                field("Penalty Applicable"; Rec."Penalty Applicable")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Visible = false;
                }
                field("Penalty Amount"; Rec."Penalty Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Termination Reason Code"; Rec."Termination Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Termination Reason"; Rec."Termination Reason Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Termination Reason';
                }
                field("Penalty Amount Days"; Rec."Penalty Amount Days")
                {
                    ApplicationArea = Basic;
                }
                field("Actual Utilized Rent Amount"; Rec."Actual Utilized Rent Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Termination Credit Memo"; Rec."Credit Memo Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Termination Credit Memo';
                    Editable = false;
                }
                field("Contract Closing Date"; Rec."Contract Closing Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*IF "Contract Closing Date" < "Expiration Date" THEN
                              "Contract Closing Date" := "Expiration Date"
                            ELSE
                              ERROR('Contract Closing Date should be lesser than Expiration Date');*/

                    end;
                }
                field("Contract Closed"; Rec."Contract Closed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
        addafter("Cancel Reason Code")
        {
            field("Closing Contract No."; Rec."Closing Contract No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = true;
            }
            field("Renewal Contract"; Rec."Renewal Contract")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Renewal Contract No."; Rec."Renewal Contract No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = true;
            }
        }
        addfirst(Details)
        {
            field("Created Datetime"; Rec."Created Datetime")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Last Modified By"; Rec."Last Modified By")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Contract Status"; Rec."Contract Status")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Contract No."; "Customer No.")
        moveafter("Starting Date"; "Responsibility Center")
        moveafter("Responsibility Center"; "Serv. Contract Acc. Gr. Code")
        moveafter("Change Status"; Prepaid)
        moveafter(Prepaid; InvoicePeriod)
        moveafter(InvoicePeriod; "No. of Unposted Credit Memos")
        moveafter(ServContractLines; Shipping)
        moveafter("Currency Code"; "Cancel Reason Code")
        addafter(Status)
        {
            field("Contract Current Status"; Rec."Contract Current Status")
            {
                ApplicationArea = all;
                Caption = 'Contract Status';
                Editable = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (Visible) on "Overview(Action 3)".


        //Unsupported feature: Property Insertion (Visible) on ""Service Dis&counts"(Action 22)".


        //Unsupported feature: Property Insertion (Visible) on ""Service &Hours"(Action 136)".


        //Unsupported feature: Property Insertion (Visible) on "Action178(Action 178)".


        //Unsupported feature: Property Insertion (Visible) on ""Tr&endscape"(Action 97)".


        //Unsupported feature: Property Insertion (Visible) on ""Filed Contracts"(Action 145)".


        //Unsupported feature: Property Insertion (Visible) on ""&Gain/Loss Entries"(Action 194)".


        //Unsupported feature: Property Insertion (Visible) on "History(Action 5)".


        //Unsupported feature: Property Insertion (Visible) on "SelectContractLines(Action 75)".


        //Unsupported feature: Property Insertion (Visible) on ""&Remove Contract Lines"(Action 77)".


        //Unsupported feature: Property Insertion (Visible) on ""C&hange Customer"(Action 103)".


        //Unsupported feature: Property Insertion (Visible) on ""Copy &Document..."(Action 20)".


        //Unsupported feature: Property Insertion (Visible) on ""&File Contract"(Action 150)".


        //Unsupported feature: Property Insertion (Visible) on ""Contract Details"(Action 1903183006)".


        //Unsupported feature: Property Insertion (Visible) on ""Contract Gain/Loss Entries"(Action 1906367306)".


        //Unsupported feature: Property Insertion (Visible) on ""Contract Invoicing"(Action 1906957906)".


        //Unsupported feature: Property Insertion (Visible) on ""Contract Price Update - Test"(Action 1902585006)".


        //Unsupported feature: Property Insertion (Visible) on ""Prepaid Contract"(Action 1906186206)".


        //Unsupported feature: Property Insertion (Visible) on ""Expired Contract Lines"(Action 1905491506)".



        //Unsupported feature: Code Modification on "CreateServiceInvoice(Action 83).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.UPDATE;
        TESTFIELD(Status,Status::Signed);
        TESTFIELD("Change Status","Change Status"::Locked);

        #5..32
          ServContractMgt.FinishCodeunit;
          MESSAGE(Text008);
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CurrPage.UPDATE;
        TESTFIELD("Approval Status","Approval Status"::Released); //win315
        #2..35
        */
        //end;


        //Unsupported feature: Code Modification on "LockContract(Action 73).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.UPDATE;
        LockOpenServContract.LockServContract(Rec);
        CurrPage.UPDATE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //WINS-PPG++
        IF ("Invoice Period"="Invoice Period"::Month) AND ("Defferal Code"<>'') THEN
          ERROR('Deferral Code should not be selected for Monthly Invoice Contracts');
        //WINS-PPG--


        #1..3
        */
        //end;


        //Unsupported feature: Code Modification on "SignContract(Action 76).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.UPDATE;
        SignServContractDoc.SignContract(Rec);
        CurrPage.UPDATE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //WINS-PPG++
        IF ("Invoice Period"="Invoice Period"::Month) AND ("Defferal Code"<>'') THEN
          ERROR('Deferral Code should not be selected for Monthly Invoice Contracts');
        IF ("Invoice Period" <> "Invoice Period"::Month) AND ("Invoice Period" <> "Invoice Period"::None) THEN
          TESTFIELD("Defferal Code");
        //WINS-PPG--
        TESTFIELD("Invoice Generation");
        // code added for single invoice creation // RealEstateCR
        ServiceContractHeader.GET("Contract Type","Contract No.");
        ServiceContractHeader.VALIDATE("Invoice Period");
        ServiceContractHeader.MODIFY;
        COMMIT;
        // code added for single invoice creation // RealEstateCR
        #1..3
        */
        //end;
        addafter(History)
        {
            group("Approval Process")
            {
                Caption = 'Approval Process';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        if ALLSubs.CheckServiceContractApprovalPossible(Rec) then
                            ALLSubs.OnSendServiceContractDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ALLSubs.OnCancelServiceContractApprovalRequest(Rec);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        // ApprovalEntries.Setfilters(DATABASE::"Service Contract Header","Contract Type","Contract No.");
                        ApprovalEntries.SetfiltersSC(Database::"Service Contract Header", Rec."Contract No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
            }
            group(ActionGroup1000000065)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator(Action1000000064)
                {
                }
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Enabled = Rec."Approval Status" <> Rec."Approval Status"::Released;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = true;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                        AllSubs: Codeunit "All Subscriber";
                    begin
                        AllSubs.ReleaseServiceContractDocument(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."Approval Status" <> Rec."Approval Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                        AllSubs: Codeunit "All Subscriber";
                    begin
                        AllSubs.ReopenServiceContractdocument(Rec);
                    end;
                }
                separator(Action1000000061)
                {
                }
            }
        }
        addafter(CreateServiceInvoice)
        {
            action("Create Single Credit &Memo")
            {
                ApplicationArea = Basic;
                Caption = 'Create Single Credit &Memo';
                Image = CreateCreditMemo;

                trigger OnAction()
                var
                    W1: Dialog;
                    CreditNoteNo: Code[20];
                    i: Integer;
                    j: Integer;
                    LineFound: Boolean;
                    ServContractMgt: Codeunit ServContractManagement;
                    ServContractLine: Record "Service Contract Line";
                    ServContractLine1: Record "Service Contract Line";


                begin
                    CurrPage.Update;
                    Rec.TestField(Status, Rec.Status::Signed);
                    if Rec."No. of Unposted Credit Memos" <> 0 then
                        if not Confirm(Text009) then
                            exit;

                    ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                    if not Confirm(Text010, false) then
                        exit;

                    ServContractLine.Reset;
                    ServContractLine.SetCurrentkey("Contract Type", "Contract No.", Credited, "New Line");
                    ServContractLine.SetRange("Contract Type", Rec."Contract Type");
                    ServContractLine.SetRange("Contract No.", Rec."Contract No.");
                    ServContractLine.SetRange(Credited, false);
                    // ServContractLine.SETFILTER("Credit Memo Date",'>%1&<=%2',0D,WORKDATE);
                    i := ServContractLine.Count;
                    j := 0;
                    if ServContractLine.Find('-') then begin
                        LineFound := true;
                        W1.Open(
                          Text011 +
                          '@1@@@@@@@@@@@@@@@@@@@@@');
                        Clear(ServContractMgt);
                        ServContractMgt.InitCodeUnit;
                        repeat
                            ServContractLine1 := ServContractLine;
                            // CreditNoteNo := ServContractMgt.CreateContractLineCreditMemo(ServContractLine1,FALSE); // To create Leasing Cr Memo
                            CreditNoteNo := ALLSubs.CreateSingleContractLineCreditMemo(ServContractLine1, false); // To create Leasing Cr Memo
                            j := j + 1;
                            W1.Update(1, ROUND(j / i * 10000, 1));
                        until ServContractLine.Next = 0;
                        ServContractMgt.FinishCodeunit;
                        W1.Close;
                        CurrPage.Update(false);
                    end;
                    ServContractLine.SetFilter("Credit Memo Date", '>%1', WorkDate);
                    if CreditNoteNo <> '' then
                        Message(StrSubstNo(Text012, CreditNoteNo))
                    else
                        if not ServContractLine.Find('-') or LineFound then
                            Message(Text013)
                        else
                            Message(Text016, ServContractLine.FieldCaption("Credit Memo Date"), ServContractLine."Credit Memo Date");
                end;
            }
            action(CreateSingleServiceInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Create Single Service &Invoice';
                Image = NewInvoice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServContractMgt: Codeunit ServContractManagement;

                begin
                    if WorkDate >= Rec."Expiration Date" then
                        Error('Service Contract is expired');
                    CurrPage.Update;
                    //TESTFIELD("Approval Status","Approval Status"::Released); //win315
                    Rec.TestField(Status, Rec.Status::Signed);
                    Rec.TestField("Change Status", Rec."change status"::Locked);

                    if Rec."No. of Unposted Invoices" <> 0 then
                        if not Confirm(Text003) then
                            exit;

                    if Rec."Invoice Period" = Rec."invoice period"::None then
                        Error(StrSubstNo(
                            Text004,
                            Rec.TableCaption, Rec."Contract No.", Rec.FieldCaption("Invoice Period"), Format(Rec."Invoice Period")));

                    if Rec."Next Invoice Date" > WorkDate then
                        if (Rec."Last Invoice Date" = 0D) and
                            (Rec."Starting Date" < Rec."Next Invoice Period Start")
                        then begin
                            Clear(ServContractMgt);
                            ServContractMgt.InitCodeUnit;
                            if ServContractMgt.CreateRemainingPeriodInvoice(Rec) <> '' then
                                Message(Text006);
                            ServContractMgt.FinishCodeunit;
                            exit;
                        end else
                            Error(Text005);

                    ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                    if Confirm(Text007) then begin
                        Clear(ServContractMgt);
                        Clear(ALLSubs);
                        ServContractMgt.InitCodeUnit;
                        // ServContractMgt.CreateInvoice(Rec); // WIN210 // RealEstateCR
                        ALLSubs.CreateSingleInvoice(Rec);
                        ServContractMgt.FinishCodeunit;
                        Message(Text008);
                    end;

                    //win315++
                    if ServiceItem.Get(Rec."Service Item No.") then begin
                        ServiceItem."Occupancy Status" := ServiceItem."occupancy status"::Occupied;
                        ServiceItem.Modify;
                        //UNTIL ServiceItem.NEXT=0;
                    end;
                    //win315--
                end;
            }
            action(CreateMultipleServiceInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Create Multiple Service &Invoice';
                Image = NewInvoice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServContractMgt: Codeunit ServContractManagement;
                begin
                    /*IF WORKDATE >= "Expiration Date" THEN
                      ERROR('Service Contract is expired');*/ // WIN210
                    CurrPage.Update;
                    Rec.TestField(Status, Rec.Status::Signed);
                    Rec.TestField("Change Status", Rec."change status"::Locked);
                    Rec.TestField("Invoice Generation", Rec."invoice generation"::"Multiple Invoice");
                    if Rec."No. of Unposted Invoices" <> 0 then
                        if not Confirm(Text003) then
                            exit;

                    if Rec."Invoice Period" = Rec."invoice period"::None then
                        Error(StrSubstNo(
                            Text004,
                            Rec.TableCaption, Rec."Contract No.", Rec.FieldCaption("Invoice Period"), Format(Rec."Invoice Period")));

                    if Rec."Next Invoice Date" > WorkDate then
                        if (Rec."Last Invoice Date" = 0D) and
                            (Rec."Starting Date" < Rec."Next Invoice Period Start")
                        then begin
                            Clear(ServContractMgt);
                            ServContractMgt.InitCodeUnit;
                            if ServContractMgt.CreateRemainingPeriodInvoice(Rec) <> '' then
                                Message(Text006);
                            ServContractMgt.FinishCodeunit;
                            exit;
                        end else
                            Error(Text005);

                    ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                    if Confirm(Text007) then begin
                        Clear(ServContractMgt);
                        Clear(ALLSubs);
                        ServContractMgt.InitCodeUnit;
                        ALLSubs.CreateDefferalInvoice(Rec);//WIN292
                        ServContractMgt.FinishCodeunit;
                        //END;


                        Clear(ServContractMgt);
                        ServContractMgt.InitCodeUnit;
                        ServContractMgt.CreateInvoice(Rec);
                        ServContractMgt.FinishCodeunit;
                        Rec.UpdateDefInvoice;
                    end;

                    //win315++
                    if ServiceItem.Get(Rec."Service Item No.") then begin
                        ServiceItem."Occupancy Status" := ServiceItem."occupancy status"::Occupied;
                        ServiceItem.Modify;
                        //UNTIL ServiceItem.NEXT=0;
                    end;
                    //win315--

                end;
            }
        }
        addafter(Lock)
        {
            group("Charges & PDC")
            {
                Caption = 'Charges & PDC';
                //Win513++ 15 Jul 22
                action("Service Contract Charges")
                {
                    ApplicationArea = All;
                    Image = PostDocument;

                    RunObject = Page "Service charge List1";
                    RunPageLink = "Table Name" = CONST("Service Contract"), "Service Contract No." = FIELD("Contract No."), "Customer No." = FIELD("Customer No."), Post = const(false);
                }

                action("Posted Service Charges")
                {
                    ApplicationArea = All;
                    Image = PostedReceipts;
                    RunObject = Page "Posted Service Charges";
                    RunPageLink = "Table Name" = CONST("Service Contract"), "Service Contract No." = FIELD("Contract No."), "Customer No." = FIELD("Customer No."), Post = const(true);
                }

                action("PDC Entries")
                {
                    ApplicationArea = All;
                    Image = EntriesList;

                    RunObject = Page "Post Dated Checks Register";
                    RunPageLink = "Contract No." = FIELD("Contract No."), "G/L Transaction No." = FILTER(0);
                }

                action("Posetd PDC Entries")
                {
                    ApplicationArea = All;
                    Image = EntriesList;

                    RunObject = Page "Post Dated Checks Leasing";
                    RunPageLink = "Contract No." = FIELD("Contract No."), "G/L Transaction No." = FILTER(<> 0);
                }
                //Win513--
            }
            group("Termination & Closing")
            {
                Caption = 'Termination & Closing';
                action("Termination contract")
                {
                    ApplicationArea = Basic;
                    Image = TerminationDescription;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    Visible = false;

                    trigger OnAction()
                    var
                        ServContractManagement: Codeunit ServContractManagement;
                    begin
                        //win315++
                        Rec.TestField("Approval Status", Rec."approval status"::Open);
                        ServMgmtSetup.Get;
                        if Rec.Terminated = false then begin
                            if Confirm('Do you want to terminate contract?', true) then begin
                                if Rec."Termination Date" = 0D then
                                    Rec."Termination Date" := WorkDate;
                                if ServMgmtSetup."Penalty Month" = 60 then
                                    Rec."Penalty Amount Days" := '60 Days'
                                else
                                    Rec."Penalty Amount Days" := '';
                                Rec.Terminated := true;
                                //Status:= Status::Canceled;
                                // "Actual Utilized Rent Amount" := (((("Termination Date" - "Starting Date") + 1) / 365 ) * "Annual Amount");
                                Rec."Actual Utilized Rent Amount" := ServContractManagement.CalcContractLineAmount(Rec."Annual Amount", Rec."Starting Date", Rec."Termination Date");
                                // "Penalty Amount" := (("Annual Amount" / 365) * ServMgmtSetup."Penalty Month");
                                Rec."Penalty Amount" := ((Rec."Annual Amount" / 12) * ServMgmtSetup."Penalty Month");
                                if ServiceItem.Get(Rec."Service Item No.") then
                                    repeat
                                        ServiceItem."Occupancy Status" := ServiceItem."occupancy status"::Vacant;
                                        ServiceItem.Modify;
                                    until ServiceItem.Next = 0;
                                //Status:= Status::Canceled;
                                Rec.Modify;
                            end;
                        end else
                            Error('Already Terminated');
                        //win315--
                    end;
                }
                action("Termination Draft Print")
                {
                    ApplicationArea = Basic;
                    Image = PrintDocument;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        //TESTFIELD("Termination Date");
                        //win315++
                        ServContrHdr.Reset;
                        ServContrHdr.SetRange(ServContrHdr."Contract Type", ServContrHdr."contract type"::Contract);
                        ServContrHdr.SetRange(ServContrHdr."Contract No.", Rec."Contract No.");
                        if ServContrHdr.FindFirst then
                            Report.RunModal(50013, true, false, ServContrHdr);
                        //win315--
                    end;
                }
                action("Reopen Terminated Contract")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //win315++
                        if Rec.Terminated = true then begin
                            Rec.Terminated := false;
                            Clear(Rec."Termination Date");
                            Clear(Rec."Penalty Amount Days");
                            Clear(Rec."Actual Utilized Rent Amount");
                            Clear(Rec."Penalty Amount");
                            Rec.Status := Rec.Status::Signed;
                            Rec.Modify;
                        end;
                        //win315--
                    end;
                }
                action("Termination Cr. Memo")
                {
                    ApplicationArea = Basic;
                    Caption = 'Termination Process';
                    Image = CreateCreditMemo;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        /*
                        //win315++
                        TESTFIELD("Approval Status","Approval Status"::Released);
                        IF CONFIRM('Do you want to create Credit Memo for this invoice?') THEN BEGIN
                          IF "Credit Memo Posted" = FALSE THEN BEGIN
                          ServiceInvoiceHeader.RESET;
                          ServiceInvoiceHeader.SETRANGE(ServiceInvoiceHeader."Contract No.",Rec."Contract No.");
                          //IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                          IF ServiceInvoiceHeader.FINDSET THEN REPEAT
                        
                            ServiceCrMemoHeader.RESET;
                            ServiceCrMemoHeader.INIT;
                            ServiceCrMemoHeader."No.":='';
                            ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Document Type",ServiceCrMemoHeader."Document Type"::"Credit Memo");
                            ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Customer No.",ServiceInvoiceHeader."Customer No.");
                            //ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Contract No.",ServiceInvoiceHeader."Contract No.");
                            ServiceCrMemoHeader."Posting Date" := "Termination Date";
                            ServiceCrMemoHeader."Document Date" := "Termination Date";
                            ServiceCrMemoHeader."Order Date" := "Termination Date";
                            //ServiceHeader."Contract No." := "Contract No."; // WIN210
                            ServiceCrMemoHeader."Contract No." := ServiceInvoiceHeader."Contract No.";
                            ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Contract No.",ServiceInvoiceHeader."Contract No.");
                            ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Shortcut Dimension 1 Code",ServiceInvoiceHeader."Shortcut Dimension 1 Code");
                            ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Shortcut Dimension 2 Code",ServiceInvoiceHeader."Shortcut Dimension 2 Code");
                            ServiceCrMemoHeader.VALIDATE(ServiceCrMemoHeader."Defferal Code",ServiceInvoiceHeader."Defferal Code"); //new
                            ServiceCrMemoHeader.INSERT(TRUE);
                            ServiceCrMemoHeader."Posting Date" := "Termination Date";
                            ServiceCrMemoHeader."Document Date" := "Termination Date";
                            //ServiceCrMemoHeader."Order Date" := "Termination Date";
                            ServiceCrMemoHeader.MODIFY;
                        
                        //new++
                            //win315++ to create defferal header for service credit memo
                        IF ServiceCrMemoHeader."Defferal Code"<>'' THEN BEGIN
                        IF NOT DeferralHeader.GET(2,'','',ServiceCrMemoHeader."Document Type",ServiceCrMemoHeader."No.",0) THEN BEGIN
                          // Need to create the header record.
                          DeferralHeader."Deferral Doc. Type" := 2;
                          DeferralHeader."Gen. Jnl. Template Name" := '';
                          DeferralHeader."Gen. Jnl. Batch Name" := '';
                          DeferralHeader."Document Type" := 0;
                          DeferralHeader."Document No." := ServiceCrMemoHeader."No.";
                          DeferralHeader."Line No." := 0;
                          DeferralHeader.INSERT;
                        END;
                        //realestatecr
                        //IF DefferralInv THEN BEGIN
                            CALCFIELDS("Calcd. Annual Amount");
                            DeferralHeader."Amount to Defer" := -"Calcd. Annual Amount" END ELSE
                        DeferralHeader."Amount to Defer" := -"Amount per Period";
                        // DeferralHeader."Start Date" := ServContract2."Next Invoice Date";
                        DeferralHeader."Start Date" := "Starting Date";
                        DeferralTemplate.RESET;
                        DeferralTemplate.GET(ServiceCrMemoHeader."Defferal Code");
                        DeferralHeader."Calc. Method" := DeferralTemplate."Calc. Method";;
                        DeferralHeader."No. of Periods" := DeferralTemplate."No. of Periods";
                        DeferralHeader."Schedule Description" := DeferralTemplate."Period Description";
                        DeferralHeader."Deferral Code" := DeferralTemplate."Deferral Code";
                        DeferralHeader."Currency Code" := "Currency Code";
                        DeferralHeader.MODIFY;
                        //END;
                        //win315-->>
                        //new--
                        
                            InvFrm:=0D;
                            ServiceCrMemoLine.RESET;
                            ServiceInvoiceLine.SETRANGE(ServiceInvoiceLine."Document No.",ServiceInvoiceHeader."No.");
                            ServiceInvoiceLine.SETFILTER(ServiceInvoiceLine.Type,'<>%1',ServiceInvoiceLine.Type::" ");
                            ServiceInvoiceLine.SETFILTER(ServiceInvoiceLine."No.",'<>%1','');
                            //IF ServiceInvoiceLine.FINDFIRST THEN BEGIN
                            IF ServiceInvoiceLine.FINDSET THEN REPEAT
                        
                              ServiceCrMemoLine.INIT;
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."Document Type",ServiceCrMemoHeader."Document Type");
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."Document No.",ServiceCrMemoHeader."No.");
                              ServiceCrMemoLine."Line No." += 10000;
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine.Type,ServiceCrMemoLine.Type::"G/L Account");
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."No.",ServiceInvoiceLine."No.");
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine.Quantity,ServiceInvoiceLine.Quantity);
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."Unit Price",ServiceInvoiceLine."Unit Price");
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."VAT Bus. Posting Group",ServiceInvoiceLine."VAT Bus. Posting Group");
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."VAT Prod. Posting Group",ServiceInvoiceLine."VAT Prod. Posting Group");
                              ServiceCrMemoLine.VALIDATE(ServiceCrMemoLine."Service Item No.",ServiceInvoiceLine."Service Item No.");
                        
                        //new line ++
                        //win315++ to create defferal line for service credit memo
                         IF (ServiceCrMemoHeader."Defferal Code"<>'') THEN BEGIN   //AND (NOT ForSubstituteInv)
                          //DeFPostingDate := 0D;
                          DeferralTemplate.RESET;
                          DeferralTemplate.GET(ServiceCrMemoHeader."Defferal Code");
                          DeferralLine.INIT;
                          DeferralLine."Deferral Doc. Type" := 2;
                          DeferralLine."Gen. Jnl. Template Name" := '';
                          DeferralLine."Gen. Jnl. Batch Name" := '';
                          DeferralLine."Document Type" := 0;
                          DeferralLine."Document No." := ServiceCrMemoHeader."No.";
                          DeferralLine."Line No." := 0;
                          DeferralLine."Currency Code" := ServiceCrMemoHeader."Currency Code";
                          //DeferralLine.VALIDATE("Posting Date",InvFrom);
                          //IF InvFrom = CALCDATE('<-CM>',InvFrom) THEN
                          //  DeFPostingDate := InvFrom
                         // ELSE DeFPostingDate := CALCDATE('<CM+1D>',InvFrom);
                         // DeFPostingDate := CALCDATE('<-CM>',DeferralHeader."Start Date");
                          IF InvFrm=0D THEN BEGIN
                          DeferralLine.VALIDATE("Posting Date",CALCDATE('<CM+1D>',DeferralHeader."Start Date"));
                          InvFrm:=DeferralLine."Posting Date";
                         // ERROR('%1',InvFrm);
                          END ELSE
                            DeferralLine.VALIDATE("Posting Date",InvFrm);
                        
                          InvFrm := CALCDATE('<CM+1D>',InvFrm);
                            // To get 1st Date of Next Period.
                         // DeferralLine.Description := DeferralUtilities.CreateRecurringDescription(InvFrom,DeferralTemplate."Period Description");
                          //DeferralLine.VALIDATE("Posting Date",ServiceCrMemoHeader."Posting Date");
                          DeferralLine.VALIDATE(Amount,-ServiceCrMemoLine."Line Amount");
                          DeferralLine.INSERT;
                        END;
                        //win315--
                        //new line --
                        
                        
                        
                              ServiceCrMemoLine.INSERT;
                            UNTIL ServiceInvoiceLine.NEXT=0;
                            //END;
                            MESSAGE('Service credit memo has been created');
                            //ServPostYesNo.PostDocument(ServiceCrMemoHeader);  //comment posting
                        
                          UNTIL ServiceInvoiceHeader.NEXT=0;
                          //END;
                          {IF CONFIRM('Do you want to open Service Credit Memo?',true) THEN
                                PAGE.RUN(5935,ServiceCrMemoHeader)}
                        
                          //IF CONFIRM('Do you want to post credit memo?',TRUE) THEN
                            //ServPostYesNo.PostDocument(ServiceCrMemoHeader);
                            "Credit Memo Posted" := TRUE;
                            MODIFY;
                          END;
                          //ELSE
                            //EXIT;
                        END ELSE
                          EXIT;
                        
                        IF "Credit Memo Posted" = TRUE THEN BEGIN
                          ServiceHeader.RESET;
                          ServiceHeader.INIT;
                          ServiceHeader."No." := '';
                          ServiceHeader.VALIDATE(ServiceHeader."Document Type",ServiceHeader."Document Type"::Invoice);
                          ServiceHeader.VALIDATE(ServiceHeader."Customer No.",Rec."Customer No.");
                          ServiceHeader."Posting Date" := Rec."Termination Date";
                          ServiceHeader."Document Date" := Rec."Termination Date";
                          ServiceHeader."Order Date" := Rec."Termination Date";
                          ServiceHeader.VALIDATE(ServiceHeader."Contract No.",Rec."Contract No.");
                          // ServiceHeader.VALIDATE(ServiceHeader."Defferal Code",Rec."Defferal Code");
                          ServiceHeader.INSERT(TRUE);
                          ServiceHeader."Order Date" := Rec."Termination Date";
                          ServiceHeader."Posting Date" := Rec."Termination Date";
                          ServiceHeader."Document Date" := Rec."Termination Date";
                        
                          ServiceHeader.MODIFY;
                        
                          ServiceLine.RESET;
                          ServiceLine.INIT;
                          ServiceLine.VALIDATE(ServiceLine."Document Type",ServiceHeader."Document Type");
                          ServiceLine.VALIDATE(ServiceLine."Document No.",ServiceHeader."No.");
                          ServiceLine."Line No." := 10000;
                          ServiceLine.VALIDATE(ServiceLine.Type,ServiceLine.Type::"G/L Account");
                          ServMgmtSetup.GET; // WIN210
                          ServMgmtSetup.TESTFIELD("Penalty Account"); // WIN210
                          {IF Prepaid = TRUE THEN BEGIN
                            TESTFIELD("Serv. Contract Acc. Gr. Code");
                            ServiceContractAccountGroup.GET(Rec."Serv. Contract Acc. Gr. Code");
                            ServiceContractAccountGroup.TESTFIELD(ServiceContractAccountGroup."Prepaid Contract Acc.");
                            ServiceLine.VALIDATE(ServiceLine."No.",ServiceContractAccountGroup."Prepaid Contract Acc.");
                          END ELSE
                          IF Prepaid = FALSE THEN BEGIN
                            TESTFIELD("Serv. Contract Acc. Gr. Code");
                            ServiceContractAccountGroup.GET(Rec."Serv. Contract Acc. Gr. Code");
                            ServiceContractAccountGroup.TESTFIELD(ServiceContractAccountGroup."Non-Prepaid Contract Acc.");
                            ServiceLine.VALIDATE(ServiceLine."No.",ServiceContractAccountGroup."Non-Prepaid Contract Acc.");
                          END;}
                          //ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);
                          ServiceLine.VALIDATE(ServiceLine."No.",ServMgmtSetup."Penalty Account"); // WIN210
                          ServiceLine.VALIDATE(ServiceLine."VAT Prod. Posting Group",Rec."VAT Prod. Posting Group");
                          ServiceLine.VALIDATE(ServiceLine.Description,'Terminated Contract');
                          ServiceLine.VALIDATE(ServiceLine.Quantity,1);
                          ServiceLine.VALIDATE(ServiceLine."Unit Price",("Actual Utilized Rent Amount" + "Penalty Amount"));
                          ServiceLine.INSERT;
                        
                          MESSAGE('Service Invoice has been created');
                          IF CONFIRM('Do you want open newly created Service Invoice?',TRUE) THEN
                            PAGE.RUN(5933,ServiceHeader)
                          ELSE
                            EXIT;
                        END;
                        //win315--
                        */
                        // Process Termination

                        Rec.TestField("Approval Status", Rec."approval status"::Released);
                        Rec.TestField("Termination Date");
                        ServMgmtSetup.Get;
                        if Rec.Terminated = false then begin
                            if Confirm('Do you want to terminate contract?', true) then begin
                                Rec.CreateSingleCrMemo;
                                if ServMgmtSetup."Penalty Month" = 60 then
                                    Rec."Penalty Amount Days" := '60 Days'
                                else
                                    Rec."Penalty Amount Days" := '';

                                if ServiceItem.Get(Rec."Service Item No.") then
                                    repeat
                                        ServiceItem."Occupancy Status" := ServiceItem."occupancy status"::Vacant;
                                        ServiceItem.Modify;
                                    until ServiceItem.Next = 0;
                                Rec.Terminated := true;
                                Rec.Status := Rec.Status::Canceled;
                                Rec."Termination Reason Code" := 'Lease Termination';
                                Rec.Modify;
                            end else
                                exit;
                        end else
                            Error('Already Terminated');

                        Rec."Contract Current Status" := Rec."Contract Current Status"::Terminated;
                        Rec.Modify();
                        //WIN586

                        // CreateSingleInvoice;
                        // Process Termination

                    end;
                }
                action("Single Credit Memo")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Single Credit Memo';
                    Image = CreateCreditMemo;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        Rec.CalcFields("No. of Posted Invoices");
                        Rec.TestField("Approval Status", Rec."approval status"::Released);
                        Rec.TestField(Status, Rec.Status::Signed);
                        Rec.TestField("No. of Posted Invoices");
                        ServMgmtSetup.Get;
                        if Rec.Terminated = false then begin
                            if Confirm('Do you want to create Single Credit Memo?', true) then begin
                                Rec.SetCreditMemo(true, Rec."Starting Date", Rec."Deal Closing Date");
                                Rec.CreateSingleCrMemo;
                                if ServiceItem.Get(Rec."Service Item No.") then
                                    repeat
                                        ServiceItem."Occupancy Status" := ServiceItem."occupancy status"::Vacant;
                                        ServiceItem.Modify;
                                    until ServiceItem.Next = 0;
                                //Terminated := TRUE;
                                Rec.Status := Rec.Status::Canceled;
                                //"Termination Reason Code" := 'Lease Termination';
                                Rec.Modify;
                            end else
                                exit;
                        end else
                            Error('Already Terminated');

                        // CreateSingleInvoice;
                        // Process Termination
                    end;
                }
            }
        }
        addafter("C&hange Customer")
        {
            action("Renew Contract")
            {
                ApplicationArea = Basic;
                Caption = 'Renew Contract';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecCust: Record Customer;
                begin
                    /*OldContract.RESET;
                    OldContract.SETRANGE("Item No.",Rec."Item No.");
                    OldContract.SETRANGE(Active,TRUE);
                    IF OldContract.FINDFIRST THEN BEGIN
                      MESSAGE('%1',OldContract."Contract No.");
                      Rec.VALIDATE("Customer No.",OldContract."Customer No.");
                      Rec.VALIDATE("Contact No.",OldContract."Contact No.");
                      Rec.VALIDATE("Service Period",OldContract."Service Period");
                    END ELSE MESSAGE ('Contract not Found');
                    
                    CheckRequiredFieldsRenewal;
                    CLEAR(CopyServDoc);
                    CopyServDoc.SetServContractHeader(Rec);
                    CopyServDoc.RUNMODAL;
                    
                    //MESSAGE('');
                    {
                    
                    
                    CLEAR(CopyServDoc);
                    CopyServDoc.SetServContractHeader(Rec);
                    CopyServDoc.RUNMODAL;
                    }
                    */
                    //win315++
                    if Confirm('Do you want to renew this contract?', true) then begin
                        if Rec."Renewal Contract" = false then begin
                            if RecCust.Get(Rec."Customer No.") then begin
                                RecCust.CalcFields(RecCust."Balance (LCY)");
                                if RecCust."Balance (LCY)" > 0 then begin
                                    Error('There is outstanding balance for this customer. You cannot renew contract.');
                                end else
                                    ;
                                Clear(ContractRenewalProces);
                                ContractRenewalProces.SetServiceContract(Rec."Contract Type", Rec."Contract No.");
                                ContractRenewalProces.RunModal;

                                //Rec."Contract Current Status" := Rec."Contract Current Status"::Expired;
                                //Rec.Modify();
                                //WIN586

                            end;
                        end else
                            Error('Contract %1 already renewed', Rec."Contact No.");
                    end else
                        exit;
                    //win315--
                    // REPORT.RUNMODAL(50000,TRUE,FALSE,Rec);

                end;
            }
        }
        //Win513++
        addafter("&Print")
        {
            action("Terms and Conditions")
            {
                ApplicationArea = All;
                Caption = 'Terms and Conditions';
                Image = ConditionalBreakpoint;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PageTnC: Page SelectTNC;
                    RecTnC: Record "Terms And Conditions";
                begin
                    if Rec."Tenancy Type" = Rec."Tenancy Type"::" " then
                        Error('Kindly select Tenancy Type');

                    AddMandatoryTnC(Rec."Contact No.");

                    if Rec."Tenancy Type" = Rec."Tenancy Type"::Commercial then
                        RecTnC.SetRange(RecTnC."Contract Type", RecTnC."Contract Type"::Commercial);
                    if Rec."Tenancy Type" = Rec."Tenancy Type"::Residential then
                        RecTnC.SetRange(RecTnC."Contract Type", RecTnC."Contract Type"::Residential);

                    RecTnC.SetRange(RecTnC.Mandatory, false);
                    PageTnC.SetDocumentTypes(2, 0, Rec."Contact No.");
                    PageTnC.SetTableView(RecTnC);
                    PageTnC.RunModal();
                end;
            }
        }

        addafter("&Contract")
        {
            action("LESSOR T&C")
            {
                ApplicationArea = All;
                Caption = 'LESSOR TnC';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Action;

                trigger OnAction()
                begin
                    OpenSelectTnCList(TnCType::LESSOR)
                end;
            }
            action("LESSEE T&C")
            {
                ApplicationArea = All;
                Caption = 'LESSEE TnC';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Action;

                trigger OnAction()
                begin
                    OpenSelectTnCList(TnCType::LESSEE)
                end;
            }
            action("GENERAL T&C")
            {
                ApplicationArea = All;
                Caption = 'GENERAL TnC';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Action;

                trigger OnAction()
                begin
                    OpenSelectTnCList(TnCType::GENERAL)
                end;
            }
        }
        addafter("Expired Contract Lines")
        {
            //WIN 586 ----
            action("Rent & Other Charges Draft Receipts")
            {
                ApplicationArea = Basic;
                Image = PrintDocument;
                Promoted = false;


                trigger OnAction()
                begin

                    ServContrHdr.Reset;
                    ServContrHdr.SetRange(ServContrHdr."Contract Type", ServContrHdr."contract type"::Contract);
                    ServContrHdr.SetRange(ServContrHdr."Contract No.", Rec."Contract No.");
                    if ServContrHdr.FindFirst then
                        Report.RunModal(50001, true, false, ServContrHdr);

                end;
            }
            //WIN 586----

        }

    }
    trigger OnAfterGetCurrRecord()
    var
    begin
        if Rec."Expiration Date" <= Today then
            if Rec."Contract Current Status" <> Rec."Contract Current Status"::Expired
            then
                Rec."Contract Current Status" := Rec."Contract Current Status"::Closed;
        Rec.Modify();
    end;

    trigger OnOpenPage()
    var
    begin

    end;

    var
        OldContract: Record "Service Contract Header";
        ContractRenewalProces: Report 50000;
        ServiceItem: Record "Service Item";
        ServMgmtSetup: Record "Service Mgt. Setup";
        ServContrHdr: Record "Service Contract Header";
        ServiceContractHeader: Record "Service Contract Header";
        ServiceCrMemoHeader: Record "Service Header";
        ServiceCrMemoLine: Record "Service Line";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServPostYesNo: Codeunit "Service-Post (Yes/No)";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceContractAccountGroup: Record "Service Contract Account Group";
        GLAcc: Record "G/L Account";
        DimSetEntry: Record "Dimension Set Entry";
        ServiceItem1: Record "Service Item";
        DeferralHeader: Record "Deferral Header";
        DeferralTemplate: Record "Deferral Template";
        DeferralLine: Record "Deferral Line";
        InvFrm: Date;
        //ContractRenewalProces1: Report 50008;//WIN292
        ALLSubs: Codeunit "All Subscriber";
        RenewalContract: Boolean;
        ClosingContract: Boolean;
        TnCType: enum "TNC Type";
        Text000: Label '%1 must not be blank in %2 %3';
        Text003: Label 'There are unposted invoices associated with this contract.\\Do you want to continue?';
        Text004: Label 'You cannot create an invoice for %1 %2 because %3 is %4.';
        Text005: Label 'The next invoice date has not expired';
        Text006: Label 'An invoice was created successfully.';
        Text007: Label 'Do you want to create an invoice for the contract?';
        Text008: Label 'The invoice was created successfully.';
        Text009: Label 'There are unposted credit memos associated with this contract.\\Do you want to continue?';
        Text010: Label 'Do you want to create a credit note for the contract?';
        Text011: Label 'Processing...        \\';
        Text012: Label 'Contract lines have been credited.\\Credit memo %1 was created.';
        Text013: Label 'A credit memo cannot be created. There must be at least one invoiced and expired service contract line which has not yet been credited.';
        Text014: Label 'Do you want to file the contract?';
        Text015: Label '%1 must not be %2 in %3 %4';
        Text016: Label 'A credit memo cannot be created, because the %1 %2 is after the work date.';


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    begin
        /*
        UpdateShiptoCode;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin

        Rec.UpdateShiptoCode;
        IF Rec."Renewal Contract" = TRUE THEN
            RenewalContract := TRUE
        ELSE
            IF Rec."Renewal Contract" = FALSE THEN
                RenewalContract := FALSE;

        IF Rec."Contract Closed" = TRUE THEN
            ClosingContract := TRUE
        ELSE
            IF Rec."Contract Closed" = FALSE THEN
                ClosingContract := FALSE;

    end;

    procedure CheckRequiredFieldsRenewal()
    begin
        /*
        
        IF "Contract No." = '' THEN
          ERROR(Text000,FIELDCAPTION("Contract No."),TABLECAPTION,"Contract No.");
        IF "Customer No." = '' THEN
          ERROR(Text000,FIELDCAPTION("Customer No."),TABLECAPTION,"Contract No.");
        IF FORMAT("Service Period") = '' THEN
          ERROR(Text000,FIELDCAPTION("Service Period"),TABLECAPTION,"Contract No.");
        IF "First Service Date" = 0D THEN
          ERROR(Text000,FIELDCAPTION("First Service Date"),TABLECAPTION,"Contract No.");
        IF Status = Status::Canceled THEN
          ERROR(Text015,FIELDCAPTION(Status),FORMAT(Status),TABLECAPTION,"Contract No.");
        IF "Change Status" = "Change Status"::Locked THEN
          ERROR(Text015,FIELDCAPTION("Change Status"),FORMAT("Change Status"),TABLECAPTION,"Contract No.");
        */

    end;

    local procedure UpdatePostingDate()
    var
        ServHdr: Record "Service Header";
    begin
        ServHdr.Reset;
        //ServHdr.SETRANGE(ServHdr."No.",)
    end;

    local procedure InsertServiceCharges()
    var
        ServCharge: Record "Service Charges";
    begin
        /*ServCharge.RESET;
        ServCharge.SETRANGE(ServCharge."Service Contract Quote No.",ServContractHdr."Contract No.");
        ServContractHdr.SETFILTER(ServContractHdr."Contract Type",'%1',ServContractHdr."Contract Type"::Quote);
        ServContractHdr.SETFILTER(ServContractHdr."Mode of Payment",'%1','PDC');
        ServContractHdr.SETFILTER(ServContractHdr."PDC Entry Generated",'%1',FALSE);
        IF ServCharge.FINDSET THEN REPEAT
          RecPDCL.INIT;
          RecPDCL."Batch Name" := 'PDC';
          num := num + 10000;
          RecPDCL."Line Number" := num;
        
          //RecPDCL.VALIDATE("Document No.");
          RecPDCL."Document No." := ServCharge."Document No.";
          RecPDCL.VALIDATE(RecPDCL."Contract No.",ServContractHdr."Contract No.");
          RecPDCL."Account Type" := RecPDCL."Account Type"::Customer;
          RecPDCL.VALIDATE(RecPDCL."Account No.",ServCharge."Customer No.");
          RecPDCL.VALIDATE(RecPDCL."Bal. Account Type",RecPDCL."Bal. Account Type"::"G/L Account");
          RecPDCL.VALIDATE(RecPDCL."Bank Account",ServCharge."Bal. Account No.");
          RecPDCL.Amount := ServCharge."Charge Amount";
          RecPDCL."Customer No." := ServContractHdr."Customer No.";
          ServContractHdr.CALCFIELDS(ServContractHdr.Name);
          RecPDCL."Customer Name" := ServContractHdr.Name;
          RecPDCL."Check Date" := ServCharge."Charge Date";
          RecPDCL."Charge Code" := ServCharge."Charge Code";
          RecPDCL."Charge Description" := ServCharge."Charge Description";
          //RecPDCL."Payment Method" := RecPDCL."Payment Method"::PDC;
          //PDCDate:=RecPDCL."Check Date";
          RecPDCL.INSERT;
          ServContractHdr."PDC Entry Generated" := TRUE;
          ServContractHdr.MODIFY;
        UNTIL ServCharge.NEXT = 0;
        MESSAGE('PDC entries has been generated successfully.');*/

    end;

    //Win513++
    procedure AddMandatoryTnC(ContractNo: Code[20])
    var
        RecTnC: Record "Terms & Condtions";
        TnC: Record "Terms And Conditions";
    begin
        RecTnC.Reset();
        RecTnC.SetRange(RecTnC."Transaction Type", RecTnC."Transaction Type"::Service);
        RecTnC.SetRange(RecTnC."Document Type", RecTnC."Document Type"::Order);
        RecTnC.SetRange(RecTnC."Document No.", ContractNo);
        if RecTnC.IsEmpty then begin
            TnC.Reset();

            if Rec."Tenancy Type" = Rec."Tenancy Type"::Commercial then
                TnC.SetRange(TnC."Contract Type", TnC."Contract Type"::Commercial);
            if Rec."Tenancy Type" = Rec."Tenancy Type"::Residential then
                TnC.SetRange(TnC."Contract Type", TnC."Contract Type"::Residential);

            TnC.SetRange(TnC.Mandatory, true);
            if TnC.FindSet() then
                repeat
                    RecTnC.Init();
                    RecTnC."Transaction Type" := RecTnC."Transaction Type"::Service;
                    RecTnC."Document Type" := RecTnC."Document Type"::Order;
                    RecTnC."Document No." := ContractNo;
                    RecTnC."No." := TnC."No.";
                    RecTnC.Conditions := TnC.Description;
                    RecTnC.Insert();
                until TnC.Next() = 0;
        end;
    end;

    local procedure OpenSelectTnCList(TnCType: enum "TNC Type")
    var
        TncMaster: Record "TNC Master";
        SelectTnCList: Page "Select TNC List";
    begin
        TncMaster.SetRange("TNC Type", TnCType);
        SelectTnCList.SetContractHeader(Rec);
        SelectTnCList.SetTableView(TncMaster);
        SelectTnCList.Run();
    end;
    //Win513--
}

