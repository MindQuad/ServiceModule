tableextension 50019 tableextension50019 extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(200; "Work Description"; Text[250])
        {
            Caption = 'Work Description';
            Description = '//WINS.20180730.PUR';
        }
        field(50016; Category; Option)
        {
            InitValue = General;
            OptionCaption = ',General,Service';
            OptionMembers = ,General,Service;
        }
        field(50017; Details; Text[250])
        {
        }
        field(50018; "Start Date"; Date)
        {
        }
        field(50019; "End Date"; Date)
        {
        }
        field(50020; "Order Type"; Option)
        {
            OptionMembers = ,Regular,AMC;
        }
    }
}

