PageExtension 50183 pageextension50183 extends "Reason Codes"
{
    layout
    {
        addafter(Description)
        {
            field("Mail to Customer"; Rec."Mail to Customer")
            {
                ApplicationArea = Basic;
            }
            field("Mail to Property Mgmt/Legal"; Rec."Mail to Property Mgmt/Legal")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

