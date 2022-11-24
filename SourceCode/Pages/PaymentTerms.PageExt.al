#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
PageExtension 50002 pageextension50002 extends "Payment Terms"
{
    layout
    {
        addafter(Description)
        {
            field("Invoice Period"; Rec."Invoice Period")
            {
                ApplicationArea = Basic;
            }
            field("Defferal Code"; Rec."Defferal Code")
            {
                ApplicationArea = Basic;
            }
            field("No. of PDC"; Rec."No. of PDC")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

