report 50205 "Help Ticket Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './HelpTicketDetails.rdl';
    Caption = 'Help Ticket Details';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Service Header"; "Service Header")
        {
            CalcFields = "Building Name";
            DataItemTableView = SORTING("Document Type", "No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "Order Date", "No.", "Customer No.", "Building No.", "Unit No.", "Service Order Type";
            column(Date; FORMAT("Service Header"."Order Date"))
            {
            }
            column(Call_No; "Service Header"."No.")
            {
            }
            column(Building_Name; "Service Header"."Building Name")
            {
            }
            column(Unit_No; "Service Header"."Unit No.")
            {
            }
            column(Time; FORMAT("Service Header"."Order Time"))
            {
            }
            column(Scope_of_Work; FORMAT("Service Header"."Service Order Type"))
            {
            }
            column(Issues; "Service Header"."Additional Work Description")
            {
            }
            column(Client_No; "Service Header"."Customer No.")
            {
            }
            column(Status; FORMAT("Service Header".Status))
            {
            }
            column(Date_Finished; FORMAT("Service Header"."Finishing Date"))
            {
            }
            column(Technician; ResourceName)
            {
            }
            column(GetFilters; "Service Header".GETFILTERS)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(ResourceName);
                ServiceOrderAllocation.RESET;
                ServiceOrderAllocation.SETRANGE("Document Type", "Service Header"."Document Type");
                ServiceOrderAllocation.SETRANGE("Document No.", "Service Header"."No.");
                IF ServiceOrderAllocation.FINDFIRST THEN
                    REPEAT
                        IF Resource.GET(ServiceOrderAllocation."Resource No.") THEN;
                        IF ResourceName = '' THEN
                            ResourceName := Resource.Name
                        ELSE
                            ResourceName += '/' + Resource.Name;
                    UNTIL ServiceOrderAllocation.NEXT = 0;
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
        ServiceOrderAllocation: Record 5950;
        Resource: Record 156;
        ResourceName: Text;
}

