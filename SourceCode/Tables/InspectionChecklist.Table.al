table 50008 "Inspection Checklist"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Area"; Text[100])
        {
        }
        field(4; Parameter; Text[100])
        {
        }
        field(5; Template; Boolean)
        {
        }
        field(6; Value; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", Template, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

