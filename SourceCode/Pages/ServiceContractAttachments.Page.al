page 50048 "Service Contract Attachments"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = 133;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Created By User Name"; Rec."Created By User Name")
                {
                    ApplicationArea = All;
                }
                field("Created Date-Time"; Rec."Created Date-Time")
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
            action("View File")
            {
                ApplicationArea = All;
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //NameDrillDown;


                    //Rec.Export('', TRUE);//WIN292
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Delete File';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*
                     IncomingDocumentAttachment.RESET;
                     IncomingDocumentAttachment.SETRANGE(IncomingDocumentAttachment."Document No.",Rec."Contract No.");
                     IF NOT IncomingDocumentAttachment.FINDFIRST THEN
                          MESSAGE('No attachment')
                      ELSE
                    
                          IncomingDocumentAttachment.DELETEALL
                        ELSE
                           EXIT;
                           */
                    IF CONFIRM('Do you want to delete the attachment', TRUE) THEN
                        Rec.DELETE
                    ELSE
                        EXIT;

                end;
            }
        }
    }
}

