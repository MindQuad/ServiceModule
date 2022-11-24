tableextension 50027 tableextension50027 extends "Currency Exchange Rate"
{

    var

        CurrencyExchRate2: array[2] of Record "Currency Exchange Rate";

        CurrencyExchRate3: Record "Currency Exchange Rate";
        ExchangeRateAmtFCY: Decimal;
        RelExchangeRateAmtFCY: Decimal;
        RelExchangeRateAmt: Decimal;
        ExchangeRateAmt: Decimal;
        RelCurrencyCode: Code[10];
        FixExchangeRateAmt: Option;
        CurrencyFactor: Decimal;
        UseAdjmtAmounts: Boolean;
        CurrencyCode2: Code[10];
        Date2: array[2] of Date;

    local procedure "--"()
    begin
    end;

    procedure ExchangeAmtLCYToFCYForMulipleCompny(Date: Date; CurrencyCode: Code[10]; Amount: Decimal; Factor: Decimal): Decimal
    begin
        IF CurrencyCode = '' THEN
            EXIT(Amount);
        FindCurrencyForMulipleCompny(Date, CurrencyCode, 1);
        TESTFIELD("Exchange Rate Amount");
        TESTFIELD("Relational Exch. Rate Amount");
        IF "Relational Currency Code" = '' THEN
            IF "Fix Exchange Rate Amount" = "Fix Exchange Rate Amount"::Both THEN
                Amount := (Amount / "Relational Exch. Rate Amount") * "Exchange Rate Amount"
            ELSE
                Amount := Amount * Factor
        ELSE BEGIN
            RelExchangeRateAmt := "Relational Exch. Rate Amount";
            ExchangeRateAmt := "Exchange Rate Amount";
            RelCurrencyCode := "Relational Currency Code";
            FixExchangeRateAmt := "Fix Exchange Rate Amount";
            FindCurrencyForMulipleCompny(Date, RelCurrencyCode, 2);
            TESTFIELD("Exchange Rate Amount");
            TESTFIELD("Relational Exch. Rate Amount");
            CASE FixExchangeRateAmt OF
                "Fix Exchange Rate Amount"::"Relational Currency":
                    ExchangeRateAmt :=
                      (Factor * RelExchangeRateAmt * "Relational Exch. Rate Amount") /
                      "Exchange Rate Amount";
                "Fix Exchange Rate Amount"::Currency:
                    RelExchangeRateAmt :=
                      (ExchangeRateAmt * "Exchange Rate Amount") /
                      (Factor * "Relational Exch. Rate Amount");
                "Fix Exchange Rate Amount"::Both:
                    CASE "Fix Exchange Rate Amount" OF
                        "Fix Exchange Rate Amount"::"Relational Currency":
                            "Exchange Rate Amount" :=
                              (Factor * RelExchangeRateAmt * "Relational Exch. Rate Amount") /
                              ExchangeRateAmt;
                        "Fix Exchange Rate Amount"::Currency:
                            "Relational Exch. Rate Amount" :=
                              (ExchangeRateAmt * "Exchange Rate Amount") /
                              (Factor * RelExchangeRateAmt);
                    END;
            END;
            Amount := (Amount / RelExchangeRateAmt) * ExchangeRateAmt;
            Amount := (Amount / "Relational Exch. Rate Amount") * "Exchange Rate Amount";
        END;
        EXIT(Amount);
    end;

    procedure ExchangeAmtFCYToLCYForMulipleCompny(Date: Date; CurrencyCode: Code[10]; Amount: Decimal; Factor: Decimal): Decimal
    begin
        IF CurrencyCode = '' THEN
            EXIT(Amount);
        FindCurrencyForMulipleCompny(Date, CurrencyCode, 1);
        IF NOT UseAdjmtAmounts THEN BEGIN
            TESTFIELD("Exchange Rate Amount");
            TESTFIELD("Relational Exch. Rate Amount");
        END ELSE BEGIN
            TESTFIELD("Adjustment Exch. Rate Amount");
            TESTFIELD("Relational Adjmt Exch Rate Amt");
            "Exchange Rate Amount" := "Adjustment Exch. Rate Amount";
            "Relational Exch. Rate Amount" := "Relational Adjmt Exch Rate Amt";
        END;
        IF "Relational Currency Code" = '' THEN
            IF "Fix Exchange Rate Amount" = "Fix Exchange Rate Amount"::Both THEN
                Amount := (Amount / "Exchange Rate Amount") * "Relational Exch. Rate Amount"
            ELSE
                Amount := Amount / Factor
        ELSE BEGIN
            RelExchangeRateAmt := "Relational Exch. Rate Amount";
            ExchangeRateAmt := "Exchange Rate Amount";
            RelCurrencyCode := "Relational Currency Code";
            FixExchangeRateAmt := "Fix Exchange Rate Amount";
            FindCurrencyForMulipleCompny(Date, RelCurrencyCode, 2);
            IF NOT UseAdjmtAmounts THEN BEGIN
                TESTFIELD("Exchange Rate Amount");
                TESTFIELD("Relational Exch. Rate Amount");
            END ELSE BEGIN
                TESTFIELD("Adjustment Exch. Rate Amount");
                TESTFIELD("Relational Adjmt Exch Rate Amt");
                "Exchange Rate Amount" := "Adjustment Exch. Rate Amount";
                "Relational Exch. Rate Amount" := "Relational Adjmt Exch Rate Amt";
            END;
            CASE FixExchangeRateAmt OF
                "Fix Exchange Rate Amount"::"Relational Currency":
                    ExchangeRateAmt :=
                      (RelExchangeRateAmt * "Relational Exch. Rate Amount") /
                      ("Exchange Rate Amount" * Factor);
                "Fix Exchange Rate Amount"::Currency:
                    RelExchangeRateAmt :=
                      ((Factor * ExchangeRateAmt * "Exchange Rate Amount") /
                       "Relational Exch. Rate Amount");
                "Fix Exchange Rate Amount"::Both:
                    CASE "Fix Exchange Rate Amount" OF
                        "Fix Exchange Rate Amount"::"Relational Currency":
                            "Exchange Rate Amount" :=
                              (RelExchangeRateAmt * "Relational Exch. Rate Amount") /
                              (ExchangeRateAmt * Factor);
                        "Fix Exchange Rate Amount"::Currency:
                            "Relational Exch. Rate Amount" :=
                              ((Factor * ExchangeRateAmt * "Exchange Rate Amount") /
                               RelExchangeRateAmt);
                        "Fix Exchange Rate Amount"::Both:
                            BEGIN
                                Amount := (Amount / ExchangeRateAmt) * RelExchangeRateAmt;
                                Amount := (Amount / "Exchange Rate Amount") * "Relational Exch. Rate Amount";
                                EXIT(Amount);
                            END;
                    END;
            END;
            Amount := (Amount / RelExchangeRateAmt) * ExchangeRateAmt;
            Amount := (Amount / "Relational Exch. Rate Amount") * "Exchange Rate Amount";
        END;
        EXIT(Amount);
    end;

    procedure FindCurrencyForMulipleCompny(Date: Date; CurrencyCode: Code[10]; CacheNo: Integer)
    begin
        IF (CurrencyCode2[CacheNo] = CurrencyCode) AND (Date2[CacheNo] = Date) THEN
            Rec := CurrencyExchRate2[CacheNo]
        ELSE BEGIN
            IF Date = 0D THEN
                Date := WORKDATE;
            CurrencyExchRate2[CacheNo].SETRANGE("Currency Code", CurrencyCode);
            CurrencyExchRate2[CacheNo].SETRANGE("Starting Date", 0D, Date);
            CurrencyExchRate2[CacheNo].FINDLAST;
            Rec := CurrencyExchRate2[CacheNo];
            //CurrencyCode2[CacheNo] := Evaluate(CurrencyCode2[CacheNo],CurrencyCode);
            Evaluate(CurrencyCode2[CacheNo], CurrencyCode);
            Date2[CacheNo] := Date;
        END;
    end;
}

