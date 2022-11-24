tableextension 50025 tableextension50025 extends "Sales & Receivables Setup"
{
    // WINPDC: Added field to selct PDC Cash Batch
    fields
    {
        field(50000; "PDC Batch For Cash"; Code[10])
        {
            Caption = 'PDC Batch For Cash';
            Description = 'WINPDC';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Post Dated Check Template"),
                                                             "Bal. Account Type" = CONST("G/L Account"));


        }

        field(50001; "Post Dated Check Template"; Code[10])
        {
            Caption = 'Post Dated Check Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50002; "Post Dated Check Batch"; Code[10])
        {
            Caption = 'Post Dated Check Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Post Dated Check Template"), "Bal. Account Type" = CONST("Bank Account"));

        }
        field(50003; "Incl. PDC in Cr. Limit Check"; Boolean)
        {
            Caption = 'Incl. PDC in Cr. Limit Check';
        }

        field(50006; "RDK Loan Account No."; Code[20])
        {
            Caption = 'RDK Loan Account No.';
            TableRelation = "G/L Account";
        }
        field(50007; "Min. Own Contribution %"; Decimal)
        {
            Caption = 'Down Payment%';
        }
        field(50008; "RDK Loan Interest %"; Decimal)
        {
            Caption = 'RDK Loan Interest %';
        }
        // field(50007; "RDK Loan Document No."; Code[20])
        // {
        //     TableRelation = "No. Series";
        // }
    }
}

