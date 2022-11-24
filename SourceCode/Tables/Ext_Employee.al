tableextension 50111 "Employee Ext" extends Employee
{
    fields
    {
        field(50000; "Person No."; Code[20])
        {
            Caption = 'Person No.';
            TableRelation = Person;
        }
    }

    var
        myInt: Integer;
}