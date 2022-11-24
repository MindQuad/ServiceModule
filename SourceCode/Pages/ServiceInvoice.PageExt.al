PageExtension 50281 pageextension50281 extends "Service Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Assigned User ID")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit No"; Rec."Service Item No.")
            {
                ApplicationArea = Basic;
            }
            field("Defferal Code"; Rec."Defferal Code")
            {
                ApplicationArea = Basic;
            }
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Prices Including VAT")
        {
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = Basic;
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Location Code")
        {
            field("Shipping No. Series"; Rec."Shipping No. Series")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("Service Document Lo&g")
        {
            action(DeferralSchedule)
            {
                Visible = false;
                ApplicationArea = Suite;
                Caption = 'Deferral Schedule';
                Image = PaymentPeriod;
                ToolTip = 'View or edit the deferral schedule that governs how expenses or revenue are deferred to different accounting periods when the journal line is posted.';

                trigger OnAction()
                var
                    DeferralSchedule: Page "Deferral Schedule";
                    DeferralHeader: Record "Deferral Header";
                begin
                    if DeferralHeader.Get(2, '', '', 0, Rec."No.", 0) then begin
                        DeferralSchedule.SetParameter(2, '', '', 0, Rec."No.", 0);
                        DeferralSchedule.RunModal;//page 1702
                                                  //Changed := DeferralSchedule.GetParameter;
                        Clear(DeferralSchedule);
                    end;
                end;
            }
        }
    }
}

