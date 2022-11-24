tableextension 50047 tableextension50047 extends "Service Invoice Header"
{
    fields
    {
        field(200; "Work Description"; Text[250])
        {
        }
        field(50000; "Defferal Code"; Code[10])
        {
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(50001; "First Partial Invoice"; Boolean)
        {
        }
        field(50002; "Type of Ticket"; Option)
        {
            OptionCaption = 'Normal,Check In,Check Out,Recovery';
            OptionMembers = Normal,"Check In","Check Out",Recovery;
        }
        field(50004; "Building No."; Code[20])
        {
            TableRelation = Building;
        }
        field(50005; "Unit No."; Code[20])
        {
        }
        field(50006; "Service Item No."; Code[20])
        {
            TableRelation = "Service Item" WHERE("Unit Purpose" = FILTER("Rental Unit" | "Common Use"),
                                                  "Customer No." = FILTER(<> ''));
        }
        field(50007; "Service Report No."; Code[20])
        {
            Caption = 'Service Report No.';
        }
        field(50008; "External Document No."; Text[50])
        {
        }
        field(50009; "Reference No."; Text[50])
        {
        }
        field(50010; "Created By"; Code[50])
        {
        }
        field(50011; "Creation date"; Date)
        {
        }
        field(50012; "Building Name"; Text[50])
        {
            CalcFormula = Lookup(Building.Description WHERE(Code = FIELD("Building No.")));
            FieldClass = FlowField;
        }
        field(50013; "Completion Date"; Date)
        {
        }
        field(50014; "Resource Allocation Date"; Date)
        {
        }
        field(50015; "Resource Allocation Time"; Time)
        {
        }
        field(50016; "Invoice Creation Date"; Date)
        {
        }
        field(50017; "Invoice Creation Time"; Time)
        {
        }
        field(50018; "No. of Credit Memo Posted"; Boolean)
        {
        }
    }
}

