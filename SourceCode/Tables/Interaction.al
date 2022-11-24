table 50016 Interaction
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Interaction Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Interaction Date';

        }
        field(2; "Interaction Type"; Option)
        {
            Caption = 'Interaction Type';
            OptionMembers = Phone,Email,Message;
            OptionCaption = 'Phone,Email,Message';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';

        }
        field(4; "PDC No."; Code[20])
        {
            Caption = 'PDC No.';

            trigger OnValidate()
            begin
                PDC.RESET;
                PDC.SETRANGE(PDC."Document No.", Rec."PDC No.");
                IF PDC.FINDFIRST THEN BEGIN
                    "Customer No." := PDC."Customer No.";
                    "Building No." := PDC."Building No.";
                    "Unit No." := PDC."Unit No.";
                    "Customer Name" := "Customer Name";
                    "Interaction Date" := 0D;
                    Description := '';
                END;
            end;
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(6; "Building No."; Code[30])
        {
            Caption = 'Building No.';
        }
        field(7; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
        }
        field(8; "Customer Name"; Text[30])
        {
            Caption = 'Customer Name';
        }
        field(9; "Interaction No."; Integer)
        {
            Caption = 'Interaction No.';
        }
        field(10; "Court Case No."; Code[20])
        {
            Caption = 'Court Case No.';
        }
    }

    keys
    {
        key(Key1; "Interaction No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

        PDC: Record "Post Dated Check Line";
        PDCNo: Code[20];

    procedure GetPDC(PDC1: Record "Post Dated Check Line")
    begin

        INIT;
        IF FINDLAST THEN
            "Interaction No." := "Interaction No." + 1
        ELSE
            "Interaction No." := 1;
        PDCNo := PDC1."Document No.";
        VALIDATE("PDC No.", PDCNo);
        INSERT;
    end;

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