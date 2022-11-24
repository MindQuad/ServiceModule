reportextension 50055 Check_Extn extends Check
{
    var
        GLSetup_New: Record "General Ledger Setup";
        Text026_New: Label 'ZERO';
        Text027_New: Label 'HUNDRED';
        Text028_New: Label 'AND';
        Text032_New: Label 'ONE';
        Text033_New: Label 'TWO';
        Text034_New: Label 'THREE';
        Text035_New: Label 'FOUR';
        Text036_New: Label 'FIVE';
        Text037_New: Label 'SIX';
        Text038_New: Label 'SEVEN';
        Text039_New: Label 'EIGHT';
        Text040_New: Label 'NINE';
        Text041_New: Label 'TEN';
        Text042_New: Label 'ELEVEN';
        Text043_New: Label 'TWELVE';
        Text044_New: Label 'THIRTEEN';
        Text045_New: Label 'FOURTEEN';
        Text046_New: Label 'FIFTEEN';
        Text047_New: Label 'SIXTEEN';
        Text048_New: Label 'SEVENTEEN';
        Text049_New: Label 'EIGHTEEN';
        Text050_New: Label 'NINETEEN';
        Text051_New: Label 'TWENTY';
        Text052_New: Label 'THIRTY';
        Text053_New: Label 'FORTY';
        Text054_New: Label 'FIFTY';
        Text055_New: Label 'SIXTY';
        Text056_New: Label 'SEVENTY';
        Text057_New: Label 'EIGHTY';
        Text058_New: Label 'NINETY';
        Text059_New: Label 'THOUSAND';
        Text060_New: Label 'MILLION';
        Text061_New: Label 'BILLION';
        Text026_Arabic: Label 'صفر';
        Text027_Arabic: Label 'مائة';
        Text028_Arabic: Label 'و';
        Text032_Arabic: Label 'واحد';
        Text033_Arabic: Label 'اثنين';
        Text034_Arabic: Label 'ثلاثة';
        Text035_Arabic: Label 'أربعة';
        Text036_Arabic: Label 'خمسة';
        Text037_Arabic: Label 'ستة';
        Text038_Arabic: Label 'سبعة';
        Text039_Arabic: Label 'ثمانية';
        Text040_Arabic: Label 'تسع';
        Text041_Arabic: Label 'عشرة';
        Text042_Arabic: Label 'أحد عشر';
        Text043_Arabic: Label 'اثني عشر';
        Text044_Arabic: Label 'ثلاثة عشر';
        Text045_Arabic: Label 'أربعة عشرة';
        Text046_Arabic: Label 'خمسة عشر';
        Text047_Arabic: Label 'السادس عشر';
        Text048_Arabic: Label 'سبعة عشر';
        Text049_Arabic: Label 'الثامنة عشر';
        Text050_Arabic: Label 'تسعة عشر';
        Text051_Arabic: Label 'عشرين';
        Text052_Arabic: Label 'ثلاثون';
        Text053_Arabic: Label 'أربعين';
        Text054_Arabic: Label 'خمسون';
        Text055_Arabic: Label 'ستون';
        Text056_Arabic: Label 'سبعون';
        Text057_Arabic: Label 'ثمانون';
        Text058_Arabic: Label 'تسعين';
        Text059_Arabic: Label 'ألف';
        Text060_Arabic: Label 'مليون';
        Text061_Arabic: Label 'مليار';

        Text029_New: Label '%1 results in a written number that is too long.';
        OnesText_New: array[20] of Text[30];
        TensText_New: array[10] of Text[30];
        ExponentText_New: array[5] of Text[30];
        OnesText_Arabic: array[20] of Text[30];
        TensText_Arabic: array[10] of Text[30];
        ExponentText_Arabic: array[5] of Text[30];

    procedure FormatNoTextNew(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        Currency: Record Currency;
    begin
        InitTextVariable_New();
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        GLSetup_New.Get();

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026_New)
        else
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText_New[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027_New);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText_New[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText_New[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText_New[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText_New[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

        if CurrencyCode <> '' then
            Currency.Get(CurrencyCode)
        else
            Currency.Get(GLSetup_New."LCY Code");

        AddToNoText(NoText, NoTextIndex, PrintExponent, Currency."Currency Numeric Description");

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028_New);
        DecimalPosition := No * 100;
        if DecimalPosition = 0 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026_New);
        end
        else begin
            Tens := (DecimalPosition mod 100) div 10;
            Ones := DecimalPosition mod 10;
            if Tens >= 2 then begin
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText_New[Tens]);
                if Ones > 0 then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText_New[Ones]);
            end else
                if (Tens * 10 + Ones) > 0 then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText_New[Tens * 10 + Ones]);
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Currency."Decimal Curr. Description");
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029_New, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure GetAmtDecimalPosition(): Decimal
    var
        Currency: Record Currency;
    begin
        if GenJnlLine."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(GenJnlLine."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
        exit(1 / Currency."Amount Rounding Precision");
    end;


    procedure InitTextVariable_New()
    begin
        OnesText_New[1] := Text032_New;
        OnesText_New[2] := Text033_New;
        OnesText_New[3] := Text034_New;
        OnesText_New[4] := Text035_New;
        OnesText_New[5] := Text036_New;
        OnesText_New[6] := Text037_New;
        OnesText_New[7] := Text038_New;
        OnesText_New[8] := Text039_New;
        OnesText_New[9] := Text040_New;
        OnesText_New[10] := Text041_New;
        OnesText_New[11] := Text042_New;
        OnesText_New[12] := Text043_New;
        OnesText_New[13] := Text044_New;
        OnesText_New[14] := Text045_New;
        OnesText_New[15] := Text046_New;
        OnesText_New[16] := Text047_New;
        OnesText_New[17] := Text048_New;
        OnesText_New[18] := Text049_New;
        OnesText_New[19] := Text050_New;

        TensText_New[1] := '';
        TensText_New[2] := Text051_New;
        TensText_New[3] := Text052_New;
        TensText_New[4] := Text053_New;
        TensText_New[5] := Text054_New;
        TensText_New[6] := Text055_New;
        TensText_New[7] := Text056_New;
        TensText_New[8] := Text057_New;
        TensText_New[9] := Text058_New;

        ExponentText_New[1] := '';
        ExponentText_New[2] := Text059_New;
        ExponentText_New[3] := Text060_New;
        ExponentText_New[4] := Text061_New;
    end;

    procedure FormatNoTextArabic(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        Currency: Record Currency;
    begin
        InitTextVariable_Arabic();
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        GLSetup_New.Get();

        if No < 1 then
            AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, Text026_Arabic)
        else
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, OnesText_Arabic[Hundreds]);
                    AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, Text027_Arabic);
                end;
                if Tens >= 2 then begin
                    AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, TensText_Arabic[Tens]);
                    if Ones > 0 then
                        AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, OnesText_Arabic[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, OnesText_Arabic[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, ExponentText_Arabic[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

        if CurrencyCode <> '' then
            Currency.Get(CurrencyCode)
        else
            Currency.Get(GLSetup_New."LCY Code");

        AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, Currency."Arabic Curr. Description");

        AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, Text028_Arabic);
        DecimalPosition := No * 100;
        if No = 0 then begin
            AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, Text026_Arabic);
        end
        else begin
            Tens := (DecimalPosition mod 100) div 10;
            Ones := DecimalPosition mod 10;
            if Tens >= 2 then begin
                AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, TensText_Arabic[Tens]);
                if Ones > 0 then
                    AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, OnesText_Arabic[Ones]);
            end else
                if (Tens * 10 + Ones) > 0 then
                    AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, OnesText_Arabic[Tens * 10 + Ones]);
        end;

        AddToNoText_Arabic(NoText, NoTextIndex, PrintExponent, Currency."Arabic Decimal Curr. Descr");
    end;

    local procedure AddToNoText_Arabic(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(AddText + ' ' + NoText[NoTextIndex]) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029_New, AddText);
        end;

        NoText[NoTextIndex] := DelChr(AddText + ' ' + NoText[NoTextIndex], '<');
    end;

    procedure InitTextVariable_Arabic()
    begin
        OnesText_Arabic[1] := Text032_Arabic;
        OnesText_Arabic[2] := Text033_Arabic;
        OnesText_Arabic[3] := Text034_Arabic;
        OnesText_Arabic[4] := Text035_Arabic;
        OnesText_Arabic[5] := Text036_Arabic;
        OnesText_Arabic[6] := Text037_Arabic;
        OnesText_Arabic[7] := Text038_Arabic;
        OnesText_Arabic[8] := Text039_Arabic;
        OnesText_Arabic[9] := Text040_Arabic;
        OnesText_Arabic[10] := Text041_Arabic;
        OnesText_Arabic[11] := Text042_Arabic;
        OnesText_Arabic[12] := Text043_Arabic;
        OnesText_Arabic[13] := Text044_Arabic;
        OnesText_Arabic[14] := Text045_Arabic;
        OnesText_Arabic[15] := Text046_Arabic;
        OnesText_Arabic[16] := Text047_Arabic;
        OnesText_Arabic[17] := Text048_Arabic;
        OnesText_Arabic[18] := Text049_Arabic;
        OnesText_Arabic[19] := Text050_Arabic;

        TensText_Arabic[1] := '';
        TensText_Arabic[2] := Text051_Arabic;
        TensText_Arabic[3] := Text052_Arabic;
        TensText_Arabic[4] := Text053_Arabic;
        TensText_Arabic[5] := Text054_Arabic;
        TensText_Arabic[6] := Text055_Arabic;
        TensText_Arabic[7] := Text056_Arabic;
        TensText_Arabic[8] := Text057_Arabic;
        TensText_Arabic[9] := Text058_Arabic;

        ExponentText_Arabic[1] := '';
        ExponentText_Arabic[2] := Text059_Arabic;
        ExponentText_Arabic[3] := Text060_Arabic;
        ExponentText_Arabic[4] := Text061_Arabic;
    end;
}