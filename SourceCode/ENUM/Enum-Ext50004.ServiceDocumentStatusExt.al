enumextension 50004 "Service Document Status Ext" extends "Service Document Status"
{
    //Win513++
    // value(50000; "On Hold,Completed / SR Pending")
    // {
    //     Caption = 'On Hold,Completed / SR Pending';
    // }
    value(50000; "Completed / SR Pending")
    {
        Caption = 'Completed / SR Pending';
    }
    //Win513--
    value(50001; Closed)
    {
        Caption = 'Closed';
    }
    value(50002; Open)
    {
        Caption = 'Open';
    }
    value(50003; New)
    {
        Caption = 'New';
    }
}