page 50004 "Deduction Plan List"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = List;
    SourceTable = 50002;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
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

