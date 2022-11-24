tableextension 50030 tableextension50030 extends "Job Task"
{
    fields
    {
        field(50000; "SubContractor No."; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50003; "Deduction Plan Code"; Code[20])
        {
            TableRelation = "Deduction Plan".Code;
        }
        field(50004; "Contractor Posted Gross Bill"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                           "Job Task No." = FIELD("Job Task No."),
                                                                           "Job Task No." = FIELD(FILTER(Totaling)),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "Posting Date" = FIELD("Posting Date Filter"),
                                                                           Type = CONST("G/L Account"),
                                                                           "No." = FIELD(FILTER("Gross Bill Filter"))));
            Editable = false;

        }
        field(50005; "Contractor Posted Advance"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                           "Job Task No." = FIELD("Job Task No."),
                                                                           "Job Task No." = FIELD(FILTER(Totaling)),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "Posting Date" = FIELD("Posting Date Filter"),
                                                                           Type = CONST("G/L Account"),
                                                                           "No." = FIELD(FILTER("Advance Filter"))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Contractor Posted Retention"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                           "Job Task No." = FIELD("Job Task No."),
                                                                           "Job Task No." = FIELD(FILTER(Totaling)),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "Posting Date" = FIELD("Posting Date Filter"),
                                                                           Type = CONST("G/L Account"),
                                                                           "No." = FIELD(FILTER("Retention Filter"))));
            Editable = false;

        }
        field(50007; "Cont. Other Posted Deduction"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                           "Job Task No." = FIELD("Job Task No."),
                                                                           "Job Task No." = FIELD(FILTER(Totaling)),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "Posting Date" = FIELD("Posting Date Filter"),
                                                                           Type = CONST("G/L Account"),
                                                                           "No." = FIELD(FILTER("Other Deduction Filter"))));
            Editable = false;

        }
        field(50008; "Gross Bill Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(50009; "Advance Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(50010; "Retention Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(50011; "Other Deduction Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(50015; "Service Report No."; Code[20])
        {
            Caption = 'Service Report No.';
        }
    }
}

