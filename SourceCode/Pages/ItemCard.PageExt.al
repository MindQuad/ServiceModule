PageExtension 50154 pageextension50154 extends "Item Card"
{
    layout
    {

        //Unsupported feature: Property Modification (Visible) on ""Product Group Code"(Control 168)".


        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = Basic;
            }

        }
        addafter(GTIN)
        {

            // field("Manufacturer Code"; Rec."Manufacturer Code")
            // {
            //     ApplicationArea = Basic;
            // }

        }

    }


}

