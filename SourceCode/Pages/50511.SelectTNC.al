page 50511 "SelectTNC"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Terms & Condtions";
    caption = 'Select Terms and Conditions';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Conditions; Rec.Conditions)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if Rec.Select = true then begin
                            TnC.Init();
                            TnC."Transaction Type" := MappedTransactionType;
                            TnC."Document Type" := MappedDocumentType;
                            TnC."Document No." := MappedDocumentNo;
                            TnC."No." := Rec."No.";
                            TnC.Conditions := Rec.Conditions;
                            TnC.Insert();
                        end
                        else begin
                            TnC.Reset();
                            TnC.SetRange(TnC."Transaction Type", MappedTransactionType);
                            TnC.SetRange(TnC."Document Type", MappedDocumentType);
                            TnC.SetRange(TnC."Document No.", MappedDocumentNo);
                            TnC.SetRange(TnC."No.", Rec."No.");
                            if TnC.FindFirst() then begin
                                TnC.Delete();
                            end
                        end;
                    end;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TnC.Reset();
        TnC.SetRange(TnC."Transaction Type", MappedTransactionType);
        TnC.SetRange(TnC."Document Type", MappedDocumentType);
        TnC.SetRange(TnC."Document No.", MappedDocumentNo);
        TnC.SetRange(TnC."No.", Rec."No.");
        if TnC.FindFirst() then begin
            Rec.Select := true;
        end;
    end;

    procedure SetDocumentTypes(TransactionType: Option Sales,Purchase,Service; DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Contract; DocumentNo: Code[20])
    begin
        MappedTransactionType := TransactionType;
        MappedDocumentType := DocumentType;
        MappedDocumentNo := DocumentNo;
    end;

    var
        MappedTransactionType: Option Sales,Purchase,Service;
        MappedDocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Contract;
        MappedDocumentNo: Code[20];
        TnC: Record "Terms & Condtions";
}