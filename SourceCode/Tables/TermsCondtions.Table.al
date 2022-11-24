table 50004 "Terms & Condtions"
{

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            OptionCaption = 'Sales,Purchase,Service';
            OptionMembers = Sales,Purchase,Service;
        }
        field(10; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Contract';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Contract;
        }
        field(20; "Document No."; Code[20])
        {
        }
        field(30; "Document Line No."; Integer)
        {
        }
        field(40; "Line No."; Integer)
        {
        }
        field(45; "No."; Code[20])
        {
        }
        field(50; Conditions; Text[250])
        {
        }
        field(55; Select; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "No.")
        {
            Clustered = false;
        }
    }

    fieldgroups
    {
    }
}

