page 50037 "Customer Incident Entries"
{
    Caption = 'Customer Incident Entries';
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = List;
    SourceTable = 50010;
    SourceTableView = SORTING("Primary Key")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
            }
        }
        area(factboxes)
        {
            part("Customer Ledger Entry FactBox"; 9106)
            {
                ApplicationArea = Basic, Suite;
                //SubPageLink = "Entry No." =field("Primary Key");
                Visible = true;
            }
            part(IncomingDocAttachFactBox; 193)
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
            systempart(RecordLinks; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Reminder/Fin. Charge Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Reminder/Fin. Charge Entries';
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    //  RunPageLink = "Customer Entry No." = FIELD("Primary Key");//WIN292
                    RunPageView = SORTING("Customer Entry No.");
                    Scope = Repeater;
                    ToolTip = 'View the reminders and finance charge entries that you have entered for the customer.';
                }
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Customer Entries";
                    RunPageOnRec = true;
                    Scope = Repeater;
                    ToolTip = 'View the ledger entries that have been applied to this record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        //ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    /* RunPageLink = "Cust. Ledger Entry No." = FIELD("Primary Key"),
                                  "Customer No." = FIELD(Contracts); *///WIN292
                    RunPageView = SORTING("Cust. Ledger Entry No.", "Posting Date");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific customer ledger entry.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Apply Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';

                    trigger OnAction()
                    var
                        CustLedgEntry: Record 21;
                        CustEntryApplyPostEntries: Codeunit 226;
                    begin
                        CustLedgEntry.COPY(Rec);
                        CustEntryApplyPostEntries.ApplyCustEntryFormEntry(CustLedgEntry);
                        //Rec := CustLedgEntry;
                        //CurrPage.UPDATE;
                    end;
                }
                separator("--")
                {
                }
                action(UnapplyEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;
                    Scope = Repeater;
                    ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                    trigger OnAction()
                    var
                        CustEntryApplyPostedEntries: Codeunit 226;
                    begin
                        //CustEntryApplyPostedEntries.UnApplyCustLedgEntry("Primary Key");
                    end;
                }
                separator("----")
                {
                }
                action(ReverseTransaction)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;
                    ToolTip = 'Reverse an erroneous customer ledger entry.';

                    trigger OnAction()
                    var
                        ReversalEntry: Record 179;
                    begin
                        CLEAR(ReversalEntry);
                        //IF Reversed THEN
                        //ReversalEntry.AlreadyReversedEntry(TABLECAPTION,"Primary Key");
                        //IF "Journal Batch Name" = '' THEN
                        //ReversalEntry.TestFieldError;
                        //TESTFIELD("Transaction No.");
                        //ReversalEntry.ReverseTransaction("Transaction No.");
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record 130;
                        begin
                            //IncomingDocument.ShowCard("Closed Opportunities",Interactions);
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData 130 = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Select Incoming Document';
                        Enabled = NOT HasIncomingDocument;
                        Image = SelectLineToApply;
                        ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record 130;
                        begin
                            //IncomingDocument.SelectIncomingDocumentForPostedDocument("Closed Opportunities",Interactions,RECORDID);
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = NOT HasIncomingDocument;
                        Image = Attach;
                        ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record 133;
                        begin
                            //IncomingDocumentAttachment.NewAttachmentFromPostedDocument("Closed Opportunities",Interactions);
                        end;
                    }
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    //Navigate.SetDoc(Interactions,"Closed Opportunities");
                    //Navigate.RUN;
                end;
            }
            action("Show Posted Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Posted Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Show details for the posted payment, invoice, or credit memo.';

                trigger OnAction()
                begin
                    //ShowDoc
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record 130;
    begin
        //HasIncomingDocument := IncomingDocument.PostedDocExists("Closed Opportunities",Interactions);
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        //StyleTxt := SetStyle;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", Rec);
        EXIT(FALSE);
    end;

    trigger OnOpenPage()
    begin
        IF Rec.FINDFIRST THEN;
    end;

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
        HasIncomingDocument: Boolean;
}

