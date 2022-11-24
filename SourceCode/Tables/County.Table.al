table 50101 County
{
    Caption = 'Emirate';
    //LookupPageID = 28003;

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, Description)
        {
        }
    }
}

