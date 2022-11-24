page 50012 "Default Terms & Conditions"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = 50004;
    SourceTableView = SORTING("Transaction Type", "Document Type", "Document No.", "Document Line No.", "Line No.")
                      WHERE("Document No." = FILTER(''),
                            "Document Line No." = FILTER(0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
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

