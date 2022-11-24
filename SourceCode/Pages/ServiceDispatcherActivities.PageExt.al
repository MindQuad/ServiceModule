PageExtension 50311 pageextension50311 extends "Service Dispatcher Activities"
{
    layout
    {
        modify("Service Quotes")
        {
            Caption = 'Contracts';

            //Unsupported feature: Property Modification (Name) on ""Service Quotes"(Control 18)".

        }
        modify("Service Orders")
        {
            Visible = false;
        }
        modify("Service Orders - in Process")
        {
            Visible = false;
        }
        modify("Service Orders - Finished")
        {
            Visible = false;
        }
        modify("Service Orders - Inactive")
        {
            Visible = false;
        }
        modify("Open Service Quotes")
        {
            Visible = false;
        }

        addfirst("Service Quotes")
        {
            field("Service Contract"; Rec."Service Contracts")
            {
                ApplicationArea = Basic;
                DrillDownPageID = "Service Contract List";
                LookupPageID = "Service Contract List";
            }
            field("Contr. Pending Renewal"; Rec."Contr. Pending Renewal")
            {
                ApplicationArea = Basic;
                Caption = 'Contracts :  Pending Renewal';
            }
        }
        addafter("Service Contracts to Expire")
        {
            field("Service Contracts Pending App"; Rec."Service Contracts Pending Appr")
            {
                ApplicationArea = Basic;
                Caption = 'Contracts : Pending Approval';
                Visible = false;
            }
            field("Service Item Woksheet"; Rec."Service Item Woksheet")
            {
                ApplicationArea = Basic;
            }
            cuegroup("Properties, Units & Rental")
            {
                Caption = 'Properties, Units & Rental';
                field(Buildings; Rec.Buildings)
                {
                    ApplicationArea = Basic;
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = Basic;
                }
                field("Rental : Vacant"; Rec."Rental : Vacant")
                {
                    ApplicationArea = Basic;
                }
                field(Occupied; Rec.Occupied)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (Name) on ""Service Quotes"(Control 18).Action17(Action 17)".

    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    IF NOT GET THEN BEGIN
      INIT;
      INSERT;
    END;

    SetRespCenterFilter;
    SETRANGE("Date Filter",0D,WORKDATE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    SETFILTER("Expiry Date Filter",'%1..%2',WORKDATE,CALCDATE('<1M>',WORKDATE));
    */
    //end;
}

