table 60001 "Contract TNC"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Contact Type"; Enum "Service Contract Type")
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "TNC Type"; Enum "TNC Type")
        {
            DataClassification = ToBeClassified;
        }
        field(4; "TNC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "TNC Master"."TNC Code";

        }
    }

    keys
    {
        key(Key1; "Contact Type", "Contract No.", "TNC Type", "TNC Code")
        {
            Clustered = true;
        }
    }
}