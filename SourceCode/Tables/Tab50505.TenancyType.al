table 50505 "Tenancy Type"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tenancy Type"; Option)
        {
            Caption = 'Tenancy Type';
            OptionMembers = " ",Residential,Commercial;
            OptionCaption = ' ,Residential,Commercial';
        }
        field(2; "GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'GL Account';
            TableRelation = "G/L Account";
        }
        field(3; "Bal GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bal GL Account';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Tenancy Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}