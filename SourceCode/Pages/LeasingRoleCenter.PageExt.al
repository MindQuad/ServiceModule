PageExtension 50246 pageextension50246 extends "Shop Supervisor Role Center"
{

    //Unsupported feature: Property Modification (Name) on ""Shop Supervisor Role Center"(Page 9012)".

    Caption = 'Document Controller ';
    layout
    {

        //Unsupported feature: Property Modification (PartType) on "Control1901377608(Control 1901377608)".


        //Unsupported feature: Property Insertion (PagePartID) on "Control1901377608(Control 1901377608)".

        modify(Control1905423708)
        {
            Visible = false;
        }
        modify(Control1905989608)
        {
            Visible = false;
        }
        modify(Control1)
        {
            Visible = false;
        }
        modify(Control3)
        {
            Visible = false;
        }


        //Unsupported feature: Property Deletion (SystemPartID) on "Control1901377608(Control 1901377608)".

        addafter(Control1900724808)
        {
            part(Control1000000000; 50032)
            {
                ApplicationArea = Suite;
            }
        }
        addfirst(Control1900724708)
        {
            part(Control8; "My Job Queue")
            {
                ApplicationArea = All;
                Visible = false;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = All;
            }
            part(Control4; "Report Inbox Part")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    actions
    {
        modify("Registered Absence")
        {
            ApplicationArea = All;
            Caption = 'Service Item &Worksheet';

            //Unsupported feature: Property Modification (RunObject) on ""Registered Absence"(Action 10)".


            //Unsupported feature: Property Modification (Name) on ""Registered Absence"(Action 10)".


            //Unsupported feature: Property Insertion (Image) on ""Registered Absence"(Action 10)".

        }
        modify(Items)
        {
            //Unsupported feature: Property Modification (Name) on "Items(Action 12)".
            ApplicationArea = All;
            Caption = 'Buildings';
        }
        modify("Sales Orders")
        {
            ApplicationArea = All;
            Caption = 'Service Item &Line Labels';
        }
        modify("Purchase Orders")
        {
            Caption = 'Service Item Lines';
            ApplicationArea = All;
        }
        modify(RequisitionWorksheets)
        {
            Caption = 'Tasks';
            //Unsupported feature: Property Insertion (IsHeader) on "RequisitionWorksheets(Action 7)".
        }
        modify(Administration)
        {
            //Unsupported feature: Property Modification (ActionType) on "Administration(Action 5)".
            Caption = 'Lease Contracts';
        }
        modify("Capacity Constrained Resources")
        {
            //Unsupported feature: Property Modification (Level) on ""Capacity Constrained Resources"(Action 20)".
            Caption = 'Units';
        }
        modify("Scrap Codes")
        {
            //Unsupported feature: Property Modification (Level) on ""Scrap Codes"(Action 13)".

            Caption = 'Service Items Out of &Warranty';


        }
        modify("Consumptio&n Journal")
        {
            Caption = 'Service &Item Worksheet';

        }
        modify("Routing &Sheet")
        {
            Visible = false;
        }

        modify("Inventory - &Availability Plan")
        {
            Visible = false;
        }

        modify("Capacity Tas&k List")
        {
            Visible = false;
        }
        modify("Subcontractor - Dis&patch List")
        {
            Visible = false;
        }

        modify("Production Order Ca&lculation")
        {
            Visible = false;
        }
        modify("S&tatus")
        {
            Visible = false;
        }
        modify("Simulated Production Orders")
        {
            Visible = false;
        }
        modify("Planned Production Orders")
        {
            Visible = false;
        }
        modify("Firm Planned Production Orders")
        {
            Visible = false;
        }
        modify("Released Production Orders")
        {
            Visible = false;
        }
        modify("Finished Production Orders")
        {
            Visible = false;
        }
        modify(Routings)
        {
            Visible = false;
        }
        modify(ItemsProduced)
        {
            Visible = false;
        }
        modify(ItemsRawMaterials)
        {
            Visible = false;
        }
        modify("Stockkeeping Units")
        {
            Visible = false;
        }
        modify("Transfer Orders")
        {
            Visible = false;
        }
        modify("Work Centers")
        {
            Visible = false;
        }
        modify("Machine Centers")
        {
            Visible = false;
        }
        modify("Inventory Put-aways")
        {
            Visible = false;
        }
        modify("Inventory Picks")
        {
            Visible = false;
        }

        modify(SubcontractingWorksheets)
        {
            Visible = false;
        }
        modify(Journals)
        {
            Visible = false;
        }
        modify(ConsumptionJournals)
        {
            Visible = false;
        }
        modify(OutputJournals)
        {
            Visible = false;
        }
        modify(CapacityJournals)
        {
            Visible = false;
        }
        modify(RecurringCapacityJournals)
        {
            Visible = false;
        }
        modify("Work Shifts")
        {
            Visible = false;
        }
        modify("Shop Calendars")
        {
            Visible = false;
        }
        modify("Work Center Groups")
        {
            Visible = false;
        }
        modify("Stop Codes")
        {
            Visible = false;
        }
        modify("Standard Tasks")
        {
            Visible = false;
        }

        modify("Output &Journal")
        {
            Visible = false;
        }
        modify("&Capacity Journal")
        {
            Visible = false;
        }

        modify("Change &Production Order Status")
        {
            Visible = false;
        }

        modify("Update &Unit Cost")
        {
            Visible = false;
        }

        modify("&Manufacturing Setup")
        {
            Visible = false;
        }

        modify("Item &Tracing")
        {
            Visible = false;
        }
        modify("Navi&gate")
        {
            Visible = false;
        }
        addafter(Administration)
        {
            //Win513++
            group(Service)
            {
                //Win513--
                action(ServiceOrdersInProcess)
                {
                    ApplicationArea = Basic;
                    Caption = 'In Process';
                    RunObject = Page "Service Orders";
                    RunPageView = where(Status = filter("In Process"));
                }
                //Win513++
            }
            //Win513--
        }
        addafter("Purchase Orders")
        {
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
        }
        addfirst(creation)
        {
            action("Service &Order")
            {
                ApplicationArea = Basic;
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

