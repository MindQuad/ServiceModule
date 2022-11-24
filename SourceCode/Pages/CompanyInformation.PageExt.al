pageextension 50512 CompnayInformation_Ext extends "Company Information"
{
    layout
    {
        addafter(Address)
        {
            field("Address (Arabic)"; Rec."Address (Arabic)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Address 2")
        {
            field("Address 2 (Arabic)"; Rec."Address 2 (Arabic)")
            {
                ApplicationArea = All;
            }
        }
        addafter(City)
        {
            field("City (Arabic)"; Rec."City (Arabic)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Phone No.")
        {
            field("Phone No. 2"; Rec."Phone No. 2")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}