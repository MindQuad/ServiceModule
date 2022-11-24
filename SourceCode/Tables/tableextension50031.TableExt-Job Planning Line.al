tableextension 50031 tableextension50031 extends "Job Planning Line"
{
    fields
    {
        field(50000; "SubContractor No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(50001; "Mark Up %"; Decimal)
        {

            trigger OnValidate()
            begin
                //CalculateUnitPrice; //WIN325
            end;
        }
        field(50002; "Subcontractor Bill Value"; Decimal)
        {
        }
        field(50003; "Deduction Plan Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Deduction Plan".Code;
        }
        field(50004; "Previous Bill Values"; Decimal)
        {
            Editable = false;
        }
        field(50005; "Previous Postive Values"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50006; "Date Filter"; Date)
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50007; "Purchase Invoice No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Document No." WHERE("Document Type" = CONST(Invoice),
                                                                       "Job No." = FIELD("Job No."),
                                                                       "Job Task No." = FIELD("Job Task No."),
                                                                       "Job Planning Line No." = FIELD("Line No."),
                                                                       "Buy-from Vendor No." = FIELD("SubContractor No."),
                                                                       "No." = FIELD("No.")));
            Editable = false;

        }
        field(50008; "Posted Pur. Inv. No."; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
        }
    }
}

