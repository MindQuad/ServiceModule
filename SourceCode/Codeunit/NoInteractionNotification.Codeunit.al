Codeunit 50004 "No Interaction Notification"
{

    trigger OnRun()
    var
        startdatetime: DateTime;
        enddatetime: DateTime;
        ServiceMgtSetup: Record "Sales & Receivables Setup";
        FileManagement: Codeunit "File Management";
        Filepath: Text;
        Filename: Text;
    begin
        ServiceMgtSetup.Get;
        //ServiceMgtSetup.TESTFIELD("Marketing team Mail ID");
        //ServiceMgtSetup.TESTFIELD("Interaction Mail attach. path");

        //Filepath:= ServiceMgtSetup."Interaction Mail attach. path";
        Filename := Filepath + 'Interaction Pending' + '.pdf';


        //ContactWebNointeraction.SAVEASPDF(Filename);
        /*
        IF FileManagement.ClientFileExists(Filename) THEN
          SendMailtointernal(Filename,ServiceMgtSetup."Marketing team Mail ID",today);*/

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
        // SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", Email, 'Interaction Pending till ' + Format(enddate), '', true);
        // //SMTPMail.AddAttachment(Filename, Filename);//WIN292
        // SMTPMail.AppendBody('Hi Team');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Please check atatched file of Web contacts/leads whose interactions is pending till ' + Format(enddate));
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('System Administartor');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;
        Recipients.Add(Receivermail);
        Subject := 'Interaction Pending till ' + Format(enddate);
        Body := 'Hi Team <br><br>  Good day! <br><Br>';
        Body += 'Please check atatched file of Web contacts/leads whose interactions is pending till ' + Format(enddate);
        Body += '<br><Br> Thanks & Regards, <br>  System Administartor <br><br>';
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}

