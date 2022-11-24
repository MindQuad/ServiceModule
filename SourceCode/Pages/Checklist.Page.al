page 50002 "Check list"
{
    // //WIN325050617 - Created

    PageType = List;
    SourceTable = 50000;

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
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Generate)
            {
                action(GenerateMonthEndChecklist)
                {
                    ApplicationArea = All;
                    Caption = 'Generate Monthend Checklist';
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 50000;
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }
}

