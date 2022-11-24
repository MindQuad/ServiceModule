PageExtension 50279 pageextension50279 extends "Service Item Worksheet"
{
    actions
    {

        addafter("&Print")
        {
            action("Proposal Internal")
            {
                ApplicationArea = Basic;
                Caption = 'Proposal Internal';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*SerHdr.RESET;
                    SerHdr.SETRANGE(SerHdr."Document No.",Rec."Document No.");
                    IF SerHdr.FINDFIRST THEN
                      REPORT.RUN(50095,TRUE,FALSE,SerHdr);*/

                    SerHdr.Reset;
                    SerHdr.SetRange(SerHdr."No.", Rec."Document No.");
                    if SerHdr.FindFirst then
                        Report.Run(50095, true, false, SerHdr);

                end;
            }
            action("Proposal External")
            {
                ApplicationArea = Basic;
                Caption = 'Proposal External';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SerHdr.Reset;
                    SerHdr.SetRange(SerHdr."No.", Rec."Document No.");
                    if SerHdr.FindFirst then
                        Report.Run(50096, true, false, SerHdr);
                end;
            }

        }
        //Win593
        addafter("&Worksheet")
        {
            action("Create Service Quote")
            {
                ApplicationArea = All;
                Caption = 'Create Service Quote';
                Image = Quote;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ServiceHeader: Record "Service Header";
                    ServHdr: Record "Service Header";
                    ServiceLineSrc: Record "Service Line";
                    ServiceLineDst: Record "Service Line";
                    ServiceItemLineSrc: Record "Service Item Line";
                    ServiceItemLineDst: Record "Service Item Line";
                    TotalCount: Integer;
                    UnitPriceNullTotalCount: Integer;
                begin
                    ServiceLineSrc.SetRange("Document Type", Rec."Document Type");
                    ServiceLineSrc.SetRange("Document No.", Rec."Document No.");
                    TotalCount := ServiceLineSrc.Count;

                    ServiceLineSrc.SetRange("FMS Approved", false);
                    if not ServiceLineSrc.IsEmpty then
                        Error(FMSApprovedErr);

                    ServiceLineSrc.SetRange("FMS Approved");
                    ServiceLineSrc.SetRange("Unit Price", 0);
                    UnitPriceNullTotalCount := ServiceLineSrc.Count;

                    if UnitPriceNullTotalCount = TotalCount then
                        Error('All the lines are having Unit Price blank');

                    ServHdr.Get(Rec."Document Type", Rec."Document No.");

                    ServiceHeader.Init();
                    ServiceHeader.TransferFields(ServHdr, true);
                    ServiceHeader.Validate("Document Type", ServiceHeader."Document Type"::Quote);
                    ServiceHeader."No." := '';
                    ServiceHeader."Contract No." := '';
                    ServiceHeader."FMS SO" := true;
                    ServiceHeader.Insert(true);

                    ServiceItemLineSrc.SetRange("Document Type", ServHdr."Document Type");
                    ServiceItemLineSrc.SetRange("Document No.", ServHdr."No.");
                    If ServiceItemLineSrc.FindSet() then
                        repeat
                            ServiceItemLineDst.TransferFields(ServiceItemLineSrc, true);
                            ServiceItemLineDst.Validate("Document Type", ServiceHeader."Document Type");
                            ServiceItemLineDst.Validate("Document No.", ServiceHeader."No.");
                            ServiceItemLineDst.Insert(true);
                        until ServiceItemLineSrc.Next() = 0;

                    ServiceLineSrc.Reset();
                    ServiceLineSrc.SetRange("Document Type", Rec."Document Type");
                    ServiceLineSrc.SetRange("Document No.", Rec."Document No.");
                    ServiceLineSrc.SetFilter("Unit Price", '<>%1', 0);
                    if ServiceLineSrc.FindSet() then
                        repeat
                            ServiceLineDst.Init();
                            ServiceLineDst.TransferFields(ServiceLineSrc, true);
                            ServiceLineDst.Validate("Document Type", ServiceHeader."Document Type");
                            ServiceLineDst.Validate("Document No.", ServiceHeader."No.");
                            ServiceLineDst.Insert(true);
                        until ServiceLineSrc.Next() = 0;

                    Message('Service Quote Created %1', ServiceHeader."No.");
                end;
            }
        }
        //Win593
    }

    var
        FMSApprovedErr: Label 'There are some lines which are not approved';
        SerHdr: Record "Service Header";
}

