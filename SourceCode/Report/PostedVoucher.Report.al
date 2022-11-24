report 50004 "Posted Voucher"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './PostedVoucher.rdl';
    RDLCLayout = 'SourceCode/Report/PostedVoucher.rdl';
    Caption = 'Posted Voucher';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purchase Header"; "Service Invoice Header")
        {
            RequestFilterFields = "No.";
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
            column(BuyfromCountryRegionCode_PurchaseHeader; RecCust."Country/Region Code")
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
            column(AmountIncludingVAT_PurchaseHeader; "Purchase Header"."Amount Including VAT")
            {
            }
            column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
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
            column(ExpectedReceiptDate_PurchaseHeader; '')
            {
            }
            column(contactphone; RecContact."Phone No.")
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
            column(username; UserSetup."User ID")
            {
            }
            column(username1; username)
            {
            }
            column(NAME1; Name)
            {
            }
            column(Header; Header)
            {
            }
            column(Type1; Type1)
            {
            }
            column(WorkDescription_PurchaseHeader; "Purchase Header"."Work Description")
            {
            }
            column(Category_PurchaseHeader; '')
            {
            }
            column(des; des)
            {
            }
            column(bool1; bool1)
            {
            }
            column(Details_PurchaseHeader; '')
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
            column(JobNo; "Purchase Header"."Unit No.")
            {
            }
            column(OrderNo_PurchaseHeader; "Purchase Header"."Order No.")
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
            column(CurrencyGLS; CurrencyGLS) { }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = field("No.");

                column(GLAccountNo_GLEntry; "G/L Account No.")
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                column(Description_GLEntry; Description)
                {
                }
                column(Amount_GLEntry; Amount)
                {
                }
                column(VATAmount_GLEntry; "VAT Amount")
                {
                }
                column(srno; srno) { }
                trigger OnAfterGetRecord()
                begin


                    srno := srno + 1;

                    TotalGLAmount += "G/L Entry".Amount + "G/L Entry"."VAT Amount";
                    //Message(Format(TotalGLAmount));
                    AmountVendor := Round(TotalGLAmount, 0.01);
                    RepCheck.InitTextVariable();
                    RepCheck.FormatNoTextNew(Notext, AmountVendor, CurrencyGLS);
                    AmountInWordsPO2 := Notext[1];

                end;
            }
            dataitem(Integer; Integer)
            {

                column(Number; Number)
                { }

                trigger OnPreDataItem()
                var
                    TotalNoOfLines: Integer;
                begin
                    TotalNoOfLines := 15;

                    if TotalNoOfLines > "G/L Entry".Count() then
                        TotalNoOfLines := TotalNoOfLines - "G/L Entry".Count
                    else
                        CurrReport.Break();

                    SetRange(Number, 1, TotalNoOfLines);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                //IF "Purchase Header".Category="Purchase Header".Category::Service THEN
                // //bool1:=
                //des:="Purchase Header"."Work Description";

                RecContact.RESET;
                //RecContact.SETRANGE(RecContact."No.","Purchase Header"."Buy-from Contact No.");
                IF RecContact.FINDFIRST THEN;

                IF CompanyInfo."Finance Manager" = TRUE THEN
                    Name := 'Finance Manager'
                ELSE
                    Name := 'Group Finance Manager';

                /*bool1:=FALSE;
                IF "Purchase Header".Category =  "Purchase Header".Category::General THEN BEGIN
                  Header:='PURCHASE ORDER';
                  bool1:=TRUE;
                  Type1:='Regular Purchase Order';
                  END ELSE BEGIN
                    Header:='SERVICE WORK ORDER';
                    Type1:='Service Work Order';
                END;*/

                RecPaymentTerms.RESET;
                RecPaymentTerms.SETRANGE(Code, "Purchase Header"."Payment Terms Code");
                IF RecPaymentTerms.FINDSET THEN BEGIN
                    PaymentDesc := RecPaymentTerms.Description;
                END;

                "Purchase Header".CALCFIELDS("Purchase Header"."Amount Including VAT");
                ReportCheck.InitTextVariable;
                ReportCheck.FormatNoText(AmountInWords, "Purchase Header"."Amount Including VAT", '');

                IF UserSetup.GET(USERID) THEN;

                user.RESET;
                user.SETRANGE(user."User Name", UserSetup."User ID");
                IF user.FINDFIRST THEN
                    username := user."Full Name";

                CustBankAcc.RESET;
                IF CustBankAcc.GET("Purchase Header"."Customer No.") THEN;

                RecSerContract.RESET;
                RecSerContract.SETRANGE(RecSerContract."Contract No.", "Purchase Header"."Contract No.");
                IF RecSerContract.FINDFIRST THEN
                    RecSerContract.CALCFIELDS(RecSerContract."Unit Code");

                BuilName := '';
                RecBuild.RESET;
                RecSerContract.RESET;
                RecSerContract.SETRANGE(RecSerContract."Contract No.", "Purchase Header"."Contract No.");
                IF RecSerContract.FINDFIRST THEN
                    RecBuild.SETRANGE(RecBuild.Code, RecSerContract."Building No.");
                IF RecBuild.FINDFIRST THEN
                    BuilName := RecBuild.Description;
                //MESSAGE(FORMAT(BuilName));

                RecBuilding.RESET;
                RecBuilding.SETRANGE(RecBuilding.Code, "Purchase Header"."Building No.");
                IF RecBuilding.FINDFIRST THEN
                    JobNo := '';
                RecJobs.RESET;
                RecJobs.SETRANGE(RecJobs."Contract No.", "Purchase Header"."Order No.");
                IF RecJobs.FINDFIRST THEN
                    JobNo := RecJobs."No.";

                RecCust.RESET;
                RecCust.SETRANGE(RecCust."No.", "Purchase Header"."Customer No.");
                IF RecCust.FINDFIRST THEN begin
                    CustomerName := RecCust.Name;
                    if RecCust."Tenancy Type" = RecCust."Tenancy Type"::Commercial then
                        CustVatNo := RecCust."VAT Reg. No."
                    else
                        CustVatNo := 'Un Registered';

                end;

                if "Purchase Header"."Currency Code" = '' then
                    CurrencyGLS := RecGenLedgerSetup."LCY Code"
                else
                    CurrencyGLS := "Purchase Header"."Currency Code";



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
        CurrencyGLS: Code[10];
        RepCheck: Report Check;
        AmountVendor: Decimal;
        Notext: array[2] of Text[80];
        AmountInWordsPO2: Text;
        TotalGLAmount: Decimal;
}

