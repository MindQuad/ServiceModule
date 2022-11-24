report 50006 "Sales Quote"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    Caption = 'Sales Quote';
    UsageCategory = Documents;
    PreviewMode = PrintLayout;
    RDLCLayout = 'SourceCode/Report/SalesQuote.rdl';

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(No_SalesHeader; "No.")
            {
            }
            column(OrderDate_SalesHeader; "Order Date")
            {
            }
            column(BilltoName_SalesHeader; "Bill-to Name")
            {
            }
            column(RDKLoanTenure_SalesHeader; "RDK Loan Tenure")
            {
            }
            column(logo; CompanyInfo.Picture)
            {
            }
            column(NoofInstallmentsforLoan_SalesHeader; "No of Installments for Loan")
            {
            }
            column(SPADate_SalesHeader; "SPA Date")
            {
            }
            column(RDKLoanInterest_SalesHeader; "RDK Loan Interest %")
            {
            }
            column(BlockValue; BlockValue)
            {

            }
            column(UnitValue; UnitValue)
            {

            }
            column(UnitTypeValue; UnitTypeValue)
            {

            }
            column(NoOfBedrooms; NoOfBedrooms)
            {

            }
            column(SqrFeetValue; SqrFeetValue)
            {

            }
            column(SqrMeterValue; SqrMeterValue)
            {

            }
            column(BuildNoValue; BuildNoValue)
            {

            }


            dataitem("Amortization Entry"; "Amortization Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Document Type" = filter(Quote), Status = filter(= '' | Received));

                column(CheckDate_AmortizationEntry; "Check Date")
                {
                }
                column(LineNumber_AmortizationEntry; "Line Number")
                {
                }
                column(PrinipalAmount_AmortizationEntry; "Prinipal Amount")
                {
                }
                column(BeginningBalance_AmortizationEntry; "Beginning Balance")
                {
                }
                column(InterestAmount_AmortizationEntry; "Interest Amount")
                {
                }
                column(EMIAmount_AmortizationEntry; "EMI Amount")
                {
                }
                column(EndingBalance_AmortizationEntry; "Ending Balance")
                {
                }
                column(srno; srno)
                {

                }
                trigger OnAfterGetRecord()

                begin
                    srno := srno + 1;
                end;
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(No_; "No.")
                {

                }

                trigger OnAfterGetRecord()

                begin
                    RecServiceItem.Reset();
                    RecServiceItem.SetRange("Item No.", "Sales Line"."No.");
                    if RecServiceItem.FindFirst() then begin
                        BlockValue := RecServiceItem.Block;
                        UnitValue := RecServiceItem."Unit No.";
                        //UnitTypeValue := RecServiceItem."Unit Type";
                        NoOfBedrooms := RecServiceItem."No. of Bedrooms";
                        SqrFeetValue := RecServiceItem."Sqr Feet";
                        SqrMeterValue := RecServiceItem."Sqr Meter";
                        BuildNoValue := RecServiceItem."Building No.";

                        if RecServiceItem."Unit Type" = RecServiceItem."Unit Type"::Residential
                        then
                            UnitTypeValue := 'Residential'
                        else

                            if RecServiceItem."Unit Type" = RecServiceItem."Unit Type"::Commercial
                            then
                                UnitTypeValue := 'Commercial'
                            else
                                UnitTypeValue := '';

                    end;
                end;

            }
            dataitem(Contact; Contact)
            {
                DataItemLink = "No." = field("Sell-to Contact No.");

                column(MobilePhoneNo_Contact; "Mobile Phone No.")
                {
                }
                column(EMail_Contact; "E-Mail")
                {
                }

            }

        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);

        RecSalesSetup.Get();

    end;

    var
        CompanyInfo: Record 79;
        RecSalesSetup: Record "Sales & Receivables Setup";
        RecServiceItem: Record "Service Item";
        BlockValue: Code[20];
        UnitValue: Code[20];
        UnitTypeValue: Text[20];
        NoOfBedrooms: Option;
        SqrFeetValue: Decimal;
        SqrMeterValue: Decimal;
        BuildNoValue: Code[20];


        srno: Integer;
}
