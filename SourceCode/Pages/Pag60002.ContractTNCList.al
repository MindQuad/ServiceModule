page 60102 "Contract TNC List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Contract TNC";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Editable = false;
                field("Contact Type"; Rec."Contact Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Type field.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract No. field.';
                }
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
            }
        }
    }
}