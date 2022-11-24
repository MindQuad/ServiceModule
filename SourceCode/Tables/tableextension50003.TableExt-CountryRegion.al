tableextension 50003 tableextension50003 extends "Country/Region"
{
    fields
    {
        field(50000; "STD Code"; Code[10])
        {
        }
        field(60000; "Gratuity for 5 Years"; Decimal)
        {
            Description = 'HR 10.0';
        }
        field(60001; "Gratuity for >5 Years"; Decimal)
        {
            Description = 'HR 10.0';
        }
        field(60002; "Pension Applicable"; Boolean)
        {
            Description = 'HR 10.0';
        }
    }
    keys
    {
        key(Key1; "STD Code")
        {
        }
    }

    //Unsupported feature: Property Modification (Fields) on "Brick(FieldGroup 1)".

}

