page 50514 "Tenancy Type"
{
    //Win593++
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tenancy Type";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Tenancy Type"; Rec."Tenancy Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenancy Type field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field("Bal GL Account"; Rec."Bal GL Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal GL Account field.';
                }
            }
        }
    }
    //Win593--
}