tableextension 50091 "Segment Line Ext" extends "Segment Line"
{
    fields
    {
        field(50000; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Service Item"."No." WHERE("Building No." = FIELD("Building Code"));

            trigger OnValidate()
            var

                ServiceItem: Record "Service Item";
            begin
                ServiceItem.RESET;
                ServiceItem.SETRANGE("No.", "Unit No.");
                IF ServiceItem.FINDFIRST THEN begin
                    "Unit Description" := ServiceItem.Description;
                    "Occupancy Status" := ServiceItem."Occupancy Status";
                end;
            end;
        }
        field(50001; "Building Code"; Code[20])
        {
            Caption = 'Building Code';
            TableRelation = Building;

            trigger OnValidate()
            begin
                GetBuilding("Building Code");
                "Building Name" := Building.Description;
            end;
        }
        field(50002; "Building Name"; Text[50])
        {
            Caption = 'Building Name';
            Editable = false;
        }
        field(50003; "Unit Description"; Text[50])
        {
            Caption = 'Unit Description';

        }
        field(50004; "Rent Amount"; Decimal)
        {
            Caption = 'Rent Amount';

        }
        field(50005; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(50006; "Discussion Date"; Date)
        {
            Caption = 'Discussion Date';
        }
        field(50007; "Rent Amt"; Text[50])
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
        field(50013; "Occupancy Status"; Option)
        {
            Caption = 'Occupancy Status';
            OptionMembers = " ",Vacant,Occupied,Pending;
            OptionCaption = ' ,Vacant,Occupied,Pending';
        }

    }

    var
        myInt: Integer;
        Building: Record Building;

    procedure GetBuilding(BuildingNo: Code[20])
    begin

        IF BuildingNo <> Building.Code THEN BEGIN
            Building.GET(BuildingNo);
        END ELSE
            CLEAR(Building);
    end;

    Procedure CreateInteractionFromCourCases(VAR CourtCase: Record "Court Case Insertion")
    var

        Customer: Record Customer;
    begin
        DELETEALL;
        CourtCase.TESTFIELD("Tenant No.");
        IF Customer.GET(CourtCase."Tenant No.") THEN;
        INIT;
        VALIDATE("Contact No.", Customer."Primary Contact No.");
        VALIDATE("Court Case No.", CourtCase."Case No.");
        SETRANGE("Court Case No.", CourtCase."Case No.");
        StartWizard;
    end;
}