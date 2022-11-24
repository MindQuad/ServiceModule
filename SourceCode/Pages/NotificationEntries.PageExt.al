PageExtension 50289 pageextension50289 extends "Notification Entries"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Notification Entries"(Page 1511)".

    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""FORMAT(""Triggered By Record"")"(Control 10)".

        addafter("Created Date-Time")
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Created By")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
            }
        }
    }

    var
        RecUserSet: Record "User Setup";


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*
    IF RecUserSet.GET(USERID) THEN BEGIN

    SETFILTER("Recipient User ID",'%1',RecUserSet."User ID");
    END;
    */
    //end;
}

