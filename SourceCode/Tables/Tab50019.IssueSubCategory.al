table 50019 "Issued Sub-Category"
{
    Caption = 'Sub-Category';
    DataClassification = ToBeClassified;
    LookupPageId = "Issued Sub-Categories";
    DrillDownPageId = "Issued Sub-Categories";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

        }
        field(2; "Main Category"; Code[20])
        {

        }
        field(3; Description; Text[50])
        {
        }
    }
    keys
    {
        key(PK; "Code", "Main Category")
        {
            Clustered = true;
        }
    }
}
