tableextension 50330 "Det. CV Ledger Entry Buf Ext" extends "Detailed CV Ledg. Entry Buffer"
{
    fields
    {
        field(50000; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
    }

    var
        myInt: Integer;
}