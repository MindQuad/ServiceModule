tableextension 50033 tableextension50033 extends "Notification Entry"
{
    fields
    {
        field(50000; "Document No."; Code[30])
        {
        }
        //Win513++
        //field(50001; Status; Option)
        field(50001; Status; Enum "Approval Status")
        //Win513--
        {
            //Win513++
            //OptionMembers = Created,Open,Canceled,Rejected,Approved;
            //Win513--
        }
    }
}

