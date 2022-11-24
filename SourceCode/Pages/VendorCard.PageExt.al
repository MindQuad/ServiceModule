PageExtension 50152 pageextension50152 extends "Vendor Card"
{
    layout
    {

        //Unsupported feature: Property Deletion (Visible) on ""No."(Control 2)".

        addafter("Creditor No.")
        {
            field("Vendor Type"; Rec."Vendor Type")
            {
                ApplicationArea = Basic;
            }
            field("Foreign Vend"; Rec."Foreign Vend")
            {
                ApplicationArea = All;
            }
        }
        //WIN 269 FIN/2.9/1.5
        modify(Blocked)
        {
            Editable = AllowBlocked;
        }
        //WIN 269 END
    }
    actions
    {

        //Unsupported feature: Property Insertion (PromotedOnly) on "ContactBtn(Action 14)".

    }
    //WIN 269 FIN/2.9/1.5
    trigger OnOpenPage()
    begin
        AllowBlocked := false;
    end;

    trigger OnAfterGetRecord()
    begin
        IF UserSetup.Get(UserId) then begin
            IF UserSetup."Admin User" = true then
                AllowBlocked := true;
        end;
    end;

    var
        UserSetup: Record "User Setup";
        AllowBlocked: Boolean;

    //WIN 269 END
}

