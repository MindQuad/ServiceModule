table 60000 "TNC Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "TNC Type"; Enum "TNC Type")
        {
            DataClassification = ToBeClassified;
        }
        field(2; "TNC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "English Description "; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Arabic Description"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "TNC Type", "TNC Code")
        {
            Clustered = true;
        }
    }


}