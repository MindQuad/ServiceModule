report 50030 "Purchase Order EXT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseOrderEXT.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(Logo; CompInfo.Picture)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name")
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
            column(BuyfromPostCode_PurchaseHeader; "Purchase Header"."Buy-from Post Code")
            {
            }
            column(BuyfromCountryRegionCode_PurchaseHeader; "Purchase Header"."Buy-from Country/Region Code")
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
            column(ShiptoPostCode_PurchaseHeader; "Purchase Header"."Ship-to Post Code")
            {
            }
            column(ShiptoCounty_PurchaseHeader; "Purchase Header"."Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode_PurchaseHeader; "Purchase Header"."Ship-to Country/Region Code")
            {
            }
            column(PaymentTerms; PaymentTerms.Description)
            {
            }
            column(ShipmentMethod; ShipMethd.Description)
            {
            }
            column(VendorName; RecVendor.Name)
            {
            }
            column(VendorAddr; RecVendor.Address)
            {
            }
            column(VendorAddr2; RecVendor."Address 2")
            {
            }
            column(VendorCity; RecVendor.City)
            {
            }
            column(VendorCountry; RecVendor."Country/Region Code")
            {
            }
            column(VendorContact; RecVendor.Contact)
            {
            }
            column(VendorPhone; RecVendor."Phone No.")
            {
            }
            column(VendorFax; RecVendor."Fax No.")
            {
            }
            column(Amount_PurchaseHeader; "Purchase Header".Amount)
            {
            }
            column(AmountIncludingVAT_PurchaseHeader; "Purchase Header"."Amount Including VAT")
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(DocumentNo_PurchaseLine; "Purchase Line"."Document No.")
                {
                }
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
                column(AmountIncludingVAT_PurchaseLine; "Purchase Line"."Amount Including VAT")
                {
                }
                column(VAT_PurchaseLine; "Purchase Line"."VAT %")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                PaymentTerms.RESET;
                PaymentTerms.SETRANGE(PaymentTerms.Code, "Purchase Header"."Payment Terms Code");
                IF PaymentTerms.FINDFIRST THEN;

                RecVendor.RESET;
                RecVendor.SETRANGE(RecVendor."No.", "Purchase Header"."Buy-from Vendor No.");
                IF RecVendor.FINDFIRST THEN;

                ShipMethd.RESET;
                ShipMethd.SETRANGE(ShipMethd.Code, "Purchase Header"."Shipment Method Code");
                IF ShipMethd.FINDFIRST THEN;

                CurrCode := '';
                GLSetup.GET;
                IF "Purchase Header"."Currency Code" = '' THEN
                    CurrCode := GLSetup."LCY Code"
                ELSE
                    CurrCode := "Purchase Header"."Currency Code";
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
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
    end;

    var
        PaymentTerms: Record 3;
        RecVendor: Record 23;
        CompInfo: Record 79;
        ShipMethd: Record 10;
        CurrCode: Code[10];
        GLSetup: Record 98;
}

