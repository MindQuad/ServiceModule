Table 50306 "WHT Revenue Types"
{
    Caption = 'WHT Revenue Types';
    // LookupPageID = UnknownPage28042;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Sequence; Integer)
        {
            Caption = 'Sequence';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Sequence)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

