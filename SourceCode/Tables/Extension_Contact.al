tableextension 50090 "Contact EXT" extends Contact
{
    fields
    {
        field(50000; "Building No."; Code[20])
        {
            Caption = 'Building No.';
            TableRelation = Building;
        }
        field(50001; Broker; Boolean)
        {
            Caption = 'Broker';
        }
        field(50002; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ","Request to Create Customer","Customer Created",Rejected;
            OptionCaption = ' ,Request to Create Customer,Customer Created,Rejected';
        }
        field(50003; "Broker No."; Code[20])
        {
            Caption = 'Broker No.';
            TableRelation = Contact."No." WHERE(Broker = CONST(true));
        }
        field(50004; "Source of Lead"; Code[20])
        {
            Caption = 'Source of Lead';
            TableRelation = "Source Lead";
        }
        field(50005; "Source Company"; Text[50])
        {
            Caption = 'Source Company';
            Editable = false;
        }
        field(50006; "Reason for Inactive"; Text[50])
        {
            Caption = 'Reason for Inactive';

            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Company);//WIN325
            end;

        }
        field(50007; "Contact Type"; Option)
        {
            Caption = 'Contact Type';
            OptionMembers = Individual,"Organizational Group";
            OptionCaption = 'Individual, Organizational Group';
        }
        field(50008; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            Editable = false;
        }
        field(50009; "Trade License No."; Code[20])
        {
            Caption = 'Trade License No.';

            trigger OnValidate()
            begin
                CheckDuplicateTradeLicenseNo; //Shruti-WIN347
                CheckDuplicateinothercompany;
            end;


        }
        field(50010; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(50012; "Lead Subtype"; Option)
        {
            Caption = 'Lead Subtype';
            OptionCaption = ' ,Online, PR, Event, sponsorship, Affiliates, others';
            OptionMembers = " ",Online,PR,Event,sponsorship,Affiliates,others;
        }
        field(50013; "SP assigned Datetime"; DateTime)
        {
            Caption = 'SP assigned Datetime';
        }
        field(50014; "SP interaction reminder sent"; Boolean)
        {
            Caption = 'SP interaction reminder sent';

        }
        field(50015; "Mgr. interaction reminder sent"; Boolean)
        {
            Caption = 'Mgr. interaction reminder sent';
            TableRelation = Campaign."No.";
        }
        field(50016; "Campaign Code"; Code[20])
        {
            Caption = 'Campaign Code';

        }
        field(50017; "Emirates ID"; Code[20])
        {
            Caption = 'Emirates ID';

            trigger OnValidate()
            begin
                CheckDuplicateEmiratesID; //Shruti-WIN347
                CheckDuplicateinothercompany;
            end;

        }
        field(50018; "Passport No."; Code[20])
        {
            Caption = 'Passport No.';

            trigger OnValidate()
            begin
                CheckDuplicatePassportNo; //Shruti-WIN347
                CheckDuplicateinothercompany;
            end;
        }
        field(50019; "D-U-N-S Number"; Text[30])
        {
            Caption = 'D-U-N-S Number';
        }
        field(50020; "Document Verifield"; Boolean)
        {
            Caption = 'Document Verifield';
            Editable = true;

            trigger OnValidate()
            begin
                //win315++
                IF (Status = Status::"Request to Create Customer") AND ("Document Verifield" = TRUE) THEN BEGIN
                    //VALIDATE(Status,Status::"Customer Created");
                    UserSetup.GET(USERID);
                    "Verified By" := USERID;
                    "Verified Date-Time" := CURRENTDATETIME;
                    MODIFY;
                END;
                //END;
                //win315--
            end;
        }
        field(50021; "Verified By"; Code[50])
        {
            Caption = 'Verified By';
            Editable = false;
        }
        field(50022; "Verified Date-Time"; DateTime)
        {
            Caption = 'Verified Date-Time';
            Editable = false;
        }
        field(50023; "Marital Status"; Option)
        {
            Caption = 'Marital Status';
            OptionMembers = " ",Single,Married,Divorced,Seperated;
            OptionCaption = ' ,Single,Married,Divorced,Seperated';
        }
        field(50024; "Mobile Phone No.2"; Text[30])
        {
            Caption = 'Mobile Phone No.2';
        }
        field(50025; "VAT Reg. No."; Text[30])
        {
            Caption = 'VAT Reg. No.';

        }
        field(50026; "Emergency Contact Name"; Text[50])
        {
            Caption = 'Emergency Contact Name';
        }
        field(50027; "STD Code"; Code[10])
        {
            Caption = 'STD Code';

        }
        field(50028; "Creation User Id"; Code[20])
        {
            Caption = 'Creation User Id';
            Editable = false;
        }
        field(50029; "Tenancy Type"; Option)
        {
            Caption = 'Tenancy Type';
            OptionMembers = " ",Residential,Commercial;
            OptionCaption = ' ,Residential,Commercial';
        }
        field(50030; "Employer Name & Add."; Text[250])
        {
            Caption = 'Employer Name & Add.';

        }
        field(50031; "Employer's Contact & Email"; Text[100])
        {
            Caption = 'Employers Contact & Email';
        }
        field(50032; Nationality; Text[30])
        {
            Caption = 'Nationality';
        }
        field(50033; "Next To-do Date"; Date)
        {
            Caption = 'Next To-do Date';
            FieldClass = FlowField;
            //Win513++
            //TableRelation = ("To-do.Date" WHERE ("Contact Company No."=FIELD("Company No."),"Contact No."=FIELD(FILTER("Lookup Contact No.")),Closed=CONST(False),"System To-do Type"=CONST("Contact Attendee")))
            CalcFormula = lookup("To-do".Date where("Contact Company No." = FIELD("Company No."), "Contact No." = FIELD(FILTER("Lookup Contact No.")), Closed = CONST(False), "System To-do Type" = CONST("Contact Attendee")));
            //Win513--
        }


        Field(50034; ABN; Text[11])
        {
            Caption = 'ABN';
            Numeric = true;
        }
        Field(50035; Registered; Boolean)
        {
            Caption = 'Registered';
        }
        Field(50036; "ABN Division Part No."; Text[30])
        {
            Caption = 'ABN Division Part No.';
            Numeric = true;
        }
        Field(50037; "IRD No."; Text[30])
        {
            Caption = 'IRD No.';
        }
        Field(50042; "Gender"; Enum Gender)
        {
            Caption = 'Gender';
        }
        Field(50043; "Company/Individual"; Enum "Company/Individual")
        {
            Caption = 'Company/Individual';
        }
        Field(50044; "Employer\ Employee Address"; Enum "Employer\ Employee Addres")
        {
            Caption = 'Employer\ Employee Address';
        }
        field(50045; Emirate; Code[10])
        {
            Caption = 'Emirate';
            TableRelation = "Country/Region";
        }

    }


    var
        myInt: Integer;
        Cont: Record Contact;
        RecCustomer: Record Customer;

        UserSetup: Record "User Setup";


        RMSetup: Record "Marketing Setup";

        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure CheckDuplicateTradeLicenseNo()
    var

        lText001: Label 'Trade License No. already exists for the contact %1';
        lText002: Label 'Trade License No. already exists for the customer %1';
    begin
        IF "Trade License No." = '' THEN
            EXIT;
        //Shruti-WIN347
        Cont.RESET;
        Cont.SETFILTER("No.", '<>%1', "No.");
        Cont.SETRANGE("Trade License No.", "Trade License No.");
        IF Cont.FINDSET THEN
            ERROR(lText001, Cont."No.");

        //Shruti-WIN347
        RecCustomer.RESET;
        //RecCustomer.SETFILTER("No.",'<>%1',"No.");
        RecCustomer.SETFILTER("Primary Contact No.", '<>%1', "No.");
        RecCustomer.SETRANGE("Trade License No.", "Trade License No.");
        IF RecCustomer.FINDSET THEN
            ERROR(lText002, RecCustomer."No.");
    end;

    procedure CheckDuplicateinothercompany()
    var

        comp: Record Company;
        compCustomer: Record Customer;

        lText001: Label 'Emirates ID. already exists for the contact %1 of Company %2';
        lText002: Label 'Passport No. already exists for the contact %1 of Company %2';
        lText003: Label 'Trade License No. already exists for the contact %1 of Company %2';
    begin
        IF ("Trade License No." = '') AND ("Passport No." = '') AND ("Emirates ID" = '') THEN
            EXIT;

        //Shruti-WIN347
        comp.SETFILTER(comp.Name, '<>%1', COMPANYNAME);
        IF comp.FINDFIRST THEN BEGIN
            REPEAT
                IF "Customer No." <> '' THEN BEGIN
                    IF ("Emirates ID" <> '') THEN BEGIN
                        compCustomer.CHANGECOMPANY(comp.Name);
                        compCustomer.SETFILTER(compCustomer."Source Company Customer Code", '<>%1', "Customer No.");
                        compCustomer.SETRANGE("Emirates ID", "Emirates ID");
                        IF compCustomer.FINDSET THEN
                            ERROR(lText001, compCustomer."No.", comp.Name);
                    END;
                    IF ("Passport No." <> '') THEN BEGIN
                        compCustomer.CHANGECOMPANY(comp.Name);
                        compCustomer.SETFILTER(compCustomer."Source Company Customer Code", '<>%1', "Customer No.");
                        compCustomer.SETRANGE("Passport No.", "Passport No.");
                        IF compCustomer.FINDSET THEN
                            ERROR(lText002, compCustomer."No.", comp.Name);
                    END;
                    IF ("Trade License No." <> '') THEN BEGIN
                        compCustomer.CHANGECOMPANY(comp.Name);
                        compCustomer.SETFILTER(compCustomer."Source Company Customer Code", '<>%1', "Customer No.");
                        compCustomer.SETRANGE("Trade License No.", "Trade License No.");
                        IF compCustomer.FINDSET THEN
                            ERROR(lText003, compCustomer."No.", comp.Name);
                    END;
                END
                ELSE BEGIN
                    IF ("Emirates ID" <> '') THEN BEGIN
                        compCustomer.CHANGECOMPANY(comp.Name);
                        compCustomer.SETRANGE("Emirates ID", "Emirates ID");
                        IF compCustomer.FINDSET THEN
                            ERROR(lText001, compCustomer."No.", comp.Name);
                    END;
                    IF ("Passport No." <> '') THEN BEGIN
                        compCustomer.CHANGECOMPANY(comp.Name);
                        compCustomer.SETRANGE("Passport No.", "Passport No.");
                        IF compCustomer.FINDSET THEN
                            ERROR(lText002, compCustomer."No.", comp.Name);
                    END;
                    IF ("Trade License No." <> '') THEN BEGIN
                        compCustomer.CHANGECOMPANY(comp.Name);
                        compCustomer.SETRANGE("Trade License No.", "Trade License No.");
                        IF compCustomer.FINDSET THEN
                            ERROR(lText003, compCustomer."No.", comp.Name);
                    END;
                END;
            UNTIL comp.NEXT = 0;
        END;
    end;

    procedure AssistEditBroker(OldCont: Record Contact): Boolean
    begin
        //WIN325
        //Win513++
        //WITH Cont DO BEGIN
        //Win513--
        Cont := Rec;
        RMSetup.GET;
        RMSetup.TESTFIELD("Broker Nos.");
        IF NoSeriesMgt.SelectSeries(RMSetup."Broker Nos.", OldCont."No. Series", "No. Series") THEN BEGIN
            RMSetup.GET;
            RMSetup.TESTFIELD("Broker Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Cont;
            EXIT(TRUE);
        END;
        //Win513++
        //END;
        //Win513--
    end;

    Procedure CustomerExists(): Boolean
    var

        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        //WIN325
        ContactBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SETRANGE("Contact No.", "Company No.");
        IF ContactBusinessRelation.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    procedure ShowCustomerCard()
    var

        ContactBusinessRelation: Record "Contact Business Relation";
        lCust: Record Customer;
    begin
        //WIN325
        ContactBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SETRANGE("Contact No.", "Company No.");
        IF ContactBusinessRelation.FINDFIRST THEN begin
            IF lCust.GET(ContactBusinessRelation."No.") THEN
                PAGE.RUN(21, lCust);
        end;
    end;

    procedure CheckDuplicatePassportNo()
    var

        lText001: Label 'Passport No already exists for the contact %1';
        lText002: Label 'Passport No already exists for the customer %1';
    begin
        //Shruti-WIN347
        IF "Passport No." = '' THEN
            EXIT;

        Cont.RESET;
        Cont.SETFILTER("No.", '<>%1', "No.");
        Cont.SETRANGE("Passport No.", "Passport No.");
        IF Cont.FINDSET THEN
            ERROR(lText001, Cont."No.");

        //Shruti-WIN347
        RecCustomer.RESET;
        //RecCustomer.SETFILTER("No.",'<>%1',"No.");
        RecCustomer.SETFILTER("Primary Contact No.", '<>%1', "No.");
        RecCustomer.SETRANGE("Passport No.", "Passport No.");
        IF RecCustomer.FINDSET THEN
            ERROR(lText002, RecCustomer."No.");
    end;

    //Win513++
    procedure CheckDuplicateEmiratesID()
    var

        lText001: Label 'Emirates ID already exists for the contact %1';
        lText002: Label 'Emirates ID already exists for the customer %1';
    begin
        //Shruti-WIN347
        IF "Emirates ID" = '' THEN
            EXIT;

        Cont.RESET;
        Cont.SETFILTER("No.", '<>%1', "No.");
        Cont.SETRANGE("Emirates ID", "Emirates ID");
        IF Cont.FINDSET THEN
            ERROR(lText001, Cont."No.");

        //Shruti-WIN347
        RecCustomer.RESET;
        //RecCustomer.SETFILTER("No.",'<>%1',"No.");
        RecCustomer.SETFILTER("Primary Contact No.", '<>%1', "No.");
        RecCustomer.SETRANGE("Emirates ID", "Emirates ID");
        IF RecCustomer.FINDSET THEN
            ERROR(lText002, RecCustomer."No.");
    end;
    //Win513--

    procedure SendMailtoSP()
    var

        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lReasonCode: Record "Reason Code";
        UserSetup: Record "User Setup";
        lUser: Record User;
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        MarketingSetup: Record "Marketing Setup";
        FileName: Text;
        FileManagement: Codeunit "File Management";
        DocArticles: Record "Incoming Document Attachment";

        DefaultFileName: Text[1024];
        DefaultFileNamePath: Text[1024];
    //TempBlob: Record TempBlob;
    begin
        //win315++

        //SMTPSetup.GET;
        //TESTFIELD("E-Mail");
        //SMTPSetup.TESTFIELD("User ID");
        //SMTPSetup.TESTFIELD("Email Sender To");

        MarketingSetup.GET;
        MarketingSetup.TESTFIELD("Email Sender To");
        Recipients.Add(MarketingSetup."Email Sender To");

        //SalespersonPurchaser.GET("Salesperson Code");
        //SalespersonPurchaser.TESTFIELD("E-Mail");

        //Link123:='';
        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",SalespersonPurchaser."E-Mail",'Contact No '+FORMAT("No.")+' is assigned','',TRUE);
        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID","E-Mail",'Contact No '+FORMAT("No.")+' is assigned','',TRUE);


        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",SMTPSetup."Email Sender To",'Contact No '+FORMAT("No.")+' is assigned','',TRUE);
        //SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", MarketingSetup."Email Sender To", 'Customer Creation Request', '', TRUE);
        //IF MarketingSetup."Email Sender CC" <> '' THEN
        //  SMTPMail.AddCC(MarketingSetup."Email Sender CC");
        //SMTPMail.AppendBody('Hi '+SalespersonPurchaser.Name);
        //SMTPMail.AppendBody('Hi '+ Name);

        Subject := 'Customer Creation Request';
        Body := 'Dear Sir / Madam, <br><br> Good day! <br><Br>';
        Body += 'Request has been generated to create customer for contact no. ' + FORMAT("No.") + '.' + ' ' + 'Related documents are attached for verifications.';
        Body += '<br><Br> Thanks & Regards, <br> NAV Administrator <br><br>';

        DocArticles.RESET;
        DocArticles.SETRANGE(DocArticles."Document No.", Rec."No.");
        IF DocArticles.FINDSET THEN
            REPEAT
                DefaultFileName := '';
                DefaultFileNamePath := '';
                DefaultFileName := DocArticles.Name + '.' + DocArticles."File Extension";
                DocArticles.CALCFIELDS(Content);
            //CLEAR(TempBlob);
            //DocArticles.OnGetBinaryContent(TempBlob);
            /* IF NOT TempBlob.Blob.HASVALUE THEN BEGIN
                TempBlob.Blob := DocArticles.Content;
                DefaultFileNamePath := FileMgt.BLOBExport(TempBlob, DefaultFileName, FALSE);
                SMTPMail.AddAttachment(DefaultFileNamePath, DefaultFileNamePath); // WIN210 Temp Commented for sharepoint access
            END; */
            // SMTPMail.AddAttachment(DocArticles.Link,DocArticles.Link);
            UNTIL DocArticles.NEXT = 0; // WIN210 Temp Commented for sharepoint access
        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        MESSAGE('Email has been sent.');

    end;
}