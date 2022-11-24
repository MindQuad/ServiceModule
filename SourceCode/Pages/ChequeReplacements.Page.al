page 50089 "Cheque Replacements"
{
    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = 50017;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PDC Document No"; Rec."PDC Document No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Old Cheque Ref."; Rec."Old Cheque Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Old Cheque Amount"; Rec."Old Cheque Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                }
                field("New Cheque No."; Rec."New Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("New Cheque Date"; Rec."New Cheque Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

