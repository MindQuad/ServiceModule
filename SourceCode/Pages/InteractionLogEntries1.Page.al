page 50062 "Interaction Log Entries1"
{
    Caption = 'Interaction Log Entries';
    Editable = false;
    InsertAllowed = true;
    PageType = List;
    SourceTable = 5065;
    SourceTableView = WHERE(Postponed = CONST(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number identifying the interaction log entry. The field is not editable.';
                }
                field("Service Order Type"; Rec."Service Order Type")
                {
                    ApplicationArea = All;
                }
                field("Building Code"; Rec."Building Code")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field("Unit Description"; Rec."Unit Description")
                {
                    ApplicationArea = All;
                }
                field("<Rent Amount1>"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Rent Amount"; Rec."Rent Amt")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Amount';
                }
                field(Canceled; Rec.Canceled)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies whether the interaction has been canceled. The field is not editable.';
                }
                field("Attempt Failed"; Rec."Attempt Failed")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies whether the interaction records an failed attempt to reach the contact. This field is not editable.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of document if there is one that the interaction log entry records. You cannot change the contents of this field.';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the document (if any) that the interaction log entry records.';
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the delivery of the attachment. There are three options:';
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that you have entered in the Date field in the Create Interaction wizard or the Segment window when you created the interaction. The field is not editable.';
                }
                field("Time of Interaction"; Rec."Time of Interaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time when the interaction was created. This field is not editable.';
                    Visible = false;
                }
                field("Correspondence Type"; Rec."Correspondence Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of correspondence of the attachment in the interaction template. This field is not editable.';
                    Visible = false;
                }
                field("Interaction Group Code"; Rec."Interaction Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the interaction group used to create this interaction. This field is not editable.';
                    Visible = false;
                }
                field("Interaction Template Code"; Rec."Interaction Template Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code for the interaction template used to create the interaction. This field is not editable.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the interaction.';
                }
                field(Attachment; Rec."Attachment No." <> 0)
                {
                    ApplicationArea = RelationshipMgmt;
                    BlankZero = true;
                    Caption = 'Attachment';
                    ToolTip = 'Specifies if the attachment that is linked to the segment line is inherited or unique.';

                    trigger OnAssistEdit()
                    begin
                        IF Rec."Attachment No." <> 0 THEN;
                        //  OpenAttachment;
                    end;
                }
                field("Information Flow"; Rec."Information Flow")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the direction of information flow recorded by the interaction. There are two options: Outbound (the information was received by your contact) and Inbound (the information was received by your company).';
                    Visible = false;
                }
                field("Initiated By"; Rec."Initiated By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who initiated the interaction. There are two options: Us (the interaction was initiated by your company) and Them (the interaction was initiated by your contact).';
                    Visible = false;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the contact involved in this interaction. This field is not editable.';
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the name of the contact for which an interaction has been logged.';
                }
                field("Contact Company No."; Rec."Contact Company No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact company.';
                    Visible = false;
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the name of the contact company for which an interaction has been logged.';
                }
                field(Evaluation; Rec.Evaluation)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the evaluation of the interaction. There are five options: Very Positive, Positive, Neutral, Negative, and Very Negative.';
                }
                field("Cost (LCY)"; Rec."Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the cost of the interaction.';
                }
                field("Duration (Min.)"; Rec."Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the duration of the interaction.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the salesperson who carried out the interaction. This field is not editable.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who logged this entry. This field is not editable.';
                    Visible = false;
                }
                field("Segment No."; Rec."Segment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the segment. This field is valid only for interactions created for segments, and is not editable.';
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the campaign (if any) to which the interaction is linked. This field is not editable.';
                }
                field("Campaign Entry No."; Rec."Campaign Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the campaign entry to which the interaction log entry is linked.';
                    Visible = false;
                }
                field("Campaign Response"; Rec."Campaign Response")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the interaction records a response to a campaign.';
                    Visible = false;
                }
                field("Campaign Target"; Rec."Campaign Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the interaction is applied to contacts that are part of the campaign target. This field is not editable.';
                    Visible = false;
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the opportunity to which the interaction is linked.';
                }
                field("To-do No."; Rec."To-do No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the to-do if the interaction has been created to complete a to-do. This field is not editable.';
                    Visible = false;
                }
                field("Interaction Language Code"; Rec."Interaction Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the language code for the interaction for the interaction log. The code is copied from the language code of the interaction template, if one is specified.';
                    Visible = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subject text that will be used for this interaction.';
                    Visible = false;
                }
                field("Contact Via"; Rec."Contact Via")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the telephone number that you used when calling the contact.';
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that a comment exists for this interaction log entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Ent&ry';
                Image = Entry;
                Visible = false;
                action("Filter")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Filter';
                    Image = "Filter";
                    Promoted = true;
                    ToolTip = 'Apply a filter to view specific interaction log entries.';

                    trigger OnAction()
                    var
                        FilterPageBuilder: FilterPageBuilder;
                    begin
                        FilterPageBuilder.ADDTABLE(Rec.TABLENAME, DATABASE::"Interaction Log Entry");
                        FilterPageBuilder.SETVIEW(Rec.TABLENAME, Rec.GETVIEW);

                        IF Rec.GETFILTER("Campaign No.") = '' THEN
                            FilterPageBuilder.ADDFIELDNO(Rec.TABLENAME, Rec.FIELDNO("Campaign No."));
                        IF Rec.GETFILTER("Segment No.") = '' THEN
                            FilterPageBuilder.ADDFIELDNO(Rec.TABLENAME, Rec.FIELDNO("Segment No."));
                        IF Rec.GETFILTER("Salesperson Code") = '' THEN
                            FilterPageBuilder.ADDFIELDNO(Rec.TABLENAME, Rec.FIELDNO("Salesperson Code"));
                        IF Rec.GETFILTER("Contact No.") = '' THEN
                            FilterPageBuilder.ADDFIELDNO(Rec.TABLENAME, Rec.FIELDNO("Contact No."));
                        IF Rec.GETFILTER("Contact Company No.") = '' THEN
                            FilterPageBuilder.ADDFIELDNO(Rec.TABLENAME, Rec.FIELDNO("Contact Company No."));

                        IF FilterPageBuilder.RUNMODAL THEN
                            Rec.SETVIEW(FilterPageBuilder.GETVIEW(Rec.TABLENAME));
                    end;
                }
                action(ClearFilter)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Clear Filter';
                    Image = ClearFilter;
                    Promoted = true;
                    ToolTip = 'Clear the applied filter on specific interaction log entries.';

                    trigger OnAction()
                    begin
                        Rec.RESET;
                        Rec.FILTERGROUP(2);
                        Rec.SETRANGE(Postponed, FALSE);
                        Rec.FILTERGROUP(0);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inter. Log Entry Comment Sheet";
                    RunPageLink = "Entry No." = FIELD("Entry No.");
                    ToolTip = 'View or add comments.';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                Visible = false;
                action("Switch Check&mark in Canceled")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Switch Check&mark in Canceled';
                    Image = ReopenCancelled;
                    ToolTip = 'Change records that have a checkmark in Canceled.';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(InteractionLogEntry);
                        //InteractionLogEntry.ToggleCanceledCheckmark;
                    end;
                }
                action(Resend)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Resend';
                    Image = Reuse;
                    ToolTip = 'Resend the attachments.';

                    trigger OnAction()
                    var
                        InteractLogEntry: Record 5065;
                    begin
                        InteractLogEntry.SETRANGE("Logged Segment Entry No.", Rec."Logged Segment Entry No.");
                        InteractLogEntry.SETRANGE("Entry No.", Rec."Entry No.");
                        REPORT.RUNMODAL(REPORT::"Resend Attachments", TRUE, FALSE, InteractLogEntry);
                    end;
                }
                action("Evaluate Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Evaluate Interaction';
                    Image = Evaluate;
                    ToolTip = 'Make an evaluation of the interaction.';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(InteractionLogEntry);
                        InteractionLogEntry.EvaluateInteraction;
                    end;
                }
                separator("--")
                {
                }
                action("Create To-do")
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData 5080 = R;
                    Caption = 'Create To-do';
                    Image = NewToDo;

                    trigger OnAction()
                    begin
                        Rec.CreateTask();
                    end;
                }
            }
            action("Show Attachments")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Show Attachments';
                Enabled = ShowEnable;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show attachments or related documents.';

                trigger OnAction()
                begin
                    IF Rec."Attachment No." <> 0 THEN
                        //OpenAttachment()

                        //ELSE
                        Rec.ShowDocument;
                end;
            }
            action("Create &Interact")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create an interaction with a specified contact.';

                trigger OnAction()
                begin
                    Rec.CreateInteraction;
                end;
            }
            action(CreateOpportunity)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create Opportunity';
                Enabled = ShowCreateOpportunity;
                Gesture = None;
                Image = NewOpportunity;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create an opportunity with a specified contact.';

                trigger OnAction()
                begin
                    Rec.AssignNewOpportunity;
                    CurrPage.UPDATE(FALSE);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CALCFIELDS("Contact Name", "Contact Company Name");
    end;

    trigger OnAfterGetRecord()
    begin
        ShowCreateOpportunity := Rec.CanCreateOpportunity;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordsFound: Boolean;
    begin
        RecordsFound := Rec.FIND(Which);
        ShowEnable := RecordsFound;
        EXIT(RecordsFound);
    end;

    trigger OnInit()
    begin
        ShowEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        SetCaption;
    end;

    var
        InteractionLogEntry: Record 5065;
        [InDataSet]
        ShowEnable: Boolean;
        ShowCreateOpportunity: Boolean;

    local procedure SetCaption()
    var
        Contact: Record 5050;
        SalespersonPurchaser: Record 13;
        ToDo: Record 5080;
        Opportunity: Record 5092;
    begin
        IF Contact.GET(Rec."Contact Company No.") THEN
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Contact."Company No." + ' . ' + Contact."Company Name");
        IF Contact.GET(Rec."Contact No.") THEN BEGIN
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Contact."No." + ' . ' + Contact.Name);
            EXIT;
        END;
        IF Rec."Contact Company No." <> '' THEN
            EXIT;
        IF SalespersonPurchaser.GET(Rec."Salesperson Code") THEN BEGIN
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Rec."Salesperson Code" + ' . ' + SalespersonPurchaser.Name);
            EXIT;
        END;
        IF Rec."Interaction Template Code" <> '' THEN BEGIN
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Rec."Interaction Template Code");
            EXIT;
        END;
        IF ToDo.GET(Rec."To-do No.") THEN BEGIN
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + ToDo."No." + ' . ' + ToDo.Description);
            EXIT;
        END;
        IF Opportunity.GET(Rec."Opportunity No.") THEN
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Opportunity."No." + ' . ' + Opportunity.Description);
    end;
}

