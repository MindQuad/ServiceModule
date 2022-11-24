page 50020 "Inspection Template"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = 50008;
    SourceTableView = WHERE(Template = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
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

