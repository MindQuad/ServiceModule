PageExtension 50255 pageextension50255 extends "Shop Supervisor Activities"
{

    //Unsupported feature: Property Modification (Name) on ""Shop Supervisor Activities"(Page 9041)".


    //Unsupported feature: Property Modification (SourceTable) on ""Shop Supervisor Activities"(Page 9041)".

    layout
    {
        modify(Operations)
        {
            Caption = 'Outbound Service Orders';

            //Unsupported feature: Property Modification (Name) on "Operations(Control 9)".

        }
        modify("Production Orders")
        {
            Visible = false;
        }
        modify("Planned Prod. Orders - All")
        {
            Visible = false;
        }
        modify("Firm Plan. Prod. Orders - All")
        {
            Visible = false;
        }
        modify("Released Prod. Orders - All")
        {
            Visible = false;
        }
        modify("Prod. Orders Routings-in Queue")
        {
            Visible = false;
        }
        modify("Prod. Orders Routings-in Prog.")
        {
            Visible = false;
        }
        modify("Warehouse Documents")
        {
            Visible = false;
        }
        modify("Invt. Picks to Production")
        {
            Visible = false;
        }
        modify("Invt. Put-aways from Prod.")
        {
            Visible = false;
        }

    }
    trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    IF NOT GET THEN BEGIN
      INIT;
      INSERT;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    begin

        //#1..5

        //SetRespCenterFilter;
        Rec.SETRANGE("Date Filter", WORKDATE, WORKDATE);

    end;



}







