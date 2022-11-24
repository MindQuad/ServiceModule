page 50028 "Customer Service Executive"
{
    Caption = 'Document Controller ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(General)
            {
                part("Document Controller Act."; 59066)
                {
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
                ApplicationArea = All;
                Caption = 'Service &Order';
                Image = Document;
                RunObject = Report 5900;
            }
            action("Service Items Out of &Warranty")
            {
                ApplicationArea = All;
                Caption = 'Service Items Out of &Warranty';
                Image = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
            action("Service Item &Line Labels")
            {
                ApplicationArea = All;
                Caption = 'Service Item &Line Labels';
                Image = "Report";
                RunObject = Report "Service Item Line Labels";
            }
            action("Service &Item Worksheet")
            {
                ApplicationArea = All;
                Caption = 'Service &Item Worksheet';
                Image = ServiceItemWorksheet;
                RunObject = Report "Service Item Worksheet";
            }
        }
        area(embedding)
        {
            action("Service Orders")
            {
                ApplicationArea = All;
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page "Service Orders";
            }
            action(ServiceOrdersInProcess)
            {
                ApplicationArea = All;
                Caption = 'In Process';
                RunObject = Page "Service Orders";
                RunPageView = WHERE(Status = FILTER("In Process"));
            }
            action("Service Item Lines")
            {
                ApplicationArea = All;
                Caption = 'Service Item Lines';
                RunObject = Page "Service Item Lines";
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Loaners)
            {
                ApplicationArea = All;
                Caption = 'Loaners';
                Image = Loaners;
                RunObject = Page "Loaner List";
            }
            action("Service Items")
            {
                ApplicationArea = All;
                Caption = 'Service Items';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
        }
        area(sections)
        {
        }
        area(creation)
        {
            action("Service &Order")
            {
                ApplicationArea = All;
                Caption = 'Service &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Service Orders";
                RunPageMode = Create;
            }
            action("&Loaner")
            {
                ApplicationArea = All;
                Caption = '&Loaner';
                Image = Loaner;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Loaner Card";
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
                ApplicationArea = All;
                Caption = 'Service Item &Worksheet';
                Image = ServiceItemWorksheet;
                RunObject = Page "Service Item Worksheet";
            }
        }
    }
}

