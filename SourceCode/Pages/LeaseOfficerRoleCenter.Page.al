page 50036 "Lease Officer Role Center"
{
    Caption = 'Lease Officer Role Center';
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {

            group(General)
            {
                part("Leasing Activities"; 50031)
                {
                    ApplicationArea = All;
                }
            }
            group(Others)
            {
                //Win513++
                //part("Notification Entries"; 1511)
                part("Notification Entries"; 50500)
                //Win513--
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
            action("Service Ta&sks")
            {
                ApplicationArea = All;
                Caption = 'Service Ta&sks';
                Image = ServiceTasks;
                RunObject = Report "Service Tasks";
            }
            action("Service &Load Level")
            {
                ApplicationArea = All;
                Caption = 'Service &Load Level';
                Image = "Report";
                RunObject = Report "Service Load Level";
            }
            action("Resource &Usage")
            {
                ApplicationArea = All;
                Caption = 'Resource &Usage';
                Image = "Report";
                RunObject = Report "Service Item - Resource Usage";
            }
            separator("-")
            {

            }
            action("Service I&tems Out of Warranty")
            {
                ApplicationArea = All;
                Caption = 'Service I&tems Out of Warranty';
                Image = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
            separator("--")
            {
            }
            action("Profit Service &Contracts")
            {
                ApplicationArea = All;
                Caption = 'Profit Service &Contracts';
                Image = "Report";
                RunObject = Report "Service Profit (Contracts)";
            }
            action("Profit Service &Orders")
            {
                ApplicationArea = All;
                Caption = 'Profit Service &Orders';
                Image = "Report";
                RunObject = Report "Service Profit (Serv. Orders)";
            }
            action("Profit Service &Items")
            {
                ApplicationArea = All;
                Caption = 'Profit Service &Items';
                Image = "Report";
                RunObject = Report "Service Profit (Service Items)";
            }
        }
        area(embedding)
        {
            action("Building List")
            {
                ApplicationArea = All;
                Caption = 'Building List';
                RunObject = Page "Building List";
            }
            action("Unit List")
            {
                ApplicationArea = All;
                Caption = 'Unit List';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
            action("Contact List")
            {
                ApplicationArea = All;
                Caption = 'Contact List';
                Image = ContactPerson;
                RunObject = Page "Contact List";
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action("Service Contract Quotes")
            {
                ApplicationArea = All;
                Caption = 'Lease Quotes';
                RunObject = Page "Service Contract Quotes";
            }
            action("Service Contract List")
            {
                ApplicationArea = All;
                Caption = 'Service Contract List';
                RunObject = Page "Service Contract List";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Service Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Service Shipments";
                }
                action("Posted Service Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Invoices';
                    Image = PostedServiceOrder;
                    RunObject = Page "Posted Service Invoices";
                }
                action("Posted Service Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Credit Memos';
                    RunObject = Page "Posted Service Credit Memos";
                }
            }
        }
        area(creation)
        {
            group("&Service")
            {
                Caption = '&Service';
                Image = Tools;
                action("Service Contract &Quote")
                {
                    ApplicationArea = All;
                    Caption = 'Lease Quote';
                    Image = AgreementQuote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Contract Quote";
                    RunPageMode = Create;
                }
                action("Service &Contract")
                {
                    ApplicationArea = All;
                    Caption = 'Service &Contract';
                    Image = Agreement;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Contract";
                    RunPageMode = Create;
                }
                action("Service Q&uote")
                {
                    ApplicationArea = All;
                    Caption = 'Service Q&uote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Quote";
                    RunPageMode = Create;
                }
                action("Service &Order")
                {
                    ApplicationArea = All;
                    Caption = 'Service &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Order";
                    RunPageMode = Create;
                }
            }
            action("Sales Or&der")
            {
                ApplicationArea = All;
                Caption = 'Sales Or&der';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
            }
            action("Transfer &Order")
            {
                ApplicationArea = All;
                Caption = 'Transfer &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Transfer Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Insurance List")
            {
                ApplicationArea = All;
                Caption = 'Insurance List';
                Image = ListPage;
                RunObject = Page "Insurance List";
            }
            action("Service Tas&ks")
            {
                ApplicationArea = All;
                Caption = 'Service Tas&ks';
                Image = ServiceTasks;
                RunObject = Page "Service Tasks";
            }
            action("C&reate Contract Service Orders")
            {
                ApplicationArea = All;
                Caption = 'C&reate Contract Service Orders';
                Image = "Report";
                RunObject = Report "Create Contract Service Orders";
            }
            action("Create Contract In&voices")
            {
                ApplicationArea = All;
                Caption = 'Create Contract In&voices';
                Image = "Report";
                RunObject = Report "Create Contract Invoices";
            }
            action("Post &Prepaid Contract Entries")
            {
                ApplicationArea = All;
                Caption = 'Post &Prepaid Contract Entries';
                Image = "Report";
                RunObject = Report "Post Prepaid Contract Entries";
            }
            separator("---")
            {
            }
            action("Order Pla&nning")
            {
                ApplicationArea = All;
                Caption = 'Order Pla&nning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Administration)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("St&andard Service Codes")
            {
                ApplicationArea = All;
                Caption = 'St&andard Service Codes';
                Image = ServiceCode;
                RunObject = Page "Standard Service Codes";
            }
            action("Dispatch Board")
            {
                ApplicationArea = All;
                Caption = 'Dispatch Board';
                Image = ListPage;
                RunObject = Page "Dispatch Board";
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Item &Tracing")
            {
                ApplicationArea = All;
                Caption = 'Item &Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
            }
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