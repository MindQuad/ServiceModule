page 50071 "Posted Service Charges1"
{
    Caption = 'Posted Service Charges';
    Editable = false;
    PageType = List;
    SourceTable = "Service Charges";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Service Contract Quote No."; Rec."Service Contract Quote No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
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
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Post)
                {
                    ApplicationArea = All;
                }
                field("Charge Date"; Rec."Charge Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("To Post"; Rec."To Post")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    var
        ServiceContractHeader: Record 5965;
        JournalTemp: Record 80;
        GenJnlPostLine: Codeunit 12;

    local procedure ServiceChargesPosting()
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

        ServiceCharges.SETFILTER(ServiceCharges.Post, '%1', FALSE);
        IF ServiceCharges.FINDSET THEN
                REPEAT
                    GenJournalLine.INIT;
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", 'GENERAL');
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", 'DEFAULT');
                    Num := Num + 1000;
                    GenJournalLine."Line No." := Num;
                    IF JournalTemp.GET(GenJournalLine."Journal Template Name") THEN
                        GenJournalLine.VALIDATE("Source Code", JournalTemp."Source Code");
                    GenJournalLine.VALIDATE("Posting Date", ServiceCharges."Charge Date");
                    GenJournalLine."Document No." := ServiceCharges."Document No.";
                    GenJournalLine.VALIDATE(GenJournalLine."Document Type", GenJournalLine."Document Type"::" ");
                    GenJournalLine.VALIDATE(GenJournalLine."Account Type", GenJournalLine."Account Type"::"G/L Account");
                    GenJournalLine."Account No." := ServiceCharges."Bal. Account No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount, ServiceCharges."Charge Amount");
                    GenJournalLine."External Document No." := ServiceCharges."Charge Code";
                    GenJournalLine."Service Quote No." := ServiceCharges."Service Contract Quote No.";
                    GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                    GenJournalLine.VALIDATE("Bal. Account No.", ServiceCharges."Customer No.");
                    //GenJournalLine.Description := ServiceCharges."Charge Description";

                    //GenJournalLine."VAT Prod. Posting Group" := ServiceCharges."VAT Prod. Posting Group";
                    //GenJournalLine."Gen. Prod. Posting Group" := ServiceCharges."Gen. Prod. Posting Group";
                    // GenJournalLine.INSERT(TRUE);
                    GenJnlPostLine.RunWithCheck(GenJournalLine);

                    ServiceCharges.Post := TRUE;
                    ServiceCharges.MODIFY;

                UNTIL ServiceCharges.NEXT = 0;

        MESSAGE('The Charges Are Sucessfully Posted');
    end;
}

