table 50018 "Issued Category"
{
    Caption = 'Category';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Issued Categories";
    LookupPageId = "Issued Categories";


    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

        }
        field(2; Description; Text[50])
        {
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
