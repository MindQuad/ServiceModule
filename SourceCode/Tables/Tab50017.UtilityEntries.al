table 50103 "Utility Entries"
{
    DataClassification = ToBeClassified;
    Caption = 'Utility Entries';

    fields
    {
        field(1; "Utility Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Utility Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Utility Master".Code;
        }
        field(3; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Item"."No.";

            trigger OnValidate()
            var
                ServiceItem: Record "Service Item";
            begin
                ServiceItem.Get("Unit Code");
                "Customer No." := ServiceItem."Customer No.";
            end;
        }
        field(4; "Meter Reading"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Service Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Header"."No.";
        }
        field(8; "Posted Service Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Invoice Header"."No.";
        }
        field(9; "Error Message"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Utility Date", "Utility Code", "Unit Code")
        {
            Clustered = true;
        }

    }

    var
        myInt: Integer;

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