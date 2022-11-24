tableextension 50048 tableextension50048 extends "Service Cue"
{
    fields
    {
        field(23; Units; Integer)
        {
            CalcFormula = Count("Service Item");
            FieldClass = FlowField;
            TableRelation = "Service Item";
        }
        field(24; Buildings; Integer)
        {
            CalcFormula = Count(Building);
            FieldClass = FlowField;
            TableRelation = Building;
        }
        field(25; "Tickets Pending"; Integer)
        {
            CalcFormula = Count("Service Header" WHERE("Order Date" = FIELD("Date Filter"),
                                                        "Document Type" = CONST(Order),
                                                        Status = CONST(Pending)));
            FieldClass = FlowField;
        }
        field(26; "Service Contracts"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = CONST(Contract)));
            Caption = 'Contracts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Tickets Till Date"; Integer)
        {
            CalcFormula = Count("Service Header" WHERE("Order Date" = FIELD("Date Filter"),
                                                        "Document Type" = CONST(Order)));
            FieldClass = FlowField;
        }
        field(28; "Service Contracts Pending Appr"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Contract),
                                                                 "Responsibility Center" = FIELD("Responsibility Center Filter"),
                                                                 "Approval Status" = FILTER("Pending Approval")));
            Caption = 'Service Contracts Pending Appr';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Rental : Vacant"; Integer)
        {
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Vacant),
                                                      "Unit Purpose" = CONST("Rental Unit")));
            FieldClass = FlowField;
        }
        field(51; Occupied; Integer)
        {
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Occupied),
                                                      "Unit Purpose" = CONST("Rental Unit")));
            Caption = 'Rental : Occupied';
            FieldClass = FlowField;
        }
        field(52; "Pending Renewal"; Integer)
        {
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Pending),
                                                      "Unit Purpose" = CONST("Rental Unit")));
            Caption = 'Rental : Pending Renewal';
            FieldClass = FlowField;
        }
        field(50000; "Pending Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Pending)));
            FieldClass = FlowField;
        }
        field(50001; "Approved Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Approved)));
            FieldClass = FlowField;
        }
        field(50002; "Invoicing Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Invoicing)));
            FieldClass = FlowField;
        }
        field(50003; "Closed Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Closed)));
            FieldClass = FlowField;
        }
        field(50004; "Expiry Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50005; "Service Contracts Expire in1M"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Expiration Date" = FIELD("Expiry Date Filter")));
            FieldClass = FlowField;
        }
        field(50006; "Contr. Pending Renewal"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Document Status" = FILTER("Pending Renewal")));
            FieldClass = FlowField;
        }
        field(50007; "Service Item Woksheet"; Integer)
        {
            CalcFormula = Count("Service Line" WHERE("Document Type" = FILTER(Order)));
            FieldClass = FlowField;
        }
        field(50008; "Service Contract Quotes"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = CONST(Quote)));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

