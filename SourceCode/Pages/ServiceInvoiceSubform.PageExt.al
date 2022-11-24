PageExtension 50282 pageextension50282 extends "Service Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Appl.-to Item Entry")
        {
            field("Deferral Code"; Rec."Deferral Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("ShortcutDimCode[8]")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("&Line")
        {
            action(DeferralSchedule)
            {
                Visible = false;
                ApplicationArea = Suite;
                Caption = 'Deferral Schedule';
                Enabled = Rec."Deferral Code" <> '';
                Image = PaymentPeriod;
                ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';

                trigger OnAction()
                var
                    ServHeader: Record "Service Header";
                begin
                    ServHeader.Get(Rec."Document Type", Rec."Document No.");
                    Rec.ShowDeferrals(ServHeader."Posting Date", ServHeader."Currency Code");
                end;
            }
        }
    }
}

