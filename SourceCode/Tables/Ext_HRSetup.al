tableextension 50119 "HR Setup Ext" extends "Human Resources Setup"
{
    fields
    {

        Field(50000; "Position Nos."; Code[20])
        {
            Caption = 'Position Nos.';
            TableRelation = "No. Series";
        }

        field(50001; "Person Nos."; Code[20])
        {
            Caption = 'Person Nos.';
            TableRelation = "No. Series";
        }
    }

    var
        myInt: Integer;
}