PageExtension 50240 pageextension50240 extends "Service Contract List"
{
    Caption = 'Service Contract List';



    layout
    {
        modify("Contract Type")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify(Description)
        {
            ApplicationArea = All;
            Visible = false;
        }

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
        addafter("Expiration Date")
        {
            field("Building No."; Rec."Building No.")
            {
                ApplicationArea = Basic;
                Caption = 'Building No.';
            }
            field("Service Item No."; Rec."Service Item No.")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item No.';
            }
            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = Basic;
                Caption = 'Unit No.';
            }
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Caption = 'Unit Code';
            }
            field("Annual Amount"; Rec."Annual Amount")
            {
                ApplicationArea = Basic;
            }

            field("Tenant Name"; Rec."Tenant Name")
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
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = Basic;
            }
            field("Defferal Code"; Rec."Defferal Code")
            {
                ApplicationArea = Basic;
            }
            field("Contract Group Code"; Rec."Contract Group Code")
            {
                ApplicationArea = Basic;
            }
            field("Serv. Contract Acc. Gr. Code"; Rec."Serv. Contract Acc. Gr. Code")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Account Group';
            }
            field("Contract Document Status"; Rec."Contract Document Status")
            {
                ApplicationArea = Basic;
            }
            field("Contract Status"; Rec."Contract Status")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter(Control1; "Contract No.")
    }
    actions
    {
        addafter(Documents)
        {
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
                    if Confirm('Do you want to send an email?', true) then
                        SendMailtoSP
                    else
                        exit;
                end;
            }
        }
    }

    var
        SerConHdr: Record "Service Contract Header";
        RenewalLetter: Text[250];

    procedure SendMailtoSP()
    var
        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        lText001: label 'Customer Email does not exist';
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lText002: label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record "Reason Code";
        UserSetup: Record "User Setup";
        lUser: Record User;
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        MarketingSetup: Record "Marketing Setup";
        FileName: Text;
        FileManagement: Codeunit "File Management";
        ImportTxt: label 'Insert File';
        FileDialogTxt: label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        DocPrint: Codeunit "Document-Print";
        //TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        IStream: InStream;
        OStream: OutStream;
        RenewalLetter: Report "Renewal Letter";
    begin
        //win315++

        // SMTPSetup.Get;
        // SMTPSetup.TestField("User ID");

        /*MarketingSetup.GET;
        MarketingSetup.TESTFIELD("Email Sender To");*/

        /*lCLE.RESET;
        lCLE.SETRANGE("Document No.",DocNo);
        IF NOT lCLE.FINDSET THEN
          EXIT;*/

        //if lCust.Get(Rec."Customer No.") then begin
        //if lCust."E-Mail" = '' then
        //Error(lText001, lCust."No.");


        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",MarketingSetup."Email Sender To",'Customer Creation Request','',TRUE);
        //SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", lCust."E-Mail", 'Renewal Contract', '', true);//WIn292
        //IF MarketingSetup."Email Sender CC" <> '' THEN
        //SMTPMail.AddCC(MarketingSetup."Email Sender CC");
        //SMTPMail.AppendBody('Hi '+SalespersonPurchaser.Name);
        //SMTPMail.AppendBody('Hi '+ Name);
        // SMTPMail.AppendBody('Dear Sir / Madam ');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Please find attached Renewal Letter for contract no. ' + Format(Rec."Contract No.") + '.');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('NAV Administrator');
        // SMTPMail.AppendBody('<br><br>');

        //Win593
        Rec.TestField("E-Mail");
        Recipients.Add(Rec."E-Mail");
        Subject := 'Renewal Contract';
        Body := 'Dear Sir / Madam, <br><br> Good day! <br><Br>';
        Body += 'Please find attached Renewal Letter for contract no. ' + Format(Rec."Contract No.") + '.';
        Body += '<br><Br> Thanks & Regards, <br> NAV Administrator <br><br>';

        //Win593++
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        RenewalLetter.SetTableView(Rec);
        RenewalLetter.SetServiceContractHdr(Rec);
        RenewalLetter.SaveAs('', ReportFormat::Pdf, OStream);
        //Win593--

        //RenewalLetter := 'D:\Renewal Letter.pdf';
        //Report.SaveAsPdf(50002, RenewalLetter, SerConHdr);
        //SMTPMail.AddAttachment(RenewalLetter, RenewalLetter);//WIN292

        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        EmailMessage.AddAttachment('Renewal Letter.pdf', 'application/pdf', IStream);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Message('Email has been sent.');
    end;
    //win315--

    //end;
}

