table 50123 "Payroll Calendar Line"
{
    Caption = 'Payroll Calendar Line';

    fields
    {
        field(1; "Calendar Code"; Code[10])
        {
            Caption = 'Calendar Code';
            Editable = false;
            NotBlank = true;
            TableRelation = "Payroll Calendar";
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
            NotBlank = true;


        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Nonworking; Boolean)
        {
            Caption = 'Nonworking';

            trigger OnValidate()
            begin
                IF Nonworking THEN BEGIN
                    "Starting Time" := 0T;
                    "Work Hours" := 0;
                END;
            end;
        }
        field(5; "Starting Time"; Time)
        {
            BlankNumbers = BlankZero;
            Caption = 'Starting Time';
        }
        field(6; "Work Hours"; Decimal)
        {
            BlankZero = true;
            Caption = 'Work Hours';
            MaxValue = 24;
            MinValue = 0;
        }
        field(7; "Week Day"; Option)
        {
            Caption = 'Week Day';
            Editable = false;
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(8; "Night Hours"; Decimal)
        {
            Caption = 'Night Hours';


        }
        field(10; "Day Status"; Option)
        {
            Caption = 'Day Status';
            OptionCaption = ' ,Weekend,Holiday';
            OptionMembers = " ",Weekend,Holiday;
        }
        field(11; "Time Activity Code"; Code[10])
        {
            Caption = 'Time Activity Code';
            TableRelation = "Time Activity";
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
    }

    keys
    {
        key(Key1; "Calendar Code", Date)
        {
            Clustered = true;
        }
        key(Key2; "Calendar Code", Nonworking, "Day Status", Date)
        {
            SumIndexFields = "Work Hours", "Night Hours";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

    end;

    trigger OnModify()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnRename()
    begin
        ERROR('');
    end;

    var







}

