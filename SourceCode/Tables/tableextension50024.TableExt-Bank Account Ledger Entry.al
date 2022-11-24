tableextension 50024 tableextension50024 extends "Bank Account Ledger Entry"
{
    local procedure "--"()
    begin
    end;

    /*  procedure CopyFromPayrollJnlLine(GenJnlLine: Record 33056072)
     begin
         "Bank Account No." := GenJnlLine."Account No.";
         "Posting Date" := GenJnlLine."Posting Date";
         "Document Date" := GenJnlLine."Document Date";
         "Document Type" := GenJnlLine."Document Type";
         "Document No." := GenJnlLine."Document No.";
         "External Document No." := GenJnlLine."External Document No.";
         Description := GenJnlLine.Description;
         "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
         "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
         "Dimension Set ID" := GenJnlLine."Dimension Set ID";
         "Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
         "Source Code" := GenJnlLine."Source Code";
         "Journal Batch Name" := GenJnlLine."Journal Batch Name";
         "Reason Code" := GenJnlLine."Reason Code";
         "Currency Code" := GenJnlLine."Currency Code";
         "User ID" := USERID;
         "Bal. Account Type" := GenJnlLine."Bal. Account Type";
         "Bal. Account No." := GenJnlLine."Bal. Account No.";
     end; *///WIN292
}

