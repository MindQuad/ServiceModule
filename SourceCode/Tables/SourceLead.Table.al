table 50015 "Source Lead"
{
    DrillDownPageID = 50100;
    LookupPageID = 50100;

    fields
    {
        field(1; "Source Lead"; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Source Lead")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

