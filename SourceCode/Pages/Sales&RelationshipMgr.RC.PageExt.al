PageExtension 50250 pageextension50250 extends "Sales & Relationship Mgr. RC"
{
    actions
    {

        //Unsupported feature: Property Modification (Name) on "Contacts(Action 25)".


        //Unsupported feature: Property Modification (Name) on "Customers(Action 26)".


        addfirst(embedding)
        {
            action(Buildings)
            {
                ApplicationArea = Basic;
                Caption = 'Buildings';
                RunObject = Page "Building List";
            }
            action(Units)
            {
                ApplicationArea = Basic;
                Caption = 'Units';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
            action(ServiceOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Service Contracts';
                Image = Document;
                RunObject = Page "Service Contracts";
            }
            action(ServiceOrdersInProcess)
            {
                ApplicationArea = Basic;
                Caption = 'In Process';
                RunObject = Page "Service Orders";
                RunPageView = where(Status = filter("In Process"));
            }
            action(Customer)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Contact)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                Image = Company;
                RunObject = Page "Contact List";
            }
            action(Campaign)
            {
                ApplicationArea = Basic;
                Caption = 'Campaigns';
                Image = Campaign;
                RunObject = Page "Campaign List";
            }
            action(Segment)
            {
                ApplicationArea = Basic;
                Caption = 'Segments';
                Image = Segment;
                RunObject = Page "Segment List";
            }
            action("To-dos")
            {
                ApplicationArea = Basic;
                Caption = 'To-dos';
                Image = TaskList;
                RunObject = Page "Task List";
            }
            action(Teams)
            {
                ApplicationArea = Basic;
                Caption = 'Teams';
                Image = TeamSales;
                RunObject = Page Teams;
            }
            action(Action1000000000)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Buildings';
                Image = FixedAssets;
                RunObject = Page "Building List";
                ToolTip = 'Buildings';
            }
        }
    }
}

