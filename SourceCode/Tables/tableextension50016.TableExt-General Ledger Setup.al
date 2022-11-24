tableextension 50016 tableextension50016 extends "General Ledger Setup"
{
    // WINPDC : Added new field 'PDC Document Nos.'.
    fields
    {
        field(50000; "Legal Department Mail ID"; Text[100])
        {
        }
        field(50001; "Property Management Mail ID"; Text[100])
        {
        }
        field(50003; "HR Claim No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50004; "Expense Claim No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50005; "Expense Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Expense Template Name"));
        }
        field(50006; "Expense Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50007; "PDC Document Nos."; Code[10])
        {
            Description = 'WINPDC';
            TableRelation = "No. Series";
        }
        field(50008; "Finance/Legal User Mail ID"; Text[250])
        {
        }
        field(50009; "Post Dated Journal Template"; Code[10])
        {
            Caption = 'Post Dated Journal Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50010; "Post Dated Journal Batch"; Code[10])
        {
            Caption = 'Post Dated Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Post Dated Journal Template"));
        }
        field(50011; "Enable WHT"; Boolean)
        {
            Caption = 'Enable WHT';
        }
        field(50012; "Enable GST (Australia)"; Boolean)
        {
            Caption = 'Enable GST (Australia)';
        }
        field(50013; "Min. WHT Calc only on Inv. Amt"; Boolean)
        {
            Caption = 'Min. WHT Calc only on Inv. Amt';
        }
        field(50014; "GST Report"; Boolean)
        {
            Caption = 'GST Report';
        }
        field(50015; "Full GST on Prepayment"; Boolean)
        {
            Caption = 'Full GST on Prepayment';
        }
    }
}

