Codeunit 50005 "No Interaction Notification-SP"
{

    trigger OnRun()
    var
        startdatetime: DateTime;
        enddatetime: DateTime;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        FileManagement: Codeunit "File Management";
        Filepath: Text;
        Filename: Text;
        Contactrec: Record Contact;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        //96 Hours Reminder to Group Manager
        Contactrec.Reset;
        Contactrec.SetRange(Contactrec.Type, Contactrec.Type::Company);
        Contactrec.CalcFields("No. of Interactions");
        Contactrec.SetRange("No. of Interactions", 0);
        Contactrec.SetRange(Status, Contactrec.Status::"Request to Create Customer");
        Contactrec.SetFilter(Contactrec."Salesperson Code", '<>%1', '');
        Contactrec.SetFilter(Contactrec."SP interaction reminder sent", '%1', true);
        Contactrec.SetFilter(Contactrec."Mgr. interaction reminder sent", '%1', false);
        if Contactrec.FindFirst then begin
            repeat

                SalesReceivablesSetup.Get;
                //SalesReceivablesSetup.TESTFIELD("Group Manager Mail ID");
                SalespersonPurchaser.Get(Contactrec."Salesperson Code");

                if ((CurrentDatetime - Contactrec."SP assigned Datetime") / 3600000) > 96 then
                    //SendMailtomanager(SalespersonPurchaser.Name,Contactrec.Name,SalesReceivablesSetup."Group Manager Mail ID");

                    Contactrec."Mgr. interaction reminder sent" := true;
                Contactrec.Modify;
            until Contactrec.Next = 0;
        end;






        //48 Hours Reminder to Salesperson
        Contactrec.Reset;
        Contactrec.SetRange(Contactrec.Type, Contactrec.Type::Company);
        Contactrec.CalcFields("No. of Interactions");
        Contactrec.SetRange("No. of Interactions", 0);
        Contactrec.SetRange(Status, Contactrec.Status::"Request to Create Customer");
        Contactrec.SetFilter(Contactrec."Salesperson Code", '<>%1', '');
        Contactrec.SetFilter(Contactrec."SP interaction reminder sent", '%1', false);
        if Contactrec.FindFirst then begin
            repeat
                SalespersonPurchaser.Get(Contactrec."Salesperson Code");
                if ((CurrentDatetime - Contactrec."SP assigned Datetime") / 3600000) > 48 then
                    SendMailtosp(Contactrec.Name, SalespersonPurchaser."E-Mail");
                Contactrec."SP interaction reminder sent" := true;
                Contactrec.Modify;
            until Contactrec.Next = 0;
        end;
    end;


    procedure SendMailtosp(contactname: Text; Receivermail: Text)
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

        lText002: label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record "Reason Code";
        lUserSetup: Record "User Setup";
        lUser: Record User;
        GeneralLedgerSetup: Record "General Ledger Setup";
        //Email: List of [Text];
        Recipients: List of [Text];
    begin
        // SMTPSetup.Get;
        // Email.Add(Receivermail);
        // SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", Email, 'Interaction log Reminder - ' + Format(contactname), '', true);
        // SMTPMail.AppendBody('Hi Team');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Just a gentle reminder that no Interaction has been logged with Lead/Contact Name ' + Format(contactname));
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('System Administartor');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;

        Recipients.Add(Receivermail);
        Subject := 'Interaction log Reminder - ' + Format(contactname);
        Body := 'Hi Team <br><br> Good day! <br><Br>';
        Body += 'Just a gentle reminder that no Interaction has been logged with Lead/Contact Name ' + Format(contactname);
        Body += '<br><Br> Thanks & Regards, <br> System Administartor <br><br>';

        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;


    procedure SendMailtomanager(spname: Text; contactname: Text; Receivermail: Text)
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
        lText002: label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record "Reason Code";
        lUserSetup: Record "User Setup";
        lUser: Record User;
        GeneralLedgerSetup: Record "General Ledger Setup";
        // Email: List of [Text];
        Recipients: List of [Text];
    begin
        // SMTPSetup.Get;
        // Email.Add(Receivermail);
        // SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", Email, 'Interaction log Reminder - ' + Format(contactname), '', true);
        // SMTPMail.AppendBody('Hi Team');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Just a gentle reminder that no Interaction has been logged with Lead/Contact Name ' + Format(contactname) + ' by Salesperson ' + spname);
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('System Administartor');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;

        Recipients.Add(Receivermail);
        Subject := 'Interaction log Reminder - ' + Format(contactname);
        Body := 'Hi Team <br><br> Good day! <br><Br> ';
        Body += 'Just a gentle reminder that no Interaction has been logged with Lead/Contact Name ' + Format(contactname) + ' by Salesperson ' + spname;
        Body += '<br><Br> Thanks & Regards, <br> System Administartor <br><br>';

        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}

