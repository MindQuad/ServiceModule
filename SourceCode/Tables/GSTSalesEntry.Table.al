Table 50311 "GST Sales Entry"
{
    Caption = 'GST Sales Entry';
    //LookupPageID = UnknownPage28165;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "GST Entry No."; Integer)
        {
            Caption = 'GST Entry No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(7; "Document Line Type"; Option)
        {
            Caption = 'Document Line Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(8; "Document Line Code"; Text[30])
        {
            Caption = 'Document Line Code';
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(10; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(11; "Document Line Description"; Text[50])
        {
            Caption = 'Document Line Description';
        }
        field(12; "GST Entry Type"; Option)
        {
            Caption = 'GST Entry Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;

            trigger OnValidate()
            begin
                if "GST Entry Type" = "gst entry type"::Settlement then
                    Error(Text000, FieldCaption("GST Entry Type"), "GST Entry Type");
            end;
        }
        field(13; "GST Base"; Decimal)
        {
            Caption = 'GST Base';
        }
        field(14; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        //Win513++
        //field(15; "VAT Calculation Type"; Option)
        field(15; "VAT Calculation Type"; Enum "Tax Calculation Type")
        //Win513--
        {
            Caption = 'VAT Calculation Type';
            //Win513++
            // OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            // OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
            //Win513--
        }
        field(16; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(17; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Posting Date")
        {
        }
        key(Key3; "GST Entry No.", "Document No.", "Document Type", "VAT Prod. Posting Group")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: label 'You cannot change the contents of this field when %1 is %2.';
}

