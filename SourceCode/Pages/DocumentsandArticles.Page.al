page 50063 "Documents and Articles"
{
    AutoSplitKey = true;
    Caption = 'Documents and Articles';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = 50009;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Code"; Rec."Confidential Code")
                {
                    ApplicationArea = All;
                    Caption = 'Document Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies a description of the confidential information.';
                }
                field("ID No."; Rec."Document No")
                {
                    ApplicationArea = All;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field(Link; Rec.Link)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AttachFile)
            {
                ApplicationArea = All;
                Caption = 'Attach File';

                trigger OnAction()
                begin
                    IncomingDocumentAttachment.NewAttachment1(Rec."Issued To", Rec."Line No.");
                end;
            }
            action("View File")
            {
                ApplicationArea = All;
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    NameDrillDown;
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Delete File';
                Visible = false;

                trigger OnAction()
                begin

                    IncomingDocumentAttachment.RESET;
                    IncomingDocumentAttachment.SETFILTER("Line No.", '%1', Rec."Line No.");
                    IncomingDocumentAttachment.SETRANGE("Document No.", Rec."Issued To");
                    IF NOT IncomingDocumentAttachment.FINDFIRST THEN
                        MESSAGE('No attachment')
                    ELSE
                        IF CONFIRM('Do you want to delete the attachment', TRUE) THEN
                            IncomingDocumentAttachment.DELETE
                        ELSE
                            EXIT;
                end;
            }
        }
    }

    var
        IncomingDocumentAttachment: Record 133;


    procedure NameDrillDown()
    var
        IncomingDocument: Record 130;
        IncomingDocumentAttachment: Record 133;
    begin

        IncomingDocumentAttachment.RESET;
        IncomingDocumentAttachment.SETFILTER("Line No.", '%1', Rec."Line No.");
        IncomingDocumentAttachment.SETRANGE("Document No.", Rec."Issued To");
        IF NOT IncomingDocumentAttachment.FINDFIRST THEN
            MESSAGE('No attachment');
        //ELSE
        //IncomingDocumentAttachment.Export('', TRUE);//WIN292


    end;
}

