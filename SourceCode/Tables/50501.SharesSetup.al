table 50501 "Shares Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "G/L A/C for Shares Investment"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(4; "Bal. A/C for Shares Investment"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Journal Template for Entry"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(6; "Journal Batch for Entry"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template for Entry"));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GenerateSharesJournal()
    var
        Shares: Record Share;
        SharesValue: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        GLAccount: Record "G/L Account";
    begin
        Rec.TestField(Rec."G/L A/C for Shares Investment");
        Rec.TestField(Rec."Bal. A/C for Shares Investment");
        Rec.TestField(Rec."Journal Template for Entry");
        Rec.TestField(Rec."Journal Batch for Entry");

        GLAccount.Get(Rec."G/L A/C for Shares Investment");
        GLAccount.CalcFields(GLAccount.Balance);
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := Rec."Journal Template for Entry";
        GenJournalLine."Journal Batch Name" := Rec."Journal Batch for Entry";
        GenJournalLine."Line No." := 10000;
        GenJournalLine.Validate(GenJournalLine."Document No.", 'ShareValue_' + FORMAT(Today()));
        GenJournalLine.Validate(GenJournalLine."Posting Date", Today());
        GenJournalLine.Validate(GenJournalLine."Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate(GenJournalLine."Account No.", Rec."G/L A/C for Shares Investment");
        GenJournalLine.Validate(GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate(GenJournalLine."Bal. Account No.", Rec."Bal. A/C for Shares Investment");
        GenJournalLine.Validate(GenJournalLine.Amount, -GLAccount.Balance);
        GenJournalLine.Insert();

        Shares.Reset();
        if Shares.FindSet() then
            repeat
                Shares.CalcFields(Shares."Value of Shares");
                SharesValue += Shares."Value of Shares";
            until Shares.Next() = 0;

        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := Rec."Journal Template for Entry";
        GenJournalLine."Journal Batch Name" := Rec."Journal Batch for Entry";
        GenJournalLine."Line No." := 20000;
        GenJournalLine.Validate(GenJournalLine."Document No.", 'ShareValue_' + FORMAT(Today()));
        GenJournalLine.Validate(GenJournalLine."Posting Date", Today());
        GenJournalLine.Validate(GenJournalLine."Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate(GenJournalLine."Account No.", Rec."G/L A/C for Shares Investment");
        GenJournalLine.Validate(GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate(GenJournalLine."Bal. Account No.", Rec."Bal. A/C for Shares Investment");
        GenJournalLine.Validate(GenJournalLine.Amount, SharesValue);
        GenJournalLine.Insert();

        Message('Entries created successfully.');
    end;
}