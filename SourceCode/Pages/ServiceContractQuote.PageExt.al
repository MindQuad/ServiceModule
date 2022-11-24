PageExtension 50308 pageextension50308 extends "Service Contract Quote"
{
    Caption = 'Lease Quote';
    layout
    {

        modify(Description)
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Contact No.")
        {
            ApplicationArea = All;
            Visible = false;
        }


        modify("Service Period")
        {
            ApplicationArea = All;
            Visible = false;
        }


        addafter("Contract No.")
        {

            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }

            field("Tenant Name"; Rec."Tenant Name")
            {
                ApplicationArea = Basic;
                Editable = true;
                Visible = false;
            }
            field("<Unit No.>"; Rec."Unit No.")
            {
                ApplicationArea = Basic;
                Caption = 'Unit No.';
                //WIN 586 ----
                trigger OnValidate()
                var
                    RecServiceItems: Record "Service Item";
                begin
                    RecServiceItems.Reset();
                    RecServiceItems.SetRange("Unit No.", Rec."Unit No.");
                    if RecServiceItems.FindFirst() then begin
                        Rec."Contract Group Code" := RecServiceItems."Service Item Group Code";
                    end;

                end;
                //WIN 586 ----
            }
            field("Service Item No."; Rec."Service Item No.")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item No.';
                Editable = false;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("<Unit Code1>"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = false;
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

            field("Contract Status"; Rec."Contract Status")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
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
            ApplicationArea = All;
            trigger OnAfterValidate()
            begin
                //win315++
                if Rec."Expiration Date" < Rec."Starting Date" then
                    Error('Expiration Date should not be lesser than Starting Date');
                //win315--
            end;
        }
        Modify("Starting Date")
        {

            ApplicationArea = All;
            trigger OnAfterValidate()
            begin
                //win315++
                if Rec."Starting Date" < Rec."Deal Closing Date" then
                    Error('Starting Date should not be less than Deal Closing Date');
                //win315--
            end;
        }
        addafter("Responsibility Center")
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Change Status")
        {
            field("Invoice Generation"; Rec."Invoice Generation")
            {
                ApplicationArea = Basic;
            }
            field("Mode of Payment"; Rec."Mode of Payment")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    if Rec."Mode of Payment" = 'CASH+PDC' then begin
                        CheckVisible := true;
                        CheckVisible1 := true;
                    end else
                        if Rec."Mode of Payment" = 'PDC' then begin
                            CheckVisible := false;
                            CheckVisible1 := false;
                        end;
                end;
            }

            field("PDC Entry Generated"; Rec."PDC Entry Generated")
            {
                ApplicationArea = Basic;
            }
        }
        modify("Serv. Contract Acc. Gr. Code")
        {
            trigger OnAfterValidate()
            begin
                Rec.Validate("Invoice Period", Rec."Invoice Period"::Year);
            end;
        }

        addafter("Serv. Contract Acc. Gr. Code")
        {
            field("Defferal Code"; Rec."Defferal Code")
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
        addafter(Prepaid)
        {
            field("No. of PDC"; Rec."No. of PDC")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Your Reference")
        {
            field("Service Quote Type"; Rec."Service Quote Type")
            {
                ApplicationArea = Basic;
            }
            field("No. of Cash"; Rec."No. of Cheque")
            {
                ApplicationArea = Basic;
                Caption = 'No. of Cash';
                Enabled = CheckVisible;
            }
            field("Cash Amount"; Rec."Cash Amount")
            {
                ApplicationArea = Basic;
                Enabled = CheckVisible1;
            }
            field("Discount Hold"; Rec."Discount Hold")
            {
                ApplicationArea = Basic;
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Currency Code")
        {
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = Basic;
                Editable = false;

                trigger OnValidate()
                begin
                    if Rec."VAT Prod. Posting Group" = 'VAT-5' then begin
                        ReportVATVisible := true;
                        ReportVATVisible1 := false
                    end else
                        if Rec."VAT Prod. Posting Group" = 'NO VAT' then begin
                            ReportVATVisible := false;
                            ReportVATVisible1 := true;
                        end;
                end;
            }
            field("Tenancy Type"; Rec."Tenancy Type")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        moveafter("Change Status"; "Serv. Contract Acc. Gr. Code")
        moveafter("Serv. Contract Acc. Gr. Code"; Prepaid)
        moveafter(Prepaid; "Your Reference")
        addafter("PDC Entry Generated")
        {
            field("Planned Rate"; Rec."Planned Rate")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("No. of Bedrooms"; Rec."No. of Bedrooms")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Bedrooms field.';
                Editable = false;
            }
            field(Floor; Rec.Floor)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Floor field.';
                Editable = false;
            }
        }

    }
    actions
    {

        //Unsupported feature: Property Insertion (Visible) on ""Service Dis&counts"(Action 81)".


        //Unsupported feature: Property Insertion (Visible) on ""Service &Hours"(Action 72)".


        //Unsupported feature: Property Insertion (Visible) on ""&Filed Contract Quotes"(Action 98)".


        //Unsupported feature: Property Insertion (Visible) on ""&Select Contract Quote Lines"(Action 103)".


        //Unsupported feature: Property Insertion (Visible) on ""Copy &Document..."(Action 36)".


        //Unsupported feature: Property Insertion (Visible) on ""&File Contract Quote"(Action 122)".


        //Unsupported feature: Property Insertion (Visible) on ""Update &Discount % on All Lines"(Action 77)".


        //Unsupported feature: Property Insertion (Visible) on ""Update with Contract &Template"(Action 15)".


        //Unsupported feature: Property Insertion (Visible) on ""Loc&k"(Action 11)".


        //Unsupported feature: Property Insertion (PromotedIsBig) on ""&Make Contract"(Action 86)".


        //Unsupported feature: Property Insertion (Visible) on ""Service Quote Details"(Action 1905622906)".


        //Unsupported feature: Property Insertion (Visible) on ""Contract Quotes to be Signed"(Action 1905017306)".



        //Unsupported feature: Code Modification on ""&Make Contract"(Action 86).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.UPDATE(TRUE);
        SignServContractDoc.SignContractQuote(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CurrPage.UPDATE(TRUE);
        TESTFIELD("Approval Status","Approval Status"::Released); //win315
        SignServContractDoc.SignContractQuote(Rec);
        */
        //end;
        addafter("&Print")
        {
            group(PDC)
            {
                Caption = 'PDC';
                action("Generate PDC Entry")
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate PDC Entry';
                    Image = Entries;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServCh: Record "Service Charges";
                    begin
                        //win315++
                        /*
                        TESTFIELD("Approval Status","Approval Status"::Open);
                        TESTFIELD("Mode of Payment");
                        
                        IF "Mode of Payment"<> 'PDC' THEN
                           ERROR('Mode of Payment should be PDC to generate PDC entries');
                        
                        TESTFIELD("Payment Terms Code");
                        TESTFIELD("No. of PDC");
                        TESTFIELD("Annual Amount");
                        
                        IF ("PDC Entry Generated" =  FALSE)  THEN BEGIN
                          IF CONFIRM('Do you want to generate PDC entries',TRUE) THEN
                            ToGeneratePDCEntry
                          ELSE
                            EXIT;
                        END ELSE
                          ERROR('PDC entries already generated for contract %1',"Contract No.");*/
                        //win315--

                        Rec.TestField("Approval Status", Rec."approval status"::Open);
                        Rec.TestField("Mode of Payment");

                        if ((Rec."Mode of Payment" <> 'PDC') and (Rec."Mode of Payment" <> 'CASH+PDC')) then
                            Error('Mode of Payment should be PDC or CASH+PDC to generate PDC entries');

                        Rec.TestField("Payment Terms Code");
                        Rec.TestField("No. of PDC");
                        Rec.TestField("Annual Amount");

                        ServCh.Reset;
                        ServCh.SetRange(ServCh."Service Contract Quote No.", Rec."Contract No.");
                        if not ServCh.FindFirst then
                            if Confirm('Service charges does not exist. Do you still want to generate PDC?', true) then begin
                                //IF CONFIRM('You dont want to create service charge entries?',TRUE) THEN BEGIN
                                if (Rec."PDC Entry Generated" = false) then begin
                                    if Confirm('Do you want to generate PDC entries', true) then begin
                                        if Rec."Mode of Payment" = 'PDC' then
                                            ToGeneratePDCEntry
                                        else
                                            if Rec."Mode of Payment" = 'CASH+PDC' then
                                                ToGeneratePDCEntry1
                                    end else
                                        exit;
                                end else
                                    Error('PDC entries already generated for contract %1', Rec."Contract No.");
                                //
                            end else
                                Error('Please update service charges');


                        ServCh.Reset;
                        ServCh.SetRange(ServCh."Service Contract Quote No.", Rec."Contract No.");
                        if ServCh.FindFirst then begin
                            //
                            if (Rec."PDC Entry Generated" = false) then begin
                                if Confirm('Do you want to generate PDC entries', true) then begin
                                    if Rec."Mode of Payment" = 'PDC' then
                                        ToGeneratePDCEntry
                                    else
                                        if Rec."Mode of Payment" = 'CASH+PDC' then
                                            ToGeneratePDCEntry1
                                end else
                                    exit;
                            end else
                                Error('PDC entries already generated for contract %1', Rec."Contract No.");
                        end;


                    end;
                }
                action("PDC Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'PDC Entries';
                    Image = Entries;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PDCEntries: Page "Post Dated Checks Register";
                        RecPDCEntries: Record "Post Dated Check Line";
                    begin
                        RecPDCEntries.Reset();
                        RecPDCEntries.SetRange("Contract No.", Rec."Contract No.");
                        RecPDCEntries.SetFilter("G/L Transaction No.", '=%1', 0);
                        PDCEntries.SetTableView(RecPDCEntries);
                        PDCEntries.RunModal();
                    end;
                }
                action("Posted PDC Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted PDC Entries';
                    Image = Entries;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PDCEntries: Page "Post Dated Checks Register";
                        RecPDCEntries: Record "Post Dated Check Line";
                    begin
                        RecPDCEntries.Reset();
                        RecPDCEntries.SetRange("Contract No.", Rec."Contract No.");
                        RecPDCEntries.SetFilter("G/L Transaction No.", '<>%1', 0);
                        PDCEntries.SetTableView(RecPDCEntries);
                        PDCEntries.RunModal();
                    end;
                }
            }
            //WIN513++ 15Jul2022
            group("Charges")
            {
                action("Service Contract Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Service Contract Charges';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Process;

                    RunObject = Page "Service charge List";
                    RunPageLink = "Table Name" = CONST("Service Contract"), "Table Subtype" = FIELD("Contract Type"), "Service Contract Quote No." = FIELD("Contract No."), "Table Line No." = CONST(0), "Customer No." = FIELD("Customer No."), Post = FILTER(false);
                }

                action("Posted Service Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Charges';
                    Image = ServiceAccessories;
                    Promoted = true;
                    PromotedCategory = Process;

                    RunObject = Page "Posted Service Charges1";
                    RunPageLink = "Table Name" = CONST("Service Contract"), "Table Subtype" = FIELD("Contract Type"), "Service Contract Quote No." = FIELD("Contract No."), "Table Line No." = CONST(0), "Customer No." = FIELD("Customer No."), Post = FILTER(true);
                }

                action("Renewal Contract Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Renewal Contract Charges';
                    Image = ServiceHours;
                    Promoted = true;
                    PromotedCategory = Process;

                    RunObject = Page "Service charge List";
                    RunPageLink = "Table Name" = CONST("Service Contract"), "Table Subtype" = FIELD("Contract Type"), "Service Contract Quote No." = FIELD("Previous Contract No."), "Table Line No." = CONST(0), "Customer No." = FIELD("Customer No."), Post = FILTER(false);
                }
                action("Posted Renewal Service Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Renewal Service Charges';
                    Image = ServiceHours;
                    Promoted = true;
                    PromotedCategory = Process;

                    RunObject = Page "Posted Service Charges";
                    RunPageLink = "Table Name" = CONST("Service Contract"), "Table Subtype" = FIELD("Contract Type"), "Service Contract Quote No." = FIELD("Previous Contract No."), "Table Line No." = CONST(0), "Customer No." = FIELD("Customer No."), Post = FILTER(true);
                }
            }
            //WIN513--
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
                        Rec.TestField("PDC Entry Generated", true);  //win315
                        if AllSubs.CheckServiceContractApprovalPossible(Rec) then
                            AllSubs.OnSendServiceContractDocForApproval(Rec);
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
                        AllSubs.OnCancelServiceContractApprovalRequest(Rec);
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
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comment';
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Incoming Documents")
            {
                Caption = 'Incoming Documents';
                action(AttachFile)
                {
                    ApplicationArea = Basic;
                    Caption = 'Attach File';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        IncomingDocumentAttachment.NewAttachment1(Rec."Contract No.", 10000);
                    end;
                }
            }
            group(ActionGroup1000000031)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator(Action1000000030)
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
                separator(Action1000000027)
                {
                }
            }
        }
        addafter("Contract Quotes to be Signed")
        {
            action("Renewal Letter")
            {
                ApplicationArea = Basic;
                Caption = 'Renewal Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                Visible = ReportVisible;

                trigger OnAction()
                begin
                    SerConHdr.Reset;
                    SerConHdr.SetRange(SerConHdr."Contract Type", Rec."Contract Type");
                    SerConHdr.SetRange(SerConHdr."Contract No.", Rec."Contract No.");
                    if SerConHdr.FindFirst then begin
                        Report.RunModal(50002, true, false, SerConHdr);
                        if Confirm('Do you want to send an email?', true) then
                            SendMailtoSP
                        else
                            exit;
                    end;
                end;
            }
            action("Lease Application Form-Commertial")
            {
                ApplicationArea = Basic;
                Caption = 'Lease Application Form-Commertial';
                Image = Report;
                Promoted = true;
                PromotedCategory = "Report";
                Visible = ReportVATVisible;

                trigger OnAction()
                var
                    PDC: Record "Post Dated Check Line";
                begin
                    Rec.TestField("Approval Status", Rec."approval status"::Released);
                    //TESTFIELD();
                    // PDC.Reset;
                    // PDC.SetRange(PDC."Contract No.", Rec."Contract No.");
                    // PDC.SetFilter(PDC."Payment Method", '<>%1 & <>%2', PDC."payment method"::Cash, PDC."payment method"::" ");
                    // if PDC.FindSet then
                    //     repeat
                    //         if PDC."Check No." = '' then
                    //             PDC.TestField(PDC."Check No.");

                    //     until PDC.Next = 0;


                    Rec.TestField("Approval Status", Rec."approval status"::Released);
                    SerConHdr.Reset;
                    SerConHdr.SetRange(SerConHdr."Contract Type", Rec."Contract Type");
                    SerConHdr.SetRange(SerConHdr."Contract No.", Rec."Contract No.");
                    if SerConHdr.FindFirst then
                        Report.RunModal(50005, true, false, SerConHdr);
                end;
            }
            action("Lease Application Form-Residential")
            {
                ApplicationArea = Basic;
                Caption = 'Lease Application Form-Residential';
                Image = Report;
                Promoted = true;
                PromotedCategory = "Report";
                Visible = ReportVATVisible1;

                trigger OnAction()
                begin
                    Rec.TestField("Approval Status", Rec."approval status"::Released);
                    SerConHdr.Reset;
                    SerConHdr.SetRange(SerConHdr."Contract Type", Rec."Contract Type");
                    SerConHdr.SetRange(SerConHdr."Contract No.", Rec."Contract No.");
                    if SerConHdr.FindFirst then
                        Report.RunModal(50003, true, false, SerConHdr);
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

        addafter("&Make Contract")
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
        //Win513--
    }
    trigger OnAfterGetCurrRecord()
    var
        RecServiceItems1: Record "Service Item";
    begin
        RecServiceItems1.Reset();
        RecServiceItems1.SetRange(RecServiceItems1."No.", Rec."Service Item No.");
        if RecServiceItems1.FindFirst() then begin

            Rec."No. of Bedrooms" := Format(RecServiceItems1."No. of Bedrooms");
            Rec.Floor := RecServiceItems1.Floor;
            Rec."Planned Rate" := RecServiceItems1."Planned Rate";
        end;

    end;

    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        SerConHdr: Record "Service Contract Header";
        AllSubs: Codeunit "All Subscriber";
        RenewalLetter: Text[250];
        ReportVisible: Boolean;
        ReportVATVisible: Boolean;
        ReportVATVisible1: Boolean;
        CheckVisible: Boolean;
        CheckVisible1: Boolean;
        EditableDate: Boolean;
        Duration: Integer;
        ExpirationDate: Date;
        StartingDate: Date;
        ExpirationDateTime: DateTime;
        StartingDateTime: DateTime;
        Duration1: Duration;
        ChequeDate: DateTime;
        chq: DateTime;
        NwUpdate: Date;
        TnCType: enum "TNC Type";

    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS("Calcd. Annual Amount");
    ActivateFields;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CALCFIELDS("Calcd. Annual Amount");
    ActivateFields;

    //win315++
    IF "Service Quote Type" = "Service Quote Type"::Renewal THEN
      ReportVisible := TRUE
    ELSE
      ReportVisible := FALSE;

    IF "VAT Prod. Posting Group" = 'VAT-5' THEN BEGIN
      ReportVATVisible := TRUE;
      ReportVATVisible1 := FALSE
    END ELSE
      IF "VAT Prod. Posting Group" = 'VAT-0' THEN BEGIN
      ReportVATVisible := FALSE;
      ReportVATVisible1 :=TRUE;
    END;
*/
    trigger OnAfterGetRecord()

    begin

        IF Rec."Tenancy Type" = Rec."Tenancy Type"::Commercial THEN BEGIN
            ReportVATVisible := TRUE;
            ReportVATVisible1 := FALSE
        END ELSE
            IF Rec."Tenancy Type" = Rec."Tenancy Type"::Residential THEN BEGIN
                ReportVATVisible := FALSE;
                ReportVATVisible1 := TRUE;
            END;
    end;
    /*

    IF ("Mode of Payment" = 'CASH+PDC') OR ("Mode of Payment" = 'CASH') THEN BEGIN
      CheckVisible := TRUE;
      CheckVisible1 := TRUE;
    END ELSE
      IF "Mode of Payment" = 'PDC' THEN BEGIN
      CheckVisible := FALSE;
      CheckVisible1 := FALSE;
    END;

    IF "Service Quote Type" = "Service Quote Type"::Renewal THEN
      EditableDate := FALSE
    ELSE
      IF "Service Quote Type" = "Service Quote Type"::"New Contract" THEN
      EditableDate := TRUE;
    //win315--
    */
    //end;


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InvoiceAfterServiceEnable := TRUE;
    PrepaidEnable := TRUE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    InvoiceAfterServiceEnable := TRUE;
    PrepaidEnable := TRUE;
    //Prepaid:=TRUE;   //win315
    */
    //end;

    local procedure ToGeneratePDCEntry()
    var
        RecPDCL: Record "Post Dated Check Line";
        ServContractHdr: Record "Service Contract Header";
        num: Integer;
        num1: Integer;
        RecPDCL1: Record "Post Dated Check Line";
        days: Integer;
        Exp: Text;
        PDCDays: Integer;
        PDCDate: Date;
        PayMethod: Record "Payment Method";
        ServCharge: Record "Service Charges";
        ServContractManagement: Codeunit ServContractManagement;
        ChargeMaster: Record "Charge Master";
    begin
        //win315++
        /*num1:=0;
        days:=0;
        PDCDays:=0;
        PDCDate:=0D;
        RecPDCL.RESET;
        RecPDCL.SETRANGE("Batch Name",'PDC');
        RecPDCL.SETRANGE("Account Type",RecPDCL."Account Type"::Customer);
        RecPDCL.SETRANGE("Account No.",Rec."Customer No.");
        IF RecPDCL.FINDLAST THEN
          num := RecPDCL."Line Number"
        ELSE
          num :=0;
        
        ServContractHdr.SETRANGE(ServContractHdr."Contract No.",Rec."Contract No.");
        ServContractHdr.SETFILTER(ServContractHdr."Contract Type",'%1',ServContractHdr."Contract Type"::Quote);
        ServContractHdr.SETFILTER(ServContractHdr."Mode of Payment",'%1','PDC');
        ServContractHdr.SETFILTER(ServContractHdr."PDC Entry Generated",'%1',FALSE);
        IF ServContractHdr.FINDSET THEN REPEAT
          IF ServContractHdr."No. of PDC" <> num1 THEN REPEAT
          RecPDCL.INIT;
          RecPDCL."Batch Name" := 'PDC';
          num := num + 10000;
          RecPDCL."Line Number" := num;
        
          days:= ("Expiration Date" - "Starting Date");
          PDCDays:=ROUND(days/"No. of PDC",1,'=');
          Exp:= FORMAT(PDCDays) + 'D';
        
          IF PDCDate = 0D THEN
           PDCDate:="Starting Date";
        
          RecPDCL."Check Date" := CALCDATE(Exp,PDCDate);
          RecPDCL."Contract Due Date" := CALCDATE(Exp,PDCDate);
          RecPDCL.VALIDATE("Document No.");
          //RecPDCL."No. Series" := 'PDC';
          //RecPDCL."Template Name" := 'PAYMENT';
          RecPDCL."Account Type" := RecPDCL."Account Type"::Customer;
          //RecPDCL."Contract Due Date" := ServContractHdr."Next Invoice Date";
          //RecPDCL."PDC Due Date" := ServContractHdr."Next Invoice Date";
          RecPDCL.VALIDATE(RecPDCL."Account No.",ServContractHdr."Customer No.");
          RecPDCL.Amount := -(ServContractHdr."Annual Amount" / ServContractHdr."No. of PDC");
          RecPDCL."Contract Amount" := -(ServContractHdr."Annual Amount" / ServContractHdr."No. of PDC");
          PDCDate:=RecPDCL."Check Date";
          //RecPDCL."Contract No.":=Rec."Contact No.";
          RecPDCL.INSERT;
          num1 := num1+1;
          UNTIL ServContractHdr."No. of PDC" = num1;
          ServContractHdr."PDC Entry Generated" := TRUE;
          ServContractHdr.MODIFY;
        
        UNTIL ServContractHdr.NEXT =0;
        MESSAGE('PDC entries has been generated successfully.');*/
        //win315--




        num1 := 0;
        days := 0;
        Clear(ChequeDate);
        Clear(NwUpdate);
        PDCDays := 0;
        PDCDate := 0D;
        //ChequeDate:=0D;
        RecPDCL.Reset;
        RecPDCL.SetRange("Batch Name", 'PDC');
        //RecPDCL.SETRANGE("Account Type",RecPDCL."Account Type"::Customer);
        RecPDCL.SetRange("Customer No.", Rec."Customer No.");
        if RecPDCL.FindLast then
            num := RecPDCL."Line Number"
        else
            num := 0;
        CalcDuration;
        ServContractHdr.SetRange(ServContractHdr."Contract No.", Rec."Contract No.");
        ServContractHdr.SetFilter(ServContractHdr."Contract Type", '%1', ServContractHdr."contract type"::Quote);
        ServContractHdr.SetFilter(ServContractHdr."Mode of Payment", '%1', 'PDC');
        ServContractHdr.SetFilter(ServContractHdr."PDC Entry Generated", '%1', false);
        if ServContractHdr.FindSet then
            repeat
                if ServContractHdr."No. of PDC" <> num1 then
                    repeat
                        RecPDCL.Init;
                        RecPDCL."Batch Name" := 'PDC';
                        num := num + 10000;
                        RecPDCL."Line Number" := num;
                        /*days:= ("Expiration Date" - "Starting Date")+1;
                        PDCDays:=ROUND(days/"No. of PDC",1,'=');
                        //PDCDays:=days/"No. of PDC";
                        Exp:= FORMAT(PDCDays) + 'D';*/
                        if PDCDate = 0D then
                            PDCDate := Rec."Starting Date";
                        if num1 = 0 then begin
                            //RecPDCL."Check Date" := PDCDate;
                            RecPDCL."Check Date" := Dt2Date(ChequeDate);
                            // RecPDCL."Contract Due Date" := PDCDate;
                            RecPDCL."Contract Due Date" := RecPDCL."Check Date";
                        end else begin
                            //RecPDCL."Check Date":=CALCDATE(Exp,PDCDate);
                            //chq := DT2DATE(ChequeDate);
                            ChequeDate := ChequeDate + Duration1;
                            NwUpdate := Dt2Date(ChequeDate);
                            RecPDCL."Check Date" := NwUpdate;
                            // RecPDCL."Contract Due Date" := CALCDATE(Exp,PDCDate);
                            RecPDCL."Contract Due Date" := RecPDCL."Check Date";
                        end;
                        RecPDCL.Validate("Document No.");
                        RecPDCL.Validate(RecPDCL."Contract No.", ServContractHdr."Contract No.");
                        //RecPDCL."No. Series" := 'PDC';
                        //RecPDCL."Template Name" := 'PAYMENT';
                        RecPDCL."Account Type" := RecPDCL."account type"::"G/L Account";
                        //RecPDCL."Account Type" := RecPDCL."Account Type"::Customer;
                        //RecPDCL.VALIDATE(RecPDCL."Account No.",ServContractHdr."Customer No.");
                        PayMethod.Reset;
                        PayMethod.SetFilter(PayMethod.Code, '%1', 'PDC');
                        if PayMethod.FindFirst then
                            RecPDCL.Validate(RecPDCL."Account No.", PayMethod."Bal. Account No.");
                        // RecPDCL.Amount := -(ServContractHdr."Annual Amount" / ServContractHdr."No. of PDC");
                        RecPDCL.Amount := -(ServContractManagement.CalcContractLineAmount(Rec."Annual Amount", Rec."Starting Date", Rec."Expiration Date")) / ServContractHdr."No. of PDC";
                        //RecPDCL."Contract Amount" := -(ServContractHdr."Annual Amount" / ServContractHdr."No. of PDC");
                        RecPDCL."Contract Amount" := -(ServContractManagement.CalcContractLineAmount(Rec."Annual Amount", Rec."Starting Date", Rec."Expiration Date")) / ServContractHdr."No. of PDC";
                        RecPDCL.Validate(RecPDCL."Bal. Account Type", RecPDCL."bal. account type"::Bank);
                        ServContractHdr.CalcFields(ServContractHdr."Bank Account No.");
                        RecPDCL.Validate(RecPDCL."Bank Account", ServContractHdr."Bank Account No.");
                        RecPDCL."Customer No." := ServContractHdr."Customer No.";
                        ServContractHdr.CalcFields(ServContractHdr.Name);
                        RecPDCL."Customer Name" := ServContractHdr.Name;
                        RecPDCL."Payment Method" := RecPDCL."payment method"::PDC;
                        RecPDCL."Dimension Set ID" := ServContractHdr."Dimension Set ID";
                        //PDCDate:=RecPDCL."Check Date";
                        RecPDCL.Insert;
                        num1 := num1 + 1;
                    until ServContractHdr."No. of PDC" = num1;
                ServContractHdr."PDC Entry Generated" := true;
                ServContractHdr.Modify;

            until ServContractHdr.Next = 0;
        //MESSAGE('PDC entries has been generated successfully.');


        ServCharge.Reset;
        ServCharge.SetRange(ServCharge."Service Contract Quote No.", ServContractHdr."Contract No.");
        ServCharge.SetRange("Allow-to Generate PDC Entry", true);                                      // RealEstateCR
        ServContractHdr.SetFilter(ServContractHdr."Contract Type", '%1', ServContractHdr."contract type"::Quote);
        ServContractHdr.SetFilter(ServContractHdr."Mode of Payment", '%1', 'PDC');
        //ServContractHdr.SETFILTER(ServContractHdr."PDC Entry Generated",'%1',FALSE);
        if ServCharge.FindSet then
            repeat
                RecPDCL.Init;
                RecPDCL."Batch Name" := 'PDC';
                num := num + 10000;
                RecPDCL."Line Number" := num;

                RecPDCL.Validate("Document No.");
                //RecPDCL."Document No." := ServCharge."Document No.";
                RecPDCL.Validate(RecPDCL."Contract No.", ServContractHdr."Contract No.");
                // RealEstateCR
                if ServCharge."Charge Code" = 'VAT' then begin
                    RecPDCL."Account Type" := RecPDCL."account type"::"G/L Account";
                    PayMethod.Reset;
                    PayMethod.SetFilter(PayMethod.Code, '%1', 'PDC');
                    if PayMethod.FindFirst then
                        RecPDCL.Validate(RecPDCL."Account No.", PayMethod."Bal. Account No.");
                end else begin
                    RecPDCL."Account Type" := RecPDCL."account type"::Customer;
                    RecPDCL.Validate(RecPDCL."Account No.", ServCharge."Customer No.");
                end;
                // RealEstateCR
                PayMethod.Reset;
                //PayMethod.SETFILTER(PayMethod.Code,'%1','PDC');
                PayMethod.SetRange(PayMethod.Code, ServCharge."Mode of Payment");
                if PayMethod.FindFirst then begin
                    if PayMethod."Bal. Account Type" = PayMethod."bal. account type"::"G/L Account" then
                        RecPDCL."Bal. Account Type" := RecPDCL."bal. account type"::"G/L Account"
                    else
                        RecPDCL."Bal. Account Type" := RecPDCL."bal. account type"::Bank;
                    RecPDCL.Validate(RecPDCL."Bank Account", PayMethod."Bal. Account No.");
                end;
                //RecPDCL.VALIDATE(RecPDCL."Bank Account",ServCharge."Bal. Account No.");
                RecPDCL.Amount := (ServCharge."Charge Amount");
                RecPDCL."Contract Amount" := RecPDCL.Amount;  // RealEstateCR
                RecPDCL."Customer No." := ServContractHdr."Customer No.";
                ServContractHdr.CalcFields(ServContractHdr.Name);
                RecPDCL."Customer Name" := ServContractHdr.Name;
                RecPDCL."Check Date" := ServCharge."Charge Date";
                RecPDCL."Contract Due Date" := RecPDCL."Check Date";  // RealEstateCR
                RecPDCL."Charge Code" := ServCharge."Charge Code";
                RecPDCL."Charge Description" := ServCharge."Charge Description";
                RecPDCL."Dimension Set ID" := ServContractHdr."Dimension Set ID";
                case ServCharge."Mode of Payment" of
                    'PDC':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::PDC;
                    'CASH':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cash;
                    'CASH+PDC':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cash;
                    'CHEQUE':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cheque;
                    'BANK':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Bank;
                end;
                //PDCDate:=RecPDCL."Check Date";
                RecPDCL.Insert;
                ServContractHdr."PDC Entry Generated" := true;
                ServContractHdr.Modify;
            until ServCharge.Next = 0;
        Message('PDC entries has been generated successfully.');

    end;

    procedure SendMailtoSP()
    var
        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        lText001: label 'Customer Email does not exist';
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lText002: label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record "Reason Code";
        UserSetup: Record "User Setup";
        lUser: Record User;
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        MarketingSetup: Record "Marketing Setup";
        FileName: Text;
        FileManagement: Codeunit "File Management";
        ImportTxt: label 'Insert File';
        FileDialogTxt: label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        DocPrint: Codeunit "Document-Print";
        //TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
    begin
        //win315++

        // SMTPSetup.Get;
        // SMTPSetup.TestField("User ID");

        /*MarketingSetup.GET;
        MarketingSetup.TESTFIELD("Email Sender To");*/

        /*lCLE.RESET;
        lCLE.SETRANGE("Document No.",DocNo);
        IF NOT lCLE.FINDSET THEN
          EXIT;*/

        if lCust.Get(Rec."Customer No.") then begin
            if lCust."E-Mail" = '' then
                Error(lText001, lCust."No.");


            //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",MarketingSetup."Email Sender To",'Customer Creation Request','',TRUE);
            //SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", lCust."E-Mail", 'Renewal Contract', '', true);//WIN292
            //IF MarketingSetup."Email Sender CC" <> '' THEN
            //SMTPMail.AddCC(MarketingSetup."Email Sender CC");
            //SMTPMail.AppendBody('Hi '+SalespersonPurchaser.Name);
            //SMTPMail.AppendBody('Hi '+ Name);
            // SMTPMail.AppendBody('Dear Sir / Madam ');
            // SMTPMail.AppendBody('<br><br>');
            // SMTPMail.AppendBody('Good day!');
            // SMTPMail.AppendBody('<br><Br>');
            // SMTPMail.AppendBody('Please find attached Renewal Letter for contract no. ' + Format(Rec."Contract No.") + '.');
            // SMTPMail.AppendBody('<br><Br>');
            // SMTPMail.AppendBody('Thanks & Regards,');
            // SMTPMail.AppendBody('<br>');
            // SMTPMail.AppendBody('NAV Administrator');
            // SMTPMail.AppendBody('<br><br>');

            Recipients.Add(lCust."E-Mail");
            Subject := 'Renewal Contract';
            Body := 'Dear Sir / Madam, <br><br> Good day! <br><Br>';
            Body += 'Please find attached Renewal Letter for contract no. ' + Format(Rec."Contract No.") + '.';
            Body += '<br><Br> Thanks & Regards, <br> NAV Administrator <br><br>';

            RenewalLetter := 'D:\Renewal Letter.pdf';
            /* Report.SaveAsPdf(50002, RenewalLetter, SerConHdr);
            SMTPMail.AddAttachment(RenewalLetter, RenewalLetter); *///WIN292

            //SMTPMail.Send;
            EmailMessage.Create(Recipients, Subject, Body, true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

            Message('Email has been sent.');
        end;
        //win315--

    end;

    procedure CustomerNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ToGeneratePDCEntry1()
    var
        RecPDCL: Record "Post Dated Check Line";
        ServContractHdr: Record "Service Contract Header";
        num: Integer;
        num1: Integer;
        RecPDCL1: Record "Post Dated Check Line";
        days: Integer;
        Exp: Text;
        PDCDays: Integer;
        PDCDate: Date;
        PayMethod: Record "Payment Method";
        PerDayRent: Decimal;
        ServCharge: Record "Service Charges";
        PayMethod2: Record "Payment Method";
        ServContractManagement: Codeunit ServContractManagement;
    begin
        //win315++
        /*num1:=0;
        days:=0;
        PDCDays:=0;
        PDCDate:=0D;
        RecPDCL.RESET;
        RecPDCL.SETRANGE("Batch Name",'PDC');
        RecPDCL.SETRANGE("Account Type",RecPDCL."Account Type"::Customer);
        RecPDCL.SETRANGE("Account No.",Rec."Customer No.");
        IF RecPDCL.FINDLAST THEN
          num := RecPDCL."Line Number"
        ELSE
          num :=0;
        
        ServContractHdr.SETRANGE(ServContractHdr."Contract No.",Rec."Contract No.");
        ServContractHdr.SETFILTER(ServContractHdr."Contract Type",'%1',ServContractHdr."Contract Type"::Quote);
        ServContractHdr.SETFILTER(ServContractHdr."Mode of Payment",'%1','PDC');
        ServContractHdr.SETFILTER(ServContractHdr."PDC Entry Generated",'%1',FALSE);
        IF ServContractHdr.FINDSET THEN REPEAT
          IF ServContractHdr."No. of PDC" <> num1 THEN REPEAT
          RecPDCL.INIT;
          RecPDCL."Batch Name" := 'PDC';
          num := num + 10000;
          RecPDCL."Line Number" := num;
        
          days:= ("Expiration Date" - "Starting Date");
          PDCDays:=ROUND(days/"No. of PDC",1,'=');
          Exp:= FORMAT(PDCDays) + 'D';
        
          IF PDCDate = 0D THEN
           PDCDate:="Starting Date";
        
          RecPDCL."Check Date" := CALCDATE(Exp,PDCDate);
          RecPDCL."Contract Due Date" := CALCDATE(Exp,PDCDate);
          RecPDCL.VALIDATE("Document No.");
          //RecPDCL."No. Series" := 'PDC';
          //RecPDCL."Template Name" := 'PAYMENT';
          RecPDCL."Account Type" := RecPDCL."Account Type"::Customer;
          //RecPDCL."Contract Due Date" := ServContractHdr."Next Invoice Date";
          //RecPDCL."PDC Due Date" := ServContractHdr."Next Invoice Date";
          RecPDCL.VALIDATE(RecPDCL."Account No.",ServContractHdr."Customer No.");
          RecPDCL.Amount := -(ServContractHdr."Annual Amount" / ServContractHdr."No. of PDC");
          RecPDCL."Contract Amount" := -(ServContractHdr."Annual Amount" / ServContractHdr."No. of PDC");
          PDCDate:=RecPDCL."Check Date";
          //RecPDCL."Contract No.":=Rec."Contact No.";
          RecPDCL.INSERT;
          num1 := num1+1;
          UNTIL ServContractHdr."No. of PDC" = num1;
          ServContractHdr."PDC Entry Generated" := TRUE;
          ServContractHdr.MODIFY;
        
        UNTIL ServContractHdr.NEXT =0;
        MESSAGE('PDC entries has been generated successfully.');*/
        //win315--


        //win315++
        //FOR CASH

        Rec.TestField("Cash Amount");
        Clear(ChequeDate);
        num1 := 0;
        days := 0;
        PDCDays := 0;
        PDCDate := 0D;
        PerDayRent := 0;
        RecPDCL.Reset;
        RecPDCL.SetRange("Batch Name", 'PDC');
        //RecPDCL.SETRANGE("Account Type",RecPDCL."Account Type"::Customer);
        RecPDCL.SetRange("Customer No.", Rec."Customer No.");
        if RecPDCL.FindLast then
            num := RecPDCL."Line Number"
        else
            num := 0;
        CalcDuration;
        ServContractHdr.SetRange(ServContractHdr."Contract No.", Rec."Contract No.");
        ServContractHdr.SetFilter(ServContractHdr."Contract Type", '%1', ServContractHdr."contract type"::Quote);
        ServContractHdr.SetFilter(ServContractHdr."Mode of Payment", '%1', 'CASH+PDC');
        ServContractHdr.SetFilter(ServContractHdr."PDC Entry Generated", '%1', false);
        if ServContractHdr.FindSet then
            repeat
                if ServContractHdr."No. of Cheque" <> num1 then
                    repeat
                        RecPDCL.Init;
                        RecPDCL."Batch Name" := 'PDC';
                        num := num + 10000;
                        RecPDCL."Line Number" := num;
                        /*
                        days:= ("Expiration Date" - "Starting Date")+1;
                        PDCDays:=ROUND(days/("No. of PDC"+"No. of Cheque"),1,'=');
                        //PDCDays:=(days/("No. of PDC"+"No. of Cheque"));
                        //PerDayRent:=ABS(ServContractHdr."Annual Amount"/365);
                        //PDCDays:=ROUND((ServContractHdr."Annual Amount" / (ServContractHdr."No. of PDC" + ServContractHdr."No. of Cheque"))/PerDayRent,1,'=');
                        //MESSAGE(FORMAT(PDCDays));
                        Exp:= FORMAT(PDCDays) + 'D';*/

                        if PDCDate = 0D then
                            PDCDate := Rec."Starting Date";

                        if num1 = 0 then begin
                            //RecPDCL."Check Date" := PDCDate;
                            RecPDCL."Check Date" := Dt2Date(ChequeDate);
                            RecPDCL."Contract Due Date" := RecPDCL."Check Date";
                        end else begin
                            ChequeDate := ChequeDate + Duration1;
                            NwUpdate := Dt2Date(ChequeDate);
                            RecPDCL."Check Date" := NwUpdate;
                            RecPDCL."Contract Due Date" := RecPDCL."Check Date";
                        end;
                        RecPDCL.Validate("Document No.");
                        RecPDCL.Validate(RecPDCL."Contract No.", ServContractHdr."Contract No.");
                        //RecPDCL."No. Series" := 'PDC';
                        //RecPDCL."Template Name" := 'PAYMENT';
                        // RecPDCL."Account Type" := RecPDCL."Account Type"::"G/L Account";
                        //RecPDCL."Account Type" := RecPDCL."Account Type"::Customer;
                        //RecPDCL.VALIDATE(RecPDCL."Account No.",ServContractHdr."Customer No.");
                        RecPDCL."Account Type" := RecPDCL."account type"::"G/L Account"; //change 211019++
                        PayMethod2.Reset;
                        PayMethod2.SetFilter(PayMethod2.Code, '%1', 'PDC');
                        if PayMethod2.FindFirst then
                            RecPDCL.Validate(RecPDCL."Account No.", PayMethod2."Bal. Account No.");  //change 211019--
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cash;
                        RecPDCL.Validate(RecPDCL."Bal. Account Type", RecPDCL."bal. account type"::"G/L Account");
                        PayMethod.Reset;
                        PayMethod.SetFilter(PayMethod.Code, '%1', 'CASH+PDC');
                        //PayMethod.SETRANGE(PayMethod.Code,ServContractHdr."Mode of Payment");
                        if PayMethod.FindFirst then
                            RecPDCL.Validate(RecPDCL."Bank Account", PayMethod."Bal. Account No.");
                        RecPDCL.Amount := -(ServContractHdr."Cash Amount" / ServContractHdr."No. of Cheque");
                        RecPDCL."Contract Amount" := -(ServContractHdr."Cash Amount" / ServContractHdr."No. of Cheque");
                        //ServContractHdr.CALCFIELDS(ServContractHdr."Bank Account No.");
                        //RecPDCL.VALIDATE(RecPDCL."Bank Account",ServContractHdr."Bank Account No.");
                        RecPDCL."Customer No." := ServContractHdr."Customer No.";
                        ServContractHdr.CalcFields(ServContractHdr.Name);
                        RecPDCL."Customer Name" := ServContractHdr.Name;
                        RecPDCL."Dimension Set ID" := ServContractHdr."Dimension Set ID";
                        // PDCDate:=RecPDCL."Check Date";

                        RecPDCL.Insert;
                        num1 := num1 + 1;
                    until ServContractHdr."No. of Cheque" = num1;
            //ServContractHdr."PDC Entry Generated" := TRUE;
            //ServContractHdr.MODIFY;

            until ServContractHdr.Next = 0;
        //MESSAGE('PDC entries has been generated successfully.');



        //for PDC
        Clear(ChequeDate);
        num1 := 0;
        days := 0;
        PDCDays := 0;
        PerDayRent := 0;
        //PDCDate:=0D;
        RecPDCL.Reset;
        RecPDCL.SetRange("Batch Name", 'PDC');
        //RecPDCL.SETRANGE("Account Type",RecPDCL."Account Type"::Customer);
        RecPDCL.SetRange("Customer No.", Rec."Customer No.");
        if RecPDCL.FindLast then
            num := RecPDCL."Line Number"
        else
            num := 0;

        CalcDuration;
        ServContractHdr.SetRange(ServContractHdr."Contract No.", Rec."Contract No.");
        ServContractHdr.SetFilter(ServContractHdr."Contract Type", '%1', ServContractHdr."contract type"::Quote);
        ServContractHdr.SetFilter(ServContractHdr."Mode of Payment", '%1', 'CASH+PDC');
        ServContractHdr.SetFilter(ServContractHdr."PDC Entry Generated", '%1', false);
        if ServContractHdr.FindSet then
            repeat
                if ServContractHdr."No. of PDC" <> num1 then
                    repeat
                        RecPDCL.Init;
                        RecPDCL."Batch Name" := 'PDC';
                        num := num + 10000;
                        RecPDCL."Line Number" := num;

                        PerDayRent := Abs(ServContractHdr."Annual Amount" / ((Rec."Expiration Date" - Rec."Starting Date") + 1));
                        //PDCDays:=ROUND(ServContractHdr."Cash Amount"/PerDayRent,1,'=');
                        PDCDays := ROUND((ServContractHdr."Annual Amount" / (ServContractHdr."No. of PDC" + ServContractHdr."No. of Cheque")) / PerDayRent, 1, '=');
                        //PDCDays:=(ServContractHdr."Annual Amount" / (ServContractHdr."No. of PDC" + ServContractHdr."No. of Cheque"))/PerDayRent;
                        Exp := Format(PDCDays) + 'D';

                        if PDCDate = 0D then
                            PDCDate := Rec."Starting Date";
                        ChequeDate := ChequeDate + Duration1;
                        NwUpdate := Dt2Date(ChequeDate);
                        RecPDCL."Check Date" := NwUpdate;
                        RecPDCL."Contract Due Date" := RecPDCL."Check Date";
                        RecPDCL.Validate("Document No.");
                        RecPDCL.Validate(RecPDCL."Contract No.", ServContractHdr."Contract No.");
                        //RecPDCL."No. Series" := 'PDC';
                        //RecPDCL."Template Name" := 'PAYMENT';
                        PayMethod.Reset;
                        PayMethod.SetFilter(PayMethod.Code, '%1', 'PDC');
                        if PayMethod.FindFirst then begin
                            RecPDCL."Account Type" := RecPDCL."account type"::"G/L Account";
                            RecPDCL.Validate(RecPDCL."Account No.", PayMethod."Bal. Account No.");
                        end;
                        //RecPDCL."Account Type" := RecPDCL."Account Type"::Customer;
                        //RecPDCL.VALIDATE(RecPDCL."Account No.",ServContractHdr."Customer No.");
                        RecPDCL.Validate(RecPDCL."Bal. Account Type", RecPDCL."bal. account type"::Bank);
                        ServContractHdr.CalcFields(ServContractHdr."Bank Account No.");
                        RecPDCL.Validate(RecPDCL."Bank Account", ServContractHdr."Bank Account No.");
                        /*PayMethod.RESET;
                        PayMethod.SETFILTER(PayMethod.Code,'%1','PDC');
                        IF PayMethod.FINDFIRST THEN
                        RecPDCL.VALIDATE(RecPDCL."Account No.",PayMethod."Bal. Account No.");*/
                        RecPDCL.Amount := -((ServContractHdr."Amount per Period" - ServContractHdr."Cash Amount") / ServContractHdr."No. of PDC");
                        //RecPDCL.Amount := -(ServContractManagement.CalcContractLineAmount("Annual Amount","Starting Date","Expiration Date")) / ServContractHdr."No. of PDC";
                        RecPDCL."Contract Amount" := -((ServContractHdr."Amount per Period" - ServContractHdr."Cash Amount") / ServContractHdr."No. of PDC");
                        //RecPDCL."Contract Amount" := -(ServContractManagement.CalcContractLineAmount("Annual Amount","Starting Date","Expiration Date")) / ServContractHdr."No. of PDC";
                        RecPDCL."Customer No." := ServContractHdr."Customer No.";
                        ServContractHdr.CalcFields(ServContractHdr.Name);
                        RecPDCL."Customer Name" := ServContractHdr.Name;
                        RecPDCL."Payment Method" := RecPDCL."payment method"::PDC;
                        PDCDate := RecPDCL."Check Date";
                        RecPDCL."Dimension Set ID" := ServContractHdr."Dimension Set ID";
                        RecPDCL.Insert;
                        num1 := num1 + 1;
                    until ServContractHdr."No. of PDC" = num1;
                ServContractHdr."PDC Entry Generated" := true;
                ServContractHdr.Modify;

            until ServContractHdr.Next = 0;
        //MESSAGE('PDC entries has been generated successfully.');


        //For service charges
        ServCharge.Reset;
        ServCharge.SetRange(ServCharge."Service Contract Quote No.", ServContractHdr."Contract No.");
        ServCharge.SetRange("Allow-to Generate PDC Entry", true);                                      // RealEstateCR
        ServContractHdr.SetFilter(ServContractHdr."Contract Type", '%1', ServContractHdr."contract type"::Quote);
        ServContractHdr.SetFilter(ServContractHdr."Mode of Payment", '%1', 'PDC');
        //ServContractHdr.SETFILTER(ServContractHdr."PDC Entry Generated",'%1',FALSE);
        if ServCharge.FindSet then
            repeat
                RecPDCL.Init;
                RecPDCL."Batch Name" := 'PDC';
                num := num + 10000;
                RecPDCL."Line Number" := num;

                RecPDCL.Validate("Document No.");
                //RecPDCL."Document No." := ServCharge."Document No.";
                RecPDCL.Validate(RecPDCL."Contract No.", ServContractHdr."Contract No.");
                // RealEstateCR
                if ServCharge."Charge Code" = 'VAT' then begin
                    RecPDCL."Account Type" := RecPDCL."account type"::"G/L Account";
                    PayMethod.Reset;
                    PayMethod.SetFilter(PayMethod.Code, '%1', 'PDC');
                    if PayMethod.FindFirst then
                        RecPDCL.Validate(RecPDCL."Account No.", PayMethod."Bal. Account No.");
                end else begin
                    RecPDCL."Account Type" := RecPDCL."account type"::Customer;
                    RecPDCL.Validate(RecPDCL."Account No.", ServCharge."Customer No.");
                end;
                // RealEstateCR
                PayMethod.Reset;
                //PayMethod.SETFILTER(PayMethod.Code,'%1','PDC');
                PayMethod.SetRange(PayMethod.Code, ServCharge."Mode of Payment");
                if PayMethod.FindFirst then begin
                    if PayMethod."Bal. Account Type" = PayMethod."bal. account type"::"G/L Account" then
                        RecPDCL."Bal. Account Type" := RecPDCL."bal. account type"::"G/L Account"
                    else
                        RecPDCL."Bal. Account Type" := RecPDCL."bal. account type"::Bank;
                    RecPDCL.Validate(RecPDCL."Bank Account", PayMethod."Bal. Account No.");
                end;
                //RecPDCL.VALIDATE(RecPDCL."Bank Account",ServCharge."Bal. Account No.");
                RecPDCL.Amount := (ServCharge."Charge Amount");
                RecPDCL."Customer No." := ServContractHdr."Customer No.";
                ServContractHdr.CalcFields(ServContractHdr.Name);
                RecPDCL."Customer Name" := ServContractHdr.Name;
                RecPDCL."Check Date" := ServCharge."Charge Date";
                RecPDCL."Charge Code" := ServCharge."Charge Code";
                RecPDCL."Contract Amount" := RecPDCL.Amount;  // RealEstateCR
                RecPDCL."Contract Due Date" := RecPDCL."Check Date";  // RealEstateCR
                RecPDCL."Charge Description" := ServCharge."Charge Description";
                //RecPDCL."Payment Method" := RecPDCL."Payment Method"::PDC;
                case ServCharge."Mode of Payment" of
                    'PDC':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::PDC;
                    'CASH':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cash;
                    'CASH+PDC':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cash;
                    'CHEQUE':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Cheque;
                    'BANK':
                        RecPDCL."Payment Method" := RecPDCL."payment method"::Bank;
                end;
                //PDCDate:=RecPDCL."Check Date";
                RecPDCL."Dimension Set ID" := ServContractHdr."Dimension Set ID";
                RecPDCL.Insert;
                ServContractHdr."PDC Entry Generated" := true;
                ServContractHdr.Modify;
            until ServCharge.Next = 0;
        Message('PDC entries has been generated successfully.');

        //win315--

    end;

    local procedure CalcDuration()
    begin
        ExpirationDate := Rec."Expiration Date";
        StartingDate := Rec."Starting Date";
        StartingDateTime := CreateDatetime(StartingDate, 0T);
        ExpirationDateTime := CreateDatetime(CalcDate('1D', ExpirationDate), 0T);
        Duration1 := ExpirationDateTime - StartingDateTime;
        if Rec."Mode of Payment" = 'PDC' then
            Duration1 := ROUND(Duration1 / Rec."No. of PDC", 2) //WIN210
        else
            if Rec."Mode of Payment" = 'CASH+PDC' then
                Duration1 := Duration1 / (Rec."No. of PDC" + Rec."No. of Cheque");
        ChequeDate := StartingDateTime;
    end;

    //Win513++
    procedure AddMandatoryTnC(ContractNo: Code[20])
    var
        RecTnC: Record "Terms & Condtions";
        TnC: Record "Terms And Conditions";
    begin
        RecTnC.Reset();
        RecTnC.SetRange(RecTnC."Transaction Type", RecTnC."Transaction Type"::Service);
        RecTnC.SetRange(RecTnC."Document Type", RecTnC."Document Type"::Quote);
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
                    RecTnC."Document Type" := RecTnC."Document Type"::Quote;
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

