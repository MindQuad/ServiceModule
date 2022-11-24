page 50503 "Share List"
{
    Caption = 'Shares';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Share;
    CardPageId = "Share Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("No. of Shares"; Rec."No. of Shares")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Value of Shares"; Rec."Value of Shares")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}