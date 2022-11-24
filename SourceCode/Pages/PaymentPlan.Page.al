page 50009 "Payment Plan"
{
    PageType = List;
    SourceTable = 50003;
    SourceTableView = WHERE("Service Item No." = CONST(''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Plan Code"; Rec."Payment Plan Code")
                {
                    ApplicationArea = All;
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                    ApplicationArea = All;
                }
                field("Milestone Description"; Rec."Milestone Description")
                {
                    ApplicationArea = All;
                }
                field("Revenue Interim Account"; Rec."Revenue Interim Account")
                {
                    ApplicationArea = All;
                }
                field("Milestone %"; Rec."Milestone %")
                {
                    ApplicationArea = All;
                }
                field("Invoice Due date Calculation"; Rec."Invoice Due date Calculation")
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

