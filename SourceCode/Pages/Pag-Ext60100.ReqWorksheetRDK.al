pageextension 60100 "Req. Worksheet RDK" extends "Req. Worksheet"
{
    layout
    {
        // Add changes to page layout here
    }

    //Win593
    actions
    {
        addafter(CarryOutActionMessage)
        {
            action("Create Purchase Quote")
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Quote';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    PurchLine: Record "Purchase Line";
                    ReqLine: Record "Requisition Line";
                    LineNo: Integer;
                    PrevVendorNo: Code[20];
                    Counter: Integer;
                begin
                    ReqLine.SetCurrentKey("Vendor No.");
                    ReqLine.SetRange("Worksheet Template Name", 'REQ.');
                    ReqLine.SetRange("Journal Batch Name", 'DEFAULT');
                    if ReqLine.FindSet() then
                        repeat
                            if ReqLine."Vendor No." <> PrevVendorNo then begin
                                Clear(PurchHeader);
                                PurchHeader.Init();
                                PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Quote);
                                PurchHeader.Insert(true);
                                PurchHeader.Validate("Buy-from Vendor No.", ReqLine."Vendor No.");
                                PurchHeader.Validate("Location Code", ReqLine."Location Code");
                                PurchHeader.Validate("Due Date", ReqLine."Due Date");
                                PurchHeader.Modify(true);
                                Counter += 1;
                                PrevVendorNo := ReqLine."Vendor No.";
                            end;

                            Clear(PurchLine);
                            PurchLine.SetRange("Document Type", PurchHeader."Document Type"::Quote);
                            PurchLine.SetRange("Document No.", PurchHeader."No.");
                            if PurchLine.FindLast() then
                                LineNo := PurchLine."Line No." + 10000
                            else
                                LineNo := 10000;

                            Clear(PurchaseLine);
                            PurchaseLine.Init();
                            PurchaseLine.Validate("Document Type", PurchaseLine."Document Type"::Quote);
                            PurchaseLine.Validate("Document No.", PurchHeader."No.");
                            PurchaseLine.Validate("Line No.", LineNo);
                            PurchaseLine.Insert(true);
                            PurchaseLine.Validate(PurchaseLine.Type, PurchaseLine.Type::Item);
                            PurchaseLine.Validate("No.", ReqLine."No.");
                            PurchaseLine.Validate(Quantity, ReqLine.Quantity);
                            PurchaseLine.Validate("Unit of Measure Code", ReqLine."Unit of Measure Code");
                            PurchaseLine.Validate("Direct Unit Cost", ReqLine."Direct Unit Cost");
                            PurchaseLine.Modify(true);
                        until ReqLine.Next() = 0;

                    Message(PurchaseQuoteCounterMsg, Counter);
                end;
            }
        }
    }
    //Win593

    var
        PurchaseQuoteCounterMsg: Label '%1 Purchase Quote(s) are created';
}