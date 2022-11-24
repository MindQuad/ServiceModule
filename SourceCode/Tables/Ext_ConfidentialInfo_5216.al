tableextension 50120 "Confidential Info Ext" extends "Confidential Information"
{
    fields
    {
        field(50000; "Document No"; Code[50])
        {
            Caption = 'Document No';
        }
        field(50001; "Document Name"; Text[50])
        {
            Caption = 'Document Name';
        }
        field(50002; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
        }
        field(50003; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
        }
        field(50004; Remarks; Text[50])
        {
            Caption = 'Remarks';
        }
        field(50005; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ",Passport,VISA,"Driving Licence",OHC,Insurance,"Air Passage","Birth Day","Wedding Anniversary","Service Year",Others;
            OptionCaption = ' ,Passport,VISA,"Driving Licence",OHC,Insurance,"Air Passage","Birth Day","Wedding Anniversary","Service Year",Others';
        }
        field(50006; Link; Text[250])
        {
            Caption = 'Link';
        }
        field(50007; Expired; Boolean)
        {
            Caption = 'Expired';

        }
        field(50008; "No. of Days"; Integer)
        {
            Caption = 'No. of Days';
        }
        field(50009; "Actual Date"; Date)
        {
            Caption = 'Actual Date';
        }




    }

    var
        myInt: Integer;
}