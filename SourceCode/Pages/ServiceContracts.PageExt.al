PageExtension 50309 pageextension50309 extends "Service Contracts"
{
    Caption = 'Service Contracts';
    layout
    {
        modify("Ship-to Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Ship-to Name")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Currency Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter("Contract No.")
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            field("Contract Current Status"; Rec."Contract Current Status")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Status';
            }
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
            }
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Customer No.")
        {
            field("Tenant Name"; Rec."Tenant Name")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Expiration Date")
        {
            field("Annual Amount"; Rec."Annual Amount")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("First Service Date")
        {
            field("Renewal Contract No."; Rec."Renewal Contract No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Last Price Update Date")
        {
            field("Status Description"; Rec."Status Description")
            {
                ApplicationArea = Basic;
            }
            field("Special Condition"; Rec."Special Condition")
            {
                ApplicationArea = Basic;
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = Basic;
            }
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
            }
            field(Active; Rec.Active)
            {
                ApplicationArea = Basic;
            }
            field("Assigned User ID"; Rec."Assigned User ID")
            {
                ApplicationArea = Basic;
            }
            field("Serv. Contract Acc. Gr. Code"; Rec."Serv. Contract Acc. Gr. Code")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Account Group';
            }
        }
    }
    actions
    {
        addfirst("F&unctions")
        {
            action("Create &Interact")
            {
                AccessByPermission = TableData Attachment = R;
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create an interaction with a specified contact.';

                trigger OnAction()
                begin
                    //CreateInteraction;
                end;
            }
            action("Renewal Letter")
            {
                ApplicationArea = Basic;
                Caption = 'Renewal Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SerConHdr.Reset;
                    SerConHdr.SetRange(SerConHdr."Contract Type", Rec."Contract Type");
                    SerConHdr.SetRange(SerConHdr."Contract No.", Rec."Contract No.");
                    if SerConHdr.FindFirst then
                        Report.RunModal(50002, true, false, SerConHdr);
                end;
            }
            action("Send Email Renewal Letter")
            {
                ApplicationArea = Basic;
                Caption = 'Send Email Renewal Letter';
                Image = Email;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Do you want to send an email?', true) then begin
                        ServiceContractList.SetRecord(Rec);
                        ServiceContractList.SendMailtoSP
                    end else
                        exit;
                end;
            }
        }
    }
    var
        SerConHdr: Record "Service Contract Header";
        ServiceContractList: page "Service Contract List";
}

