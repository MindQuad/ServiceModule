table 50002 "Deduction Plan"
{
    /* DrillDownPageID = 50004;
    LookupPageID = 50004; *///WIN292

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(10; Description; Text[50])
        {
        }
        field(20; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(30; Percentage; Decimal)
        {
        }
        field(40; Amount; Decimal)
        {
        }
        field(41; Type; Option)
        {
            OptionCaption = 'Expense,Advance,Retention,Other';
            OptionMembers = Expense,Advance,Retention,Other;
        }
    }

    keys
    {
        key(Key1; "Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

