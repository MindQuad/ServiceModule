tableextension 50012 tableextension50012 extends "G/L Register"
{
    fields
    {
        field(50000; "Posting Date"; Date)
        {
            CalcFormula = Lookup("G/L Entry"."Posting Date" WHERE("Entry No." = FIELD("From Entry No.")));
            FieldClass = FlowField;
        }
    }
}

