PageExtension 50312 pageextension50312 extends "Service Dispatcher Role Center"
{
    layout
    {


    }
    actions
    {
        modify("Service Contract Quotes")
        {
            Caption = 'Lease Quotes';
        }
        modify("Service Contract &Quote")
        {
            Caption = 'Lease Quote';
        }
        addafter(Customers)
        {
            action("Contact List")
            {
                ApplicationArea = Basic;
                Caption = 'Contact List';
                Image = ContactPerson;
                RunObject = Page "Contact List";
            }
        }
        addafter("Requisition Worksheets")
        {
            action("Job List")
            {
                ApplicationArea = Basic;
                Caption = 'Job List';
                RunObject = Page "Job List";
            }
            action(Insurance)
            {
                ApplicationArea = Basic;
                Caption = 'Insurance';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Insurance List";
            }
        }
        //Win593
        addafter("Service Orders")
        {
            action("Service Ticket")
            {
                ApplicationArea = All;
                Caption = 'Service Ticket';
                RunObject = page "Service Ticket";
                RunPageView = where("FMS SO" = const(false));
            }
        }
        //Win593
    }
}

