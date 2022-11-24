report 50051 "Turnover report by Dimensions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TurnoverreportbyDimensions.rdl';
    Caption = 'Turnover report by Glob. Dim.';
    TransactionType = Update;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Account Type" = FILTER(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(tcText002___gtePeriodText; Text002 + PeriodText)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            //Win513++
            // column(CurrReport_PAGENO; CurrReport.PAGENO)
            // {
            // }
            //Win513--
            column(Filters; Filters)
            {
            }
            column(gdaDateFrom; DateFrom)
            {
            }
            column(gdaDateStartFisk; DateStartFisk)
            {
            }
            column(gdaDateTo; DateTo)
            {
            }
            column(gteDimCaption; DimCaption)
            {
            }
            column(AccountNo; "No.")
            {
            }
            column(AccDescription; Name)
            {
            }
            column(Synthesis; Synthesis)
            {
            }
            column(Group; Group)
            {
            }
            column(Class; Class)
            {
            }
            column(PrintSynthesisTotals; PrintSynthesis)
            {
            }
            column(PrintDimensions; PrintDim)
            {
            }
            column(SynthesisTotalText; STRSUBSTNO(Text001, Synthesis))
            {
            }
            column(GroupTotalText; STRSUBSTNO(Text001, Group))
            {
            }
            column(ClassTotalText; STRSUBSTNO(Text001, Class))
            {
            }
            column(Col1TotalInitialAmt; Initial2Debit - Initial2Credit)
            {
            }
            column(Col2InitialAmt; InitialDebit - InitialCredit)
            {
            }
            column(Col3Debit; Debit)
            {
            }
            column(Col4Credit; Credit)
            {
            }
            column(Col5DebitTotal; Debit2)
            {
            }
            column(Col6CreditTotal; Credit2)
            {
            }
            column(Col7EndAmt; FinishedDebit - FinishedCredit)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ReportCaption; General_Ledger_by_Global_DimensionCaptionLbl)
            {
            }
            column(AccNoCaption; AccountCaptionLbl)
            {
            }
            column(Col1TotalInitialAmtCaption; Initial2Debit_gdeInitial2CreditCaptionLbl)
            {
            }
            column(Col2InitialAmtCaption; InitialDebit_gdeInitialCreditCaptionLbl)
            {
            }
            column(Col3DebitCaption; DebitCaptionLbl)
            {
            }
            column(Col4CreditCaption; CreditCaptionLbl)
            {
            }
            column(Col5DebitTotalCaption; Debit2CaptionLbl)
            {
            }
            column(Col6CreditTotalCaption; Credit2CaptionLbl)
            {
            }
            column(Col7EndAmtCaption; FinishedDebit_gdeFinishedCreditCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem(Dimensions; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(DimCodeText; DimCodeText)
                {
                }
                column(DimCol1TotalInitialAmt; Initial2Debit - Initial2Credit)
                {
                }
                column(DimCol2InitialAmt; InitialDebit - InitialCredit)
                {
                }
                column(DimCol3Debit; Debit)
                {
                }
                column(DimCol4Credit; Credit)
                {
                }
                column(DimCol5DebitTotal; Debit2)
                {
                }
                column(DimCol6CreditTotal; Credit2)
                {
                }
                column(DimCol7EndAmt; FinishedDebit - FinishedCredit)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                        DimValue.FINDSET
                    ELSE
                        DimValue.NEXT;

                    IF (Number < DimCount) OR (NOT PrintEmptyDim) THEN BEGIN
                        IF Detail = Detail::GlDim1 THEN
                            "G/L Account".SETFILTER("Global Dimension 1 Filter", DimValue.Code);
                        IF Detail = Detail::GlDim2 THEN
                            "G/L Account".SETFILTER("Global Dimension 2 Filter", DimValue.Code);
                        DimCodeText := DimValue.Code;
                    END ELSE BEGIN
                        IF Detail = Detail::GlDim1 THEN
                            "G/L Account".SETFILTER("Global Dimension 1 Filter", '''''');
                        IF Detail = Detail::GlDim2 THEN
                            "G/L Account".SETFILTER("Global Dimension 2 Filter", '''''');
                        DimCodeText := OthersCaptionLbl;
                    END;

                    CalculateValues;

                    IF (InitialDebit = 0) AND (InitialCredit = 0) AND
                       (Initial2Debit = 0) AND (Initial2Credit = 0) AND
                       (Debit = 0) AND (Credit = 0) AND
                       (Debit2 = 0) AND (Credit2 = 0) AND
                       (FinishedDebit = 0) AND (FinishedCredit = 0)
                    THEN
                        CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT PrintDim THEN
                        CurrReport.BREAK;

                    CASE Detail OF
                        Detail::GlDim1:
                            BEGIN
                                DimValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 1 Code");
                                IF Dim1Filter <> '' THEN
                                    DimValue.SETFILTER(Code, Dim1Filter);
                            END;
                        Detail::GlDim2:
                            BEGIN
                                DimValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 2 Code");
                                IF Dim2Filter <> '' THEN
                                    DimValue.SETFILTER(Code, Dim2Filter);
                            END;
                    END;

                    PrintEmptyDim := NOT (((Dim1Filter <> '') AND (Detail = Detail::GlDim1)) OR
                                          ((Dim2Filter <> '') AND (Detail = Detail::GlDim2)));

                    DimCount := DimValue.COUNT;
                    IF PrintEmptyDim THEN
                        DimCount += 1;

                    SETRANGE(Number, 1, DimCount);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Synthesis := COPYSTR("No.", 1, 3);
                Group := COPYSTR("No.", 1, 2);
                Class := COPYSTR("No.", 1, 1);

                IF NOT PrintDim THEN BEGIN
                    CalculateValues;

                    IF (InitialDebit = 0) AND (InitialCredit = 0) AND
                       (Initial2Debit = 0) AND (Initial2Credit = 0) AND
                       (Debit = 0) AND (Credit = 0) AND
                       (Debit2 = 0) AND (Credit2 = 0) AND
                       (FinishedDebit = 0) AND (FinishedCredit = 0)
                    THEN
                        CurrReport.SKIP;
                END;
            end;

            trigger OnPreDataItem()
            var
                Dim: Record 348;
                DimTransln: Record 388;
            begin
                PeriodText := FORMAT(DateFrom) + '..' + FORMAT(DateTo);
                IF DateFrom > DateTo THEN
                    ERROR(Text003);

                IF GLEntry.RECORDLEVELLOCKING THEN BEGIN
                    GLEntry.LOCKTABLE;
                    GLEntry.FINDLAST;
                END;

                GLSetup.GET;
                CASE Detail OF
                    Detail::GlDim1:
                        BEGIN
                            Dim.GET(GLSetup."Global Dimension 1 Code");
                            IF DimTransln.GET(GLSetup."Global Dimension 1 Code", CurrReport.LANGUAGE) THEN
                                DimCaption := DimTransln."Code Caption"
                            ELSE
                                DimCaption := Dim."Code Caption";


                        END;
                    Detail::GlDim2:
                        BEGIN
                            Dim.GET(GLSetup."Global Dimension 2 Code");
                            IF DimTransln.GET(GLSetup."Global Dimension 2 Code", CurrReport.LANGUAGE) THEN
                                DimCaption := DimTransln."Code Caption"
                            ELSE
                                DimCaption := Dim."Code Caption";


                        END;
                    Detail::Empty:
                        BEGIN
                            CLEAR(DimCaption);

                        END;
                END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        SourceTable = 9;

        layout
        {
            area(content)
            {
                group("Moºnosti")
                {
                    Caption = 'Options';
                    field(Detail; Detail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Detail';
                        OptionCaption = 'Empty,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code';
                        ToolTip = 'Specify Dimension Code';
                    }
                    field(PrintSynthesis; PrintSynthesis)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Synthesis';
                        ToolTip = 'Specifies if the synthesis accounts have to be printed.';
                    }
                    field(IncomeInFY; IncomeInFY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Income Only In Current Year';
                        ToolTip = 'Specifies if the income only has to be printed only in current year.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Detail := Detail::Empty;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PrintDim := Detail <> Detail::Empty;

        DateFrom := "G/L Account".GETRANGEMIN("Date Filter");
        DateTo := "G/L Account".GETRANGEMAX("Date Filter");

        // Fiscal Year Start
        DateStartFisk := AccountingPeriodMgt.FindFiscalYear(DateFrom);

        Dim1Filter := "G/L Account".GETFILTER("Global Dimension 1 Filter");
        Dim2Filter := "G/L Account".GETFILTER("Global Dimension 2 Filter");
        Filters := "G/L Account".GETFILTERS;
    end;

    var
        GLSetup: Record 98;
        GLEntry: Record 17;
        DimValue: Record 349;
        AccSchedManagement: Codeunit 8;
        Synthesis: Code[3];
        Group: Code[2];
        Class: Code[1];
        PeriodText: Text[30];
        DimCaption: Text[80];
        Dim1Filter: Text;
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
        Dim2Filter: Text;
        Filters: Text;
        InitialDebit: Decimal;
        InitialCredit: Decimal;
        Initial2Debit: Decimal;
        Initial2Credit: Decimal;
        Debit: Decimal;
        Credit: Decimal;
        Debit2: Decimal;
        Credit2: Decimal;
        FinishedDebit: Decimal;
        FinishedCredit: Decimal;
        DateFrom: Date;
        DateTo: Date;
        DateStartFisk: Date;
        Detail: Option Empty,GlDim1,GlDim2;
        PrintSynthesis: Boolean;
        IncomeInFY: Boolean;
        PrintDim: Boolean;
        PrintEmptyDim: Boolean;
        DimCount: Integer;
        DimCodeText: Text[30];
        Text001: Label 'Total for %1';
        Text002: Label 'Period :';
        Text003: Label 'Wrong Date Interval !';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        General_Ledger_by_Global_DimensionCaptionLbl: Label 'Turnover report by Global Dimension';
        AccountCaptionLbl: Label 'Account No.';
        DebitCaptionLbl: Label 'Debit for period';
        CreditCaptionLbl: Label 'Credit for period';
        Debit2CaptionLbl: Label 'Total debit for all period';
        Credit2CaptionLbl: Label 'Total credit for all period';
        InitialDebit_gdeInitialCreditCaptionLbl: Label 'Initial state for period';
        Initial2Debit_gdeInitial2CreditCaptionLbl: Label 'Initial state for period';
        FinishedDebit_gdeFinishedCreditCaptionLbl: Label 'Closing balance';
        OthersCaptionLbl: Label 'Others';
        TotalCaptionLbl: Label 'Total';


    procedure CalculateValues()
    begin
        // Fiscal Year First Period
        // Start Balance
        IF IncomeInFY AND ("G/L Account"."Income/Balance" = "G/L Account"."Income/Balance"::"Income Statement") THEN BEGIN
            IF DateFrom = DateStartFisk THEN
                "G/L Account".SETFILTER("Date Filter", '%1..%2', DateStartFisk, CLOSINGDATE(DateFrom - 1))
            ELSE
                "G/L Account".SETFILTER("Date Filter", '%1..%2', DateStartFisk, DateFrom - 1);
        END ELSE BEGIN
            IF DateFrom = DateStartFisk THEN
                "G/L Account".SETFILTER("Date Filter", '..%1', CLOSINGDATE(DateFrom - 1))
            ELSE
                "G/L Account".SETFILTER("Date Filter", '..%1', DateFrom - 1);
        END;
        "G/L Account".CALCFIELDS("Debit Amount", "Credit Amount");
        InitialDebit := "G/L Account"."Debit Amount";
        InitialCredit := "G/L Account"."Credit Amount";

        // Start Balance 2
        IF NOT (IncomeInFY AND ("G/L Account"."Income/Balance" = "G/L Account"."Income/Balance"::"Income Statement")) THEN BEGIN
            "G/L Account".SETFILTER("Date Filter", '..%1', CLOSINGDATE(DateStartFisk - 1));
            "G/L Account".CALCFIELDS("Debit Amount", "Credit Amount");
            Initial2Debit := "G/L Account"."Debit Amount";
            Initial2Credit := "G/L Account"."Credit Amount";
        END ELSE BEGIN
            Initial2Debit := 0;
            Initial2Credit := 0;
        END;

        // Balance by period
        "G/L Account".SETFILTER("Date Filter", '%1..%2', DateFrom, DateTo);
        "G/L Account".CALCFIELDS("Debit Amount", "Credit Amount");
        Debit := "G/L Account"."Debit Amount";
        Credit := "G/L Account"."Credit Amount";

        // Balance by period 2
        "G/L Account".SETFILTER("Date Filter", '%1..%2', DateStartFisk, DateTo);
        "G/L Account".CALCFIELDS("Debit Amount", "Credit Amount");
        Debit2 := "G/L Account"."Debit Amount";
        Credit2 := "G/L Account"."Credit Amount";

        // End balance
        IF IncomeInFY AND ("G/L Account"."Income/Balance" = "G/L Account"."Income/Balance"::"Income Statement") THEN
            "G/L Account".SETFILTER("Date Filter", '%1..%2', DateStartFisk, DateTo)
        ELSE
            "G/L Account".SETFILTER("Date Filter", '..%1', DateTo);
        "G/L Account".CALCFIELDS("Debit Amount", "Credit Amount");
        FinishedDebit := "G/L Account"."Debit Amount";
        FinishedCredit := "G/L Account"."Credit Amount";
    end;
}

