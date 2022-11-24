PageExtension 50157 pageextension50157 extends "General Journal"
{
    layout
    {
        addfirst(Control1)
        {
            field("Line No."; rec."Line No.")
            {
                ApplicationArea = Basic;
            }
        }


        moveafter(Amount; "Amount (LCY)")

        addafter("Credit Amount")
        {
            field("Employee No."; rec."Employee No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Applied Automatically")
        {
            field(Narration; rec.Narration)
            {
                ApplicationArea = Basic;
            }
            field("Check No"; rec."Check No")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Applied)
        {
            field("Check Date"; rec."Check Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field("Source Code"; rec."Source Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

