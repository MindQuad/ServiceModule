table 50099 "Expense Claim Codes"
{
    //DrillDownPageID = 33020953;
    //LookupPageID = 33020953;

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "G/L Account"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true),
                                                     "Income/Balance" = CONST("Income Statement"));
        }
        field(91; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(99; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(100; "Claim Type"; Option)
        {
            OptionMembers = Normal,HR,Both;

            trigger OnValidate()
            begin
                VALIDATE("Default Renewal Frequency");
            end;
        }
        field(101; "Default Renewal Frequency"; DateFormula)
        {

            trigger OnValidate()
            begin
                IF "Claim Type" = "Claim Type"::Normal THEN
                    ERROR('Only applicable to HR expense codes');
            end;
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
}

