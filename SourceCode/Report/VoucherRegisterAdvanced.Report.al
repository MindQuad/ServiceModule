report 50054 "Voucher Register Advanced"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VoucherRegisterAdvanced.rdl';
    Caption = 'Voucher Register';

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(No_GLReg; "No.")
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = SORTING("Document No.", "Posting Date", Amount)
                                    ORDER(Descending);
                column(VoucherSourceDesc; SourceDesc + ' Voucher')
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(PostingDateFormatted; 'Date: ' + FORMAT("Posting Date"))
                {
                }
                column(CompanyInformationAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + '  ' + CompanyInformation.City)
                {
                }
                column(CompanyInformationName; CompanyInformation.Name)
                {
                }
                column(CreditAmount_GLEntry; "Credit Amount")
                {
                }
                column(DebitAmount_GLEntry; "Debit Amount")
                {
                }
                column(DrText; DrText)
                {
                }
                column(GLAccName; GLAccName)
                {
                }
                column(CrText; CrText)
                {
                }
                column(DebitAmountTotal; DebitAmountTotal)
                {
                }
                column(CreditAmountTotal; CreditAmountTotal)
                {
                }
                column(ChequeNoDateFormatted; 'Cheque No: ' + ChequeNo + '  Dated: ' + FORMAT(ChequeDate))
                {
                }
                column(ChequeNo; ChequeNo)
                {
                }
                column(ChequeDate; ChequeDate)
                {
                }
                column(RsNumberText1NumberText2; 'Rs. ' + NumberText[1] + ' ' + NumberText[2])
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                column(PostingDate_GLEntry; "Posting Date")
                {
                }
                column(TransactionNo_GLEntry; "Transaction No.")
                {
                }
                column(VoucherNoCaption; VoucherNoCaptionLbl)
                {
                }
                column(CreditAmountCaption; CreditAmountCaptionLbl)
                {
                }
                column(DebitAmountCaption; DebitAmountCaptionLbl)
                {
                }
                column(ParticularsCaption; ParticularsCaptionLbl)
                {
                }
                column(AmountinwordsCaption; AmountinwordsCaptionLbl)
                {
                }
                column(PreparedbyCaption; PreparedbyCaptionLbl)
                {
                }
                column(CheckedbyCaption; CheckedbyCaptionLbl)
                {
                }
                column(ApprovedbyCaption; ApprovedbyCaptionLbl)
                {
                }
                dataitem(LineNarration; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD("Transaction No."),
                                   "Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.");
                    column(Narration_LineNarration; Narration)
                    {
                    }
                    column(PrintLineNarration; PrintLineNarration)
                    {
                    }
                }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(IntegerOccurcesCaption; IntegerOccurcesCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PageLoop := PageLoop - 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLEntry.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                        GLEntry.ASCENDING(FALSE);
                        GLEntry.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                        GLEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        GLEntry.SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                        GLEntry.FINDLAST;
                        IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                            CurrReport.BREAK;

                        SETRANGE(Number, 1, PageLoop)
                    end;
                }
                dataitem(PostedNarration1; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD("Transaction No.");
                    DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.")
                                        WHERE("Entry No." = FILTER(0));
                    column(Narration_PostedNarration; Narration)
                    {
                    }
                    column(NarrationCaption; NarrationCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PostedNarrationOne := Narration <> '';
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLEntry.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                        GLEntry.ASCENDING(FALSE);
                        GLEntry.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                        GLEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        GLEntry.FINDLAST;
                        IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                            CurrReport.BREAK;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                    IF Amount < 0 THEN BEGIN
                        CrText := 'To';
                        DrText := '';
                    END ELSE BEGIN
                        CrText := '';
                        DrText := 'Dr';
                    END;
                    SourceDesc := '';
                    IF "Source Code" <> '' THEN BEGIN
                        SourceCode.GET("Source Code");
                        SourceDesc := SourceCode.Description;
                    END;

                    PageLoop := PageLoop - 1;
                    LinesPrinted := LinesPrinted + 1;

                    ChequeNo := '';
                    ChequeDate := 0D;
                    IF ("Source No." <> '') AND ("Source Type" = "Source Type"::"Bank Account") THEN BEGIN
                        IF BankAccLedgEntry.GET("Entry No.") THEN BEGIN
                            //ChequeNo := BankAccLedgEntry."Cheque No.";
                            //ChequeDate := BankAccLedgEntry."Cheque Date";
                        END;
                    END;

                    PrintBody5 := (ChequeNo <> '') AND (ChequeDate <> 0D);
                    IF PrintBody5 OR PrintLineNarration THEN BEGIN
                        PageLoop := PageLoop - 1;
                        LinesPrinted := LinesPrinted + 1;
                    END;


                    IF PostingDate <> "Posting Date" THEN BEGIN
                        PostingDate := "Posting Date";
                        TotalDebitAmt := 0;
                    END;
                    IF DocumentNo <> "Document No." THEN BEGIN
                        DocumentNo := "Document No.";
                        TotalDebitAmt := 0;
                    END;

                    IF PostingDate = "Posting Date" THEN BEGIN
                        InitTextVariable;
                        TotalDebitAmt += "Debit Amount";
                        FormatNoText(NumberText, ABS(TotalDebitAmt), '');
                        PageLoop := NUMLines;
                        LinesPrinted := 0;
                    END;

                    IF (PrePostingDate <> "Posting Date") OR (PreDocumentNo <> "Document No.") THEN BEGIN
                        DebitAmountTotal := 0;
                        CreditAmountTotal := 0;
                        PrePostingDate := "Posting Date";
                        PreDocumentNo := "Document No.";
                        PageLoop := NUMLines;
                        LinesPrinted := 0;
                        PageLoop := PageLoop - 1;
                    END;
                    DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                    CreditAmountTotal := CreditAmountTotal + "Credit Amount";

                    LinesPrinted := LinesPrinted + 1;

                    InitTextVariable();
                    FormatNoText(NumberText, ABS(DebitAmountTotal), '');
                end;

                trigger OnPreDataItem()
                begin
                    NUMLines := 13;
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                    TotalDebitAmt := 0;
                    SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        Caption = 'PrintLineNarration';
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
        CompanyInformation.GET;
    end;

    var
        CompanyInformation: Record 79;
        GLEntry: Record 17;
        SourceCode: Record 230;
        BankAccLedgEntry: Record 271;
        GLAccName: Text[50];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: array[2] of Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[20];
        ChequeDate: Date;
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
        PrintLineNarration: Boolean;
        PrePostingDate: Date;
        PreDocumentNo: Code[30];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrintBody5: Boolean;
        PostedNarrationOne: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        VoucherNoCaptionLbl: Label 'Voucher No. :';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        ParticularsCaptionLbl: Label 'Particulars';
        AmountinwordsCaptionLbl: Label 'Amount (in words):';
        PreparedbyCaptionLbl: Label 'Prepared by:';
        CheckedbyCaptionLbl: Label 'Checked by:';
        ApprovedbyCaptionLbl: Label 'Approved by:';
        IntegerOccurcesCaptionLbl: Label 'IntegerOccurcesCaption';
        NarrationCaptionLbl: Label 'Narration :';


    //Win513++
    //procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    procedure FindGLAccName("Source Type": Enum "Gen. Journal Source Type"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    //Win513--
    var
        AccName: Text[50];
        VendLedgEntry: Record 25;
        Vend: Record 23;
        CustLedgEntry: Record 21;
        Cust: Record 18;
        BankLedgEntry: Record 271;
        Bank: Record 270;
        FALedgEntry: Record 5601;
        FA: Record 5600;
        GLAccount: Record 15;
    begin
        IF "Source Type" = "Source Type"::Vendor THEN
            IF VendLedgEntry.GET("Entry No.") THEN BEGIN
                Vend.GET("Source No.");
                AccName := Vend.Name;
            END ELSE BEGIN
                GLAccount.GET("G/L Account No.");
                AccName := GLAccount.Name;
            END
        ELSE
            IF "Source Type" = "Source Type"::Customer THEN
                IF CustLedgEntry.GET("Entry No.") THEN BEGIN
                    Cust.GET("Source No.");
                    AccName := Cust.Name;
                END ELSE BEGIN
                    GLAccount.GET("G/L Account No.");
                    AccName := GLAccount.Name;
                END
            ELSE
                IF "Source Type" = "Source Type"::"Bank Account" THEN
                    IF BankLedgEntry.GET("Entry No.") THEN BEGIN
                        Bank.GET("Source No.");
                        AccName := Bank.Name;
                    END ELSE BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END
                ELSE
                    IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
                        FALedgEntry.RESET;
                        FALedgEntry.SETCURRENTKEY("G/L Entry No.");
                        FALedgEntry.SETRANGE("G/L Entry No.", "Entry No.");
                        IF FALedgEntry.FINDFIRST THEN BEGIN
                            FA.GET("Source No.");
                            AccName := FA.Description;
                        END ELSE BEGIN
                            GLAccount.GET("G/L Account No.");
                            AccName := GLAccount.Name;
                        END;
                    END ELSE BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END;

        IF "Source Type" = "Source Type"::" " THEN BEGIN
            GLAccount.GET("G/L Account No.");
            AccName := GLAccount.Name;
        END;

        EXIT(AccName);
    end;


    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record 4;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        IF CurrencyCode <> '' THEN BEGIN
            Currency.GET(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Numeric Description");
        END ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);
        IF (CurrencyCode <> '') THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Numeric Description" + ' ONLY')
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text16529, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;
}

