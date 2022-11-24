page 50005 "Deduction Plan Card"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    SourceTable = 50002;

    layout
    {
        area(content)
        {
            group(General)
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

