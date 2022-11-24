Codeunit 50002 "Preventive Maint. Notification"
{

    trigger OnRun()
    var
        startdate: Date;
        enddate: Date;
        ServiceMgtSetup: Record "Service Mgt. Setup";
        FileManagement: Codeunit "File Management";
        Filepath: Text;
        Filename: Text;
    begin
        ServiceMgtSetup.Get;
        //ServiceMgtSetup.TESTFIELD("Notify Preventive Maint before");
        //ServiceMgtSetup.TESTFIELD("Preventive Maint FilePath");
        //ServiceMgtSetup.TESTFIELD("Prev. Maint Contract Groups");
        startdate := Today;
        //enddate:=CALCDATE(ServiceMgtSetup."Notify Preventive Maint before",startdate);
        //Filepath:= ServiceMgtSetup."Preventive Maint FilePath";
        Filename := Filepath + 'MaintenancePlan-' + Format(enddate) + '.pdf';

        //PreventiveMaintenanceAlert.InitVariables(startdate,enddate,ServiceMgtSetup."Prev. Maint Contract Groups");
        //PreventiveMaintenanceAlert.SAVEASPDF(Filename);

        //IF FileManagement.ClientFileExists(Filename) AND (ServiceMgtSetup."Preventive Maint Not. Email ID"<>'')THEN
        //SendMailtointernal(Filename,ServiceMgtSetup."Preventive Maint Not. Email ID",enddate);
    end;


    procedure SendMailtointernal(Filename: Text; Receivermail: Text; enddate: Date)
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
        // SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", Email, 'Preventive Maintenance Plan till ' + Format(enddate), '', true);
        // //SMTPMail.AddAttachment(Filename, Filename); //WIN292
        // SMTPMail.AppendBody('Hi Team');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Please check atatched file of Preventive Maintenance Plan till ' + Format(enddate));
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('System Administartor');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;
        Recipients.Add(Receivermail);
        Subject := 'Preventive Maintenance Plan till ' + Format(enddate);
        Body := 'Hi Team <br><br> Good day! <br><Br>';
        Body += 'Please check atatched file of Preventive Maintenance Plan till ' + Format(enddate);
        Body += '<br><Br> Thanks & Regards, <br> System Administartor <br><br>';
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}

