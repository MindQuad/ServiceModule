tableextension 50038 tableextension50038 extends "Purchase Header Archive"
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
            OptionCaption = ',General,Service';
            OptionMembers = ,General,Service;
        }
        field(50017; Details; Text[250])
        {
        }
    }
}

