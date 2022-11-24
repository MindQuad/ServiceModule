table 50114 "Person Name History"
{
    Caption = 'Person Name History';

    fields
    {
        field(1; "Person No."; Code[20])
        {
            Caption = 'Person No.';
            NotBlank = true;
            TableRelation = Person;
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(3; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(4; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(5; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(10; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(11; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(12; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit 418;
            begin
                // UserMgt.LookupUserID("User ID");
            end;
        }
        field(21; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
    }

    keys
    {
        key(Key1; "Person No.", "Start Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetFullName(): Text[100]
    begin
        EXIT("Last Name" + ' ' + "First Name" + ' ' + "Middle Name");
    end;


    procedure GetNameInitials() NameInitials: Text[100]
    begin
        NameInitials := "Last Name";

        IF "First Name" <> '' THEN
            NameInitials := NameInitials + ' ' + COPYSTR("First Name", 1, 1) + '.';

        IF "Middle Name" <> '' THEN
            NameInitials := NameInitials + COPYSTR("Middle Name", 1, 1) + '.';
    end;
}

