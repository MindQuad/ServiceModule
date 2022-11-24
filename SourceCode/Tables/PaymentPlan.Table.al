table 50003 "Payment Plan"
{
    DrillDownPageID = 50009;
    LookupPageID = 50009;

    fields
    {
        field(1; "Payment Plan Code"; Code[20])
        {
        }
        field(10; "Milestone Code"; Code[20])
        {
        }
        field(20; "Service Item No."; Code[20])
        {
            TableRelation = "Service Item" WHERE("Unit Purpose" = CONST("Saleable Unit"));
        }
        field(30; "Milestone Description"; Text[50])
        {
        }
        field(40; "Milestone %"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Revenue Interim Account");
                TESTFIELD("Milestone Amount", 0);
            end;
        }
        field(50; "Milestone Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Revenue Interim Account");
                TESTFIELD("Milestone %", 0);
            end;
        }
        field(60; "Invoice Due date Calculation"; DateFormula)
        {
        }
        field(70; "Revenue Interim Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(71; "Recognized Revenue Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Payment Plan Code", "Milestone Code", "Service Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

