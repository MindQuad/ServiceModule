tableextension 50049 tableextension50049 extends "Finance Cue"
{
    fields
    {
        field(32; "PO Received Not Invoiced"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = FILTER(Order),
                                                         "Completely Received" = FILTER(true),
                                                         Invoice = FILTER(false)));
            FieldClass = FlowField;
        }
        field(34; "Service Item Woksheet"; Integer)
        {
            CalcFormula = Count("Service Line" WHERE("Document Type" = FILTER(Order)));
            FieldClass = FlowField;
        }
    }
}

