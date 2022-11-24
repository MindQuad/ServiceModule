page 50025 "Doc. Controller Role Center"
{
    Caption = 'Document Controller ';
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
                part("My Job Queue"; 675)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part("My Customers"; 9150)
                {
                    ApplicationArea = All;
                }
                part("Report Inbox Part"; 681)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                systempart("MyNotes"; MyNotes)
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
            action("Service Order")
            {
                Caption = 'Service &Order';
                Image = Document;
                RunObject = Report "Service Order";
            }
            action("Service Items Out of &Warranty")
            {
                Caption = 'Service Items Out of &Warranty';
                Image = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
            action("Service Item &Line Labels")
            {
                Caption = 'Service Item &Line Labels';
                Image = "Report";
                RunObject = Report "Service Item Line Labels";
            }
            action("Service &Item Worksheet")
            {
                Caption = 'Service &Item Worksheet';
                Image = ServiceItemWorksheet;
                RunObject = Report "Service Item Worksheet";
            }
        }
        area(embedding)
        {
            action(ServiceOrders)
            {
                Caption = 'Lease Contracts';
                Image = Document;
                RunObject = Page "Service Contracts";
            }
            action(ServiceOrdersInProcess)
            {
                Caption = 'In Process';
                RunObject = Page "Service Orders";
                RunPageView = WHERE(Status = FILTER("In Process"));
            }
            action("Service Item Lines")
            {
                Caption = 'Service Item Lines';
                RunObject = Page "Service Item Lines";
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Units)
            {
                Caption = 'Units';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
        }
        area(sections)
        {
        }
        area(creation)
        {
            action("Service &Order")
            {
                Caption = 'Service &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Service Order";
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
            action("Service Item &Worksheet")
            {
                Caption = 'Service Item &Worksheet';
                Image = ServiceItemWorksheet;
                RunObject = Page 5906;
            }
        }
    }
}

