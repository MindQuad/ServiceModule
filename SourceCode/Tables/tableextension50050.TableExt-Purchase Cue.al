tableextension 50050 tableextension50050 extends "Purchase Cue"
{
    fields
    {
        field(23; "Service Item Woksheet"; Integer)
        {
            CalcFormula = Count("Service Line" WHERE("Document Type" = FILTER(Order)));
            FieldClass = FlowField;
        }
        field(24; "Released Purchase Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = FILTER(Order),
                                                         Status = FILTER(Released)));
            FieldClass = FlowField;
        }
    }
}

