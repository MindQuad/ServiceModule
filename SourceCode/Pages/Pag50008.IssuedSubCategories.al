page 50008 "Issued Sub-Categories"
{
    ApplicationArea = All;
    Caption = 'Sub-Categories';
    PageType = List;
    SourceTable = "Issued Sub-Category";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Main Category"; Rec."Main Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Main Category field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
