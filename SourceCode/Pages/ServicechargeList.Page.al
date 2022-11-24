page 50065 "Service charge List"
{
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
                    trigger OnValidate()
                    begin
                        Rec.CALCFIELDS("Approval Status");
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Open);
                    end;
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
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.CALCFIELDS("Approval Status");
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Open);
                    end;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
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
                field("Charge Date"; Rec."Charge Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CALCFIELDS("Approval Status");
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Open);
                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CALCFIELDS("Approval Status");
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Open);
                    end;
                }
                field("To Post"; Rec."To Post")
                {
                    ApplicationArea = All;
                }
                field("Mode of Payment"; Rec."Mode of Payment")
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
            action("Post Charges")
            {
                ApplicationArea = All;
                Caption = 'Post Charges';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin

                    IF Rec.Post = FALSE THEN BEGIN
                        IF CONFIRM('Do you want to post service contract charges?', TRUE) THEN
                            ServiceChargesPosting(Rec."Service Contract Quote No.");
                    END ELSE
                        ERROR('This Charges has been already posted');
                end;
            }
        }
    }

    var
        ServiceContractHeader: Record 5965;
        JournalTemp: Record 80;
        GenJnlPostLine: Codeunit 12;

    local procedure ServiceChargesPosting(ContractNo: Code[20])
    var
        GenJournalLine: Record 81;
        Num: Integer;
        ServiceCharges: Record "Service Charges";
        ServiceContractHeader: Record 5965;
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
                IF ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Contract, ServiceCharges."Service Contract Quote No.") THEN BEGIN
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ServiceContractHeader."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ServiceContractHeader."Shortcut Dimension 2 Code");
                END;
                // GenJournalLine.VALIDATE("Dimension Set ID",ServiceCharges."Dimension Set ID");
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

