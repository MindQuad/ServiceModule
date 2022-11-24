PageExtension 50235 pageextension50235 extends "Posted Service Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Defferal Code"; Rec."Defferal Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Order No.")
        {
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("No. Printed")
        {
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = Basic;
                MultiLine = true;
            }
        }
    }
    actions
    {
        addafter("Service Document Lo&g")
        {
            action(CancelInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.';

                trigger OnAction()
                var
                    CancelPstdSalesInvYesNo: Codeunit "Cancel PstdSalesInv (Yes/No)";
                begin
                    /*IF CancelPstdSalesInvYesNo.CancelInvoice(Rec) THEN
                      CurrPage.CLOSE;
                      */

                end;
            }
        }
    }
}

