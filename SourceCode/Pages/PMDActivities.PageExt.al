PageExtension 50302 pageextension50302 extends "Serv Outbound Technician Act."
{

    //Unsupported feature: Property Modification (Name) on ""Serv Outbound Technician Act."(Page 9066)".


    //Unsupported feature: Property Modification (SourceTable) on ""Serv Outbound Technician Act."(Page 9066)".

    layout
    {
        modify("Service Orders - Today")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Service Orders - to Follow-up")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addfirst("Outbound Service Orders")
        {

            field("Service Contracts to Expire"; rec."Service Contracts to Expire")
            {
                ApplicationArea = Basic;
            }
            label(Control1000000007)
            {
                ApplicationArea = Basic;
            }
            cuegroup("Properties, Units & Rental")
            {
                Caption = 'Properties, Units & Rental';
                field(Buildings; rec.Buildings)
                {
                    ApplicationArea = Basic;
                }
                field(Units; rec.Units)
                {
                    ApplicationArea = Basic;
                }
                field("Rental : Vacant"; rec."Rental : Vacant")
                {
                    ApplicationArea = Basic;
                }
                field(Occupied; rec.Occupied)
                {
                    ApplicationArea = Basic;
                }
                field("Pending Renewal"; rec."Pending Renewal")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            cuegroup(Contracts)
            {
                Caption = 'Contracts';
                field("Service Contracts"; rec."Service Contracts")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Contract List";
                    LookupPageID = "Service Contract List";
                }
                field("Service Contracts Pending Appr"; rec."Service Contracts Pending Appr")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}
