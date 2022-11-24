table 50009 "Documents and Articles"
{
    Caption = 'Documents and Expiries';

    fields
    {
        field(1; "Issued To Type"; Option)
        {
            Caption = 'Issued To Type';
            OptionCaption = 'Contact,Customer,Vendor,Bank Account,Employee';
            OptionMembers = Contact,Customer,Vendor,"Bank Account",Employee;
        }
        field(2; "Confidential Code"; Code[10])
        {
            Caption = 'Confidential Code';
            NotBlank = true;
            TableRelation = Confidential.code;

            trigger OnValidate()
            begin
                IF Confidential.GET("Confidential Code") THEN BEGIN
                    Description := Confidential.Description;
                    //"Document Type" := Confidential."Personnel Type";
                END ELSE
                    ERROR(ErrEmployeeDocumentInvlaid);
            end;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
        }
        field(6; "Issued To"; Code[20])
        {
            Caption = 'Issued To';
            TableRelation = IF ("Issued To Type" = CONST(Customer)) Customer
            ELSE
            IF ("Issued To Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Issued To Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Issued To Type" = CONST(Contact)) Contact;
        }
        field(50000; "Document No"; Code[50])
        {
            Description = 'Added by Winspire HR & Payroll';

            trigger OnValidate()
            begin
                //win315++
                IF "Confidential Code" = 'EID' THEN BEGIN
                    IF STRLEN("Document No") <> 18 THEN
                        ERROR('Length should be 18 Characters for Emirates ID');
                END;
                //win315--
            end;
        }
        field(50001; "Document Name"; Text[50])
        {
            Description = 'Added by Winspire HR & Payroll';
        }
        field(50002; "Issue Date"; Date)
        {
            Description = 'Added by Winspire HR & Payroll';
        }
        field(50003; "Expiry Date"; Date)
        {
            Description = 'Added by Winspire HR & Payroll';
        }
        field(50004; Remarks; Text[50])
        {
            Description = 'Added by Winspire HR & Payroll';
        }
        field(50005; "Document Type"; Code[10])
        {
            Description = 'Added by Winspire HR & Payroll';
        }
        field(50006; Link; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Issued To Type", "Confidential Code", "Issued To", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Comment THEN
            ERROR(Text000);
    end;

    var
        Text000: Label 'You can not delete confidential information if there are comments associated with it.';
        Confidential: Record Confidential;//WIN292
        ErrEmployeeDocumentInvlaid: Label 'Invalid Document Type';
    //RecContact: Record "5050";//WIN292
    //DocArt: Record "50009";//WIN292
}

