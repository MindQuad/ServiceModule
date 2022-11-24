page 50101 "Utility Master List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Utility Master";
    Caption = 'Utility Master';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field("Utility Description"; Rec."Utility Description")
                {
                    ToolTip = 'Specifies the value of the Utility Description field.';
                    ApplicationArea = All;
                    Caption = 'Utility Description';
                }
                field("Related G/L Account"; Rec."Related G/L Account")
                {
                    ToolTip = 'Specifies the value of the Related G/L Account field.';
                    ApplicationArea = All;
                    Caption = 'Related G/L Account';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}