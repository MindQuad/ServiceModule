tableextension 50042 tableextension50042 extends "Service Line"
{
    // WIN-438 : Added new field LSM Group & Code on Quantity On Validate.
    // WIN-438 : 25/10/2018 : Added new fileds related to Margin & code for Margin Calculation.
    fields
    {
        modify("No.")
        {
            Description = 'WIN-438';

            trigger OnAfterValidate()
            begin
                //WIN-438++
                IF (Type = Type::Item) AND ("No." <> '') AND ("Location Code" <> '') THEN
                    CalculatePreciseAverageCost("No.", "Location Code", "Variant Code");
                //WIN-438--
            end;
        }
        modify("Location Code")
        {
            Description = 'WIN-438';

            trigger OnAfterValidate()
            begin
                //WIN-438++
                IF (Type = Type::Item) AND ("No." <> '') AND ("Location Code" <> '') THEN
                    CalculatePreciseAverageCost("No.", "Location Code", "Variant Code");
                IF "Unit Price" <> 0 THEN
                    VALIDATE("Line Discount %");
                //WIN-438--
            end;
        }
        modify(Quantity)
        {
            Description = 'WIN-438';


            trigger OnAfterValidate()
            begin
                //WIN-438++
                ServiceLineRec.RESET;
                ServiceLineRec.SETCURRENTKEY(ServiceLineRec."Document Type", ServiceLineRec."Document No.", ServiceLineRec."Line No.");
                ServiceLineRec.SETRANGE(ServiceLineRec."Document Type", "Document Type");
                ServiceLineRec.SETRANGE(ServiceLineRec."Document No.", "Document No.");
                ServiceLineRec.SETRANGE(ServiceLineRec.Type, ServiceLineRec.Type::"Begin-Total");
                ServiceLineRec.SETFILTER(ServiceLineRec."Line No.", '<%1', "Line No.");
                IF ServiceLineRec.FINDLAST THEN
                    "LSM Group" := ServiceLineRec."LSM Group";
                //WIN-438--
            end;
        }


        field(1700; "Deferral Code"; Code[10])
        {
            Caption = 'Deferral Code';
            Description = '//WINS.AE';
            TableRelation = "Deferral Template"."Deferral Code";

            trigger OnValidate()
            var
                ServDocType: Enum "Service Document Type";
            begin
                //Win593++
                //GetServHeader;
                ServHeader.Get("Document Type", "Document No.");
                //Win593--
                DeferralPostDate := ServHeader."Posting Date";

                //Win513++
                // DeferralUtilities.DeferralCodeOnValidate(
                //   "Deferral Code", DeferralUtilities.GetSalesDeferralDocType, '', '',
                //   ServDocType.AsInteger(), "Document No.", "Line No.",
                //   GetDeferralAmount, DeferralPostDate,
                //   Description, ServHeader."Currency Code");

                // IF "Document Type" = "Document Type"::"Credit Memo" THEN
                //     "Returns Deferral Start Date" :=
                //       DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetSalesDeferralDocType,
                //         ServDocType.AsInteger(), "Document No.", "Line No.", "Deferral Code", ServHeader."Posting Date");

                DeferralUtilities.DeferralCodeOnValidate(
                                  "Deferral Code", GetSalesDeferralDocType, '', '',
                                  ServDocType.AsInteger(), "Document No.", "Line No.",
                                  GetDeferralAmount, DeferralPostDate,
                                  Description, ServHeader."Currency Code");

                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    "Returns Deferral Start Date" :=
                      DeferralUtilities.GetDeferralStartDate(GetSalesDeferralDocType,
                        ServDocType.AsInteger(), "Document No.", "Line No.", "Deferral Code", ServHeader."Posting Date");

                //Win513--
            end;
        }
        field(1702; "Returns Deferral Start Date"; Date)
        {
            Caption = 'Returns Deferral Start Date';
            Description = '//WINS.AE';

            trigger OnValidate()
            var
                DeferralHeader: Record 1701;
                ServHeader: Record "Service Header";
                AllSubs: Codeunit "All Subscriber";
                DefDoctypeVal: Enum "Deferral Document Type";

            begin
                GetServHeader;
                IF DeferralHeader.GET(DefDoctypeVal, '', '', "Document Type", "Document No.", "Line No.") THEN
                    //Win513++
                    // AllSubs.CreateServiceDeferralSchedule("Deferral Code", DeferralUtilities.GetSalesDeferralDocType, '', '',
                    //  "Document Type", "Document No.", "Line No.", GetDeferralAmount,
                    //  DeferralHeader."Calc. Method", "Returns Deferral Start Date",
                    //  DeferralHeader."No. of Periods", TRUE,
                    //  DeferralHeader."Schedule Description", FALSE,
                    //  ServHeader."Currency Code");
                    AllSubs.CreateServiceDeferralSchedule("Deferral Code", GetSalesDeferralDocType, '', '',
                     "Document Type".AsInteger(), "Document No.", "Line No.", GetDeferralAmount,
                     DeferralHeader."Calc. Method", "Returns Deferral Start Date",
                     DeferralHeader."No. of Periods", TRUE,
                     DeferralHeader."Schedule Description", FALSE,
                     ServHeader."Currency Code");
                //Win513--
            end;
        }
        field(50000; "Customer Line Reference"; Integer)
        {
            Caption = 'Customer Line Reference';
            Description = 'WINS.03032018.1751';
        }
        field(50001; Level; Integer)
        {
            BlankZero = true;
            Caption = 'Level';
            Description = 'WINS.03032018.1751';
            Editable = false;
            InitValue = 1;
            MinValue = 1;
        }
        field(50002; Position; Integer)
        {
            BlankZero = true;
            Caption = 'Position';
            Description = 'WINS.03032018.1751';
            Editable = false;
        }
        field(50003; "Quote Variant"; Option)
        {
            Caption = 'Quote Variant';
            Description = 'WINS.03032018.1751';
            OptionCaption = ' ,Calculate only,Variant';
            OptionMembers = " ","Calculate only",Variant;
        }
        field(50004; "Subtotal Net"; Decimal)
        {
            BlankZero = true;
            Caption = 'Subtotal Net';
            Description = 'WINS.03032018.1751';
            Editable = false;
        }
        field(50005; "Subtotal Gross"; Decimal)
        {
            BlankZero = true;
            Caption = 'Subtotal Gross';
            Description = 'WINS.03032018.1751';
            Editable = false;
        }
        field(50006; "Title No."; Integer)
        {
            BlankZero = true;
            Caption = 'Title No.';
            Description = 'WINS.03032018.1751';
            Editable = false;
        }
        field(50007; Classification; Code[20])
        {
            Caption = 'Classification';
            Description = 'WINS.03032018.1751';
            Editable = false;
        }
        field(50008; "LSM Group"; Boolean)
        {
            Caption = 'LSM Group';
            Description = 'WIN-438';

            trigger OnValidate()
            begin
                //WIN-438++
                ServiceLineRec.RESET;
                ServiceLineRec.SETCURRENTKEY(ServiceLineRec."Document Type", ServiceLineRec."Document No.", ServiceLineRec."Line No.");
                ServiceLineRec.SETRANGE(ServiceLineRec."Document Type", "Document Type");
                ServiceLineRec.SETRANGE(ServiceLineRec."Document No.", "Document No.");
                ServiceLineRec.SETFILTER(ServiceLineRec."Line No.", '>%1', "Line No.");
                IF ServiceLineRec.FINDSET THEN
                    REPEAT
                        ServiceLineRec."LSM Group" := "LSM Group";
                        ServiceLineRec.MODIFY;
                    UNTIL (ServiceLineRec.NEXT = 0) OR (ServiceLineRec.Type = ServiceLineRec.Type::"Begin-Total");
                //WIN-438--
            end;
        }
        field(50009; "Margin %"; Decimal)
        {
            Description = 'WIN-438';

            trigger OnValidate()
            begin
                /*//WIN-438++
                 IF "Margin %" <> 0 THEN
                   VALIDATE("Unit Price",ROUND(((("Margin %" / 100) + 1) * "Average Unit Cost"),0.01,'>'));
                //WIN-438--*/

                //WIN-438++
                IF "Margin %" <> 0 THEN
                    VALIDATE("Unit Price", ((("Margin %" / 100) + 1) * "Unit Cost (LCY)"));
                //WIN-438--

            end;
        }
        field(50010; "Margin Amount"; Decimal)
        {
            Description = 'WIN-438';
            Editable = false;
        }
        field(50011; "Cost Amount"; Decimal)
        {
            Description = 'WIN-438';
            Editable = false;
        }
        field(50012; "Average Unit Cost"; Decimal)
        {
            Description = 'WIN-438';
            Editable = false;
        }
        field(50101; "Non-VAT"; Boolean)
        {
            Description = 'RealEstateCr';
        }
        //Win593
        field(50102; "Actual Price"; Decimal)
        {
            Description = 'RealEstateCr';
            Caption = 'Actual Price';
        }
        field(50103; "FMS Approved"; Boolean)
        {
            Description = 'RealEstateCr';
            Caption = 'FMS Approved';

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Get(UserId);
                if not UserSetup."FMS Approver" then
                    Error(ApprovedErr);
            end;
        }
        //Win593
    }


    local procedure "--"()
    begin
    end;

    procedure GetDeferralAmount() DeferralAmount: Decimal
    begin
        IF "VAT Base Amount" <> 0 THEN
            DeferralAmount := "VAT Base Amount"
        ELSE
            DeferralAmount := "Line Amount" - "Inv. Discount Amount";
    end;

    procedure ShowDeferrals(PostingDate: Date; CurrencyCode: Code[10]): Boolean
    begin
        //Win513++
        // EXIT(DeferralUtilities.OpenLineScheduleEdit(
        //     "Deferral Code", DeferralUtilities.GetSalesDeferralDocType, '', '',
        //     "Document Type", "Document No.", "Line No.",
        //     GetDeferralAmount, PostingDate, Description, CurrencyCode));
        EXIT(DeferralUtilities.OpenLineScheduleEdit(
        "Deferral Code", GetSalesDeferralDocType, '', '',
        "Document Type".AsInteger(), "Document No.", "Line No.",
        GetDeferralAmount, PostingDate, Description, CurrencyCode));
        //Win513--
    end;

    //Win513++
    procedure GetSalesDeferralDocType(): Integer
    var
        DeferralHeader: Record "Deferral Header";
    begin
        EXIT(DeferralHeader."Deferral Doc. Type"::Sales.AsInteger());
    end;
    //Win513--

    local procedure "---"()
    begin
    end;

    procedure HasTypeToFillMandatoryFields(): Boolean
    begin
        EXIT(NOT (Type IN [Type::" ", Type::Title, Type::"Begin-Total", Type::"End-Total", Type::"New Page"]));
    end;

    procedure FormatType(): Text[20]
    begin
        IF Type = Type::" " THEN
            EXIT(CommentLbl);

        EXIT(FORMAT(Type));
    end;

    procedure AssignedItemCharge(): Boolean
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignFieldsForNo(var SalesLine: Record 37; xSalesLine: Record 37; SalesHeader: Record 36)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignHeaderValues(var SalesLine: Record 37; SalesHeader: Record 36)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignStdTxtValues(var SalesLine: Record 37; StandardText: Record 7)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignGLAccountValues(var SalesLine: Record 37; GLAccount: Record 15)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignItemValues(var SalesLine: Record 37; Item: Record 27)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignItemChargeValues(var SalesLine: Record 37; ItemCharge: Record 5800)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignResourceValues(var SalesLine: Record 37; Resource: Record 156)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignFixedAssetValues(var SalesLine: Record 37; FixedAsset: Record 5600)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignItemUOM(var SalesLine: Record 37; Item: Record 27)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignResourceUOM(var SalesLine: Record 37; Resource: Record 156; ResourceUOM: Record 205)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateUnitPrice(var SalesLine: Record 37; xSalesLine: Record 37; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateUnitPrice(var SalesLine: Record 37; xSalesLine: Record 37; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVerifyReservedQty(var SalesLine: Record 37; xSalesLine: Record 37; CalledByFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitOutstandingAmount(var SalesLine: Record 37; SalesHeader: Record 36; Currency: Record 4)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitQtyToInvoice(var SalesLine: Record 37; CurrFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitQtyToShip(var SalesLine: Record 37; CurrFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitQtyToReceive(var SalesLine: Record 37; CurrFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateAmounts(var SalesLine: Record 37)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateAmountsDone(var SalesLine: Record 37; var xSalesLine: Record 37; CurrentFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDimTableIDs(var SalesLine: Record 37; FieldNo: Integer; TableID: array[10] of Integer; No: array[10] of Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShowItemSub(var SalesLine: Record 37)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateTypeOnCopyFromTempSalesLine(var SalesLine: Record 37; var TempSalesLine: Record 37 temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record 37; var TempSalesLine: Record 37 temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestStatusOpen(var SalesLine: Record 37; var SalesHeader: Record 36)
    begin
    end;

    local procedure CalculatePreciseAverageCost(ItemCode: Code[20]; LocationCode: Code[20]; VariantCode: Code[20])
    var
        ItemLedgerEntry: Record 32;
    begin
        //Function Copied from Codeunit 5804 (CalculatePreciseCostAmounts)
        //WIN-438++
        //Win513++
        // WITH ItemLedgerEntry DO BEGIN
        //     ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.", ItemCode);
        //     ItemLedgerEntry.SETRANGE(ItemLedgerEntry.Open, TRUE);
        //     ItemLedgerEntry.SETRANGE(ItemLedgerEntry.Positive, TRUE);
        //     ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Location Code", LocationCode);
        //     IF VariantCode <> '' THEN
        //         ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Variant Code", VariantCode);
        //     IF ItemLedgerEntry.FINDSET THEN
        //         REPEAT
        //             CALCFIELDS(ItemLedgerEntry."Cost Amount (Actual)", ItemLedgerEntry."Cost Amount (Expected)");
        //             IF ItemLedgerEntry.Quantity <> 0 THEN
        //                 "Average Unit Cost" += (ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") /
        //                                     ItemLedgerEntry.Quantity;
        //         UNTIL ItemLedgerEntry.NEXT = 0;
        // END;
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.", ItemCode);
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry.Open, TRUE);
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry.Positive, TRUE);
        ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Location Code", LocationCode);
        IF VariantCode <> '' THEN
            ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Variant Code", VariantCode);
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                ItemLedgerEntry.CALCFIELDS(ItemLedgerEntry."Cost Amount (Actual)", ItemLedgerEntry."Cost Amount (Expected)");
                IF ItemLedgerEntry.Quantity <> 0 THEN
                    "Average Unit Cost" += (ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") /
                                        ItemLedgerEntry.Quantity;
            UNTIL ItemLedgerEntry.NEXT = 0;
        //Win513--
        //WIN-438--
    end;

    var
        DeferralPostDate: Date;
        DeferralUtilities: Codeunit 1720;
        DeferralChangeConfirmed: Boolean;
        Warning053: Label 'Service Lines being modified';
        ApprovedErr: Label 'You dont have permission to approve';
        Text50801: Label 'You cannot insert further lines on this position. If the %1 has no entries yet, you can reorganize the lines with Function, Re-Calculate.';
        Text50802: Label 'Otherwise, you can insert after the last line.';
        Text50803: Label 'Line type %1 can only be used with the module quote management.';
        Text50804: Label '%1 must not be %2.';
        EstimateLbl: Label 'Estimate';
        CommentLbl: Label 'Comment';
        ServiceLineRec: Record 5902;
        ServHeader: Record "Service Header";
}

