table 50000 "Check List"
{
    // //WIN325050617 - Created

    //DrillDownPageID = 50002;//WIN292
    //LookupPageID = 50002;//WIN292

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(5; Description; Text[50])
        {
        }
        field(10; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*  gCheckListStatus.RESET;
         gCheckListStatus.SETRANGE("Checklist Code", Code);
         IF gCheckListStatus.FINDFIRST THEN
             ERROR(Text001); *///WIN292
    end;

    var
        //gCheckListStatus: Record "50001";
        Text001: Label 'You cannot delete checklist.it alread exists in check list status';
}

