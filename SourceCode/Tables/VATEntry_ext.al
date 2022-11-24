tableextension 50331 "VAT Entry Ext" extends "VAT Entry"
{
    fields
    {
        field(5000; "BAS Adjustment"; Boolean)
        {
            Caption = 'BAS Adjustment';
        }
        field(5001; "BAS Doc. No."; code[11])
        {
            Caption = 'BAS Doc. No.';

            TableRelation = "BAS Calculation Sheet".A1;
        }
        field(50002; "BAS Version"; Integer)
        {
            Caption = 'BAS Version';
            TableRelation = "BAS Calculation Sheet"."BAS Version" WHERE(A1 = FIELD("BAS Doc. No."));
        }
    }

    var
        myInt: Integer;
}