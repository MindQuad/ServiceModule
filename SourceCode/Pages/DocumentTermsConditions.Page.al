page 50013 "Document Terms & Conditions"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = 50004;
    SourceTableView = SORTING("Transaction Type", "Document Type", "Document No.", "Document Line No.", "Line No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Conditions; Rec.Conditions)
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

