page 50033 "Service Contracts (Leasing)"
{
    Caption = 'Leasing Contracts';
    CardPageID = "Service Contract";
    Editable = false;
    PageType = List;
    SourceTable = 5965;
    SourceTableView = WHERE("Contract Type" = CONST(Contract));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the service contract or service contract quote.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the service contract or contract quote.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the customer in the service contract.';
                    Visible = false;
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the service contract expires.';
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                }
                field("Change Status"; Rec."Change Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if a service contract or contract quote is locked or open for changes.';
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment terms code for the customer in the contract.';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency used to calculate the amounts in the documents related to this contract.';
                    Visible = false;
                }
                field("First Service Date"; Rec."First Service Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the first expected service for the service items in the contract.';
                    Visible = false;
                }
                field("Service Order Type"; Rec."Service Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service order type assigned to service orders linked to this contract.';
                    Visible = false;
                }
                field("Invoice Period"; Rec."Invoice Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoice period for the service contract.';
                    Visible = false;
                }
                field("Next Price Update Date"; Rec."Next Price Update Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the next date you want contract prices to be updated.';
                    Visible = false;
                }
                field("Last Price Update Date"; Rec."Last Price Update Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date you last updated the contract prices.';
                    Visible = false;
                }
                field("Status Description"; Rec."Status Description")
                {
                    ApplicationArea = All;
                }
                field("Special Condition"; Rec."Special Condition")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Service Zone Code"; Rec."Service Zone Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Customer Statistics FactBox"; 9082)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No."),
                              "Date Filter" = FIELD("Date Filter");
                Visible = true;
            }
            part("Customer Details FactBox"; 9084)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Customer No."),
                              "Date Filter" = FIELD("Date Filter");
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
                separator("-")
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
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Contract No." = FIELD("Contract No.");
                    RunPageView = SORTING("Service Contract No.", "Posting Date", "Document No.");
                }
                separator("--")
                {
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
                separator("---")
                {
                    Caption = '';
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
                separator("----")
                {
                    Caption = '';
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
                separator("-----")
                {
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
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Si&gn Contract")
                {
                    ApplicationArea = All;
                    Caption = 'Si&gn Contract';
                    Image = Signature;

                    trigger OnAction()
                    var
                        SignServContractDoc: Codeunit 5944;
                    begin
                        CurrPage.UPDATE;
                        SignServContractDoc.SignContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                separator("------")
                {
                    Caption = '';
                }
                action("&Lock Contract")
                {
                    ApplicationArea = All;
                    Caption = '&Lock Contract';
                    Image = Lock;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit 5943;
                    begin
                        CurrPage.UPDATE;
                        LockOpenServContract.LockServContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action("&Open Contract")
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
            }
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
        area(reporting)
        {
            action("Contract, Service Order Test")
            {
                ApplicationArea = All;
                Caption = 'Contract, Service Order Test';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 5988;
            }
            action("Maintenance Visit - Planning")
            {
                ApplicationArea = All;
                Caption = 'Maintenance Visit - Planning';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 5980;
            }
            action("Service Contract Details")
            {
                ApplicationArea = All;
                Caption = 'Service Contract Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5971;
            }
            action("Service Contract Profit")
            {
                ApplicationArea = All;
                Caption = 'Service Contract Profit';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 5976;
            }
            action("Contract Invoice Test")
            {
                ApplicationArea = All;
                Caption = 'Contract Invoice Test';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5984;
                ToolTip = 'Specifies billable profits for the job task that are related to items.';
            }
            action("Service Contract-Customer")
            {
                ApplicationArea = All;
                Caption = 'Service Contract-Customer';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 5977;
            }
            action("Service Contract-Salesperson")
            {
                ApplicationArea = All;
                Caption = 'Service Contract-Salesperson';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5978;
            }
            action("Contract Price Update - Test")
            {
                ApplicationArea = All;
                Caption = 'Contract Price Update - Test';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5985;
            }
            action("Service Items Out of Warranty")
            {
                ApplicationArea = All;
                Caption = 'Service Items Out of Warranty';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5937;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetSecurityFilterOnRespCenter;
    end;
}

