report 50206 "Consolidated Bank"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ConsolidatedBank.rdl';

    dataset
    {
        dataitem(Company; Company)
        {
            DataItemTableView = SORTING(Name);
            RequestFilterFields = Name;

            trigger OnAfterGetRecord()
            begin
                BankAccount.RESET;
                BankAccount.CHANGECOMPANY(Name); //filter to be add from request page
                IF vCurrency <> '' THEN
                    BankAccount.SETRANGE("Currency Code", vCurrency);
                IF BankAccount.FINDSET THEN
                    REPEAT
                        ExcelBuffer.NewRow;
                        IF CompName2 <> Name THEN
                            ExcelBuffer.AddColumn(Name, FALSE, '', TRUE, FALSE, FALSE, '', 0)
                        ELSE
                            ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 0);

                        CompName2 := Name;

                        ExcelBuffer.AddColumn(BankAccount."No.", FALSE, '', TRUE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(BankAccount.Name, FALSE, '', TRUE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(BankAccount."Bank Account No.", FALSE, '', TRUE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(BankAccount."Currency Code", FALSE, '', TRUE, FALSE, FALSE, '', 0);

                        CLEAR(OriginalValue);
                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.CHANGECOMPANY(Name);
                        BankAccountLedgerEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                        BankAccountLedgerEntry.SETRANGE("Bank Account No.", BankAccount."No.");
                        BankAccountLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        IF BankAccountLedgerEntry.FINDSET THEN BEGIN
                            BankAccountLedgerEntry.CALCSUMS(Amount, "Amount (LCY)");
                            OriginalValue := BankAccountLedgerEntry.Amount;
                            AEDAmt := BankAccountLedgerEntry."Amount (LCY)";
                        END;
                        ExcelBuffer.AddColumn(OriginalValue, FALSE, '', TRUE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(OriginalValue / AEDAmt, FALSE, '', TRUE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(AEDAmt, FALSE, '', TRUE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 0);
                    UNTIL BankAccount.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                CreateHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    Caption = 'Period From';
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';
                }
                field(vCurrency; vCurrency)
                {
                    Caption = 'Currency';
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
        ExcelBuffer.DELETEALL;
    end;

    var
        BankAccount: Record 270;
        ExcelBuffer: Record 370 temporary;
        CompName2: Text;
        BankAccountLedgerEntry: Record 271;
        OriginalValue: Decimal;
        AEDAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        vCurrency: Code[20];

    local procedure CreateHeader()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Company', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Bank Code', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Bank Name', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Account No.', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Currency', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Original Currency Balance', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Convert Rate', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('AED Balance', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Balance as per Bank', FALSE, '', TRUE, FALSE, FALSE, '', 0);
    end;
}

