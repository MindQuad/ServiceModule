#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
PageExtension 50003 pageextension50003 extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {
            field("STD Code"; Rec."STD Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

