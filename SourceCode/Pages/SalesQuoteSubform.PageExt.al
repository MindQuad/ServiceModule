PageExtension 50170 pageextension50170 extends "Sales Quote Subform"
{
    layout
    {

        addafter("Variant Code")
        {
            field(Position; rec.Position)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pos';
                ToolTip = 'Specifies the position of the line on the page. This number is calculated automatically.';
            }
            field("Quote Variant"; rec."Quote Variant")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies if the line is a normal sales line, used for calculation only, or if it is a variant that is not included in the total and is printed in italics, if the sales quote form is formatted for it.';
            }
        }
    }

    var
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        "--CUSTOM.VAR": Integer;
        ItemChargeStyleExpression: Text;

    local procedure "--"()
    begin
    end;

    local procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(rec.FieldNo(Type)));
    end;

    local procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        if rec.AssignedItemCharge then
            ItemChargeStyleExpression := 'Unfavorable';
    end;
}

