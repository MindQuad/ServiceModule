page 50502 "Share Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Share;
    Caption = 'Share Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
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
    }
}