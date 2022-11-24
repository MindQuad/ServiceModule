report 50053 "Ledger Advanced"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LedgerAdvanced.rdl';
    Caption = 'Ledger';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("Account Type" = FILTER(Posting));
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(TodayFormatted; FORMAT(TODAY, 0, 4))
            {
            }
            column(CompInfoName; CompInfo.Name)
            {
            }
            column(LedgerName; Name + '  ' + 'Ledger')
            {
            }
            column(GetFilters; GETFILTERS)
            {
            }
            column(LocationFilter; LocationFilter)
            {
            }
            column(OpeningBalDesc; 'Opening Balance As On' + ' ' + FORMAT(GETRANGEMIN("Date Filter")))
            {
            }
            column(OpeningDRBal; OpeningDRBal)
            {
            }
            column(OpeningCRBal; OpeningCRBal)
            {
            }
            column(DRCRBal; ABS(OpeningDRBal - OpeningCRBal))
            {
            }
            column(DrCrTextBalance; DrCrTextBalance)
            {
            }
            column(OpeningCRBalGLEntryCreditAmt; OpeningCRBal + "G/L Entry"."Credit Amount")
            {
            }
            column(OpeningDRBalGLEntryDebitAmt; OpeningDRBal + "G/L Entry"."Debit Amount")
            {
            }
            column(SumOpeningDRCRBalTransDRCR; ABS(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
            {
            }
            column(DrCrTextBalance2; DrCrTextBalance2)
            {
            }
            column(TotalDebitAmount; TotalDebitAmount)
            {
            }
            column(TotalCreditAmount; TotalCreditAmount)
            {
            }
            column(TransDebits; TransDebits)
            {
            }
            column(TransCredits; TransCredits)
            {
            }
            column(No_GLAccount; "No.")
            {
            }
            column(DateFilter_GLAccount; "Date Filter")
            {
            }
            column(GlobalDim1Filter_GLAccount; "Global Dimension 1 Filter")
            {
            }
            column(GlobalDim2Filter_GLAccount; "Global Dimension 2 Filter")
            {
            }
            column(PageNoCaption; PageCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            column(Debit_AmountCaption; DebitAmountCaptionLbl)
            {
            }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            {
            }
            column(AccountNameCaption; AccountNameCaptionLbl)
            {
            }
            column(VoucherTypeCaption; VoucherTypeCaptionLbl)
            {
            }
            column(LocationCodeCaption; LocationCodeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Closing_BalanceCaption; Closing_BalanceCaptionLbl)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter"),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date")
                                    ORDER(Ascending);
                column(ControlAccountName; ControlAccountName)
                {
                }
                column(PostingDate_GLEntry; FORMAT("Posting Date"))
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(AccountName; AccountName)
                {
                }
                column(DebitAmount_GLEntry; "Debit Amount")
                {
                }
                column(CreditAmoutnt_GLEntry; "Credit Amount")
                {
                }
                column(SourceDesc; SourceDesc)
                {
                }
                column(LocationCode_GLEntry; '')
                {
                }
                column(SumOpeningDRCRBalTransDRCR2; ABS(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
                {
                }
                column(DrCrTextBalance3; DrCrTextBalance)
                {
                }
                column(OneEntryRecord; OneEntryRecord)
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(ControlAccountName1; ControlAccountName)
                    {
                    }
                    column(PostingDate_GLEntry2; FORMAT(GLEntry."Posting Date"))
                    {
                    }
                    column(GLEntryDocumentNo; GLEntry."Document No.")
                    {
                    }
                    column(AccountName2; AccountName)
                    {
                    }
                    column(GLEntryDebitAmount; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(GLEntryCreditAmount; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(DetailAmt; ABS(DetailAmt))
                    {
                    }
                    column(SourceDesc2; SourceDesc)
                    {
                    }
                    column(DrCrText; DrCrText)
                    {
                    }
                    column(LocationCode_GLEntry2; '')
                    {
                    }
                    column(SumOpeningDRCRBalTransDRCR3; ABS(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
                    {
                    }
                    column(DrCrTextBalance4; DrCrTextBalance)
                    {
                    }
                    column(FirstRecord; FirstRecord)
                    {
                    }
                    column(Amount_GLEntry2; ABS(GLEntry.Amount))
                    {
                    }
                    column(PrintDetail; PrintDetail)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DrCrText := '';
                        IF Number > 1 THEN BEGIN
                            FirstRecord := FALSE;
                            GLEntry.NEXT;
                        END;
                        IF FirstRecord AND (ControlAccountName <> '') THEN BEGIN
                            DetailAmt := 0;
                            IF PrintDetail THEN
                                DetailAmt := GLEntry.Amount;
                            IF DetailAmt > 0 THEN
                                DrCrText := 'Dr';
                            IF DetailAmt < 0 THEN
                                DrCrText := 'Cr';

                            IF NOT PrintDetail THEN
                                AccountName := Text16500;
                            //ELSE
                            //AccountName := Daybook.FindGLAccName(GLEntry."Source Type",GLEntry."Entry No.",GLEntry."Source No.",GLEntry."G/L Account No.");

                            DrCrTextBalance := '';
                            IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 THEN
                                DrCrTextBalance := 'Dr';
                            IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 THEN
                                DrCrTextBalance := 'Cr';
                        END ELSE
                            IF FirstRecord AND (ControlAccountName = '') THEN BEGIN
                                DetailAmt := 0;
                                IF PrintDetail THEN
                                    DetailAmt := GLEntry.Amount;

                                IF DetailAmt > 0 THEN
                                    DrCrText := 'Dr';
                                IF DetailAmt < 0 THEN
                                    DrCrText := 'Cr';

                                IF NOT PrintDetail THEN
                                    AccountName := Text16500;
                                //ELSE
                                //AccountName := Daybook.FindGLAccName(GLEntry."Source Type",GLEntry."Entry No.",GLEntry."Source No.",GLEntry."G/L Account No.");

                                DrCrTextBalance := '';
                                IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 THEN
                                    DrCrTextBalance := 'Dr';
                                IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 THEN
                                    DrCrTextBalance := 'Cr';
                            END;

                        IF PrintDetail AND (NOT FirstRecord) THEN BEGIN
                            IF GLEntry.Amount > 0 THEN
                                DrCrText := 'Dr';
                            IF GLEntry.Amount < 0 THEN
                                DrCrText := 'Cr';
                            //AccountName := Daybook.FindGLAccName(GLEntry."Source Type",GLEntry."Entry No.",GLEntry."Source No.",GLEntry."G/L Account No.");
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, GLEntry.COUNT);
                        FirstRecord := TRUE;

                        IF GLEntry.COUNT = 1 THEN
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Posted Narration"; "Posted Narration")
                {
                    DataItemLink = "Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.")
                                        ORDER(Ascending);
                    column(Narration_PostedNarration; Narration)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        IF NOT PrintLineNarration THEN
                            CurrReport.BREAK;
                    end;
                }
                dataitem(PostedNarration1; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD("Transaction No.");
                    DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.")
                                        WHERE("Entry No." = FILTER(0));
                    column(Narration_PostedNarration1; Narration)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        IF NOT PrintVchNarration THEN
                            CurrReport.BREAK;

                        GLEntry2.RESET;
                        GLEntry2.SETCURRENTKEY("Posting Date", "Source Code", "Transaction No.");
                        GLEntry2.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                        GLEntry2.SETRANGE("Source Code", "G/L Entry"."Source Code");
                        GLEntry2.SETRANGE("Transaction No.", "G/L Entry"."Transaction No.");
                        GLEntry2.FINDLAST;
                        IF NOT (GLEntry2."Entry No." = "G/L Entry"."Entry No.") THEN
                            CurrReport.BREAK;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GLEntry.SETRANGE("Transaction No.", "Transaction No.");
                    GLEntry.SETFILTER("Entry No.", '<>%1', "Entry No.");
                    IF GLEntry.FINDFIRST THEN;

                    DrCrText := '';
                    ControlAccount := FALSE;
                    OneEntryRecord := TRUE;
                    IF GLEntry.COUNT > 1 THEN
                        OneEntryRecord := FALSE;

                    GLAcc.GET("G/L Account No.");
                    ControlAccount := FindControlAccount("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                    IF ControlAccount THEN
                        //ControlAccountName := Daybook.FindGLAccName("Source Type","Entry No.","Source No.","G/L Account No.");

                        IF Amount > 0 THEN
                            TransDebits := TransDebits + Amount;
                    IF Amount < 0 THEN
                        TransCredits := TransCredits - Amount;

                    SourceDesc := '';
                    IF "Source Code" <> '' THEN BEGIN
                        SourceCode.GET("Source Code");
                        SourceDesc := SourceCode.Description;
                    END;

                    AccountName := '';
                    IF OneEntryRecord AND (ControlAccountName <> '') THEN BEGIN
                        //AccountName := Daybook.FindGLAccName(GLEntry."Source Type",GLEntry."Entry No.",GLEntry."Source No.",GLEntry."G/L Account No.");
                        DrCrTextBalance := '';
                        IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 THEN
                            DrCrTextBalance := 'Dr';
                        IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 THEN
                            DrCrTextBalance := 'Cr';
                    END ELSE
                        IF OneEntryRecord AND (ControlAccountName = '') THEN BEGIN
                            //AccountName := Daybook.FindGLAccName(GLEntry."Source Type",GLEntry."Entry No.",GLEntry."Source No.",GLEntry."G/L Account No.");
                            DrCrTextBalance := '';
                            IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 THEN
                                DrCrTextBalance := 'Dr';
                            IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 THEN
                                DrCrTextBalance := 'Cr';
                        END;

                    IF GLAccountNo <> "G/L Account"."No." THEN
                        GLAccountNo := "G/L Account"."No.";

                    IF GLAccountNo = "G/L Account"."No." THEN BEGIN
                        DrCrTextBalance2 := '';
                        IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 THEN
                            DrCrTextBalance2 := 'Dr';
                        IF OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 THEN
                            DrCrTextBalance2 := 'Cr';
                    END;

                    TotalDebitAmount += "G/L Entry"."Debit Amount";
                    TotalCreditAmount += "G/L Entry"."Credit Amount";
                end;

                trigger OnPostDataItem()
                begin
                    AccountChanged := TRUE;
                end;

                trigger OnPreDataItem()
                begin
                    IF LocationCode <> '' THEN
                        //SETFILTER("Location Code",LocationCode);
                        GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Transaction No.");
                    TotalDebitAmount := 0;
                    TotalCreditAmount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF AccountNo <> "No." THEN BEGIN
                    AccountNo := "No.";
                    OpeningDRBal := 0;
                    OpeningCRBal := 0;

                    GLEntry2.RESET;
                    //GLEntry2.SETCURRENTKEY("G/L Account No.","Business Unit Code","Global Dimension 1 Code",
                    //"Global Dimension 2 Code","Close Income Statement Dim. ID","Posting Date","Location Code");
                    GLEntry2.SETRANGE("G/L Account No.", "No.");
                    GLEntry2.SETFILTER("Posting Date", '%1..%2', 0D, CLOSINGDATE(GETRANGEMIN("Date Filter") - 1));
                    IF "Global Dimension 1 Filter" <> '' THEN
                        GLEntry2.SETFILTER("Global Dimension 1 Code", "Global Dimension 1 Filter");
                    IF "Global Dimension 2 Filter" <> '' THEN
                        GLEntry2.SETFILTER("Global Dimension 2 Code", "Global Dimension 2 Filter");
                    IF LocationCode <> '' THEN
                        //GLEntry2.SETFILTER("Location Code",LocationCode);

                        GLEntry2.CALCSUMS(Amount);
                    IF GLEntry2.Amount > 0 THEN
                        OpeningDRBal := GLEntry2.Amount;
                    IF GLEntry2.Amount < 0 THEN
                        OpeningCRBal := -GLEntry2.Amount;

                    DrCrTextBalance := '';
                    IF OpeningDRBal - OpeningCRBal > 0 THEN
                        DrCrTextBalance := 'Dr';
                    IF OpeningDRBal - OpeningCRBal < 0 THEN
                        DrCrTextBalance := 'Cr';
                END;
            end;

            trigger OnPreDataItem()
            begin
                //Win513++
                // CurrReport.CREATETOTALS(TransDebits, TransCredits, "G/L Entry"."Debit Amount", "G/L Entry"."Credit Amount");
                //Win513--
                IF LocationCode <> '' THEN
                    LocationFilter := 'Location Code: ' + LocationCode;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintDetail; PrintDetail)
                    {
                        Caption = 'Print Detail';
                    }
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        Caption = 'Print Line Narration';
                    }
                    field(PrintVchNarration; PrintVchNarration)
                    {
                        Caption = 'Print Voucher Narration';
                    }
                    field(LocationCode; LocationCode)
                    {
                        Caption = 'Location Code';
                        TableRelation = Location;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompInfo.GET;
    end;

    var
        CompInfo: Record 79;
        GLAcc: Record 15;
        GLEntry: Record 17;
        GLEntry2: Record 17;
        SourceCode: Record 230;
        OpeningDRBal: Decimal;
        OpeningCRBal: Decimal;
        TransDebits: Decimal;
        TransCredits: Decimal;
        OneEntryRecord: Boolean;
        FirstRecord: Boolean;
        PrintDetail: Boolean;
        PrintLineNarration: Boolean;
        PrintVchNarration: Boolean;
        DetailAmt: Decimal;
        AccountName: Text[100];
        ControlAccountName: Text[100];
        ControlAccount: Boolean;
        SourceDesc: Text[50];
        DrCrText: Text[2];
        DrCrTextBalance: Text[2];
        LocationCode: Code[20];
        LocationFilter: Text[100];
        Text16500: Label 'As per Details';
        AccountChanged: Boolean;
        AccountNo: Code[20];
        DrCrTextBalance2: Text[2];
        GLAccountNo: Code[20];
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;
        PageCaptionLbl: Label 'Page';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        AccountNameCaptionLbl: Label 'Account Name';
        VoucherTypeCaptionLbl: Label 'Voucher Type';
        LocationCodeCaptionLbl: Label 'Location Code';
        BalanceCaptionLbl: Label 'Balance';
        Closing_BalanceCaptionLbl: Label 'Closing Balance';


    //Win513++
    //procedure FindControlAccount("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Boolean
    procedure FindControlAccount("Source Type": Enum "Gen. Journal Source Type"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Boolean
    //Win513--
    var
        VendLedgEntry: Record 25;
        CustLedgEntry: Record 21;
        BankLedgEntry: Record 271;
        FALedgEntry: Record 5601;
        SubLedgerFound: Boolean;
    begin
        IF "Source Type" = "Source Type"::Vendor THEN BEGIN
            IF VendLedgEntry.GET("Entry No.") THEN
                SubLedgerFound := TRUE;
        END;
        IF "Source Type" = "Source Type"::Customer THEN BEGIN
            IF CustLedgEntry.GET("Entry No.") THEN
                SubLedgerFound := TRUE;
        END;
        IF "Source Type" = "Source Type"::"Bank Account" THEN
            IF BankLedgEntry.GET("Entry No.") THEN BEGIN
                SubLedgerFound := TRUE;
            END;
        IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
            FALedgEntry.RESET;
            FALedgEntry.SETCURRENTKEY("G/L Entry No.");
            FALedgEntry.SETRANGE("G/L Entry No.", "Entry No.");
            IF FALedgEntry.FINDFIRST THEN
                SubLedgerFound := TRUE;
        END;
        EXIT(SubLedgerFound);
    end;
}

