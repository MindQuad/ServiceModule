tableextension 50052 FixedAssetExtension extends "Fixed Asset"
{
    fields
    {
        field(50000; "Mapped against Service Item"; Code[20])
        {
            Caption = 'Mapped against Service Item';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }
        field(50001; "Select for Mapping"; Boolean)
        {
            Caption = 'Select for Mapping';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}