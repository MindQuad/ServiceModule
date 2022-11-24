page 50003 "Monthend Checklist Status"
{
    // //WIN325050617 - Created

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = 50001;
    SourceTableView = WHERE("Month End Closed" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Checklist Code"; Rec."Checklist Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                }
                field("Month End Closed"; Rec."Month End Closed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Others)
            {
            }
        }
    }
}

