PageExtension 50149 pageextension50149 extends "General Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field(Narration; rec.Narration)
            {
                ApplicationArea = Basic;
            }
            field("Check Date"; rec."Check Date")
            {
                ApplicationArea = Basic;
            }
            field("Check No."; rec."Check No.")
            {
                ApplicationArea = Basic;
            }
            field("PDC Document No."; rec."PDC Document No.")
            {
                ApplicationArea = Basic;
            }
            field("PDC Line No."; rec."PDC Line No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Reversed Entry No.")
        {
            field("Reversal Reason Code"; rec."Reversal Reason Code")
            {
                ApplicationArea = Basic;
            }
            field("Reversal Reason Comments"; rec."Reversal Reason Comments")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Entry No.")
        {
            field("VLE Exist"; rec."VLE Exist")
            {
                ApplicationArea = Basic;
                Visible = false;
            }

        }
        moveafter("VLE Exist"; "External Document No.")
    }
    actions
    {
        addafter(ReverseTransaction)
        {
            action("Print Voucher")
            {
                ApplicationArea = Basic;
                Caption = 'Print Voucher';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GLEntry.SetCurrentkey("Document No.", "Posting Date");
                    GLEntry.SetRange("Document No.", rec."Document No.");
                    GLEntry.SetRange("Posting Date", rec."Posting Date");
                    if GLEntry.FindFirst then;
                    Report.RunModal(Report::"Posted Voucher", true, true, GLEntry);
                end;
            }
        }
    }

    var
        GLEntry: Record "G/L Entry";
}

