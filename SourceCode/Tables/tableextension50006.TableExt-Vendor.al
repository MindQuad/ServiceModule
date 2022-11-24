tableextension 50006 tableextension50006 extends Vendor
{
    fields
    {
        field(12432; "Vendor Type"; Option)
        {
            Caption = 'Vendor Type';
            OptionCaption = 'Vendor,Resp. Employee,Tax Authority,Person';
            OptionMembers = Vendor,"Resp. Employee","Tax Authority",Person;
        }
        field(50011; "Foreign Vend"; Boolean)
        {
            Caption = 'Foreign Vend';
        }
    }

    //WIN513++
    //WIN 269  FIN/2.8/1/1.5 
    // trigger OnAfterInsert()
    // begin
    //     Blocked := Blocked::All;
    // end;

    trigger OnInsert()
    begin
        Blocked := Blocked::All;
    end;
    //WIN531--
}

