page 50086 "To Apply CLE for Court Cases"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData 21 = rm;
    SourceTable = 21;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Apply Doc. No."; Rec."Apply Doc. No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Apply Entries"; Rec."Apply Entries")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Apply Amount"; Rec."Apply Amount")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
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
            action("Set to Doc. No.Court")
            {
                ApplicationArea = All;
                Caption = 'Apply Doc. No. for Court  Case';
                Image = Apply;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    //for Court
                    Rec.TESTFIELD("Apply Amount");

                    Rec."Apply Doc. No." := doc;
                    Rec."Apply to ID" := USERID;
                    Rec."Apply Entries" := TRUE;
                    Rec.MODIFY;
                    //RecPDC.MODIFY;
                    RecCourt.RESET;
                    RecCourt.SETRANGE(RecCourt."Case No.", doc);
                    IF RecCourt.FINDSET THEN
                            REPEAT
                                RecCourt.CALCFIELDS("Applied Amount");
                                //RecPDC."Remaining Amount" := RecPDC."Applied Amount" + RecPDC.Amount;
                                amt += RecCourt."Applied Amount";
                                RecCourt."Balancing Amount" := ABS(RecCourt."Customer Balance" - amt);
                                RecCourt.MODIFY;
                            UNTIL RecCourt.NEXT = 0;
                    //END;
                end;
            }
            action("Unapply Court")
            {
                ApplicationArea = All;
                Caption = 'Unapply for Court Cases';
                Image = UnApply;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var

                begin
                    amt := 0;
                    RecCourt1.RESET;
                    RecCourt1.SETRANGE(RecCourt1."Case No.", Rec."Apply Doc. No.");
                    IF RecCourt1.FINDFIRST THEN BEGIN//REPEAT
                        amt := Rec."Apply Amount";
                        //UNTIL RecPDC1.NEXT =0;
                        //MESSAGE(FORMAT(amt));

                        RecCourt1.CALCFIELDS("Applied Amount");
                        RecCourt1."Balancing Amount" := ABS(RecCourt1."Customer Balance" - (RecCourt1."Applied Amount" - amt));
                        //RecPDC1."App Amount" := RecPDC1."Applied Amount";
                        RecCourt1.MODIFY;
                        Rec."Apply Doc. No." := '';
                        Rec."Apply Entries" := FALSE;
                        Rec."Apply to ID" := '';
                        Rec."Apply Amount" := 0;
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        Rec.SETFILTER("Customer No.", Cust);
    end;

    var
        ApplyDocNo: Code[20];
        RecPDC: Record "Post Dated Check Line";
        abc: Code[10];
        amt: Decimal;
        RecPDC1: Record "Post Dated Check Line";
        doc: Code[20];
        NewDoc: Code[20];
        RecCourt: Record 50014;
        Cust: Code[20];
        RecCourt1: Record 50014;


    procedure AddDocNo(docre: Code[20]; CustNo: Code[20])
    begin
        doc := docre;
        Cust := CustNo;
    end;
}

