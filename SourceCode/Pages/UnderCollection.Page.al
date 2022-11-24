page 50074 "Under Collection"
{
    PageType = Card;
    SourceTable = "Interaction";

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field("PDC No."; Rec."PDC No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
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

