page 50100 "Source Lead"
{
    PageType = List;
    SourceTable = 50015;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Lead"; Rec."Source Lead")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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

