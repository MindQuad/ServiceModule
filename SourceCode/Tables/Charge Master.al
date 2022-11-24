table 50012 "Charge Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Charge Code';
            NotBlank = true;

        }
        field(2; "Charge Description"; Text[50])
        {
            Caption = 'Charge Description';

        }
        field(3; "Bal. Account No."; Code[10])
        {
            Caption = 'Bal. Account No.';
            TableRelation = "G/L Account";
        }
        field(4; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(5; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(6; "Posting Allowed"; Boolean)
        {
            Caption = 'Posting Allowed';
        }
        field(7; "Allow-to Generate PDC Entry"; Boolean)
        {
            Caption = 'Allow-to Generate PDC Entry';

        }
    }

    keys
    {
        key(Key1; "Charge Code")
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