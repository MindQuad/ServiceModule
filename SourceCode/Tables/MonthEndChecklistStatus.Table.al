table 50001 "MonthEnd Checklist Status"
{
    // //WIN325050617 - Created

    DrillDownPageID = 50003;
    LookupPageID = 50003;

    fields
    {
        field(1; "Closing Date"; Date)
        {
        }
        field(5; "Checklist Code"; Code[20])
        {
            TableRelation = "Check List";
        }
        field(10; Description; Text[50])
        {
        }
        field(15; Completed; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Month End Closed", FALSE);
                IF Completed THEN
                    "User ID" := USERID
                ELSE
                    "User ID" := '';
            end;
        }
        field(20; "Month End Closed"; Boolean)
        {
        }
        field(25; "User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(30; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code;
        }
    }

    keys
    {
        key(Key1; "Closing Date", "Checklist Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

