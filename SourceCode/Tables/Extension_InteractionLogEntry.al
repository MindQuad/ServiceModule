tableextension 50089 "InteractionLogEntry Ext" extends "Interaction Log Entry"
{
    fields
    {
        field(50000; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
        }
        field(50001; "Building Code"; Code[20])
        {
            Caption = 'Building Code';
            TableRelation = Building;
        }
        field(50002; "Building Name"; Text[50])
        {
            Caption = 'Building Name';
            Editable = false;
        }
        field(50003; "Service Order Type"; Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }
        field(50004; Priority; Option)
        {
            Caption = 'Priority';
            OptionMembers = High,Medium,Low;
            OptionCaption = 'High,Medium,Low';
        }
        field(50005; Resource; Code[10])
        {
            Caption = 'Resource';
            TableRelation = Resource;
        }
        field(50006; "Unit Description"; Text[50])
        {
            Caption = 'Unit Description';

        }
        field(50007; "Rent Amount"; Decimal)
        {
            Caption = 'Rent Amount';
        }
        field(50008; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(50009; "Discussion Date"; Date)
        {
            Caption = 'Discussion Date';
        }
        field(50010; "Rent Amt"; Text[50])
        {
            Caption = 'Rent Amt';
        }
        field(50011; "Service Contract No."; Code[20])
        {
            Caption = 'Service Contract No.';
            TableRelation = "Service Contract Header"."Contract No.";
        }
        field(50012; "Court Case No."; Code[20])
        {
            Caption = 'Court Case No.';
            TableRelation = "Court Case Insertion"."Case No.";
        }

    }

    var
        myInt: Integer;


    Procedure GetBuilding(BuildingNo: Code[20])
    var
        Building: Record Building;
    begin

        IF BuildingNo <> Building.Code THEN BEGIN
            Building.GET(BuildingNo);
        END ELSE
            CLEAR(Building);
    end;
}