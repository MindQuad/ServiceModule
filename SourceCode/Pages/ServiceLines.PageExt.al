PageExtension 50278 pageextension50278 extends "Service Lines"
{
    layout
    {
        modify("Unit Cost (LCY)")
        {
            ApplicationArea = All;
            Editable = false;
        }

        //Unsupported feature: Property Insertion (DecimalPlaces) on ""Unit Price"(Control 34)".

        addafter("Service Item Line No.")
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Control134)
        {
            field("LSM Group"; Rec."LSM Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Unit Cost (LCY)")
        {
            field("Average Unit Cost"; Rec."Average Unit Cost")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Line Amount")
        {
            field("Margin %"; Rec."Margin %")
            {
                ApplicationArea = Basic;
                DecimalPlaces = 2 : 2;
            }
            field("Margin Amount"; Rec."Margin Amount")
            {
                ApplicationArea = Basic;
            }
            field("Cost Amount"; Rec."Cost Amount")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Posting Date")
        {
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("P&osting")
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
    }

    var
        SerHdr: Record "Service Header";
}

