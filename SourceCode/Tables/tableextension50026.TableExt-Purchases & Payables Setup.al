tableextension 50026 tableextension50026 extends "Purchases & Payables Setup"

{
    // WINPDC: Added field to selct PDC Batch for Cash
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
            Caption = 'Post Dated Check Template';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Post Dated Check Template"), "Bal. Account Type" = CONST("Bank Account"));


        }
        field(50003; "Enable Vendor GST Amount (ACY)"; Boolean)
        {
            Caption = 'Enable Vendor GST Amount (ACY)';
        }
    }
}

