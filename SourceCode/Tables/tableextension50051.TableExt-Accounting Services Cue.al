tableextension 50051 tableextension50051 extends "Accounting Services Cue"
{
    fields
    {
        field(21; "PO Received Not Invoiced"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = FILTER(Order),
                                                         "Completely Received" = FILTER(true),
                                                         Invoice = FILTER(false)));
            FieldClass = FlowField;
        }
        field(22; "Service Item Woksheet"; Integer)
        {
            CalcFormula = Count("Service Line" WHERE("Document Type" = FILTER(Order)));
            FieldClass = FlowField;
        }
    }
}

