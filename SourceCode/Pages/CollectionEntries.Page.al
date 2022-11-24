page 50076 "Collection Entries"
{
    PageType = List;
    SourceTable = Interaction;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PDC No."; Rec."PDC No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Interaction Date"; Rec."Interaction Date")
                {
                    ApplicationArea = All;
                }
                field("Interaction Type"; Rec."Interaction Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

