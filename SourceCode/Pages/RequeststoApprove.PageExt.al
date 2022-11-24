PageExtension 50274 pageextension50274 extends "Requests to Approve"
{
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "CommentsFactBox(Control 3)".


        //Unsupported feature: Property Insertion (Visible) on "CommentsFactBox(Control 3)".

    }
    actions
    {

        //Unsupported feature: Code Modification on "Comments(Action 42).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        RecRef.GET("Record ID to Approve");
        ApprovalsMgmt.GetApprovalComment(RecRef);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        RecRef.GET("Record ID to Approve");
        ApprovalsMgmt.GetApprovalComment(RecRef);
        */
        //end;


        //Unsupported feature: Code Modification on "Approve(Action 19).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        ServContrNo:='';
        ServContrNo := Rec."Document No.";
        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
        //InsertNotification1;     //win315
        SendMailtoSender;
        */
        //end;


        //Unsupported feature: Code Modification on "Reject(Action 2).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
        //InsertNotification;     //win315
        */
        //end;
        addafter(Comments)
        {
            action("Approval Comments")
            {
                ApplicationArea = Basic;
                Image = ViewComments;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Service Comment Sheet";
                RunPageLink = "No." = field("Document No.");
            }
        }
    }

    var
        RecordLink: Record "Record Link";
        UserSetup: Record "User Setup";
        ServContrNo: Code[20];

    local procedure InsertNotification()
    var
        NotificationEntry: Record "Notification Entry";
    begin

        if NotificationEntry.FindLast then begin
            NotificationEntry.Init;
            NotificationEntry.ID := NotificationEntry.ID + 1;
            NotificationEntry.Type := NotificationEntry.Type::Approval;
            NotificationEntry."Recipient User ID" := Rec."Sender ID";
            NotificationEntry."Error Message" := 'Rejected';
            NotificationEntry."Document No." := Rec."Document No.";
            NotificationEntry.Status := Rec.Status::Rejected;
            NotificationEntry.Insert(true);
        end;
    end;

    local procedure InsertNotification1()
    var
        NotificationEntry1: Record "Notification Entry";
    begin

        if NotificationEntry1.FindLast then begin
            NotificationEntry1.Init;
            NotificationEntry1.ID := NotificationEntry1.ID + 1;
            NotificationEntry1.Type := NotificationEntry1.Type::Approval;
            NotificationEntry1."Recipient User ID" := Rec."Sender ID";
            NotificationEntry1."Error Message" := 'Approved';
            NotificationEntry1."Document No." := Rec."Document No.";
            NotificationEntry1.Status := Rec.Status::Approved;
            NotificationEntry1.Insert(true);
        end;




    end;

    procedure SendMailtoSender()
    var
        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        lText001: label 'Email Id is blank for the Customer %1';
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];
        lText002: label 'Mail sent Successfully';
        lReasonCode: Record "Reason Code";
        lUserSetup: Record "User Setup";
        lUser: Record User;
        ApprovalEntry5: Record "Approval Entry";
        ServCntr: Record "Service Contract Header";
    begin

        //SMTPSetup.Get;
        //TESTFIELD("E-Mail");
        //SMTPSetup.TestField("User ID");

        lUserSetup.Get(Rec."Sender ID");
        lUserSetup.TestField("E-Mail");
        Recipients.Add(lUserSetup."E-Mail");

        lUser.Reset;
        lUser.SetRange("User Name", UserId);
        if lUser.FindSet then;

        /*lCLE.RESET;
        lCLE.SETRANGE("Document No.",DocNo);
        IF NOT lCLE.FINDSET THEN
          EXIT;*/

        ServCntr.Reset;
        ServCntr.SetRange(ServCntr."Contract No.", ServContrNo);
        ServCntr.SetRange(ServCntr."Approval Status", ServCntr."approval status"::Released);
        if ServCntr.FindFirst then begin

            ApprovalEntry5.Reset;
            ApprovalEntry5.SetRange(ApprovalEntry5."Document No.", ServCntr."Contract No.");
            if ApprovalEntry5.FindFirst then
                if lUserSetup.Get(ApprovalEntry5."Sender ID") then;


            //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",lUserSetup."E-Mail",'Request Approved','',true);
            //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",MarketingSetup."Email Sender To",'Customer Creation Request','',TRUE);
            // if lUserSetup.Get(ApprovalEntry5."Approver ID") then
            //     SMTPMail.AddCC(lUserSetup."E-Mail");

            Subject := 'Customer Creation Request';
            Body := 'Hello Sir/Madam, <br><br> Good day! <br><Br>';
            //SMTPMail.AppendBody(ReversalComments);
            Body += 'Service contract' + ' ' + Format(ServContrNo) + ' ' + 'has been approved.';
            Body += '<br><Br> Thanks & Regards, <br> System Administartor <br><br>';
            //SMTPMail.Send;
            EmailMessage.Create(Recipients, Subject, Body, true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

            Message(lText002, lCust."No.");
            //END;
        end;

    end;
}

