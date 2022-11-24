report 50209 "Inbound Leads Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './InboundLeadsReport.rdl';
    Caption = 'Inbound Leads Report';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Contact; Contact)
        {
            CalcFields = "Date of Last Interaction";
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE(Type = FILTER(Person));
            RequestFilterFields = "No.", "Company No.";
            column(Contact_No; Contact."No.")
            {
            }
            column(First_Name; Contact."First Name")
            {
            }
            column(Middle_Name; Contact."Middle Name")
            {
            }
            column(Last_Name; Contact.Surname)
            {
            }
            column(Email; Contact."E-Mail")
            {
            }
            column(Mobile_No; Contact."Phone No.")
            {
            }
            column(Business_Unit_Code; Contact."Company No.")
            {
            }
            column(Business_Unit_Name; Contact."Company Name")
            {
            }
            column(Source; FORMAT(RecContact."Source of Lead"))
            {
            }
            column(Date_Sourced; FORMAT(RecContact."Creation Date"))
            {
            }
            column(Type_of_Enquiry; InteractionDesc)
            {
            }
            column(Date_of_Contact; FORMAT(Contact."Date of Last Interaction"))
            {
            }
            column(Sales_Person_Assigned; SalespersonPurchaser.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF SalespersonPurchaser.GET(Contact."Salesperson Code") THEN;

                IF RecContact.GET(Contact."Company No.") THEN;

                CLEAR(InteractionDesc);
                InteractionLogEntry.RESET;
                InteractionLogEntry.SETRANGE(InteractionLogEntry."Contact Company No.", Contact."Company No.");
                InteractionLogEntry.SETRANGE(InteractionLogEntry."Contact No.", Contact."No.");
                InteractionLogEntry.SETRANGE(InteractionLogEntry."Attempt Failed", FALSE);
                InteractionLogEntry.SETRANGE(InteractionLogEntry.Postponed, FALSE);
                IF InteractionLogEntry.FINDLAST THEN
                    InteractionDesc := InteractionLogEntry.Description;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecContact: Record 5050;
        SalespersonPurchaser: Record 13;
        InteractionLogEntry: Record 5065;
        InteractionDesc: Text[100];
}

