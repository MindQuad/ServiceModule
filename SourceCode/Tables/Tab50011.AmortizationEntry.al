table 50011 "Amortization Entry"
{

    Caption = 'Amortization Entry';

    fields
    {
        field(1; "Line Number"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line Number';
            Editable = false;
        }
        field(2; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnValidate()
            begin
                //WINPDC++
                // IF "Document No." <> xRec."Document No." THEN BEGIN
                //     SalesSetup.Get();
                //     NoSeriesMgt.TestManual(GetNoSeriesCode);
                //     "No. Series" := '';
                // END;
                //WINPDC--
            end;
        }
        field(9; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = ' ,Customer,Vendor,G/L Account';
            OptionMembers = " ",Customer,Vendor,"G/L Account";

            trigger OnValidate()
            begin
                VALIDATE("Account No.", '');
            end;
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor;

            trigger OnValidate()
            begin
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            Customer.GET("Account No.");
                            Description := Customer.Name;
                            SalesSetup.GET;
                            SalesSetup.TESTFIELD("Post Dated Check Template");
                            // WINPDC
                            IF "Payment Method" = "Payment Method"::Cash THEN BEGIN
                                SalesSetup.TESTFIELD("PDC Batch For Cash");
                                "Batch Name" := SalesSetup."PDC Batch For Cash";
                                "Template Name" := SalesSetup."Post Dated Check Template";
                                JnlBatch.GET(SalesSetup."Post Dated Check Template", SalesSetup."PDC Batch For Cash");
                                JnlBatch.SETRANGE("Journal Template Name", SalesSetup."Post Dated Check Template");
                                JnlBatch.SETRANGE(Name, SalesSetup."PDC Batch For Cash");
                                "Bank Account" := JnlBatch."Bal. Account No.";
                            END ELSE BEGIN
                                // WINPDC
                                SalesSetup.TESTFIELD("Post Dated Check Batch");
                                "Batch Name" := SalesSetup."Post Dated Check Batch";
                                "Template Name" := SalesSetup."Post Dated Check Template";
                                JnlBatch.GET(SalesSetup."Post Dated Check Template", SalesSetup."Post Dated Check Batch");
                                JnlBatch.SETRANGE("Journal Template Name", SalesSetup."Post Dated Check Template");
                                JnlBatch.SETRANGE(Name, SalesSetup."Post Dated Check Batch");
                                "Bank Account" := JnlBatch."Bal. Account No.";
                            END;
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            Vendor.GET("Account No.");
                            Description := Vendor.Name;
                            PurchSetup.GET;
                            PurchSetup.TESTFIELD("Post Dated Check Template");
                            // WINPDC
                            IF "Payment Method" = "Payment Method"::Cash THEN BEGIN
                                PurchSetup.TESTFIELD("PDC Batch For Cash");
                                IF "Batch Name" = '' THEN
                                    "Batch Name" := PurchSetup."PDC Batch For Cash";
                                "Template Name" := PurchSetup."Post Dated Check Template";
                                JnlBatch.GET(PurchSetup."Post Dated Check Template", PurchSetup."PDC Batch For Cash");
                                JnlBatch.SETRANGE("Journal Template Name", PurchSetup."Post Dated Check Template");
                                JnlBatch.SETRANGE(Name, PurchSetup."PDC Batch For Cash");
                                "Bank Account" := JnlBatch."Bal. Account No.";
                            END ELSE BEGIN
                                // WINPDC
                                PurchSetup.TESTFIELD("Post Dated Check Batch");
                                IF "Batch Name" = '' THEN
                                    "Batch Name" := PurchSetup."Post Dated Check Batch";
                                "Template Name" := PurchSetup."Post Dated Check Template";
                                JnlBatch.GET(PurchSetup."Post Dated Check Template", PurchSetup."Post Dated Check Batch");
                                JnlBatch.SETRANGE("Journal Template Name", PurchSetup."Post Dated Check Template");
                                JnlBatch.SETRANGE(Name, PurchSetup."Post Dated Check Batch");
                                "Bank Account" := JnlBatch."Bal. Account No.";
                            END;
                        END;
                    "Account Type"::"G/L Account":
                        BEGIN
                            IF GLAccount.GET("Account No.") THEN
                                Description := GLAccount.Name;
                        END;
                END;
                "Date Received" := WORKDATE;

                //WINPDC++
                // IF "Document No." = '' THEN BEGIN
                //     SalesSetup.GET;
                //     NoSeriesMgt.InitSeries(SalesSetup."RDK Loan Document No.", xRec."No. Series", 0D, "Document No.", "No. Series");
                // END;
                //WINPDC--
            end;
        }
        field(11; "Check Date"; Date)
        {
            Caption = 'Payment Date';

            trigger OnValidate()
            begin
                TESTFIELD("Check No.");
                IF "Check Date" < "Date Received" THEN
                    ERROR('Check Date must not be less than Check Recieved Date');

                VALIDATE(Amount);
            end;
        }
        field(12; "Check No."; Code[20])
        {
            Caption = 'Check No.';

            trigger OnValidate()
            begin
                IF "Check No." <> '' THEN
                    IF "Document No." = '' THEN
                        "Document No." := "Check No.";
            end;
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       ("Check Date" <> xRec."Check Date") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Check Date", "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE("Currency Factor");
            end;
        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(21; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(22; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                // WINPDC
                IF (("Payment Method" <> "Payment Method"::Cash) AND ("Payment Method" <> "Payment Method"::" ")) THEN
                    TESTFIELD("Check No.");
                // WINPDC
                /*IF "Account Type" = "Account Type"::Customer THEN
                  IF Amount > 0 THEN
                    FIELDERROR(Amount,Text006);
                    */
                IF "Account Type" = "Account Type"::Vendor THEN
                    IF Amount < 0 THEN
                        FIELDERROR(Amount, Text007);

                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE
                    "Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Check Date", "Currency Code",
                          Amount, "Currency Factor"));

                Amount := ROUND(Amount, Currency."Amount Rounding Precision");

            end;
        }
        field(23; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::Customer THEN
                    IF Amount > 0 THEN
                        FIELDERROR(Amount, Text006);

                IF "Account Type" = "Account Type"::Vendor THEN
                    IF Amount < 0 THEN
                        FIELDERROR(Amount, Text007);

                TempAmount := "Amount (LCY)";
                VALIDATE("Currency Code", '');
                Amount := TempAmount;
                "Amount (LCY)" := TempAmount;
            end;
        }
        field(24; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(30; "Bank Account"; Code[20])
        {
            Caption = 'Bank/ GL Account';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST(Bank)) "Bank Account";
        }
        field(34; "Replacement Check"; Boolean)
        {
            Caption = 'Replacement Check';
            Editable = false;
        }
        field(40; Comment; Text[90])
        {
            Caption = 'Comment';
        }
        field(41; "Batch Name"; Code[10])
        {
            Caption = 'Batch Name';

            trigger OnLookup()
            begin
                CLEAR(JournalBatch);
                // JnlBatch.SETRANGE("Bal. Account Type",JnlBatch."Bal. Account Type"::"Bank Account"); // PDCCR // To Add Cash Filter
                JnlBatch.SETFILTER("Bal. Account Type", '%1|%2', JnlBatch."Bal. Account Type"::"Bank Account", JnlBatch."Bal. Account Type"::"G/L Account"); // PDCCR // To Add Cash Filter
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            SalesSetup.GET;
                            JnlBatch.SETRANGE("Journal Template Name", SalesSetup."Post Dated Check Template");
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            PurchSetup.GET;
                            JnlBatch.SETRANGE("Journal Template Name", PurchSetup."Post Dated Check Template");
                        END;
                END;
                JournalBatch.SETTABLEVIEW(JnlBatch);
                JournalBatch.SETRECORD(JnlBatch);
                JournalBatch.LOOKUPMODE(TRUE);
                IF JournalBatch.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    JournalBatch.GETRECORD(JnlBatch);
                    "Batch Name" := JnlBatch.Name;
                    "Template Name" := JnlBatch."Journal Template Name";
                    "Bank Account" := JnlBatch."Bal. Account No.";
                END;
            end;

            trigger OnValidate()
            begin
                IF "Batch Name" = '' THEN
                    EXIT;

                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            SalesSetup.GET;
                            JnlBatch.GET(SalesSetup."Post Dated Check Template", "Batch Name");
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            PurchSetup.GET;
                            JnlBatch.GET(PurchSetup."Post Dated Check Template", "Batch Name");
                        END;
                END;
                // PDCCR // To Add Cash Filter
                IF "Payment Method" = "Payment Method"::Cash THEN
                    JnlBatch.TESTFIELD("Bal. Account Type", JnlBatch."Bal. Account Type"::"G/L Account"); // PDCCR // To Add Cash Filter
                //ELSE JnlBatch.TESTFIELD("Bal. Account Type",JnlBatch."Bal. Account Type"::"Bank Account"); // PDCCR // To Add Cash Filter   //win315
                // PDCCR // To Add Cash Filter
            end;
        }
        //Win513++
        //field(42; "Applies-to Doc. Type"; Option)
        field(42; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        //Win513--
        {
            Caption = 'Applies-to Doc. Type';
            //Win513++
            // OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            // OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
            //Win513--
        }
        field(43; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                PaymentToleranceMgt: Codeunit 426;
            begin
                IF xRec."Line Number" = 0 THEN
                    xRec.Amount := Amount;

                IF "Account Type" IN
                   ["Account Type"::Customer]
                THEN BEGIN
                    AccNo := "Account No.";
                    AccType := AccType::Customer;
                    CLEAR(CustLedgEntry);
                END;
                IF "Account Type" IN
                   ["Account Type"::Vendor]
                THEN BEGIN
                    AccNo := "Account No.";
                    AccType := AccType::Vendor;
                    CLEAR(VendLedgEntry);
                END;

                xRec."Currency Code" := "Currency Code";
                xRec."Check Date" := "Check Date";

                CASE AccType OF
                    AccType::Customer:
                        BEGIN
                            CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
                            CustLedgEntry.SETRANGE("Customer No.", AccNo);
                            CustLedgEntry.SETRANGE(Open, TRUE);
                            IF "Applies-to Doc. No." <> '' THEN BEGIN
                                CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                                CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                IF NOT CustLedgEntry.FINDFIRST THEN BEGIN
                                    CustLedgEntry.SETRANGE("Document Type");
                                    CustLedgEntry.SETRANGE("Document No.");
                                END;
                            END;
                            IF "Applies-to ID" <> '' THEN BEGIN
                                CustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                                IF NOT CustLedgEntry.FINDFIRST THEN
                                    CustLedgEntry.SETRANGE("Applies-to ID");
                            END;
                            IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
                                CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                                IF NOT CustLedgEntry.FINDFIRST THEN
                                    CustLedgEntry.SETRANGE("Document Type");
                            END;
                            IF "Applies-to Doc. No." <> '' THEN BEGIN
                                CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                IF NOT CustLedgEntry.FINDFIRST THEN
                                    CustLedgEntry.SETRANGE("Document No.");
                            END;
                            IF Amount <> 0 THEN BEGIN
                                CustLedgEntry.SETRANGE(Positive, Amount < 0);
                                IF CustLedgEntry.FINDFIRST THEN;
                                CustLedgEntry.SETRANGE(Positive);
                            END;
                            SetGenJnlLine(Rec);
                            ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FIELDNO("Applies-to Doc. No."));
                            ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
                            ApplyCustEntries.SETRECORD(CustLedgEntry);
                            ApplyCustEntries.LOOKUPMODE(TRUE);
                            IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                ApplyCustEntries.GETRECORD(CustLedgEntry);
                                CLEAR(ApplyCustEntries);
                                IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
                                    IF Amount = 0 THEN BEGIN
                                        FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                                        ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
                                        IF NOT
                                           CONFIRM(
                                             Text003 +
                                             Text004, TRUE,
                                             FIELDCAPTION("Currency Code"), TABLECAPTION, FromCurrencyCode,
                                             ToCurrencyCode)
                                        THEN
                                            ERROR(Text005);
                                        VALIDATE("Currency Code", CustLedgEntry."Currency Code");
                                    END ELSE
                                        GenJnlApply.CheckAgainstApplnCurrency(
                                          "Currency Code", CustLedgEntry."Currency Code", GenJnlLine."Account Type"::Customer, TRUE);
                                IF Amount = 0 THEN BEGIN
                                    CustLedgEntry.CALCFIELDS("Remaining Amount");
                                    IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, FALSE) THEN
                                        Amount := (CustLedgEntry."Remaining Amount" -
                                                   CustLedgEntry."Remaining Pmt. Disc. Possible")
                                    ELSE
                                        Amount := CustLedgEntry."Remaining Amount";
                                    IF "Account Type" IN
                                       ["Account Type"::Customer]
                                    THEN
                                        Amount := -Amount;
                                    VALIDATE(Amount);
                                END;
                                "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                                "Applies-to Doc. No." := CustLedgEntry."Document No.";
                                "Applies-to ID" := '';
                            END ELSE
                                CLEAR(ApplyCustEntries);
                        END;
                    AccType::Vendor:
                        BEGIN
                            VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                            VendLedgEntry.SETRANGE("Vendor No.", AccNo);
                            VendLedgEntry.SETRANGE(Open, TRUE);
                            IF "Applies-to Doc. No." <> '' THEN BEGIN
                                VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                                VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                IF NOT VendLedgEntry.FINDFIRST THEN BEGIN
                                    VendLedgEntry.SETRANGE("Document Type");
                                    VendLedgEntry.SETRANGE("Document No.");
                                END;
                            END;
                            IF "Applies-to ID" <> '' THEN BEGIN
                                VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                                IF NOT VendLedgEntry.FINDFIRST THEN
                                    VendLedgEntry.SETRANGE("Applies-to ID");
                            END;
                            IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
                                VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                                IF NOT VendLedgEntry.FINDFIRST THEN
                                    VendLedgEntry.SETRANGE("Document Type");
                            END;
                            IF "Applies-to Doc. No." <> '' THEN BEGIN
                                VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                IF NOT VendLedgEntry.FINDFIRST THEN
                                    VendLedgEntry.SETRANGE("Document No.");
                            END;
                            IF Amount <> 0 THEN BEGIN
                                VendLedgEntry.SETRANGE(Positive, Amount < 0);
                                IF VendLedgEntry.FINDFIRST THEN;
                                VendLedgEntry.SETRANGE(Positive);
                            END;
                            SetGenJnlLine(Rec);
                            ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FIELDNO("Applies-to Doc. No."));
                            ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                            ApplyVendEntries.SETRECORD(VendLedgEntry);
                            ApplyVendEntries.LOOKUPMODE(TRUE);
                            IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                ApplyVendEntries.GETRECORD(VendLedgEntry);
                                CLEAR(ApplyVendEntries);
                                IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
                                    IF Amount = 0 THEN BEGIN
                                        FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                                        ToCurrencyCode := GetShowCurrencyCode(VendLedgEntry."Currency Code");
                                        IF NOT
                                           CONFIRM(
                                             Text003 +
                                             Text004, TRUE,
                                             FIELDCAPTION("Currency Code"), TABLECAPTION, FromCurrencyCode,
                                             ToCurrencyCode)
                                        THEN
                                            ERROR(Text005);
                                        VALIDATE("Currency Code", VendLedgEntry."Currency Code");
                                    END ELSE
                                        GenJnlApply.CheckAgainstApplnCurrency(
                                          "Currency Code", VendLedgEntry."Currency Code", GenJnlLine."Account Type"::Vendor, TRUE);
                                IF Amount = 0 THEN BEGIN
                                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                                    IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, FALSE) THEN
                                        Amount := -(VendLedgEntry."Remaining Amount" -
                                                    VendLedgEntry."Remaining Pmt. Disc. Possible")
                                    ELSE
                                        Amount := -VendLedgEntry."Remaining Amount";
                                    VALIDATE(Amount);
                                END;
                                "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                                "Applies-to Doc. No." := VendLedgEntry."Document No.";
                                "Applies-to ID" := '';
                            END ELSE
                                CLEAR(ApplyVendEntries);
                        END;
                END;
            end;
        }
        field(48; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN
                    ClearCustVendAppID;
            end;
        }
        //Win513++
        //field(50; "Bank Payment Type"; Option)
        field(50; "Bank Payment Type"; Enum "Bank Payment Type")
        //Win513--
        {
            Caption = 'Bank Payment Type';
            //Win513++
            // OptionCaption = ' ,Computer Check,Manual Check';
            // OptionMembers = " ","Computer Check","Manual Check";
            //Win513--
        }
        field(51; "Check Printed"; Boolean)
        {
            Caption = 'Check Printed';
            Editable = false;
        }
        field(52; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';

            trigger OnValidate()
            begin
                IF "Currency Code" = '' THEN
                    "Interest Amount (LCY)" := "Interest Amount"
                ELSE
                    "Interest Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Date Received", "Currency Code",
                          "Interest Amount", "Currency Factor"));
            end;
        }
        field(53; "Interest Amount (LCY)"; Decimal)
        {
            Caption = 'Interest Amount (LCY)';
        }
        field(54; "Beginning Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Beginning Balance';
        }
        field(55; "Ending Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ending Balance';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50000; "Contract No."; Code[20])
        {
            TableRelation = "Service Contract Header"."Contract No.";

            trigger OnValidate()
            var
                lServContract: Record 5965;
                Customer: Record 18;
            begin
                //>>WINS-394
                ServiceContractHdr.RESET;
                ServiceContractHdr.SETRANGE("Contract No.", "Contract No.");
                IF ServiceContractHdr.FINDFIRST THEN BEGIN
                    "Account Type" := "Account Type"::Customer;
                    VALIDATE("Account No.", ServiceContractHdr."Customer No.");
                    // RealEstateCr
                    "Building No." := ServiceContractHdr."Building No.";
                    "Unit No." := ServiceContractHdr."Unit No.";
                    "Customer No." := ServiceContractHdr."Customer No.";
                    IF Customer.GET(ServiceContractHdr."Customer No.") THEN
                        "Customer Name" := Customer.Name;
                    // RealEstateCr
                END;

                //<<WINS-394
                /*
                //WIN325
                IF Rec."Contract No." <> xRec."Contract No." THEN BEGIN
                  //IF lServContract.GET(lServContract."Contract Type"::Contract,"Contract No.") THEN BEGIN
                  IF lServContract.GET(lServContract."Contract Type","Contract No.") THEN BEGIN
                    "Building No." := lServContract."Building No.";
                    "Unit No."     := lServContract."Unit No.";
                  END ELSE
                    BEGIN
                      CLEAR("Building No.");
                      CLEAR("Unit No.");
                    END;
                END;
                */

            end;
        }
        field(50001; "Building No."; Code[20])
        {
            TableRelation = Building;
        }
        field(50002; "Unit No."; Code[20])
        {
        }
        field(50003; "Unposted Service Invoice No."; Code[20])
        {
            TableRelation = "Service Header"."No." WHERE("Document Type" = CONST(Invoice),
                                                        "Contract No." = FIELD("Contract No."));
        }
        field(50004; "Receipt Exchange Rate"; Decimal)
        {
        }
        field(50005; Status; Option)
        {
            Description = 'WINPDC';
            Editable = false;
            OptionCaption = ' ,Received,Deposited,Reversed,Contract Cancelled, Collected,Cancelled,Revoke Cheque,Replaced,Send for Police Case,Police Case,Case Closed,Under Collection,Escalated to Legal';
            OptionMembers = " ",Received,Deposited,Reversed,"Contract Cancelled"," Collected",Cancelled,"Revoke Cheque",Replaced,"Send for Police Case","Police Case","Case Closed ","Under Collection","Escalated to Legal";
        }
        field(50007; "Reversal Reason Code"; Code[20])
        {
            Editable = false;
        }
        field(50008; "Settlement Type"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,Notify Legal Department';
            OptionMembers = " ",Cash,Cheque,"Notify Legal Department";

            trigger OnValidate()
            begin
                //SendMailtointernal("Contract No.");  //win315
            end;
        }
        field(50009; "Settlement Comments"; Text[90])
        {
        }
        field(50010; "Reversal Reason Comments"; Text[100])
        {
            Editable = false;
        }
        field(50011; "Service Contract Type"; Option)
        {
            Description = 'WINS-394';
            InitValue = Internal;
            OptionMembers = " ",Internal,External;
        }
        field(50012; Charges; Decimal)
        {
        }
        field(50013; "Amount Paid"; Decimal)
        {
        }
        field(50014; "Updated with Legal Dept"; Text[30])
        {
        }
        field(50015; "Cheque Dropped"; Boolean)
        {
            Description = 'WINPDC';
            Editable = false;
        }
        field(50016; "Payment Method"; Option)
        {
            Description = 'PDCCR';
            OptionCaption = ' ,Cheque,Bank,Cash,PDC';
            OptionMembers = " ",Cheque,Bank,Cash,PDC;
        }
        field(50017; "No. Series"; Code[20])
        {
            Description = 'WINPDC';
        }
        field(50018; "PDC Due Date"; Date)
        {
        }
        field(50019; "Contract Due Date"; Date)
        {
            Editable = false;
        }
        field(50020; "Contract Amount"; Decimal)
        {
            Editable = false;
        }
        field(50021; "Cancelled Check"; Boolean)
        {
        }
        field(50022; "Police Case No."; Text[30])
        {
        }
        field(50023; "Police Case"; Boolean)
        {
            Editable = false;
        }
        field(50024; "Closed Police Case"; Boolean)
        {
        }
        field(50025; "Transaction No."; Integer)
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Transaction No." WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50026; "Check Bounce"; Boolean)
        {
            Editable = false;
        }
        field(50027; "Customer No."; Code[20])
        {
        }
        field(50028; "Customer Name"; Text[50])
        {
        }
        field(50029; "G/L Transaction No."; Integer)
        {
            CalcFormula = Lookup("G/L Entry"."Transaction No." WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50030; "Approval Status"; Option)
        {
            CalcFormula = Lookup("Service Contract Header"."Approval Status" WHERE("Contract No." = FIELD("Contract No.")));
            FieldClass = FlowField;
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(50031; "Bal. Account Type"; Option)
        {
            OptionCaption = ' ,Customer,Vendor,G/L Account,Bank';
            OptionMembers = " ",Customer,Vendor,"G/L Account",Bank;
        }
        field(50032; "Charge Code"; Code[20])
        {
            TableRelation = "Charge Master";

            trigger OnValidate()
            var
                ChargeCode: Record "Charge Master";
            begin
                if ChargeCode.Get(Rec."Charge Code") then
                    "Charge Description" := ChargeCode."Charge Description";
            end;
        }
        field(50033; "Charge Description"; Text[50])
        {
        }
        field(50034; "Check Cancelled Befoe Posting"; Boolean)
        {
        }
        field(50035; "Apply Entry"; Boolean)
        {
            CalcFormula = Lookup("Cust. Ledger Entry"."Apply Entries" WHERE("Apply Doc. No." = FIELD("Document No."),
                                                                             "Apply Entries" = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50036; "Payment Entry"; Boolean)
        {
        }
        field(50037; "Applied Amount"; Decimal)
        {
            CalcFormula = Sum("Cust. Ledger Entry"."Apply Amount" WHERE("Apply Doc. No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50038; "Remaining Amount"; Decimal)
        {
        }
        field(50039; "App Amount"; Decimal)
        {
        }
        field(50040; "EMI Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Prinipal Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(1500000; "Template Name"; Code[20])
        {
            Caption = 'Template Name';
        }
        field(1500001; "Reversal Date"; Date)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Settlement Type", "Settlement Type"::"Notify Legal Department");
            end;
        }
        field(1500002; "Bounce Notification Sent"; Boolean)
        {
        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.", "Line Number")
        {
            Clustered = true;
            SumIndexFields = "Amount (LCY)";
        }
        key(Key1; "Template Name", "Batch Name", "Account Type", "Account No.", "Customer No.", "Line Number", "Contract No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key2; "Check Date")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key3; "Account No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key4; "Line Number")
        {
        }
        key(Key5; "Account Type", "Account No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Check Printed", FALSE);
        ClearCustVendAppID;


        ServConH.RESET;
        ServConH.SETRANGE(ServConH."Contract No.", Rec."Contract No.");
        IF ServConH.FINDFIRST THEN BEGIN
            ServConH."PDC Entry Generated" := FALSE;
            ServConH.MODIFY;
        END;
    end;

    trigger OnModify()
    begin
        TESTFIELD("Check Printed", FALSE);
        IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
            ClearCustVendAppID;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record 18;
        Vendor: Record 23;
        CurrExchRate: Record 330;
        CurrencyCode: Code[20];
        Currency: Record 4;
        GLAccount: Record 15;
        GenJnlLine: Record 81;
        JournalBatch: Page 251;
        JnlBatch: Record 232;
        GenJnlApply: Codeunit 225;
        CustEntrySetApplID: Codeunit 101;
        VendEntrySetApplID: Codeunit 111;
        TempAmount: Decimal;
        AccNo: Code[20];
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        ApplyCustEntries: Page 232;
        CustLedgEntry: Record 21;
        ApplyVendEntries: Page 233;
        VendLedgEntry: Record 25;
        PurchSetup: Record 312;
        Text002: Label 'cannot be specified without %1';
        Text009: Label 'LCY';
        Text003: Label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text004: Label 'Do you wish to continue?';
        Text005: Label 'The update has been interrupted to respect the warning.';
        Text006: Label 'must be negative';
        Text007: Label 'must be positive';
        //DimMgt: Codeunit 408;
        ServHeader: Record 5900;
        ServiceContractHdr: Record 5965;
        GeneralLedgerSetup: Record 98;
        NoSeriesMgt: Codeunit 396;
        ServConH: Record 5965;

    local procedure GetCurrency()
    begin
        CurrencyCode := "Currency Code";

        IF CurrencyCode = '' THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        END ELSE
            IF CurrencyCode <> Currency.Code THEN BEGIN
                Currency.GET(CurrencyCode);
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
    end;

    /* [Scope('Internal')] */
    procedure SetGenJnlLine(var PostDatedCheck: Record 50011)
    begin
        //Win513++
        //WITH PostDatedCheck DO BEGIN
        //Win513--
        // GenJnlLine."Line No." := "Line Number";
        // GenJnlLine."Journal Batch Name" := 'Postdated';
        // IF "Account Type" = "Account Type"::Customer THEN
        //     GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer
        // ELSE
        //     IF "Account Type" = "Account Type"::Vendor THEN
        //         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor
        //     ELSE
        //         IF "Account Type" = "Account Type"::"G/L Account" THEN
        //             GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        // GenJnlLine."Account No." := "Account No.";
        // GenJnlLine."Document No." := "Document No.";
        // GenJnlLine."Posting Date" := "Check Date";
        // GenJnlLine.Amount := Amount;
        // GenJnlLine."Document No." := "Document No.";
        // GenJnlLine.Description := Description;
        // IF "Currency Code" = '' THEN
        //     GenJnlLine."Amount (LCY)" := Amount
        // ELSE
        //     GenJnlLine."Amount (LCY)" := ROUND(
        //         CurrExchRate.ExchangeAmtFCYToLCY(
        //           "Date Received", "Currency Code",
        //           Amount, "Currency Factor"));
        // GenJnlLine."Currency Code" := "Currency Code";
        // GenJnlLine."Applies-to Doc. Type" := "Applies-to Doc. Type";
        // GenJnlLine."Applies-to Doc. No." := "Applies-to Doc. No.";
        // GenJnlLine."Applies-to ID" := "Applies-to ID";
        // GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        // GenJnlLine."Post Dated Check" := TRUE;
        // GenJnlLine."Check No." := "Check No.";
        // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        // GenJnlLine."Bal. Account No." := "Bank Account";
        // //Win513++
        // //END;
        // //Win513++
    end;

    /*  [Scope('Internal')] */
    procedure ClearCustVendAppID()
    var
        TempCustLedgEntry: Record 21;
        TempVendLedgEntry: Record 25;
        CustEntryEdit: Codeunit 103;
        VendEntryEdit: Codeunit 113;
    begin
        IF "Account Type" = "Account Type"::Customer THEN
            AccType := AccType::Customer;
        IF "Account Type" = "Account Type"::"G/L Account" THEN
            AccType := AccType::"G/L Account";
        IF "Account Type" = "Account Type"::Vendor THEN
            AccType := AccType::Vendor;

        AccNo := "Account No.";
        CASE AccType OF
            AccType::Customer:
                IF "Applies-to ID" <> '' THEN BEGIN
                    CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open);
                    CustLedgEntry.SETRANGE("Customer No.", AccNo);
                    CustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    IF CustLedgEntry.FINDFIRST THEN BEGIN
                        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                        CustLedgEntry."Accepted Payment Tolerance" := 0;
                        CustLedgEntry."Amount to Apply" := 0;
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    END;
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN BEGIN
                        CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                        CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                        CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                        CustLedgEntry.SETRANGE("Customer No.", AccNo);
                        CustLedgEntry.SETRANGE(Open, TRUE);
                        IF CustLedgEntry.FINDFIRST THEN BEGIN
                            CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                            CustLedgEntry."Accepted Payment Tolerance" := 0;
                            CustLedgEntry."Amount to Apply" := 0;
                            CustEntryEdit.RUN(CustLedgEntry);
                        END;
                    END;
            AccType::Vendor:
                IF "Applies-to ID" <> '' THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
                    VendLedgEntry.SETRANGE("Vendor No.", AccNo);
                    VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                        VendLedgEntry."Accepted Payment Tolerance" := 0;
                        VendLedgEntry."Amount to Apply" := 0;
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    END;
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN BEGIN
                        VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                        VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                        VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
                        VendLedgEntry.SETRANGE(Open, TRUE);
                        IF VendLedgEntry.FINDFIRST THEN BEGIN
                            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                            VendLedgEntry."Accepted Payment Tolerance" := 0;
                            VendLedgEntry."Amount to Apply" := 0;
                            VendEntryEdit.RUN(VendLedgEntry);
                        END;
                    END;
        END;
    end;

    /* [Scope('Internal')] */
    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        IF CurrencyCode <> '' THEN
            EXIT(CurrencyCode);

        EXIT(Text009);
    end;

    /* [Scope('Internal')] */
    procedure ShowDimensions()
    begin
        //"Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Document No."));
    end;

    /* [Scope('Internal')] */
    procedure SendMailtointernal(var DocNo: Code[20])
    var
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'Email Id is blank for the Customer %1';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];
        lText002: Label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record 231;
        lUserSetup: Record 91;
        lUser: Record 2000000120;
        GeneralLedgerSetup: Record 98;
    begin
        IF ("Settlement Type" = "Settlement Type"::Cash) OR ("Settlement Type" = "Settlement Type"::Cheque) THEN BEGIN
            TESTFIELD("Settlement Comments");
            IF NOT CONFIRM('This will inform Legal team and send mail that settlement is done against this PDC.Are you sure on this?', FALSE) THEN
                ERROR('Change aborted');
        END
        ELSE
            EXIT;

        lUserSetup.GET(USERID);
        lUserSetup.TESTFIELD("E-Mail");

        lUser.RESET;
        lUser.SETRANGE("User Name", USERID);
        IF lUser.FINDSET THEN;

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Legal Department Mail ID");
        GeneralLedgerSetup.TESTFIELD("Property Management Mail ID");

        Recipients.Add(GeneralLedgerSetup."Legal Department Mail ID");
        Recipients.Add(GeneralLedgerSetup."Property Management Mail ID");
        //SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", GeneralLedgerSetup."Legal Department Mail ID", 'Settlement of Contract No ' + DocNo, '', TRUE);
        //SMTPMail.AddRecipients(GeneralLedgerSetup."Property Management Mail ID");
        Subject := 'Settlement of Contract No ' + DocNo;
        Body := 'Hi Team, <br><br> Good day! <br><Br>';
        Body += 'Just to notify that settlement of Contract No ' + DocNo + ' is done and settlement comment are as below';
        Body += 'Settlement Comments <br><Br> Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';
        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        MESSAGE(lText002);
    end;

    /* [Scope('Internal')] */
    procedure Sendbouncemailaftergraceperiod(var DocNo: Code[20])
    var
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'Email Id is blank for the Customer %1';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lText002: Label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record 231;
        lUserSetup: Record 91;
        lUser: Record 2000000120;
        GeneralLedgerSetup: Record 98;
    begin
        IF ("Settlement Type" = "Settlement Type"::Cash) OR ("Settlement Type" = "Settlement Type"::Cheque) THEN BEGIN
            TESTFIELD("Settlement Comments");
            IF NOT CONFIRM('This will inform Legal team and send mail that settlement is done against this PDC.Are you sure on this?', FALSE) THEN
                ERROR('Change aborted');
        END
        ELSE
            EXIT;

        lUserSetup.GET(USERID);
        lUserSetup.TESTFIELD("E-Mail");

        lUser.RESET;
        lUser.SETRANGE("User Name", USERID);
        IF lUser.FINDSET THEN;

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Legal Department Mail ID");
        GeneralLedgerSetup.TESTFIELD("Property Management Mail ID");

        //SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", GeneralLedgerSetup."Legal Department Mail ID", 'Pending Settlement of Cheque No. ' + DocNo, '', TRUE);
        //SMTPMail.AddRecipients(GeneralLedgerSetup."Property Management Mail ID");

        Recipients.Add(GeneralLedgerSetup."Legal Department Mail ID");
        Recipients.Add(GeneralLedgerSetup."Property Management Mail ID");
        Subject := 'Pending Settlement of Cheque No. ' + DocNo;
        Body := 'Hi Team, <br><br> Good day! <br><Br>';
        Body += 'Just to notify that settlement of Cheque No ' + DocNo + ' is pending for more than 30 days and required action need to be taken.';
        Body += '<br><Br> Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';
        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        "Bounce Notification Sent" := TRUE;
        MODIFY;
    end;

    /* [Scope('Internal')] */
    procedure AssistEdit(OldPostDatedCheckLine: Record 50011): Boolean
    begin
        //WINPDC++
        GeneralLedgerSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldPostDatedCheckLine."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("Document No.");
            EXIT(TRUE);
        END;
        //WINPDC--
    end;

    /* [Scope('Internal')] */
    procedure TestNoSeries()
    begin
        //WINPDC++
        //SalesSetup.GET;
        //SalesSetup.TESTFIELD("RDK Loan Document No.");
        //WINPDC--
    end;

    /* [Scope('Internal')] */
    procedure GetNoSeriesCode(): Code[20]
    begin
        //WINPDC++
        //SalesSetup.GET;
        //SalesSetup.TESTFIELD("RDK Loan Document No.");
        //WINPDC--
    end;
}

