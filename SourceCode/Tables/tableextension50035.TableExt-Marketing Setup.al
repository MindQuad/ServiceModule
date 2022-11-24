tableextension 50035 tableextension50035 extends "Marketing Setup"
{
    fields
    {
        field(50000; "Broker Nos."; Code[10])
        {
            Caption = 'Broker Nos.';
            TableRelation = "No. Series";
        }
        field(50001; "Copy Contacts to Company"; Boolean)
        {
        }
        field(50002; "Email Sender To"; Text[250])
        {
        }
        field(50003; "Email Sender CC"; Text[250])
        {
        }
        field(50004; "Court Case No."; Code[10])
        {
            TableRelation = "No. Series";
        }
    }
}

