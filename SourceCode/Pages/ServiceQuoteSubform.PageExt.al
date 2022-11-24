PageExtension 50233 pageextension50233 extends "Service Quote Subform"
{
    layout
    {
        addafter("Line No.")
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';

                trigger OnValidate()
                begin
                    NoOnAfterValidate;
                end;
            }
            field(FilteredTypeField; TypeAsText)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Type';
                LookupPageID = "Option Lookup List";
                TableRelation = "Option Lookup Buffer"."Option Caption" where("Lookup Type" = const(Sales));
                ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item,, or G/L Account.';
                Visible = false;

                trigger OnValidate()
                begin
                    if TempOptionLookupBuffer.AutoCompleteLookup(TypeAsText, TempOptionLookupBuffer."lookup type"::Sales) then//WIN292
                        Rec.Validate(Type, TempOptionLookupBuffer.ID);
                    TempOptionLookupBuffer.ValidateOption(TypeAsText);
                    UpdateEditableOnRow;
                    UpdateTypeText;
                end;
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';

                trigger OnValidate()
                begin

                    NoOnAfterValidate;


                    UpdateEditableOnRow;
                end;
            }
        }
    }

    var
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        TypeAsText: Text[30];
        RowIsText: Boolean;

    local procedure "---"()
    begin
    end;

    local procedure NoOnAfterValidate()
    begin
    end;

    local procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        //TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Type)));
    end;

    local procedure UpdateEditableOnRow()
    var
        ServiceLine: Record "Service Item Line";
    begin
        RowIsText := (Rec."No." = '') and (Rec.Description <> '');
    end;

    local procedure UpdatePage()
    var
        ServiceHeader: Record "Service Header";
    begin
        CurrPage.Update;
    end;
}

