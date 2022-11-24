tableextension 50001 tableextension50001 extends "Payment Terms"
{
    fields
    {
        //Win513++
        // field(32; "Invoice Period"; Option)
        field(32; "Invoice Period"; Enum "Service Contract Header Invoice Period")
        //Win513--
        {
            Caption = 'Invoice Period';
            //Win513++
            // OptionCaption = 'Month,Two Months,Quarter,Half Year,Year,None';
            // OptionMembers = Month,"Two Months",Quarter,"Half Year",Year,"None";
            //Win513--
        }
        field(50000; "Defferal Code"; Code[10])
        {
            Caption = 'Defferal Code';
            TableRelation = "Deferral Template"."Deferral Code" WHERE("Invoice Period" = FIELD("Invoice Period"));
        }
        field(50001; "No. of PDC"; Integer)
        {
            Caption = 'No. of PDC';
        }
    }
}

