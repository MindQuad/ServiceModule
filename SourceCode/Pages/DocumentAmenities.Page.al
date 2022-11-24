page 50019 "Document Amenities"
{
    PageType = List;
    SourceTable = 50007;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Amenities Code"; Rec."Amenities Code")
                {
                    ApplicationArea = All;
                }
                field(Descripition; Rec.Descripition)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

