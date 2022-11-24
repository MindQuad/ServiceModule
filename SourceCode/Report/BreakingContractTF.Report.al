report 50013 "Breaking Contract-TF"
{
    DefaultLayout = RDLC;
    // RDLCLayout = './TerminateQuote.rdl';
    RDLCLayout = 'SourceCode/Report/TerminateQuote.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Terminate Quote';
    ApplicationArea = All;
    UsageCategory = Documents;

    dataset
    {

        dataitem("Service Contract Header"; "Service Contract Header")
        {
            //DataItemLink = "Contract No." = FIELD("Contract No.");
            RequestFilterFields = "Contract Type", "Contract No.";



            column(ContractNo_ServiceContractHeader; "Contract No.")
            {
            }
            column(CustomerNo_ServiceContractHeader; "Customer No.")
            {
            }
            column(Name_ServiceContractHeader; Name)
            {
            }
            column(Address_ServiceContractHeader; Address)
            {
            }
            column(Address2_ServiceContractHeader; "Address 2")
            {
            }
            column(PostCode_ServiceContractHeader; "Post Code")
            {
            }
            column(City_ServiceContractHeader; City)
            {
            }
            column(County_ServiceContractHeader; County)
            {
            }
            column(EMail_ServiceContractHeader; "E-Mail")
            {
            }
            column(PhoneNo_ServiceContractHeader; "Phone No.")
            {
            }
            column(StartingDate_ServiceContractHeader; "Starting Date")
            {
            }
            column(ExpirationDate_ServiceContractHeader; "Expiration Date")
            {
            }
            column(BuildingNo_ServiceContractHeader; "Building No.")
            {
            }
            column(BuildingName_ServiceContractHeader; "Building Name")
            {
            }
            column(UnitNo_ServiceContractHeader; "Unit No.")
            {
            }
            column(AnnualAmount_ServiceContractHeader; "Annual Amount")
            {
            }
            column(SecurityDep; SecurityDep)
            {

            }
            column(MaintCharge; MaintCharge)
            {

            }
            column(OtherSecDep; OtherSecDep)
            {

            }
            column(Penalty; Penalty)
            {

            }
            column(OtherCharges; OtherCharges)
            {

            }
            column(BuyfromVendorName_PurchaseHeader; RecCust.Name)
            {
            }
            column(BuyfromAddress_PurchaseHeader; RecCust.Address)
            {
            }
            column(BuyfromAddress2_PurchaseHeader; RecCust."Address 2")
            {
            }
            column(BuyfromCity_PurchaseHeader; RecCust.City)
            {
            }
            column(BuyfromCountryRegionCode_PurchaseHeader; RecCust."Country/Region Code")
            {
            }
            column(BuildNo; BuilName)
            {
            }
            column(UnitCode; RecSerContract."Unit Code")
            {
            }
            column(logo; CompanyInfo.Picture)
            {
            }
            column(name; CompanyInfo.Name)
            {
            }
            column(add; CompanyInfo.Address)
            {
            }
            column(add1; CompanyInfo."Address 2")
            {
            }
            column(phoneno; CompanyInfo."Phone No.")
            {
            }
            column(city; CompanyInfo.City)
            {
            }
            column(faxno; CompanyInfo."Fax No.")
            {
            }
            column(postcode; CompanyInfo."Post Code")
            {
            }
            column(email; CompanyInfo."E-Mail")
            {
            }
            column(VatRegno; CompanyInfo."VAT Registration No.")
            {
            }
            column(Homepage; CompanyInfo."Home Page")
            {
            }
            column(country; CompanyInfo.County)
            {
            }
            column(VATRegistrationNo_PurchaseHeader; RecCust."VAT Registration No.")
            {
            }
            column(PaymentDesc; PaymentDesc)
            {
            }
            column(AmountInWords1; AmountInWords[1])
            {
            }
            column(AmountInWords2; AmountInWords[2])
            {
            }
            column(contactphone; RecContact."Phone No.")
            {
            }
            column(des; des)
            {
            }
            column(bool1; bool1)
            {
            }
            column(username; UserSetup."User ID")
            {
            }
            column(username1; username)
            {
            }
            column(Header; Header)
            {
            }
            column(Type1; Type1)
            {
            }
            column(BankName; CompanyInfo."Bank Name")
            {
            }
            column(BankAccNo; CompanyInfo."Bank Account No.")
            {
            }
            column(Currency; CustBankAcc."Currency Code")
            {
            }
            column(Swift; CompanyInfo."SWIFT Code")
            {
            }
            column(IBAN; CompanyInfo.IBAN)
            {
            }
            column(BuildDesc; RecBuilding.Description)
            {
            }
            column(CustomerName; CustomerName)
            {

            }
            column(CustVatNo; CustVatNo)
            {

            }
            column(AmountInWordsPO2; AmountInWordsPO2)
            {

            }
            column(CurrencyGLS; CurrencyGLS)
            {

            }
            column(TotalMonths; TotalMonths) { }
            column(PDCAmount; PDCAmount) { }
            dataitem("Purchase Header"; "Service Invoice Header")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                //RequestFilterFields = "No.";
                column(ShiptoCode_PurchaseHeader; "Purchase Header"."Ship-to Code")
                {
                }
                column(CustomerNo_PurchaseHeader; "Customer No.")
                {
                }
                column(PhoneNo_PurchaseHeader; "Phone No.")
                {
                }
                column(EMail_PurchaseHeader; "E-Mail")
                {
                }
                column(PostCode_PurchaseHeader; "Post Code")
                {
                }
                column(ShiptoName_PurchaseHeader; "Purchase Header"."Ship-to Name")
                {
                }
                column(ShiptoName2_PurchaseHeader; "Purchase Header"."Ship-to Name 2")
                {
                }
                column(ShiptoAddress_PurchaseHeader; "Purchase Header"."Ship-to Address")
                {
                }
                column(ShiptoAddress2_PurchaseHeader; "Purchase Header"."Ship-to Address 2")
                {
                }
                column(ShiptoCity_PurchaseHeader; "Purchase Header"."Ship-to City")
                {
                }
                column(ShiptoContact_PurchaseHeader; "Purchase Header"."Ship-to Contact")
                {
                }

                column(BuyfromContact_PurchaseHeader; "Purchase Header"."Bill-to Contact")
                {
                }
                column(BilltoName_PurchaseHeader; "Purchase Header"."Bill-to Name")
                {
                }
                column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Bill-to Customer No.")
                {
                }
                column(No_PurchaseHeader; "Purchase Header"."No.")
                {
                }
                column(PostingDate_PurchaseHeader; "Purchase Header"."Posting Date")
                {
                }
                column(BuyfromContactNo_PurchaseHeader; "Purchase Header"."Bill-to Contact No.")
                {
                }
                column(BilltoAddress_PurchaseHeader; "Bill-to Address")
                {
                }
                column(BuyfromPostCode_PurchaseHeader; "Purchase Header"."Bill-to Post Code")
                {
                }
                column(BilltoCity_PurchaseHeader; "Bill-to City")
                {
                }
                column(BuyfromCounty_PurchaseHeader; "Purchase Header"."Bill-to County")
                {
                }

                column(DueDate_PurchaseHeader; "Purchase Header"."Due Date")
                {
                }
                column(ContractNo; "Purchase Header"."Contract No.")
                {
                }
                column(WorkDes; "Purchase Header"."Work Description")
                {
                }

                column(AmountIncludingVAT_PurchaseHeader; "Purchase Header"."Amount Including VAT")
                {
                }
                column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
                {
                }

                column(ExpectedReceiptDate_PurchaseHeader; '')
                {
                }

                column(AssignedUserID_PurchaseHeader; '')
                {
                }
                column(RequestedReceiptDate_PurchaseHeader; '')
                {
                }
                column(YourReference_PurchaseHeader; "Purchase Header"."Your Reference")
                {
                }

                column(NAME1; Name)
                {
                }

                column(WorkDescription_PurchaseHeader; "Purchase Header"."Work Description")
                {
                }
                column(Category_PurchaseHeader; '')
                {
                }

                column(Details_PurchaseHeader; '')
                {
                }

                column(JobNo; "Purchase Header"."Unit No.")
                {
                }
                column(OrderNo_PurchaseHeader; "Purchase Header"."Order No.")
                {
                }

            }



            trigger OnAfterGetRecord()
            begin
                RecServCharges.Reset();
                RecServCharges.SetRange(RecServCharges."Service Contract No.", "Service Contract Header"."Contract No.");
                if RecServCharges.FindSET then
                    repeat
                        if RecServCharges."Charge Code" = 'SD' then
                            SecurityDep := RecServCharges."Charge Amount";

                        if RecServCharges."Charge Code" = 'OTH SEC DEPO' then
                            OtherSecDep := RecServCharges."Charge Amount";

                        if RecServCharges."Charge Code" = 'MAIN CHR' then
                            MaintCharge := RecServCharges."Charge Amount";

                        if RecServCharges."Charge Code" = 'PENALTY' then
                            Penalty := RecServCharges."Charge Amount";

                        if RecServCharges."Charge Code" = 'OTH CHARGE' then
                            OtherCharges := RecServCharges."Charge Amount";
                    until RecServCharges.Next = 0;

                RecPdc.Reset();
                RecPdc.SetFilter(RecPdc."Contract No.", "Service Contract Header"."Contract No.");
                if RecPdc.FindSet() then
                    if RecPdc."G/L Transaction No." = 0 then
                        repeat
                            PDCAmount += RecPdc.Amount;
                        until RecPdc.Next() = 0;






                RecCust.RESET;
                RecCust.SETRANGE(RecCust."No.", "Service Contract Header"."Customer No.");
                IF RecCust.FINDFIRST THEN begin
                    CustomerName := RecCust.Name;
                    if RecCust."Tenancy Type" = RecCust."Tenancy Type"::Commercial then
                        CustVatNo := RecCust."VAT Reg. No."
                    else
                        CustVatNo := 'Un Registered';

                end;

                CurrDate := Today;
                //TermnDate := CurrDate-"Service Contract Header"."Starting Date";
                NoofDays := Date2DMY(CurrDate, 1) - Date2DMY("Service Contract Header"."Starting Date", 1);
                NoofMonths := Date2DMY(CurrDate, 2) - Date2DMY("Service Contract Header"."Starting Date", 2);
                NoofYears := 12 * (Date2DMY(CurrDate, 3) - Date2DMY("Service Contract Header"."Starting Date", 3));
                TotalMonths := NoofYears + NoofMonths;
                if NoofDays > 0 then
                    TotalMonths += 1;
                //Message(format(TotalMonths));








                /* if "Purchase Header"."Currency Code" = '' then
                     CurrencyGLS := RecGenLedgerSetup."LCY Code"
                 else
                     CurrencyGLS := "Purchase Header"."Currency Code";*/



            end;




        }
    }

    requestpage
    {

        layout
        {
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);

        RecGenLedgerSetup.Get();
    end;

    var
        CompanyInfo: Record 79;
        srno: Integer;
        VATAmount: Decimal;
        AmountInWords: array[2] of Text[80];
        ReportCheck: Report 1401;
        amt: Decimal;
        RecPurchaseLine: Record 5993;
        RecPaymentTerms: Record 3;
        PaymentDesc: Text[80];
        TotalLineAmt: Decimal;
        TotalVATAmt: Decimal;
        UserSetup: Record 91;
        username: Text[80];
        user: Record 2000000120;
        RecContact: Record 5050;
        bool1: Boolean;
        bool2: Boolean;
        NAME: Text[50];
        RecItem: Record 27;
        CaptionGeneral: Label 'Purchase Order';
        CaptionService: Label 'Service Work Order';
        Header: Text[30];
        Type1: Text[30];
        des: Text;
        CustBankAcc: Record 287;
        VAT: Decimal;
        RecSerContract: Record 5965;
        UnitCode: Code[10];
        RecJobs: Record 167;
        JobNo: Code[10];
        RecBuild: Record 50005;
        BuilName: Text;
        RecBuilding: Record 50005;
        RecCust: Record 18;
        CustomerName: Text[100];
        CustVatNo: Text[20];
        RecGenLedgerSetup: Record "General Ledger Setup";
        RecServCharges: Record "Service Charges";
        RecPdc: Record "Post Dated Check Line";
        CurrencyGLS: Code[10];
        RepCheck: Report Check;
        AmountVendor: Decimal;
        Notext: array[2] of Text[80];
        AmountInWordsPO2: Text;
        SecurityDep: Decimal;
        OtherSecDep: Decimal;
        MaintCharge: Decimal;
        Penalty: Decimal;
        OtherCharges: Decimal;
        PDCAmount: Decimal;
        TermnDate: Date;
        CurrDate: Date;
        NoofMonths: Integer;
        NoofYears: Integer;
        TotalMonths: Integer;
        NoofDays: Integer;

}

