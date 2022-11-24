tableextension 50088 "Incoming Document Ext" extends "Incoming Document"
{
    fields
    {
        field(50004; "Expense document"; Boolean)
        {
            Caption = 'Expense document';

        }
        field(50005; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

        }
        field(50006; "HR Expense Document"; Boolean)
        {
            Caption = 'HR Expense Document';

        }
    }

    var
        myInt: Integer;
}