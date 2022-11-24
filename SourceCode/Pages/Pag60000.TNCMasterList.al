page 60100 "TNC Master List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TNC Master";
    Caption = 'TNC Master List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field("TNC Type"; Rec."TNC Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TNC Type field.';
                }
                field("TNC Code"; Rec."TNC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TNC Code field.';
                }
                field("English Description "; Rec."English Description ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the English Description  field.';
                }
                field("Arabic Description"; Rec."Arabic Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Arabic Description field.';
                }
            }
        }

    }
}