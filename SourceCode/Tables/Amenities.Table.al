table 50006 Amenities
{
    // DrillDownPageID = 50018;
    // LookupPageID = 50018;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(10; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

