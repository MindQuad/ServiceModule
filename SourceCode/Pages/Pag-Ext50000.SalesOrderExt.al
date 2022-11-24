pageextension 50000 "Sales Order Ext" extends "Sales Order"
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
                Editable = RDKLoanEditable;
            }
            field("RDK Loan Tenure"; Rec."RDK Loan Tenure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RDK Loan Tenure field.';
                Editable = RDKLoanEditable;
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
                Editable = RDKLoanEditable;
            }
        }
    }

    actions
    {
        addafter("Create Inventor&y Put-away/Pick")
        {
            action(GenerateAmortization)
            {
                Caption = 'Generate Payment Schedule And PDC Entries';
                Promoted = true;
                PromotedCategory = Process;
                Image = Entries;
                ApplicationArea = All;
                Visible = Rec."Loan Type" = Rec."Loan Type"::"RDK Loan";

                trigger OnAction()
                var
                    SalesQuote: Page "Sales Quote";
                begin
                    SalesSetup.Get();
                    if Rec."Loan Type" = Rec."Loan Type"::"RDK Loan" then begin
                        Rec.TestField("RDK Loan Tenure");
                        Rec.TestField("RDK Loan");
                    end else
                        Error('Payment Schedule And PDC entries will be generated only for RDK Loan');

                    Rec.CalcFields("Amount Including VAT");
                    Rec.TestField("Amount Including VAT");
                    Rec.TestField("SPA Date");
                    Rec.TestField("RDK Loan Interest %");
                    SalesSetup.TestField("RDK Loan Account No.");

                    if Rec."RDK Loan" + Rec."Own Contribution" <> Rec."Amount Including VAT" then
                        Error('The sum of RDK loan amount and down payment must be equal to %1', Rec."Amount Including VAT");

                    if not Rec."Amortization Entries Generated" then begin
                        if not Confirm('Do you want to generate Payment Schedule And PDC entries', true) then
                            exit;
                        SalesQuote.GeneateAmortizationEntries(Rec);
                    end else
                        if not Confirm('Do you want to regenerate Payment Schedule And PDC entries', true) then
                            exit;
                    SalesQuote.GeneateAmortizationEntries(Rec);


                end;
            }
            action(AmortizationEntries)
            {
                Caption = 'Payment Schedulde';
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
        }
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        RDKLoanEditable: Boolean;
        BankLoanEditable: Boolean;

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
                    Rec."RDK Loan Tenure" := 0;
                    Rec."No of Installments for Loan" := 0;
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
        SalesSetup.Get();
        SalesSetup.TestField("Min. Own Contribution %");

        Rec.CalcFields("Amount Including VAT");
        Rec.TestField("Amount Including VAT");
        MinOwnContribution := (Rec."Amount Including VAT" / 100) * SalesSetup."Min. Own Contribution %";
    end;

    trigger OnOpenPage()
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
    //Win593--
}