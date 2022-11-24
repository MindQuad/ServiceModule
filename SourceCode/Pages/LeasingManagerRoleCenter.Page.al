page 50023 "Leasing Manager Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(General)
            {
                part("Property Mgmt"; 50044)
                {
                    ApplicationArea = All;
                    Caption = 'Property Management';
                }
                part("Document Controller Act."; 59066)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part("Leasing & Contracts"; 9057)
                {
                    ApplicationArea = All;
                    Caption = 'Leasing & Contracts';
                    Visible = true;
                }
                part("Property Management"; "Serv Outbound Technician Act.")
                {
                    ApplicationArea = All;
                    Caption = 'Property Management';
                    Visible = false;
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
                RunObject = Report "Service Order";
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
            action("Salesperson - Sales &Statistics")
            {
                ApplicationArea = All;
                Caption = 'Salesperson - Sales &Statistics';
                Image = "Report";
                RunObject = Report "Salesperson - Sales Statistics";
            }
            action("Salesperson - &Commission")
            {
                ApplicationArea = All;
                Caption = 'Salesperson - &Commission';
                Image = "Report";
                RunObject = Report "Salesperson - Commission";
            }
            separator("-")
            {

            }
            action("Campaign - &Details")
            {
                ApplicationArea = All;
                Caption = 'Campaign - &Details';
                Image = "Report";
                RunObject = Report "Campaign - Details";
            }
        }
        area(embedding)
        {
            action(Buildings)
            {
                ApplicationArea = All;
                Caption = 'Buildings';
                RunObject = Page "Building List";
            }
            action(Units)
            {
                ApplicationArea = All;
                Caption = 'Units';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
            action(ServiceOrders)
            {
                ApplicationArea = All;
                Caption = 'Service Contracts';
                Image = Document;
                RunObject = Page "Service Contracts";
            }
            action(ServiceOrdersInProcess)
            {
                ApplicationArea = All;
                Caption = 'In Process';
                RunObject = Page "Service Orders";
                RunPageView = WHERE(Status = FILTER("In Process"));
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Contacts)
            {
                ApplicationArea = All;
                Caption = 'Contacts';
                Image = Company;
                RunObject = Page "Contact List";
            }
            action(Campaigns)
            {
                ApplicationArea = All;
                Caption = 'Campaigns';
                Image = Campaign;
                RunObject = Page "Campaign List";
            }
            action(Segments)
            {
                ApplicationArea = All;
                Caption = 'Segments';
                Image = Segment;
                RunObject = Page "Segment List";
            }
            action("To-dos")
            {
                ApplicationArea = All;
                Caption = 'To-dos';
                Image = TaskList;
                RunObject = Page "Task List";
            }
            action(Teams)
            {
                ApplicationArea = All;
                Caption = 'Teams';
                Image = TeamSales;
                RunObject = Page "Teams";
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
                RunObject = Page "Service Order";
                RunPageMode = Create;
            }
            action("Salespeople/Purchasers")
            {
                ApplicationArea = All;
                Caption = 'Salespeople/Purchasers';
                RunObject = Page "Salespersons/Purchasers";
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
        }
    }
}

