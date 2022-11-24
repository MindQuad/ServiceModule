PageExtension 50158 "Sales Quote RDK" extends "Sales Quote"
{
    //Win593++
    layout
    {

        addafter(Status)
        {
            field("SPA Date"; Rec."SPA Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SPA Date field.';
            }
            field("Loan Type"; Rec."Loan Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan Type field.';

                trigger onvalidate()
                begin
                    Rec."Bal. Account No." := '';
                    LoanTypeOnValidate();
                    CurrPage.Update();
                end;
            }
            field("Min. Own Contribution %"; Rec."Min. Own Contribution %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Min. Own Contribution % field.';
            }
            field("Own Contribution"; Rec."Own Contribution")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Own Contribution field.';

                trigger OnValidate()
                begin
                    Rec.CalcFields("Amount Including VAT");
                    if Rec."Amount Including VAT" = 0 then
                        exit;

                    Rec."RDK Loan" := Rec."Amount Including VAT" - Rec."Own Contribution";
                    CurrPage.Update();
                end;
            }
            field("Bank Loan"; Rec."Bank Loan")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Loan field.';
                Editable = BankLoanEditable;
            }
            field("RDK Loan"; Rec."RDK Loan")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RDK Loan field.';
                Editable = RDKLoanEditable;

                trigger OnValidate()
                begin
                    Rec.CalcFields("Amount Including VAT");
                    if Rec."Amount Including VAT" = 0 then
                        exit;

                    Rec."Own Contribution" := Rec."Amount Including VAT" - Rec."RDK Loan";
                    CurrPage.Update();
                end;
            }
            field("RDK Loan Interest %"; Rec."RDK Loan Interest %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RDK Loan Interest % field.';
            }
            field("RDK Loan Tenure"; Rec."RDK Loan Tenure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RDK Loan Tenure field.';
            }
            field("RDK Loan Intrest Amount"; Rec."RDK Loan Intrest Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RDK Loan Intrest Amount field.';
            }
            field("No of Installments for Loan"; Rec."No of Installments for Loan")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No of Installments for Loan field.';

                trigger OnValidate()
                var
                    Amount: Decimal;
                begin
                    Amount := Rec."RDK Loan Tenure" / Rec."No of Installments for Loan";
                    if Amount <> Round(Amount, 1) then
                        Message(InstallmentErr);
                end;
            }
        }

    }

    actions
    {
        addafter(CopyDocument)
        {
            action(CalculateOwnContribution)
            {
                Caption = 'Calculate DownPayment';
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateUnitCost;
                ApplicationArea = All;
                Visible = Rec."Loan Type" = Rec."Loan Type"::"RDK Loan";

                trigger OnAction()
                var
                    MinOwnContribution: Decimal;
                begin
                    OwnContributionCalculation(MinOwnContribution);
                    Rec."Own Contribution" := MinOwnContribution;
                end;
            }
            action(GenerateAmortization)
            {
                Caption = 'Generate Payment Schedule And PDC Entries';
                Promoted = true;
                PromotedCategory = Process;
                Image = Entries;
                ApplicationArea = All;
                Visible = Rec."Loan Type" = Rec."Loan Type"::"RDK Loan";

                trigger OnAction()
                begin
                    SalesSetup.Get();
                    if Rec."Loan Type" = Rec."Loan Type"::"RDK Loan" then begin
                        Rec.TestField("RDK Loan Tenure");
                        Rec.TestField("RDK Loan");
                    end else
                        Error('Payment Schedule And PDC entries will be generated only for RDK Loan');

                    Rec.CalcFields("Amount Including VAT");
                    Rec.TestField("Amount Including VAT");
                    // Rec.TestField("Own Contribution");
                    Rec.TestField("SPA Date");
                    Rec.TestField("RDK Loan Interest %");
                    SalesSetup.TestField("RDK Loan Account No.");

                    if Rec."RDK Loan" + Rec."Own Contribution" <> Rec."Amount Including VAT" then
                        Error('The sum of RDK loan amount and down payment must be equal to %1', Rec."Amount Including VAT");

                    if not Rec."Amortization Entries Generated" then begin
                        if not Confirm('Do you want to generate Payment Schedule And PDC entries', true) then
                            exit;
                        GeneateAmortizationEntries(Rec);
                    end else
                        if not Confirm('Do you want to regenerate Payment Schedule And PDC entries', true) then
                            exit;
                    GeneateAmortizationEntries(Rec);
                end;
            }
            action(AmortizationEntries)
            {
                Caption = 'Payment Schedule';
                Promoted = true;
                PromotedCategory = Process;
                Image = Entries;
                ApplicationArea = All;
                Visible = Rec."Loan Type" = Rec."Loan Type"::"RDK Loan";

                trigger OnAction()
                var
                    AmortizationEntries: Page "Amortization Entries";
                    AmortizationEntry: Record "Amortization Entry";
                begin
                    AmortizationEntry.SetRange("Document Type", Rec."Document Type");
                    AmortizationEntry.SetRange("Document No.", Rec."No.");
                    AmortizationEntry.SetFilter(Status, '=%1|%2', AmortizationEntry.Status::" ", AmortizationEntry.Status::Received);
                    AmortizationEntries.SetTableView(AmortizationEntry);
                    AmortizationEntries.Run();
                end;
            }
            action(PDCEntries)
            {
                Caption = 'PDC Entries';
                Promoted = true;
                PromotedCategory = Process;
                Image = Entries;
                ApplicationArea = All;
                Visible = Rec."Loan Type" = Rec."Loan Type"::"RDK Loan";

                trigger OnAction()
                var
                    PDCEntries: Page "Post Dated Checks Register";
                    RecPDCEntries: Record "Post Dated Check Line";
                begin
                    RecPDCEntries.Reset();
                    RecPDCEntries.SetRange("Document Type", Rec."Document Type");
                    RecPDCEntries.SetRange("Document No.", Rec."No.");
                    RecPDCEntries.SetFilter("G/L Transaction No.", '=%1', 0);
                    PDCEntries.SetTableView(RecPDCEntries);
                    PDCEntries.RunModal();
                end;
            }
            action(PostedAmortizationEntries)
            {
                Caption = 'Posted PDC Entries';
                Promoted = true;
                PromotedCategory = Process;
                Image = Entries;
                ApplicationArea = All;
                Visible = Rec."Loan Type" = Rec."Loan Type"::"RDK Loan";

                trigger OnAction()
                var
                    PDCEntries: Page "Post Dated Checks Register";
                    RecPDCEntries: Record "Post Dated Check Line";
                begin
                    RecPDCEntries.Reset();
                    RecPDCEntries.SetRange("Document Type", Rec."Document Type");
                    RecPDCEntries.SetRange("Document No.", Rec."No.");
                    RecPDCEntries.SetFilter("G/L Transaction No.", '<>%1', 0);
                    PDCEntries.SetTableView(RecPDCEntries);
                    PDCEntries.RunModal();
                end;
            }
        }
    }
    var
        SalesSetup: Record "Sales & Receivables Setup";
        RDKLoanEditable: Boolean;
        BankLoanEditable: Boolean;

    procedure GeneateAmortizationEntries(Rec: Record "Sales Header")
    var
        AmortizationEntry: Record "Amortization Entry";
        Counter: Integer;
        CheckDate: Date;
        PrincipalAmtPerMonth: Decimal;
        IntAmtPerMonth: Decimal;
        IntPer: Decimal;
        IntAmt: Decimal;
        BeginningBal: Decimal;
        EndingBal: Decimal;
        EMIAmt: Decimal;
        PowerAmt: Decimal;
        InstallmentAmount: Decimal;
    begin
        SalesSetup.Get();
        AmortizationEntry.SetRange("Document Type", Rec."Document Type");
        AmortizationEntry.SetRange("Document No.", Rec."No.");
        if AmortizationEntry.FindSet() then
            AmortizationEntry.DeleteAll();

        IntPer := Round(Rec."RDK Loan Interest %" / 100, 0.001);
        IntAmt := IntPer / 12;
        PowerAmt := Power(1 + IntAmt, Rec."RDK Loan Tenure");

        EMIAmt := Round(Rec."RDK Loan" * IntAmt * PowerAmt / (PowerAmt - 1));

        BeginningBal := Rec."RDK Loan";
        CheckDate := Rec."SPA Date";
        AmortizationEntry.Reset();
        for Counter := 1 to Rec."RDK Loan Tenure" do begin
            IntAmtPerMonth := Round(BeginningBal * IntPer / 12);
            PrincipalAmtPerMonth := EMIAmt - IntAmtPerMonth;
            EndingBal := BeginningBal - PrincipalAmtPerMonth;
            if EndingBal < 1 then
                EndingBal := 0;

            AmortizationEntry.Init;
            AmortizationEntry."Document Type" := Rec."Document Type";
            AmortizationEntry."Document No." := Rec."No.";
            AmortizationEntry."Batch Name" := 'PDC';
            AmortizationEntry."Line Number" := Counter * 10000;
            AmortizationEntry."Check Date" := CheckDate;
            AmortizationEntry."Account Type" := AmortizationEntry."account type"::"G/L Account";
            AmortizationEntry.Validate("Account No.", SalesSetup."RDK Loan Account No.");
            AmortizationEntry."Beginning Balance" := BeginningBal;
            AmortizationEntry."Prinipal Amount" := PrincipalAmtPerMonth;
            AmortizationEntry."Interest Amount" := IntAmtPerMonth;
            AmortizationEntry."EMI Amount" := EMIAmt;
            AmortizationEntry."Ending Balance" := EndingBal;
            AmortizationEntry.Amount := -EMIAmt;
            AmortizationEntry.Validate("Bal. Account Type", AmortizationEntry."bal. account type"::Bank);
            AmortizationEntry."Customer No." := Rec."Sell-to Customer No.";
            AmortizationEntry."Customer Name" := Rec."Sell-to Customer Name";
            AmortizationEntry."Dimension Set ID" := Rec."Dimension Set ID";
            AmortizationEntry.Insert;
            CheckDate := CalcDate('1M', CheckDate);
            BeginningBal := EndingBal;
        end;
        // Rec."Amortization Entries Generated" := true;
        // Rec.Modify();

        Rec.TestField("No of Installments for Loan");
        InstallmentAmount := (EMIAmt * Rec."RDK Loan Tenure") / Rec."No of Installments for Loan";
        GeneratePDCEntries(InstallmentAmount, Rec);
        Message('Payment Schedule And PDC entries has been generated successfully.');
    end;

    local procedure LoanTypeOnValidate()
    var
        AmortizationEntry: Record "Amortization Entry";
        RecPDCL: Record "Post Dated Check Line";
    begin
        case Rec."Loan Type" of
            Rec."Loan Type"::" ":
                begin
                    RDKLoanEditable := false;
                    BankLoanEditable := false;
                    Rec."RDK Loan" := 0;
                    Rec."Bank Loan" := 0;
                    Rec."RDK Loan Interest %" := 0;
                    Rec."No of Installments for Loan" := 0;
                    Rec."RDK Loan Tenure" := 0;
                    AmortizationEntry.SetRange("Document Type", Rec."Document Type");
                    AmortizationEntry.SetRange("Document No.", Rec."No.");
                    AmortizationEntry.DeleteAll();

                    RecPDCL.SetRange("Document Type", Rec."Document Type");
                    RecPDCL.SetRange("Document No.", Rec."No.");
                    RecPDCL.DeleteAll();
                end;

            Rec."Loan Type"::"Bank Loan":
                begin
                    RDKLoanEditable := false;
                    BankLoanEditable := true;
                    Rec."RDK Loan" := 0;
                    Rec."RDK Loan Interest %" := 0;
                    Rec."No of Installments for Loan" := 0;
                    Rec."RDK Loan Tenure" := 0;
                    AmortizationEntry.SetRange("Document Type", Rec."Document Type");
                    AmortizationEntry.SetRange("Document No.", Rec."No.");
                    AmortizationEntry.DeleteAll();

                    RecPDCL.SetRange("Document Type", Rec."Document Type");
                    RecPDCL.SetRange("Document No.", Rec."No.");
                    RecPDCL.DeleteAll();
                end;

            Rec."Loan Type"::"RDK Loan":
                begin
                    RDKLoanEditable := true;
                    BankLoanEditable := false;
                    Rec."Bank Loan" := 0;
                end;
        end;
    end;

    local procedure OwnContributionCalculation(var MinOwnContribution: Decimal)
    begin
        Rec.TestField("Min. Own Contribution %");

        Rec.CalcFields("Amount Including VAT");
        Rec.TestField("Amount Including VAT");
        MinOwnContribution := (Rec."Amount Including VAT" / 100) * Rec."Min. Own Contribution %";
    end;

    local procedure GeneratePDCEntries(InstallmentAmount: Decimal; Rec: Record "Sales Header")
    var
        RecPDCL: Record "Post Dated Check Line";
        PDCEntries: Record "Post Dated Check Line";
        Counter: Integer;
        IntAmtPerMonth: Decimal;
        BeginningBal: Decimal;
        IntPer: Decimal;
        PrincipalAmtPerMonth: Decimal;
        EMIAmt: Decimal;
        EndingBal: Decimal;
        CheckDate: Date;
        CalcMonth: Integer;
    begin
        RecPDCL.SetRange("Document Type", Rec."Document Type");
        RecPDCL.SetRange("Document No.", Rec."No.");
        RecPDCL.DeleteAll();

        CalcMonth := Rec."RDK Loan Tenure" / rec."No of Installments for Loan";

        CheckDate := Rec."SPA Date";
        RecPDCL.Reset();
        for Counter := 1 to Rec."No of Installments for Loan" do begin
            RecPDCL.Init;
            RecPDCL."Document Type" := Rec."Document Type";
            RecPDCL."Document No." := Rec."No.";
            RecPDCL."Batch Name" := 'PDC';
            RecPDCL."Line Number" := Counter * 10000;
            RecPDCL."Check Date" := CheckDate;
            RecPDCL."Account Type" := RecPDCL."account type"::"G/L Account";
            RecPDCL.Validate("Account No.", SalesSetup."RDK Loan Account No.");
            RecPDCL.Amount := -InstallmentAmount;
            RecPDCL.Validate("Bal. Account Type", RecPDCL."bal. account type"::Bank);
            RecPDCL."Customer No." := Rec."Sell-to Customer No.";
            RecPDCL."Customer Name" := Rec."Sell-to Customer Name";
            RecPDCL."Dimension Set ID" := Rec."Dimension Set ID";
            RecPDCL.Insert;
            CheckDate := CalcDate(Format(CalcMonth) + 'M', CheckDate);
        end;
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get();
        case Rec."Loan Type" of
            Rec."Loan Type"::" ":
                begin
                    RDKLoanEditable := false;
                    BankLoanEditable := false;
                end;

            Rec."Loan Type"::"Bank Loan":
                begin
                    RDKLoanEditable := false;
                    BankLoanEditable := true;
                end;

            Rec."Loan Type"::"RDK Loan":
                begin
                    RDKLoanEditable := true;
                    BankLoanEditable := false;
                end;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        case Rec."Loan Type" of
            Rec."Loan Type"::" ":
                begin
                    RDKLoanEditable := false;
                    BankLoanEditable := false;
                end;

            Rec."Loan Type"::"Bank Loan":
                begin
                    RDKLoanEditable := false;
                    BankLoanEditable := true;
                end;

            Rec."Loan Type"::"RDK Loan":
                begin
                    RDKLoanEditable := true;
                    BankLoanEditable := false;
                end;
        end;
    end;

    var
        InstallmentErr: Label 'Installment amount must be in Whole number';
    //Win593--
}

