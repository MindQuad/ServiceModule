page 50088 "Legal Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(General)
            {

            }
            part("Service Lease Activities"; 50032)
            {
                ApplicationArea = All;
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
        area(embedding)
        {
            action("Building List")
            {
                ApplicationArea = All;
                Caption = 'Building List';
                RunObject = Page "Building List";
                Visible = false;
            }
            action("Unit List")
            {
                ApplicationArea = All;
                Caption = 'Unit List';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
                Visible = false;
            }
            action("Contact List")
            {
                ApplicationArea = All;
                Caption = 'Contact List';
                Image = ContactPerson;
                RunObject = Page "Contact List";
                Visible = true;
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                Visible = false;
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
            action("Post Dated Check List")
            {
                ApplicationArea = All;
                Caption = 'Post Dated Check List';
                RunObject = Page "Post Dated Checks Status List";
            }
            action("Court Case Entries")
            {
                ApplicationArea = All;
                Caption = 'Court Case Entries';
                RunObject = Page "Court Case";
            }
            action("Post Dated Checks Leasing")
            {
                ApplicationArea = All;
                Caption = 'Post Dated Checks Leasing';
                RunObject = Page "Post Dated Checks Leasing";
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
                    Visible = false;
                }
                action("Posted Service Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Invoices';
                    Image = PostedServiceOrder;
                    RunObject = Page "Posted Service Invoices";
                    Visible = false;
                }
                action("Posted Service Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Credit Memos';
                    RunObject = Page "Posted Service Credit Memos";
                    Visible = false;
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
        }
    }
}

