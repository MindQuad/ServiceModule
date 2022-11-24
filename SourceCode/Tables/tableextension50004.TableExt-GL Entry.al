tableextension 50004 tableextension50004 extends "G/L Entry"
{
    fields
    {

        field(50001; Narration; Text[100])
        {
        }
        field(50002; "Check Date"; Date)
        {
        }
        field(50003; "Check No."; Code[10])
        {
        }
        field(50004; "Creation Date"; Date)
        {
        }
        field(50005; "Reversal Reason Code"; Code[10])
        {
        }
        field(50006; "Reversal Reason Comments"; Text[100])
        {
        }
        field(50007; "PDC Document No."; Code[20])
        {
        }
        field(50008; "PDC Line No."; Integer)
        {
        }
        field(50009; "VLE Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Vendor Ledger Entry" WHERE("Entry No." = FIELD("Entry No.")));

        }
        field(50010; "Service Contract No."; Code[20])
        {
        }
        field(50011; "Charge Code"; Code[20])
        {
        }
        field(50012; "Charge Description"; Text[50])
        {
        }
        field(50013; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'Added by Winspire HR & Payroll';
            TableRelation = Employee."No.";
        }
        field(50014; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = Definitive,Simulation;
            OptionCaption = 'Definitive,Simulation';
        }
    }

    //Win513++
    keys
    {
        key(NewKey; "Document No.", "Posting Date", Amount)
        { }
        key(NewKey1; "Posting Date", "Source Code", "Transaction No.")
        { }
    }
    //Win513--

    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 4)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    "Document Type" := GenJnlLine."Document Type";
    #4..29
    "BAS Adjustment" := GenJnlLine."BAS Adjustment";
    "BAS Doc. No." := GenJnlLine."BAS Doc. No.";
    "BAS Version" := GenJnlLine."BAS Version";

    OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);

    //end;
    //>>>> MODIFIED CODE:
    begin
    
    #1..32
    //Win160 to flow narration in gl entry
    Narration:=GenJnlLine.Narration;
    "Check No.":=GenJnlLine."Check No";
    "Check Date":=GenJnlLine."Check Date";
    "Creation Date":=TODAY;
    OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);
    
    //end;

    local procedure "--"()
    begin
    end;

    /* procedure CopyFromPayrollJnlLine(GenJnlLine: Record 33056072)
    begin
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Business Unit Code" := GenJnlLine."Business Unit Code";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Source Code" := GenJnlLine."Source Code";
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
            "Source Type" := GenJnlLine."Source Type";
            "Source No." := GenJnlLine."Source No.";
        END ELSE BEGIN
            "Source Type" := GenJnlLine."Account Type";
            "Source No." := GenJnlLine."Account No.";
        END;
        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner") OR
           (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"IC Partner")
        THEN
            "Source Type" := "Source Type"::" ";
        "Job No." := GenJnlLine."Job No.";
        Quantity := GenJnlLine.Quantity;
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "User ID" := USERID;
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
        //Win160 to flow narration in gl entry
        Narration := GenJnlLine.Narration;
        "Check No." := GenJnlLine."Check No.";
        "Check Date" := GenJnlLine."Check Date";
        "Creation Date" := TODAY;
        OnAfterCopyGLEntryFromPayrollJnlLine(Rec, GenJnlLine);
    end; *///WIN292

    /* [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGLEntryFromPayrollJnlLine(var GLEntry: Record 17; var GenJournalLine: Record 33056072)
    begin
    end; */




}

