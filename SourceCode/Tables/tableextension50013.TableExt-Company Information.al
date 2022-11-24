tableextension 50013 tableextension50013 extends "Company Information"
{
    fields
    {
        field(50000; "Finance Manager"; Boolean)
        {
        }
        field(50001; "Leasing Module"; Boolean)
        {
        }

        field(60000; "Address (Arabic)"; Text[100])
        {
            Caption = 'Arabic Address';
        }
        field(60001; "Address 2 (Arabic)"; Text[50])
        {
            Caption = 'Arabic Address 2';
        }
        field(60002; "City (Arabic)"; Text[50])
        {
            Caption = 'City';
        }
    }
}

