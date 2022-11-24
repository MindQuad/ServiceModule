page 50006 "ERP Admin Role Center"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'ERP Admin Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(General)
            {
                part("Finance Performance"; 762)
                {
                    ApplicationArea = All;
                    Caption = 'Finance Performance';
                    Visible = false;
                }
                part("Account Manager Activities"; 9030)
                {
                    ApplicationArea = All;
                    Caption = 'Account Manager Activities';
                }
                part("Sales Activities"; 9060)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Activities';
                }
                part("Purchase/Logistics Activities"; 9063)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase/Logistics Activities';
                }
                part("Service Manager Activities"; 9057)
                {
                    ApplicationArea = All;
                    Caption = 'Service Manager Activities';
                }
            }
            group(Others)
            {
                part("Trailing Sales Orders Chart"; 760)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part("My Customers"; 9150)
                {
                    ApplicationArea = All;
                }
                part("My Vendors"; 9151)
                {
                    ApplicationArea = All;
                }
                systempart("MyNotes"; MyNotes)
                {
                    ApplicationArea = All;
                }
                systempart("Outlook"; Outlook)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&G/L Trial Balance")
            {
                ApplicationArea = All;
                Caption = '&G/L Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance";
            }
            action("&Bank Detail Trial Balance")
            {
                ApplicationArea = All;
                Caption = '&Bank Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
            }
            action("&Account Schedule")
            {
                ApplicationArea = All;
                Caption = '&Account Schedule';
                Image = "Report";
                RunObject = Report "Account Schedule";
            }
            action("Trial Bala&nce/Budget")
            {
                ApplicationArea = All;
                Caption = 'Trial Bala&nce/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
            }
            action("Trial Balance by &Period")
            {
                ApplicationArea = All;
                Caption = 'Trial Balance by &Period';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action("&Fiscal Year Balance")
            {
                ApplicationArea = All;
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                ApplicationArea = All;
                Caption = 'Balance Comp. - Prev. Y&ear';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("&Closing Trial Balance")
            {
                ApplicationArea = All;
                Caption = '&Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            separator("--")
            {
            }
            action("Aged Accounts &Receivable")
            {
                ApplicationArea = All;
                Caption = 'Aged Accounts &Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Pa&yable")
            {
                ApplicationArea = All;
                Caption = 'Aged Accounts Pa&yable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            separator("---")
            {
            }
            action("VAT &Statement")
            {
                ApplicationArea = All;
                Caption = 'VAT &Statement';
                Image = "Report";
                RunObject = Report 12;
            }
        }
        area(embedding)
        {
            action("Chart of Account")
            {
                ApplicationArea = All;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
            }
            action("Bank Accounts")
            {
                ApplicationArea = All;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
            }
            action("Approval Entries")
            {
                ApplicationArea = All;
                RunObject = Page "Approval Entries";
            }
        }
        area(sections)
        {
            group(Masters)
            {
                Caption = 'Masters';
                Image = AdministrationSalesPurchases;
                action("Salesperson/Purchaser")
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson/Purchaser';
                    RunObject = Page "Salespersons/Purchasers";
                }
                action(Contacts)
                {
                    ApplicationArea = All;
                    Caption = 'Contacts';
                    Image = Customer;
                    RunObject = Page "Contact List";
                }
                action(Customers)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    Image = Customer;
                    RunObject = Page "Customer List";
                }
                action(Vendors)
                {
                    ApplicationArea = All;
                    Caption = 'Vendors';
                    Image = Vendor;
                    RunObject = Page "Vendor List";
                }
                action(Items)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                }
                action("Service Item")
                {
                    ApplicationArea = All;
                    RunObject = Page "Service Item List";
                }
                action("Location List")
                {
                    ApplicationArea = All;
                    Caption = 'Location List';
                    Image = LotInfo;
                    RunObject = Page "Location List";
                }
                action("Bank Account List")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Account List';
                    Image = Bank;
                    RunObject = Page "Bank Account List";
                }
                action(Dimension)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Dimensions";
                }
                action("Fixed Assets")
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Assets';
                    Image = FixedAssets;
                    RunObject = Page "Fixed Asset List";
                }
                action("Chart of Accounts")
                {
                    ApplicationArea = All;
                    Caption = 'Chart of Accounts';
                    Image = ChartOfAccounts;
                    RunObject = Page "Chart of Accounts";
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                Image = Purchasing;
                action("Purchase Quote")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Quote';
                    RunObject = Page "Purchase Quotes";
                }
                action("Purchase Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                }
                action("Purchase Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Invoices';
                    RunObject = Page "Purchase Invoices";
                }
                action("Purchase Credit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Credit Memo';
                    RunObject = Page "Purchase Credit Memos";
                }
                action("Posted Purchase Rcpts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Credit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Credit Memo';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = All;
                    RunObject = Page "Posted Return Shipments";
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                action("Sales Quote")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quote';
                    RunObject = Page "Sales Quotes";
                }
                action("Sales Order")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order';
                    RunObject = Page "Sales Order List";
                }
                action("Sales Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoice (DN)';
                    RunObject = Page "Sales Invoice List";
                }
                action("Sales Credit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Credit Memo';
                    RunObject = Page "Sales Credit Memos";
                }
                action("Posted Sales Shipments(DO)")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Shipments(DO)';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memo';
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = All;
                    RunObject = Page "Posted Return Receipts";
                }
            }
            group(Warehousing)
            {
                Caption = 'Warehousing';
                Image = LotInfo;
                action("<Page Location List>")
                {
                    ApplicationArea = All;
                    Caption = 'Locations';
                    RunObject = Page "Location List";
                }
                action("Transfer Order")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Order';
                    RunObject = Page "Transfer Orders";
                }
                action("Item Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(false));
                }
                action("Item Reclassification Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Item Reclassification Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Transfer),
                                        Recurring = CONST(false));
                }
                action("Revaluation Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Revaluation Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Revaluation),
                                        Recurring = CONST(false));
                }
                action("Physical Inventory Journal")
                {
                    ApplicationArea = All;
                    Caption = 'Physical Inventory Journal';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Phys. Inventory"),
                                        Recurring = CONST(False));
                }
                action("Posted Transfer Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page "Posted Transfer Shipments";
                }
                action("Posted Transfer Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = HumanResources;
                action("Service Items")
                {
                    ApplicationArea = All;
                    Caption = 'Service Items';
                    RunObject = Page "Service Item List";
                }
                action("Service Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Service Orders';
                    RunObject = Page "Service Orders";
                }
                action("Service Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Service Invoices';
                    RunObject = Page "Service Invoices";
                }
                action("Service Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Service Credit Memos';
                    RunObject = Page "Service Credit Memos";
                }
                action("Posted Service Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Shipments';
                    RunObject = Page "Posted Service Shipments";
                }
                action("Posted Service Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Invoices';
                    RunObject = Page "Posted Service Invoices";
                }
                action("Posted Service Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Credit Memos';
                    RunObject = Page "Posted Service Credit Memos";
                }
                action("Time-Sheet List")
                {
                    ApplicationArea = All;
                    Caption = 'Time Sheet List';
                    RunObject = Page "Time Sheet List";
                }
                action("Manager Time-Sheet List")
                {
                    ApplicationArea = All;
                    Caption = 'Manager Time Sheet List';
                    RunObject = Page "Manager Time Sheet List";
                }
            }
            group("Project Management")
            {
                Caption = 'Project Management';
                Image = ProductDesign;
                action("Job List")
                {
                    ApplicationArea = All;
                    Caption = 'Job List';
                    RunObject = Page "Job List";
                }
                action("Job Journal")
                {
                    ApplicationArea = All;
                    Caption = 'Job Journal';
                    RunObject = Page "Job Journal Batches";
                }
                action("Time Sheet List")
                {
                    ApplicationArea = All;
                    Caption = 'Time Sheet List';
                    RunObject = Page "Time Sheet List";
                }
                action("Manager Time Sheet List")
                {
                    ApplicationArea = All;
                    Caption = 'Manager Time Sheet List';
                    RunObject = Page "Manager Time Sheet List";
                }
            }
            group("Assembly Order")
            {
                Caption = 'Assembly Orders';
                action("Assembly Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Assembly Orders';
                    RunObject = Page "Assembly Orders";
                }
                action("Posted Assembly Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Assembly Orders';
                    RunObject = Page "Posted Assembly Orders";
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action("Cash Receipt Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                }
                action("Payment Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                }
                action("General Journals")
                {
                    ApplicationArea = All;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                }
                action("<Action3>")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Shipments';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("G/L Registers")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
            }
            group("Service Setup")
            {
                Caption = 'Service Setup';
                Image = SNInfo;
                action("Resolution Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Resolution Codes';
                    Image = Currency;
                    RunObject = Page "Resolution Codes";
                }
                action("Fault Areas")
                {
                    ApplicationArea = All;
                    Caption = 'Fault Areas';
                    Image = AccountingPeriods;
                    RunObject = Page "Fault Areas";
                }
                action("Symptom Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Symptom Codes';
                    RunObject = Page "Symptom Codes";
                }
                action("Fault Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Fault Codes';
                    RunObject = Page "Fault Codes";
                }
                action("Fault Reason Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Fault Reason Codes';
                    Image = Dimensions;
                    RunObject = Page "Fault Reason Codes";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action(Currencies)
                {
                    ApplicationArea = All;
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                }
                action("Accounting Periods")
                {
                    ApplicationArea = All;
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                }
                action("Number Series")
                {
                    ApplicationArea = All;
                    Caption = 'Number Series';
                    RunObject = Page "No. Series";
                }
                action("Analysis Views")
                {
                    ApplicationArea = All;
                    Caption = 'Analysis Views';
                    RunObject = Page "Analysis View List";
                }
                action("Account Schedules")
                {
                    ApplicationArea = All;
                    Caption = 'Account Schedules';
                    RunObject = Page "Account Schedule Names";
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Dimensions";
                }
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Account Posting Groups';
                    RunObject = Page "Bank Account Posting Groups";
                }
                action("Countries/Regions")
                {
                    ApplicationArea = All;
                    Caption = 'Countries/Regions';
                    RunObject = Page "Countries/Regions";
                }
                action("Post Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Post Codes';
                    RunObject = Page "Post Codes";
                }
                action("User Setup")
                {
                    ApplicationArea = All;
                    Caption = 'User Setup';
                    RunObject = Page "User Setup";
                }
                action("Warehouse Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Employees';
                    RunObject = Page "Warehouse Employees";
                }
                action("Active Session")
                {
                    ApplicationArea = All;
                    RunObject = Page "Concurrent Session List";
                }
            }
        }
        area(processing)
        {
            action("Navi&gate")
            {
                ApplicationArea = All;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page "Navigate";
            }
        }
    }
}

