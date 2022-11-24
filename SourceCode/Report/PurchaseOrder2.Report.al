report 50021 "Purchase Order2"
{
    DefaultLayout = RDLC;
    // RDLCLayout = './PurchaseOrder2.rdl';
    RDLCLayout = 'SourceCode/Report/PurchaseOrder2.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Purchase Order 2';
    ApplicationArea = All;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(ShiptoCode_PurchaseHeader; "Purchase Header"."Ship-to Code")
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
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(BuyfromVendorName2_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name 2")
            {
            }
            column(BuyfromAddress_PurchaseHeader; "Purchase Header"."Buy-from Address")
            {
            }
            column(BuyfromAddress2_PurchaseHeader; "Purchase Header"."Buy-from Address 2")
            {
            }
            column(BuyfromCity_PurchaseHeader; "Purchase Header"."Buy-from City")
            {
            }
            column(BuyfromContact_PurchaseHeader; "Purchase Header"."Buy-from Contact")
            {
            }
            column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(PostingDate_PurchaseHeader; "Purchase Header"."Posting Date")
            {
            }
            column(BuyfromContactNo_PurchaseHeader; "Purchase Header"."Buy-from Contact No.")
            {
            }
            column(BuyfromPostCode_PurchaseHeader; "Purchase Header"."Buy-from Post Code")
            {
            }
            column(BuyfromCounty_PurchaseHeader; "Purchase Header"."Buy-from County")
            {
            }
            column(BuyfromCountryRegionCode_PurchaseHeader; "Purchase Header"."Buy-from Country/Region Code")
            {
            }
            column(BuyFromQuoteNo; "Purchase Header"."Quote No.")
            {

            }
            column(BuyFromCurency; "Purchase Header"."Currency Code")
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
            column(VATRegistrationNo_PurchaseHeader; "Purchase Header"."VAT Registration No.")
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
            column(ExpectedReceiptDate_PurchaseHeader; "Purchase Header"."Expected Receipt Date")
            {
            }
            column(contactphone; RecContact."Phone No.")
            {
            }
            column(contactfax; RecContact."Fax No.")
            {
            }
            column(AssignedUserID_PurchaseHeader; "Purchase Header"."Assigned User ID")
            {
            }
            column(RequestedReceiptDate_PurchaseHeader; "Purchase Header"."Requested Receipt Date")
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
            column(NAME1; NAME)
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
            column(Category_PurchaseHeader; "Purchase Header".Category)
            {
            }
            column(des; des)
            {
            }
            column(bool1; bool1)
            {
            }
            column(Details_PurchaseHeader; "Purchase Header".Details)
            {
            }
            column(AmountInWordsPO2; AmountInWordsPO2)
            {

            }
            column(PurchaserName; PurchaserName)
            { }
            column(PurchaserPhone; PurchaserPhone)
            { }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE("Document Line No." = FILTER(= 0));
                column(DocumentType_PurchCommentLine; "Purch. Comment Line"."Document Type")
                {
                }
                column(No_PurchCommentLine; "Purch. Comment Line"."No.")
                {
                }
                column(LineNo_PurchCommentLine; "Purch. Comment Line"."Line No.")
                {
                }
                column(Date_PurchCommentLine; "Purch. Comment Line".Date)
                {
                }
                column(Code_PurchCommentLine; "Purch. Comment Line".Code)
                {
                }
                column(Comment_PurchCommentLine; "Purch. Comment Line".Comment)
                {
                }
                column(DocumentLineNo_PurchCommentLine; "Purch. Comment Line"."Document Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin

                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Document Type" = FILTER(Order), Type = filter(<> " "));
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(Amount_PurchaseLine; "Purchase Line".Amount)
                {
                }
                column(LineAmount_PurchaseLine; "Purchase Line"."Line Amount")
                {
                }
                column(VAT_PurchaseLine; "Purchase Line"."VAT %")
                {
                }
                column(LineDiscountAmount_PurchaseLine; "Purchase Line"."Line Discount Amount")
                {
                }
                column(srno; srno)
                {
                }
                column(AmountIncludingVAT_PurchaseLine; "Purchase Line"."Amount Including VAT")
                {
                }
                column(VATAmount; VATAmount)
                {
                }
                column(UnitCost_PurchaseLine; "Purchase Line"."Unit Cost")
                {
                }
                column(ExpectedReceiptDate_PurchaseLine; "Purchase Line"."Expected Receipt Date")
                {
                }
                column(TotalVATAmt; TotalVATAmt)
                {
                }
                column(UnitofMeasureCode_PurchaseLine; "Purchase Line"."Unit of Measure Code")
                {
                }
                column(BaseUOM; RecItem."Base Unit of Measure")
                {
                }
                column(amt; amt) { }
                column(DocumentNo_PurchaseLine; "Document No.")
                {
                }
                column(LineNo_PurchaseLine; "Line No.")
                {
                }
                column(Type_PurchaseLine; "Type")
                {
                }
                column(VATBaseAmount_PurchaseLine; "VAT Base Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin


                    srno := srno + 1;


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
                    TotalNoOfLines := 10;

                    if TotalNoOfLines > "Purchase Line".Count() then
                        TotalNoOfLines := TotalNoOfLines - "Purchase Line".Count
                    else
                        CurrReport.Break();

                    SetRange(Number, 1, TotalNoOfLines);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                IF RecItem.GET("Purchase Line"."No.") THEN;

                RecPurchaseLine.RESET;
                RecPurchaseLine.SETRANGE("Document No.", "Purchase Header"."No.");
                IF RecPurchaseLine.FINDFIRST THEN BEGIN
                    REPEAT
                        //amt:=amt+RecPurchaseLine."Line Amount";
                        TotalLineAmt := RecPurchaseLine."Line Amount";
                        VATAmount := RecPurchaseLine."Amount Including VAT" - RecPurchaseLine.Amount;
                        //MESSAGE(FORMAT(TotalLineAmt));
                        //amt := amt + (TotalLineAmt + VATAmount);
                        amt := amt + ((RecPurchaseLine.Quantity * RecPurchaseLine."Unit Cost") + RecPurchaseLine."VAT %") - RecPurchaseLine."Line Discount Amount";
                        //amt := TotalLineAmt + VATAmount;
                        // amt := amt + RecPurchaseLine.Amount * RecPurchaseLine.Quantity;
                        //Message(Format(amt));
                        TotalVATAmt += VATAmount;
                    //MESSAGE(FORMAT(amt));
                    UNTIL RecPurchaseLine.NEXT = 0;
                    // RecPurchaseLine.vat


                    //amt := amt / "Purchase Line".Count;
                END;

                RecPurchaser.Reset();
                RecPurchaser.SetRange(Code, "Purchase Header"."Purchaser Code");
                if RecPurchaseLine.FindSet() then begin
                    PurchaserName := RecPurchaser.Name;
                    PurchaserPhone := RecPurchaser."Phone No.";
                end;
                //IF "Purchase Header".Category="Purchase Header".Category::Service THEN
                // //bool1:=
                //des:="Purchase Header"."Work Description";

                RecContact.RESET;
                RecContact.SETRANGE(RecContact."No.", "Purchase Header"."Buy-from Contact No.");
                IF RecContact.FINDFIRST THEN;

                IF CompanyInfo."Finance Manager" = TRUE THEN
                    NAME := 'Finance Manager'
                ELSE
                    NAME := 'Group Finance Manager';

                bool1 := FALSE;
                IF "Purchase Header".Category = "Purchase Header".Category::General THEN BEGIN
                    Header := 'PURCHASE ORDER';
                    bool1 := TRUE;
                    Type1 := 'Regular Purchase Order';
                END ELSE BEGIN
                    Header := 'SERVICE WORK ORDER';
                    Type1 := 'Service Work Order';
                END;

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




                AmountVendor := Round("Purchase Header"."Amount Including VAT", 0.01);
                RepCheck.InitTextVariable();
                RepCheck.FormatNoTextNew(Notext, AmountVendor, "Purchase Header"."Currency Code");
                AmountInWordsPO2 := Notext[1];
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
        /*IF RecItem.GET("Purchase Line"."No.") THEN;

        RecPurchaseLine.RESET;
        RecPurchaseLine.SETRANGE("Document No.", "Purchase Header"."No.");
        IF RecPurchaseLine.FINDSET THEN BEGIN
            REPEAT
                //amt:=amt+RecPurchaseLine."Line Amount";
                TotalLineAmt := RecPurchaseLine."Line Amount";
                VATAmount := "Purchase Line"."Amount Including VAT" - "Purchase Line".Amount;
                //MESSAGE(FORMAT(TotalLineAmt));
                //amt := amt + (TotalLineAmt + VATAmount);
                amt := RecPurchaseLine.Amount * RecPurchaseLine.Quantity;
                //Message(Format(amt));
                TotalVATAmt += VATAmount;
            //MESSAGE(FORMAT(amt));
            UNTIL RecPurchaseLine.NEXT = 0;
        END;*/
    end;

    var
        CompanyInfo: Record 79;
        srno: Integer;
        VATAmount: Decimal;
        AmountInWords: array[2] of Text[80];
        ReportCheck: Report 1401;
        amt: Decimal;
        RecPurchaseLine: Record 39;
        RecPaymentTerms: Record 3;
        PaymentDesc: Text[80];
        TotalLineAmt: Decimal;
        TotalVATAmt: Decimal;
        UserSetup: Record 91;
        RecPurchaser: Record "Salesperson/Purchaser";
        RepCheck: Report Check;
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
        PurchaserName: Text;
        PurchaserPhone: Text;
        Notext: array[2] of Text[80];
        AmountInWordsPO2: Text;
        AmountVendor: Decimal;


}

