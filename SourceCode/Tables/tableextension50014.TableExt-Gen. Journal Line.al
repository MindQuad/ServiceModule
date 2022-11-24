tableextension 50014 tableextension50014 extends "Gen. Journal Line"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST("Employee")) Employee;
        }

        modify("Deferral Code")
        {
            trigger OnAfterValidate()
            begin

            end;
        }




        //Unsupported feature: Code Modification on ""Deferral Code"(Field 1700).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Deferral Code" <> '' THEN
          TESTFIELD("Account Type","Account Type"::"G/L Account");

        DeferralUtilities.DeferralCodeOnValidate("Deferral Code",DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",
          0,'',"Line No.",GetDeferralAmount,"Posting Date",Description,"Currency Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        // IF "Deferral Code" <> '' THEN
        //  TESTFIELD("Account Type","Account Type"::"G/L Account");
        //
        // DeferralUtilities.DeferralCodeOnValidate("Deferral Code",DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",
        //  0,'',"Line No.",GetDeferralAmount,"Posting Date",Description,"Currency Code");


        IF "Deferral Code" <> '' THEN
          TESTFIELD("Account Type","Account Type"::"G/L Account");
        //WINS-PPG++
        DeferralUtilities.SetServiceDeferral(ServiceDeferral);
        //WINS-PPG--
        DeferralUtilities.DeferralCodeOnValidate("Deferral Code",DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",
          0,'',"Line No.",GetDeferralAmount,"Posting Date",Description,"Currency Code");
        */
        //end;
        field(50001; Narration; Text[100])
        {
        }
        field(50002; "Check Date"; Date)
        {
        }
        field(50003; "Check No"; Code[10])
        {
        }
        field(50004; "PDC Document No."; Code[20])
        {
            Editable = false;
        }
        field(50005; "PDC Line No."; Integer)
        {
            Editable = false;
        }
        field(50010; "Expense Claim Code"; Code[10])
        {
            TableRelation = "Expense Claim Codes";
        }
        field(50011; "Job Code"; Code[20])
        {
        }
        field(50012; "Milestone Code"; Code[20])
        {
        }
        field(50013; "Service Contract No."; Code[20])
        {
        }
        field(50014; "Service Quote No."; Code[20])
        {
        }
        field(50015; "Charge Code"; Code[20])
        {
        }
        field(50016; "Charge Description"; Text[50])
        {
        }
        field(90000; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'Added By Winspire HR & Payroll';
            TableRelation = Employee."No.";
        }
        field(50017; "Post Dated Check"; Boolean)
        {
            Caption = 'Post Dated Check';
        }
        field(50018; "Check No."; Code[20])
        {
            Caption = 'Check No.';
        }
        field(50019; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
        }
        field(50020; "Interest Amount (LCY)"; Decimal)
        {
            Caption = 'Interest Amount(LCY)';
        }
        field(50021; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(50022; "BAS Adjustment"; Boolean)
        {
            Caption = 'BAS Adjustment';

        }
        field(50023; "Skip WHT"; Boolean)
        {
            Caption = 'Skip WHT';
        }
    }



    local procedure "--PY032018"()
    begin
    end;

    procedure SetServiceDeferral()
    begin
        ServiceDeferral := TRUE;//tt
    end;

    local procedure GetEmployeeAccount()
    var
        Employee: Record 5200;
    begin
        Employee.GET("Account No.");
        UpdateDescriptionWithEmployeeName(Employee);
        "Posting Group" := Employee."Employee Posting Group";
        "Salespers./Purch. Code" := Employee."Salespers./Purch. Code";
        "Currency Code" := '';
        ClearPostingGroups;

        OnAfterAccountNoOnValidateGetEmployeeAccount(Rec, Employee);
    end;

    //Win513++
    // procedure ClearPostingGroups()
    // begin
    //     "Gen. Posting Type" := "Gen. Posting Type"::" ";
    //     "Gen. Bus. Posting Group" := '';
    //     "Gen. Prod. Posting Group" := '';
    //     "VAT Bus. Posting Group" := '';
    //     "VAT Prod. Posting Group" := '';
    // end;
    //Win513--

    procedure UpdateDescription(Name: Text[50])
    begin
        IF NOT IsAdHocDescription THEN
            Description := Name;
    end;

    Procedure IsAdHocDescription(): Boolean
    var

        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        Employee: Record Employee;
    begin
        IF Description = '' THEN
            EXIT(FALSE);
        IF xRec."Account No." = '' THEN
            EXIT(TRUE);

        CASE xRec."Account Type" OF
            xRec."Account Type"::"G/L Account":
                EXIT(GLAccount.GET(xRec."Account No.") AND (GLAccount.Name <> Description));
            xRec."Account Type"::Customer:
                EXIT(Customer.GET(xRec."Account No.") AND (Customer.Name <> Description));
            xRec."Account Type"::Vendor:
                EXIT(Vendor.GET(xRec."Account No.") AND (Vendor.Name <> Description));
            xRec."Account Type"::"Bank Account":
                EXIT(BankAccount.GET(xRec."Account No.") AND (BankAccount.Name <> Description));
            xRec."Account Type"::"Fixed Asset":
                EXIT(FixedAsset.GET(xRec."Account No.") AND (FixedAsset.Description <> Description));
            xRec."Account Type"::"IC Partner":
                EXIT(ICPartner.GET(xRec."Account No.") AND (ICPartner.Name <> Description));
            //
            xRec."Account Type"::Employee:
                EXIT(Employee.GET(xRec."Account No.") AND (Employee.FullName <> Description));
        //
        END;
        EXIT(FALSE);
    end;

    local procedure UpdateDescriptionWithEmployeeName(Employee: Record 5200)
    begin
        IF STRLEN(Employee.FullName) <= MAXSTRLEN(Description) THEN
            UpdateDescription(COPYSTR(Employee.FullName, 1, MAXSTRLEN(Description)))
        ELSE
            UpdateDescription(Employee."Last Name");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetEmployeeAccount(var GenJournalLine: Record 81; var Employee: Record 5200)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetEmployeeBalAccount(var GenJournalLine: Record 81; var Employee: Record 5200)
    begin
    end;

    local procedure GetEmployeeBalAccount()
    var
        Employee: Record 5200;
    begin
        Employee.GET("Bal. Account No.");
        IF "Account No." = '' THEN
            UpdateDescriptionWithEmployeeName(Employee);
        "Posting Group" := Employee."Employee Posting Group";
        "Salespers./Purch. Code" := Employee."Salespers./Purch. Code";
        "Currency Code" := '';
        ClearBalancePostingGroups;

        OnAfterAccountNoOnValidateGetEmployeeBalAccount(Rec, Employee);
    end;

    local procedure SetAppliesToFields(DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Code[35])
    begin
        "Document Type" := "Document Type"::Payment;
        "Applies-to Doc. Type" := DocType;
        "Applies-to Doc. No." := DocNo;
        "Applies-to ID" := '';
        IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice) AND
           ("Document Type" = "Document Type"::Payment)
        THEN
            "External Document No." := ExtDocNo;
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
    end;

    //Win513++
    // procedure ClearBalancePostingGroups()
    // begin
    //     "Bal. Gen. Posting Type" := "Bal. Gen. Posting Type"::" ";
    //     "Bal. Gen. Bus. Posting Group" := '';
    //     "Bal. Gen. Prod. Posting Group" := '';
    //     "Bal. VAT Bus. Posting Group" := '';
    //     "Bal. VAT Prod. Posting Group" := '';
    // end;
    //Win513--


    local procedure SetAmountWithEmplLedgEntry()
    begin
        IF Amount = 0 THEN BEGIN
            EmplLedgEntry.CALCFIELDS("Remaining Amount");
            SetAmountWithRemaining(FALSE, EmplLedgEntry."Amount to Apply", EmplLedgEntry."Remaining Amount", 0.0);
        END;
    end;


    local procedure FindFirstEmplLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        EmplLedgEntry.RESET;
        EmplLedgEntry.SETCURRENTKEY("Employee No.", "Applies-to ID", Open);
        EmplLedgEntry.SETRANGE("Employee No.", AccNo);
        EmplLedgEntry.SETRANGE("Applies-to ID", AppliesToID);
        EmplLedgEntry.SETRANGE(Open, TRUE);
        EXIT(EmplLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        EmplLedgEntry.RESET;
        EmplLedgEntry.SETCURRENTKEY("Document No.");
        EmplLedgEntry.SETRANGE("Document No.", AppliestoDocNo);
        EmplLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        EmplLedgEntry.SETRANGE("Employee No.", AccNo);
        EmplLedgEntry.SETRANGE(Open, TRUE);
        EXIT(EmplLedgEntry.FINDFIRST)
    end;

    local procedure ClearEmplApplnEntryFields()
    begin
        EmplLedgEntry."Amount to Apply" := 0;
    end;

    //Win513++
    // procedure SetAmountWithRemaining(CalcPmtDisc: Boolean; AmountToApply: Decimal; RemainingAmount: Decimal; RemainingPmtDiscPossible: Decimal)
    // begin
    //     IF AmountToApply <> 0 THEN
    //         IF CalcPmtDisc AND (ABS(AmountToApply) >= ABS(RemainingAmount - RemainingPmtDiscPossible)) THEN
    //             Amount := -(RemainingAmount - RemainingPmtDiscPossible)
    //         ELSE
    //             Amount := -AmountToApply
    //     ELSE
    //         IF CalcPmtDisc THEN
    //             Amount := -(RemainingAmount - RemainingPmtDiscPossible)
    //         ELSE
    //             Amount := -RemainingAmount;
    //     IF "Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor] THEN
    //         Amount := -Amount;
    //     VALIDATE(Amount);
    // end;
    //Win513--
    local procedure "--PY032018--"()
    begin
    end;

    //Unsupported feature: Property Modification (OptionString) on "ClearCustVendApplnEntry(PROCEDURE 11).AccType(Variable 1004)".


    //Unsupported feature: Property Modification (OptionString) on "SetJournalLineFieldsFromApplication(PROCEDURE 51).AccType(Variable 1005)".



    //Unsupported feature: Property Modification (OptionString) on ""Applies-to Doc. No."(Field 36).OnLookup.AccType(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //"Applies-to Doc. No." : G/L Account,Customer,Vendor,Bank Account,Fixed Asset;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //"Applies-to Doc. No." : G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee;
    //Variable type has not been exported.

    var
        ServiceDeferral: Boolean;
        "--WINS.PY.AE": Integer;
        EmplLedgEntry: Record "Employee Ledger Entry";

        GenJnlBatch: Record "Gen. Journal Batch";

        NotExistErr: Label 'Document number %1 does not exist or is already closed.';
        OnlyLocalCurrencyForEmployeeErr: Label 'The value of the Currency Code field must be empty. General journal lines in foreign currency are not supported for employee account type.';
    //EmplEntrySetApplID: Codeunit 33055819;
}

