page 50069 "Service charge List1"
{
    Caption = 'Service charge List';
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
                field("<Service Contract No.>"; Rec."Service Contract Quote No.")
                {
                    ApplicationArea = All;
                    Caption = 'Service Contract No.';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Service Contract No."; Rec."Service Contract No.")
                {
                    ApplicationArea = All;
                    Visible = false;
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
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
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

                trigger OnAction()
                var
                    PDC: Record "Service Charges";
                begin
                    //CurrPage.SETSELECTIONFILTER(Rec);
                    Rec.TESTFIELD("Mode of Payment");
                    IF Rec."To Post" = TRUE THEN BEGIN
                        IF Rec.Post = FALSE THEN BEGIN
                            IF CONFIRM('Do you want to post service contract charges?', TRUE) THEN
                                ServiceChargesPosting(Rec);
                        END ELSE
                            ERROR('This Charges has been already posted');
                        //SETFILTER(Post,'<>%1',TRUE);
                    END ELSE
                        ERROR('No charges to post');
                end;
            }
        }
    }

    var
        ServiceContractHeader: Record 5965;
        JournalTemp: Record 80;
        GenJnlPostLine: Codeunit 12;

    local procedure ServiceChargesPosting(PDC: Record "Service Charges")
    var
        GenJournalLine: Record 81;
        Num: Integer;
        ServiceCharges: Record "Service Charges";
        ServiceContractHeader: Record 5965;
    begin
        //win315++
        //CurrPage.SETSELECTIONFILTER(Rec);
        GenJournalLine.RESET;
        GenJournalLine.SETFILTER(GenJournalLine."Journal Template Name", '%1', 'GENERAL');
        GenJournalLine.SETFILTER(GenJournalLine."Journal Batch Name", '%1', 'DEFAULT');
        IF GenJournalLine.FINDLAST THEN
            Num := GenJournalLine."Line No."
        ELSE
            Num := 0;

        ServiceCharges.SetRange("Service Contract No.", Rec."Service Contract No.");
        //ServiceCharges.SETRANGE(ServiceCharges."Service Contract Quote No.", PDC."Service Contract Quote No.");
        ServiceCharges.SETRANGE(ServiceCharges."To Post", TRUE);
        ServiceCharges.SETRANGE("Posting Allowed", TRUE);    // RealEstateCR
        ServiceCharges.SETFILTER(ServiceCharges."Charge Code", '<>%1', 'VAT');
        ServiceCharges.SETFILTER(ServiceCharges.Post, '%1', FALSE);
        ServiceCharges.SETFILTER(ServiceCharges."Charge Amount", '<>%1', 0);
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
                GenJournalLine."Charge Code" := ServiceCharges."Charge Code";
                GenJournalLine."Charge Description" := ServiceCharges."Charge Description";
                GenJournalLine."Service Quote No." := ServiceCharges."Service Contract Quote No.";
                GenJournalLine."Service Contract No." := ServiceCharges."Service Contract Quote No.";
                GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                GenJournalLine.VALIDATE("Bal. Account No.", ServiceCharges."Customer No.");
                IF ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Contract, ServiceCharges."Service Contract Quote No.") THEN BEGIN
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ServiceContractHeader."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ServiceContractHeader."Shortcut Dimension 2 Code");
                END;
                //GenJournalLine.Description := ServiceCharges."Charge Description";

                //GenJournalLine."VAT Prod. Posting Group" := ServiceCharges."VAT Prod. Posting Group";
                //GenJournalLine."Gen. Prod. Posting Group" := ServiceCharges."Gen. Prod. Posting Group";
                // GenJournalLine.INSERT(TRUE);

                //Win593++
                CreateCashReceiptJournal(GenJournalLine, ServiceCharges."Charge Amount");
                //Win593--

                GenJnlPostLine.RunWithCheck(GenJournalLine);

                ServiceCharges.Post := TRUE;
                ServiceCharges.MODIFY;

            UNTIL ServiceCharges.NEXT = 0;

        MESSAGE('The Charges Are Sucessfully Posted');

        //win315--
    end;

    //Win593
    local procedure CreateCashReceiptJournal(GenJournalLine: Record "Gen. Journal Line"; ChargeAmount: Decimal)
    var
        CashReceiptJnl: Record "Gen. Journal Line";
        Num: Integer;
    begin
        CashReceiptJnl.SETFILTER("Journal Template Name", '%1', 'CASH RECE');
        CashReceiptJnl.SETFILTER("Journal Batch Name", '%1', 'DEFAULT');
        IF CashReceiptJnl.FINDLAST THEN
            Num := CashReceiptJnl."Line No."
        ELSE
            Num := 0;

        CashReceiptJnl.Init();
        CashReceiptJnl.Validate("Journal Template Name", 'CASH RECE');
        CashReceiptJnl.Validate("Journal Batch Name", 'DEFAULT');
        CashReceiptJnl."Line No." := Num + 10000;
        CashReceiptJnl.Validate("Posting Date", GenJournalLine."Posting Date");
        CashReceiptJnl.Validate("Document Type", CashReceiptJnl."Document Type"::Payment);
        CashReceiptJnl.Validate("Document No.", GenJournalLine."Document No.");
        CashReceiptJnl.Validate("Account Type", GenJournalLine."Account Type");
        CashReceiptJnl.Validate("Account No.", '2910');
        CashReceiptJnl.Description := 'Cash';
        CashReceiptJnl.Validate("Debit Amount", ChargeAmount);
        CashReceiptJnl.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type");
        CashReceiptJnl.Validate("Bal. Account No.", GenJournalLine."Bal. Account No.");
        CashReceiptJnl.Insert(true);
    end;
    //Win593

}

