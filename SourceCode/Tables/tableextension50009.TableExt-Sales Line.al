tableextension 50009 tableextension50009 extends "Sales Line"
{
    fields
    {

        field(50000; "Customer Line Reference"; Integer)
        {
            Caption = 'Customer Line Reference';
        }
        field(50001; Level; Integer)
        {
            BlankZero = true;
            Caption = 'Level';
            Editable = false;
            InitValue = 1;
            MinValue = 1;
        }
        field(50002; Position; Integer)
        {
            BlankZero = true;
            Caption = 'Position';
            Editable = false;
        }
        field(50003; "Quote Variant"; Option)
        {
            Caption = 'Quote Variant';
            OptionCaption = ' ,Calculate only,Variant';
            OptionMembers = " ","Calculate only",Variant;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                IF NOT HasTypeToFillMandatoryFields THEN
                    ERROR(Text50800);

                IF Type IN [Type::Item, Type::"Charge (Item)"] THEN BEGIN
                    IF Item.GET("No.") THEN;
                    IF "Quote Variant" = "Quote Variant"::Variant THEN
                        VALIDATE("Allow Invoice Disc.", FALSE)
                    ELSE
                        IF ((Type = Type::Item) AND Item."Allow Invoice Disc.") OR
                           (Type <> Type::Item)
                        THEN
                            VALIDATE("Allow Invoice Disc.", TRUE);
                END;
            end;
        }
        field(50004; "Subtotal Net"; Decimal)
        {
            BlankZero = true;
            Caption = 'Subtotal Net';
            Editable = false;
        }
        field(50005; "Subtotal Gross"; Decimal)
        {
            BlankZero = true;
            Caption = 'Subtotal Gross';
            Editable = false;
        }
        field(50006; "Title No."; Integer)
        {
            BlankZero = true;
            Caption = 'Title No.';
            Editable = false;
        }
        field(50007; Classification; Code[20])
        {
            Caption = 'Classification';
            Editable = false;
        }
    }







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

    var
        Text50800: Label 'Variant may only be used for G/L accounts, items and resources.';
        Text50801: Label 'You cannot insert further lines on this position. If the %1 has no entries yet, you can reorganize the lines with Function, Re-Calculate.';
        Text50802: Label 'Otherwise, you can insert after the last line.';
        Text50803: Label 'Line type %1 can only be used with the module quote management.';
        Text50804: Label '%1 must not be %2.';
        EstimateLbl: Label 'Estimate';
        CommentLbl: Label 'Comment';
}

