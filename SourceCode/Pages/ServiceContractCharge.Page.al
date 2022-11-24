page 50064 "Service Contract Charge"
{
    PageType = List;
    SourceTable = "Service Charges";

    layout
    {
        area(content)
        {
            repeater(General)
            {

            }
            field("Charge Code"; Rec."Charge Code")
            {
                ApplicationArea = All;
            }
            field("Service Contract Quote No."; Rec."Service Contract Quote No.")
            {
                ApplicationArea = All;
            }
            field("Service Contract No."; Rec."Service Contract No.")
            {
                ApplicationArea = All;
            }
            field("Charge Description"; Rec."Charge Description")
            {
                ApplicationArea = All;
            }
            field("Charge Amount"; Rec."Charge Amount")
            {
                ApplicationArea = All;
            }
            field("G/L Account No."; Rec."Bal. Account No.")
            {
                ApplicationArea = All;
                Caption = 'G/L Account No.';
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field(Post; Rec.Post)
            {
                ApplicationArea = All;
            }
            field(Unposted; Rec.Unposted)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Charges")
            {
                ApplicationArea = All;
                Caption = 'Post Charges';

                trigger OnAction()
                begin

                    IF Rec.Post = FALSE THEN BEGIN
                        IF CONFIRM('Do you want to post service contract charges?', TRUE) THEN
                            ServiceChargesPosting(Rec."Service Contract Quote No.");
                    END;

                end;
            }
        }
    }

    var
        ServiceContractHeader: Record 5965;

    local procedure ServiceChargesPosting(ContractNo: Code[20])
    var
        GenJournalLine: Record 81;
        Num: Integer;
        ServiceCharges: Record "Service Charges";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETFILTER(GenJournalLine."Journal Template Name", '%1', 'GENERAL');
        GenJournalLine.SETFILTER(GenJournalLine."Journal Batch Name", '%1', 'DEFAULT');
        IF GenJournalLine.FINDLAST THEN
            Num := GenJournalLine."Line No."
        ELSE
            Num := 0;

        ServiceCharges.RESET;
        ServiceCharges.SETRANGE(ServiceCharges."Service Contract Quote No.", ContractNo);
        ServiceCharges.SETFILTER(ServiceCharges.Unposted, '%1', TRUE);
        ServiceCharges.SETFILTER(ServiceCharges.Post, '%', FALSE);
        IF ServiceCharges.FINDSET THEN
            REPEAT
                    GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                Num := Num + 1000;
                GenJournalLine."Line No." := Num;
                GenJournalLine.VALIDATE("Posting Date", ServiceCharges."Charge Date");
                //GenJournalLine."Document No." := ServiceCharges."Document No.";
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.", ServiceCharges."Bal. Account No.");
                GenJournalLine.VALIDATE(GenJournalLine.Amount, ServiceCharges."Charge Amount");
                GenJournalLine."External Document No." := ServiceCharges."Charge Code";
                GenJournalLine."Service Quote No." := ServiceCharges."Service Contract Quote No.";
                //GenJournalLine.Description := ServiceCharges."Charge Description";

                //GenJournalLine."VAT Prod. Posting Group" := ServiceCharges."VAT Prod. Posting Group";
                //GenJournalLine."Gen. Prod. Posting Group" := ServiceCharges."Gen. Prod. Posting Group";
                GenJournalLine.INSERT(TRUE);

                ServiceCharges.Post := TRUE;
                ServiceCharges.MODIFY;

            UNTIL ServiceCharges.NEXT = 0;
    end;
}

