PageExtension 50275 pageextension50275 extends "Service Order"
{
    layout
    {
        addlast(General)
        {

            field("Scheduled Date"; Rec."Scheduled Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scheduled Date field.';
            }
            field("Scheduled From Time"; Rec."Scheduled From Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scheduled From Time field.';
            }
            field("Scheduled To Time"; Rec."Scheduled To Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scheduled To Time field.';
            }
        }

        modify(Address)
        {
            Visible = false;
        }
        modify("Address 2")
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
        modify(County)
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        // moveafter(Description; "Reference No.")

        addafter(Description)
        {

            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
            }
            field("Service Item No."; Rec."Service Item No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }

        addafter("Service Order Type")
        {

            field("Service Report No."; Rec."Service Report No.")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Order Time"; "Service Order Type")

        addafter(Status)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Name)
        {
            field("Completion Date"; Rec."Completion Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Release Status")
        {
            field("Type of Ticket"; Rec."Type of Ticket")
            {
                ApplicationArea = Basic;
            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = Basic;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
            field("Reference No."; Rec."Reference No.")
            {
                ApplicationArea = Basic;
            }
            field(Category; Rec.Category)
            {
                ApplicationArea = All;
            }
            field("Sub-Category"; Rec."Sub-Category")
            {
                ApplicationArea = all;
            }
            field("Additional Work Description"; Rec."Additional Work Description")
            {
                ApplicationArea = Basic;
                MultiLine = true;
                Visible = false;
            }
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = Basic;
                MultiLine = true;
            }
            group("Work Description1")
            {
                Caption = '<Work Description1>';
                Visible = false;
                field("<WorkDescription>"; WorkDescription)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '<<WorkDescription>>';
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered';

                    trigger OnValidate()
                    begin
                        Rec.SetWorkDescription(WorkDescription);
                    end;
                }
            }
        }
        moveafter("Service Time (Hours)"; "Response Date")
        moveafter("Response Date"; "Response Time")
        //Win593
        addafter("Work Description")
        {
            field("Supervisor Remark"; Rec."Supervisor Remark")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Supervisor Remark field.';
                MultiLine = true;
            }
        }
        //Win593

        addafter("Shipping Time")
        {
            field("Shipping No. Series"; Rec."Shipping No. Series")
            {
                ApplicationArea = Basic;
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(" Foreign Trade")
        {
            group(Administration)
            {
                Caption = 'Administration';

            }
        }
        moveafter(Administration; "Responsibility Center")
        moveafter("Responsibility Center"; "Assigned User ID")
        moveafter(Description; "Order Date")
        moveafter("Order Time"; "Phone No.")
        moveafter("Phone No."; "Phone No. 2")
        moveafter("Phone No. 2"; "E-Mail")
        moveafter("E-Mail"; Priority)
        moveafter(ServItemLines; Details)
        moveafter("Service Zone Code"; "Expected Finishing Date")

        //Win513++
        addafter("No.")
        {
            field("From Portal"; Rec."From Portal")
            {
                ApplicationArea = All;
            }
        }
        addafter("From Portal")
        {

            field("FMS SO"; Rec."FMS SO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FMS SO field.';
            }
        }
        //Win513--
    }
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
                    SerHdr.Reset;
                    SerHdr.SetRange(SerHdr."No.", Rec."No.");
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
                    SerHdr.SetRange(SerHdr."No.", Rec."No.");
                    if SerHdr.FindFirst then
                        Report.Run(50096, true, false, SerHdr);
                end;
            }
        }
    }

    var
        WorkDescription: Text;
        SerHdr: Record "Service Header";


    //Unsupported feature: Code Insertion on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //begin
    /*
    //Work Description
    CLEAR(WorkDescription);
    WorkDescription := GetWorkDescription;
    */
    //end;

    trigger OnOpenPage()
    begin
        if not Rec."FMS SO" then
            CurrPage.Caption := 'Service Ticket';
    end;
}

