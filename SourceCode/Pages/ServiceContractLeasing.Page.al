page 50034 "Service Contract (Leasing)"
{
    Caption = 'Leasing Contract';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = 5965;
    SourceTableView = WHERE("Contract Type" = FILTER(Contract));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the service contract or service contract quote.';

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';

                    trigger OnValidate()
                    begin
                        CustomerNoOnAfterValidate;
                    end;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact who will receive the service delivery.';
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        servitem: Record 5940;
                    begin
                        //WIN325
                        Rec.TESTFIELD("Building No.");
                        servitem.RESET;
                        servitem.SETRANGE("Unit Purpose", servitem."Unit Purpose"::"Rental Unit");
                        servitem.SETRANGE("Building No.", Rec."Building No.");
                        IF PAGE.RUNMODAL(0, servitem) = ACTION::LookupOK THEN BEGIN
                            Rec.VALIDATE("Unit No.", servitem."Unit No.");
                        END;
                        //ServiceItemOnAfterValidat;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the customer in the service contract.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer''s address.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional address line for the customer.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the postal code of the address.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the city in where the customer is located.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in this service contract.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer phone number.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field("Contract Group Code"; Rec."Contract Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract group code assigned to the service contract.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the salesperson assigned to this service contract.';
                }
                field("Service Period"; Rec."Service Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a default service period for the items in the contract.';

                    trigger OnValidate()
                    begin
                        ServicePeriodOnAfterValidate;
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the starting date of the service contract.';

                    trigger OnValidate()
                    begin
                        StartingDateOnAfterValidate;
                    end;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the status of the service contract or contract quote.';

                    trigger OnValidate()
                    begin
                        ActivateFields;
                        StatusOnAfterValidate;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the responsibility center associated either with the customer in the service contract or with your company.';
                }
                field("Change Status"; Rec."Change Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if a service contract or contract quote is locked or open for changes.';
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount per Period"; Rec."Amount per Period")
                {
                    ApplicationArea = All;
                }
            }
            part(ServContractLines; 6052)
            {
                ApplicationArea = All;
                Caption = 'Contract Amounts';
                SubPageLink = "Contract No." = FIELD("Contract No.");
            }
            group(Tenancy)
            {
                Caption = 'Tenancy';
                Visible = true;
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ship-to code for the customer.';

                    trigger OnValidate()
                    begin
                        ShiptoCodeOnAfterValidate;
                    end;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer address.';
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the postal code of the address.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer to whom you will send the invoice.';

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact who receives the invoice.';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the customer you will send the invoice to.';
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer address.';
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the postal code of the address.';
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of your customer contact person, who you send the invoice to.';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s reference number.';
                }
                field("Serv. Contract Acc. Gr. Code"; Rec."Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code associated with the service contract account group.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a dimension value code for the document line.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a dimension value code for the document line.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the payment terms code for the customer in the contract.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency used to calculate the amounts in the documents related to this contract.';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Service Zone Code"; Rec."Service Zone Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the service zone of the customer ship-to address.';
                }
                field("First Service Date"; Rec."First Service Date")
                {
                    ApplicationArea = All;
                    Editable = FirstServiceDateEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date of the first expected service for the service items in the contract.';

                    trigger OnValidate()
                    begin
                        FirstServiceDateOnAfterValidat;
                    end;
                }
                field("Response Time (Hours)"; Rec."Response Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response time for the service contract.';

                    trigger OnValidate()
                    begin
                        ResponseTimeHoursOnAfterValida;
                    end;
                }
                field("Service Order Type"; Rec."Service Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service order type assigned to service orders linked to this contract.';
                }
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Allow Unbalanced Amounts"; Rec."Allow Unbalanced Amounts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the contents of the Calcd. Annual Amount field are copied into the Annual Amount field in the service contract or contract quote.';

                    trigger OnValidate()
                    begin
                        AllowUnbalancedAmountsOnAfterV;
                    end;
                }
                field("Calcd. Annual Amount"; Rec."Calcd. Annual Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sum of the Line Amount field values on all contract lines associated with the service contract or contract quote.';
                }
                field(InvoicePeriod; Rec."Invoice Period")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the invoice period for the service contract.';
                }
                field(NextInvoiceDate; Rec."Next Invoice Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date of the next invoice for this service contract.';
                }
                field(AmountPerPeriod; Rec."Amount per Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that will be invoiced for each invoice period for the service contract.';
                }
                field(NextInvoicePeriod; Rec.NextInvoicePeriod)
                {
                    ApplicationArea = All;
                    Caption = 'Next Invoice Period';
                }
                field("Last Invoice Date"; Rec."Last Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when this service contract was last invoiced.';
                }
                field(Prepaid; Rec.Prepaid)
                {
                    ApplicationArea = All;
                    Enabled = PrepaidEnable;
                    ToolTip = 'Specifies that this service contract is prepaid.';

                    trigger OnValidate()
                    begin
                        PrepaidOnAfterValidate;
                    end;
                }
                field("Automatic Credit Memos"; Rec."Automatic Credit Memos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that a credit memo is created when you remove a contract line.';
                }
                field("Invoice after Service"; Rec."Invoice after Service")
                {
                    ApplicationArea = All;
                    Enabled = InvoiceAfterServiceEnable;
                    ToolTip = 'Specifies that you can only invoice the contract if you have posted a service order since last time you invoiced the contract.';

                    trigger OnValidate()
                    begin
                        InvoiceafterServiceOnAfterVali;
                    end;
                }
                field("Combine Invoices"; Rec."Combine Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies you want to combine invoices for this service contract with invoices for other service contracts with the same bill-to customer.';
                }
                field("Contract Lines on Invoice"; Rec."Contract Lines on Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that you want the lines for this contract to appear as text on the invoice.';
                }
                field("No. of Unposted Invoices"; Rec."No. of Unposted Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of unposted service invoices linked to the service contract.';
                }
                field("No. of Unposted Credit Memos"; Rec."No. of Unposted Credit Memos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of unposted credit memos linked to the service contract.';
                }
                field("No. of Posted Invoices"; Rec."No. of Posted Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of posted service invoices linked to the service contract.';
                }
                field("No. of Posted Credit Memos"; Rec."No. of Posted Credit Memos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of posted credit memos linked to this service contract.';
                }
            }
            group("Price Update")
            {
                Caption = 'Price Update';
                field("Price Update Period"; Rec."Price Update Period")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the price update period for this service contract.';
                }
                field("Next Price Update Date"; Rec."Next Price Update Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the next date you want contract prices to be updated.';
                }
                field("Last Price Update %"; Rec."Last Price Update %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price update percentage you used the last time you updated the contract prices.';
                }
                field("Last Price Update Date"; Rec."Last Price Update Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date you last updated the contract prices.';
                }
                field("Print Increase Text"; Rec."Print Increase Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.';
                }
                field("Price Inv. Increase Code"; Rec."Price Inv. Increase Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.';
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Cancel Reason Code"; Rec."Cancel Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a reason code for canceling the service contract.';
                }
                field("Max. Labor Unit Price"; Rec."Max. Labor Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource on all service orders and lines for the service contract.';
                }
            }
        }
        area(factboxes)
        {
            part("Customer Statistics FactBox"; 9082)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part("Customer Details FactBox"; 9084)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Customer No.");
                Visible = true;
            }
            systempart(Recordlinks; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Overview)
            {
                Caption = 'Overview';
                group("Ser&vice Overview")
                {
                    Caption = 'Ser&vice Overview';
                    Image = Tools;
                    action("Service Orders")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Orders';
                        Image = Document;
                        RunObject = Page "Service List";
                        RunPageLink = "Document Type" = CONST(Order),
                                      "Contract No." = FIELD("Contract No.");
                        RunPageView = SORTING("Contract No.");
                    }
                    action("Posted Service Shipments")
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Service Shipments';
                        Image = PostedShipment;

                        trigger OnAction()
                        var
                            TempServShptHeader: Record 5990 temporary;
                        begin
                            CollectShpmntsByLineContractNo(TempServShptHeader);
                            PAGE.RUNMODAL(PAGE::"Posted Service Shipments", TempServShptHeader);
                        end;
                    }
                    action("Posted Service Invoices")
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Service Invoices';
                        Image = PostedServiceOrder;
                        RunObject = Page "Service Document Registers";
                        RunPageLink = "Source Document No." = FIELD("Contract No.");
                        RunPageView = SORTING("Source Document Type", "Source Document No.", "Destination Document Type", "Destination Document No.")
                                      WHERE("Source Document Type" = CONST(Contract),
                                            "Destination Document Type" = CONST("Posted Invoice"));
                    }
                }
            }
            group("&Contract")
            {
                Caption = '&Contract';
                Image = Agreement;
                action(Dimensions)
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData 348 = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("Service Dis&counts")
                {
                    ApplicationArea = All;
                    Caption = 'Service Dis&counts';
                    Image = Discount;
                    RunObject = Page "Contract/Service Discounts";
                    RunPageLink = "Contract Type" = FIELD("Contract Type"),
                                  "Contract No." = FIELD("Contract No.");
                }
                action("Service &Hours")
                {
                    ApplicationArea = All;
                    Caption = 'Service &Hours';
                    Image = ServiceHours;
                    RunObject = Page "Service Hours";
                    RunPageLink = "Service Contract No." = FIELD("Contract No."),
                                  "Service Contract Type" = FILTER(Contract);
                }
                group(Statistic)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Statistics)
                    {
                        ApplicationArea = All;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Contract Statistics";
                        RunPageLink = "Contract Type" = CONST(Contract),
                                      "Contract No." = FIELD("Contract No.");
                        ShortCutKey = 'F7';
                    }
                    action("Tr&endscape")
                    {
                        ApplicationArea = All;
                        Caption = 'Tr&endscape';
                        Image = Trendscape;
                        RunObject = Page "Contract Trendscape";
                        RunPageLink = "Contract Type" = CONST(Contract),
                                      "Contract No." = FIELD("Contract No.");
                    }
                }
                separator("-==-")
                {
                    Caption = '';
                }
                action("Filed Contracts")
                {
                    ApplicationArea = All;
                    Caption = 'Filed Contracts';
                    Image = Agreement;
                    RunObject = Page "Filed Service Contract List";
                    RunPageLink = "Contract Type Relation" = FIELD("Contract Type"),
                                  "Contract No. Relation" = FIELD("Contract No.");
                    RunPageView = SORTING("Contract Type Relation", "Contract No. Relation", "File Date", "File Time")
                                  ORDER(Descending);
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Service Contract"),
                                  "Table Subtype" = FIELD("Contract Type"),
                                  "No." = FIELD("Contract No."),
                                  "Table Line No." = CONST(0);
                }
                action("&Gain/Loss Entries")
                {
                    ApplicationArea = All;
                    Caption = '&Gain/Loss Entries';
                    Image = GainLossEntries;
                    RunObject = Page "Contract Gain/Loss Entries";
                    RunPageLink = "Contract No." = FIELD("Contract No.");
                    RunPageView = SORTING("Contract No.", "Change Date")
                                  ORDER(Descending);
                }
                separator("--")
                {
                    Caption = '';
                }
            }
            group(History)
            {
                Caption = 'History';
                action("C&hange Log")
                {
                    ApplicationArea = All;
                    Caption = 'C&hange Log';
                    Image = ChangeLog;
                    RunObject = Page "Contract Change Log";
                    RunPageLink = "Contract No." = FIELD("Contract No.");
                    RunPageView = SORTING("Contract No.")
                                  ORDER(Descending);
                }
                separator("---")
                {
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Contract No." = FIELD("Contract No.");
                    RunPageView = SORTING("Service Contract No.", "Posting Date", "Document No.");
                }
                separator("-----")
                {
                    Caption = '';
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Contract No." = FIELD("Contract No.");
                    RunPageView = SORTING("Service Contract No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                separator("------")
                {
                }
            }
        }
        area(processing)
        {
            group(Generals)
            {
                Caption = 'General';
                action("&Print")
                {
                    ApplicationArea = All;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        DocPrint: Codeunit 229;
                    begin
                        DocPrint.PrintServiceContract(Rec);
                    end;
                }
            }
            group("New Documents")
            {
                Caption = 'New Documents';
                action("Create Credit &Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Create Credit &Memo';
                    Image = CreateCreditMemo;

                    trigger OnAction()
                    var
                        W1: Dialog;
                        CreditNoteNo: Code[20];
                        i: Integer;
                        j: Integer;
                        LineFound: Boolean;
                    begin
                        CurrPage.UPDATE;
                        Rec.TESTFIELD(Status, Rec.Status::Signed);
                        IF Rec."No. of Unposted Credit Memos" <> 0 THEN
                            IF NOT CONFIRM(Text009) THEN
                                EXIT;

                        ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                        IF NOT CONFIRM(Text010, FALSE) THEN
                            EXIT;

                        ServContractLine.RESET;
                        ServContractLine.SETCURRENTKEY("Contract Type", "Contract No.", Credited, "New Line");
                        ServContractLine.SETRANGE("Contract Type", Rec."Contract Type");
                        ServContractLine.SETRANGE("Contract No.", Rec."Contract No.");
                        ServContractLine.SETRANGE(Credited, FALSE);
                        ServContractLine.SETFILTER("Credit Memo Date", '>%1&<=%2', 0D, WORKDATE);
                        i := ServContractLine.COUNT;
                        j := 0;
                        IF ServContractLine.FIND('-') THEN BEGIN
                            LineFound := TRUE;
                            W1.OPEN(
                              Text011 +
                              '@1@@@@@@@@@@@@@@@@@@@@@');
                            CLEAR(ServContractMgt);
                            ServContractMgt.InitCodeUnit;
                                                               REPEAT
                                                                   ServContractLine1 := ServContractLine;
                                                                   CreditNoteNo := ServContractMgt.CreateContractLineCreditMemo(ServContractLine1, FALSE);
                                                                   j := j + 1;
                                                                   W1.UPDATE(1, ROUND(j / i * 10000, 1));
                                                               UNTIL ServContractLine.NEXT = 0;
                            ServContractMgt.FinishCodeunit;
                            W1.CLOSE;
                            CurrPage.UPDATE(FALSE);
                        END;
                        ServContractLine.SETFILTER("Credit Memo Date", '>%1', WORKDATE);
                        IF CreditNoteNo <> '' THEN
                            MESSAGE(STRSUBSTNO(Text012, CreditNoteNo))
                        ELSE
                            IF NOT ServContractLine.FIND('-') OR LineFound THEN
                                MESSAGE(Text013)
                            ELSE
                                MESSAGE(Text016, ServContractLine.FIELDCAPTION("Credit Memo Date"), ServContractLine."Credit Memo Date");
                    end;
                }
                action(CreateServiceInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Create Service &Invoice';
                    Image = NewInvoice;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE;
                        Rec.TESTFIELD(Status, Rec.Status::Signed);
                        Rec.TESTFIELD("Change Status", Rec."Change Status"::Locked);

                        IF Rec."No. of Unposted Invoices" <> 0 THEN
                            IF NOT CONFIRM(Text003) THEN
                                EXIT;

                        IF Rec."Invoice Period" = Rec."Invoice Period"::None THEN
                            ERROR(STRSUBSTNO(
                                Text004,
                                Rec.TABLECAPTION, Rec."Contract No.", Rec.FIELDCAPTION("Invoice Period"), FORMAT(Rec."Invoice Period")));

                        IF Rec."Next Invoice Date" > WORKDATE THEN
                            IF (Rec."Last Invoice Date" = 0D) AND
                               (Rec."Starting Date" < Rec."Next Invoice Period Start")
                            THEN BEGIN
                                CLEAR(ServContractMgt);
                                ServContractMgt.InitCodeUnit;
                                IF ServContractMgt.CreateRemainingPeriodInvoice(Rec) <> '' THEN
                                    MESSAGE(Text006);
                                ServContractMgt.FinishCodeunit;
                                EXIT;
                            END ELSE
                                ERROR(Text005);

                        ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                        IF CONFIRM(Text007) THEN BEGIN
                            CLEAR(ServContractMgt);
                            ServContractMgt.InitCodeUnit;
                            ServContractMgt.CreateInvoice(Rec);
                            ServContractMgt.FinishCodeunit;
                            MESSAGE(Text008);
                        END;
                    end;
                }
                separator("---=---")
                {
                    Caption = '';
                }
            }
            group(Lock)
            {
                Caption = 'Lock';
                action(LockContract)
                {
                    ApplicationArea = All;
                    Caption = '&Lock Contract';
                    Image = Lock;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit 5943;
                    begin
                        CurrPage.UPDATE;
                        LockOpenServContract.LockServContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action(OpenContract)
                {
                    ApplicationArea = All;
                    Caption = '&Open Contract';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit 5943;
                    begin
                        CurrPage.UPDATE;
                        LockOpenServContract.OpenServContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                separator("---------")
                {
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SelectContractLines)
                {
                    Caption = '&Select Contract Lines';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        CheckRequiredFields;
                        GetServItemLine;
                    end;
                }
                action("&Remove Contract Lines")
                {
                    ApplicationArea = All;
                    Caption = '&Remove Contract Lines';
                    Image = RemoveLine;

                    trigger OnAction()
                    begin
                        ServContractLine.RESET;
                        ServContractLine.SETRANGE("Contract Type", Rec."Contract Type");
                        ServContractLine.SETRANGE("Contract No.", Rec."Contract No.");
                        REPORT.RUNMODAL(REPORT::"Remove Lines from Contract", TRUE, TRUE, ServContractLine);
                        CurrPage.UPDATE;
                    end;
                }
                action(SignContract)
                {
                    ApplicationArea = All;
                    Caption = 'Si&gn Contract';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SignServContractDoc: Codeunit 5944;
                    begin
                        CurrPage.UPDATE;
                        SignServContractDoc.SignContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                separator("-=-----")
                {
                }
                action("C&hange Customer")
                {
                    ApplicationArea = All;
                    Caption = 'C&hange Customer';
                    Image = ChangeCustomer;

                    trigger OnAction()
                    begin
                        CLEAR(ChangeCustomerinContract);
                        ChangeCustomerinContract.SetRecord(Rec."Contract No.");
                        ChangeCustomerinContract.RUNMODAL;
                    end;
                }
                action("Copy &Document...")
                {
                    ApplicationArea = All;
                    Caption = 'Copy &Document...';
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CheckRequiredFields;
                        CLEAR(CopyServDoc);
                        CopyServDoc.SetServContractHeader(Rec);
                        CopyServDoc.RUNMODAL;
                    end;
                }
                action("&File Contract")
                {
                    ApplicationArea = All;
                    Caption = '&File Contract';
                    Image = Agreement;

                    trigger OnAction()
                    begin
                        IF CONFIRM(Text014) THEN
                            FiledServContract.FileContract(Rec);
                    end;
                }
                separator("-=-")
                {
                }
            }
        }
        area(reporting)
        {
            action("Contract Details")
            {
                ApplicationArea = All;
                Caption = 'Contract Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Contract-Detail";
                ToolTip = 'Specifies billable prices for the job task that are related to items.';
            }
            action("Contract Gain/Loss Entries")
            {
                ApplicationArea = All;
                Caption = 'Contract Gain/Loss Entries';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contract Gain/Loss Entries";
                ToolTip = 'Specifies billable prices for the job task that are related to G/L accounts, expressed in the local currency.';
            }
            action("Contract Invoicing")
            {
                ApplicationArea = All;
                Caption = 'Contract Invoicing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contract Invoicing";
                ToolTip = 'Specifies all billable profits for the job task.';
            }
            action("Contract Price Update - Test")
            {
                ApplicationArea = All;
                Caption = 'Contract Price Update - Test';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Contract Price Update - Test";
            }
            action("Prepaid Contract")
            {
                ApplicationArea = All;
                Caption = 'Prepaid Contract';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prepaid Contr. Entries - Test";
            }
            action("Expired Contract Lines")
            {
                ApplicationArea = All;
                Caption = 'Expired Contract Lines';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Expired Contract Lines - Test";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CALCFIELDS("Calcd. Annual Amount", "No. of Posted Invoices", "No. of Unposted Invoices");
        ActivateFields;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.UpdateShiptoCode;
    end;

    trigger OnInit()
    begin
        InvoiceAfterServiceEnable := TRUE;
        PrepaidEnable := TRUE;
        FirstServiceDateEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetServiceFilter;
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetServiceFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetServiceFilter);
            Rec.FILTERGROUP(0);
        END;

        ActivateFields;
    end;

    var
        Text000: Label '%1 must not be blank in %2 %3', Comment = 'Contract No. must not be blank in Service Contract Header SC00004';
        Text003: Label 'There are unposted invoices associated with this contract.\\Do you want to continue?';
        Text004: Label 'You cannot create an invoice for %1 %2 because %3 is %4.', Comment = 'You cannot create an invoice for Service Contract Header Contract No. because Invoice Period is Month.';
        Text005: Label 'The next invoice date has not expired.';
        Text006: Label 'An invoice was created successfully.';
        Text007: Label 'Do you want to create an invoice for the contract?';
        Text008: Label 'The invoice was created successfully.';
        Text009: Label 'There are unposted credit memos associated with this contract.\\Do you want to continue?';
        Text010: Label 'Do you want to create a credit note for the contract?';
        Text011: Label 'Processing...        \\';
        Text012: Label 'Contract lines have been credited.\\Credit memo %1 was created.';
        Text013: Label 'A credit memo cannot be created. There must be at least one invoiced and expired service contract line which has not yet been credited.';
        Text014: Label 'Do you want to file the contract?';
        ServContractLine: Record 5964;
        ServContractLine1: Record 5964;
        FiledServContract: Record 5970;
        ChangeCustomerinContract: Report 6037;
        CopyServDoc: Report 5979;
        ServContractMgt: Codeunit 5940;
        UserMgt: Codeunit 5700;
        Text015: Label '%1 must not be %2 in %3 %4', Comment = 'Status must not be Locked in Service Contract Header SC00005';
        Text016: Label 'A credit memo cannot be created, because the %1 %2 is after the work date.', Comment = 'A credit memo cannot be created, because the Credit Memo Date 03-02-11 is after the work date.';
        [InDataSet]
        FirstServiceDateEditable: Boolean;
        [InDataSet]
        PrepaidEnable: Boolean;
        [InDataSet]
        InvoiceAfterServiceEnable: Boolean;

    local procedure CollectShpmntsByLineContractNo(var TempServShptHeader: Record 5990 temporary)
    var
        ServShptHeader: Record 5990;
        ServShptLine: Record 5991;
    begin
        TempServShptHeader.RESET;
        TempServShptHeader.DELETEALL;
        ServShptLine.RESET;
        ServShptLine.SETCURRENTKEY("Contract No.");
        ServShptLine.SETRANGE("Contract No.", Rec."Contract No.");
        IF ServShptLine.FIND('-') THEN
                REPEAT
                    IF ServShptHeader.GET(ServShptLine."Document No.") THEN BEGIN
                        TempServShptHeader.COPY(ServShptHeader);
                        IF TempServShptHeader.INSERT THEN;
                    END;
                UNTIL ServShptLine.NEXT = 0;
    end;

    local procedure ActivateFields()
    begin
        FirstServiceDateEditable := Rec.Status <> Rec.Status::Signed;
        PrepaidEnable := (NOT Rec."Invoice after Service" OR Rec.Prepaid);
        InvoiceAfterServiceEnable := (NOT Rec.Prepaid OR Rec."Invoice after Service");
    end;


    procedure CheckRequiredFields()
    begin
        IF Rec."Contract No." = '' THEN
            ERROR(Text000, Rec.FIELDCAPTION("Contract No."), Rec.TABLECAPTION, Rec."Contract No.");
        IF Rec."Customer No." = '' THEN
            ERROR(Text000, Rec.FIELDCAPTION("Customer No."), Rec.TABLECAPTION, Rec."Contract No.");
        IF FORMAT(Rec."Service Period") = '' THEN
            ERROR(Text000, Rec.FIELDCAPTION("Service Period"), Rec.TABLECAPTION, Rec."Contract No.");
        IF Rec."First Service Date" = 0D THEN
            ERROR(Text000, Rec.FIELDCAPTION("First Service Date"), Rec.TABLECAPTION, Rec."Contract No.");
        IF Rec.Status = Rec.Status::Canceled THEN
            ERROR(Text015, Rec.FIELDCAPTION(Status), FORMAT(Rec.Status), Rec.TABLECAPTION, Rec."Contract No.");
        IF Rec."Change Status" = Rec."Change Status"::Locked THEN
            ERROR(Text015, Rec.FIELDCAPTION("Change Status"), FORMAT(Rec."Change Status"), Rec.TABLECAPTION, Rec."Contract No.");
    end;

    local procedure GetServItemLine()
    var
        ContractLineSelection: Page 6057;
        EnumServConType: Enum "Service Contract Type";
    begin
        CLEAR(ContractLineSelection);
        //Win513++
        //ContractLineSelection.SetSelection(Rec."Customer No.", Rec."Ship-to Code", Rec."Contract Type", Rec."Contract No.");//EnumServConType.AsInteger()
        ContractLineSelection.SetSelection(Rec."Customer No.", Rec."Ship-to Code", Rec."Contract Type".AsInteger(), Rec."Contract No.");//EnumServConType.AsInteger()
        //Win513--
        ContractLineSelection.RUNMODAL;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure StartingDateOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure StatusOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShiptoCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ResponseTimeHoursOnAfterValida()
    begin
        CurrPage.UPDATE(TRUE);
    end;

    local procedure ServicePeriodOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure AnnualAmountOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure InvoiceafterServiceOnAfterVali()
    begin
        ActivateFields;
    end;

    local procedure AllowUnbalancedAmountsOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure PrepaidOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure ExpirationDateOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure FirstServiceDateOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;
}

