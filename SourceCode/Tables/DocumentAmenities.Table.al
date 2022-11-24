table 50007 "Document Amenities"
{
    /* DrillDownPageID = 50019;
    LookupPageID = 50019; */

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = ' ,Job,Service Item';
            OptionMembers = " ",Job,"Service Item";
        }
        field(5; "No."; Code[20])
        {
        }
        field(10; "Amenities Code"; Code[20])
        {
            TableRelation = Amenities;

            trigger OnValidate()
            begin
                /* IF Amenity.GET("Amenities Code") THEN
                    Descripition := Amenity.Description; *///WIN292
            end;
        }
        field(20; Descripition; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Amenities Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
    //Amenity: Record "50006";//WIN292
}

