PageExtension 50229 pageextension50229 extends "Contact Card"
{
    layout
    {
        modify("VAT Registration No.")
        {
            ApplicationArea = All;
            Enabled = true;
        }

        modify(Type)
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Date of Last Interaction")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Last Date Attempted")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Exclude from Segment")
        {
            ApplicationArea = All;
            Visible = false;
        }

        addafter("No.")
        {
            field("Select Country Code"; SelectCountryCode)
            {
                ApplicationArea = Basic;
                Editable = false;
                Caption = 'Select Country Code';

                trigger OnValidate()
                begin
                    Rec."STD Code" := SelectCountryCode;
                end;
            }

        }
        addafter(Name)
        {
            field("Company/Individual"; Rec."Company/Individual")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company/Individual field.';
            }
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender field.';
            }

            field("Contact Type"; Rec."Contact Type")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Salutation Code")
        {
            field("Source of Lead"; Rec."Source of Lead")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
            field("Tenancy Type"; Rec."Tenancy Type")
            {
                ApplicationArea = Basic;
            }
            field("Lead Subtype"; Rec."Lead Subtype")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(Nationality; Rec.Nationality)
            {
                ApplicationArea = Basic;
            }
            field("Emirates ID"; Rec."Emirates ID")
            {
                ApplicationArea = Basic;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = Basic;
            }
            field("Creation User ID"; Rec."Creation User ID")
            {
                ApplicationArea = Basic;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Organizational Level Code")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Document Verified"; Rec."Document Verifield")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Verified By"; Rec."Verified By")
            {
                ApplicationArea = Basic;
            }
            field("Verified Date-Time"; Rec."Verified Date-Time")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Country/Region Code"; "Mobile Phone No.")

        addafter("Correspondence Type")
        {
            field("Trade License No."; Rec."Trade License No.")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
            field("<VAT Registration No.>"; Rec."VAT Reg. No.")
            {
                ApplicationArea = Basic;
                Caption = 'VAT Registration No.';
            }
        }
        addbefore("VAT Registration No.")
        {
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("E-Mail")
        {
            field("Emergency Contact Name"; Rec."Emergency Contact Name")
            {
                ApplicationArea = Basic;
            }
            group("Employer Details")
            {
                Caption = 'Employer Details';
                field("Employer Name & Add."; Rec."Employer Name & Add.")
                {
                    ApplicationArea = Basic;
                }
                field("Employer's Contact & Email"; Rec."Employer's Contact & Email")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        addfirst("Foreign Trade")
        {

            field("D-U-N-S Number"; Rec."D-U-N-S Number")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        moveafter(ContactDetails; "Fax No.")
        moveafter("Correspondence Type"; "VAT Registration No.")

        //WIN513++
        addafter(Communication)
        {
            // part(Documents; "Documents and Articles")
            // {
            //     ApplicationArea = All;
            //     Enabled = Rec."No." <> '';
            //     SubPageLink = "Issued To Type" = const(Contact), "Issued To" = field("No.");
            //     UpdatePropagation = Both;
            // }
            part("Require Documents"; "Required Attached Documents")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5050),
                              "No." = FIELD("No.");
            }
        }

        addafter("Parental Consent Received")
        {
            field(Broker; Rec.Broker)
            {
                ApplicationArea = All;
            }
        }
        addafter("Customer No.")
        {

            field("Employer\ Employee Address"; Rec."Employer\ Employee Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employer\ Employee Address field.';
            }
        }
        addafter(City)
        {
            field(Emirate; Rec.Emirate)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Emirate field.';
            }
        }
    }

    //WIN513--

    actions
    {
        //Win513++
        //modify("C&ustomer/Vendor/Bank Acc.")
        modify(RelatedCustomer)
        //Win513--
        {
            ApplicationArea = All;
            Caption = 'Created Customer';
        }

        modify(Customer)
        {
            ApplicationArea = All;
            Caption = 'Create as Customer';
        }
        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CreateCustomer(ChooseCustomerTemplate);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //win315++
        IF ("Document Verifield" = TRUE) THEN BEGIN
          TempCode:=ChooseCustomerTemplate;

          IF TempCode <> '' THEN
          CreateCustomer(TempCode)
        END ELSE
          ERROR('You cannot create customer as for contact %1 document is not verified',"No.");
        //win315--
        */
        //end;

        //Unsupported feature: Code Modification on "CreateAsCustomer(Action 17).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CreateCustomer(ChooseCustomerTemplate);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //CreateCustomer(ChooseCustomerTemplate);
        IF ("Document Verifield" = TRUE) THEN BEGIN
          TempCode:=ChooseCustomerTemplate;
          IF TempCode <> '' THEN
          CreateCustomer(TempCode)
        END ELSE
          ERROR('You cannot create customer as for contact %1 document is not verified',"No.");
        */
        //end;
        addafter("Create Opportunity")
        {
            action("Request to Create Customer")
            {
                ApplicationArea = Basic;
                Caption = 'Request to Create Customer';
                Image = CreateDocument;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IsDocAttachmentExist: Boolean;
                begin
                    SelectCountryCode := '+971';
                    Rec."Mobile Phone No." := SelectCountryCode + Format(Rec."Mobile Phone No.");

                    //win315++
                    if Rec.Status = Rec.Status::"Request to Create Customer" then
                        Error('Contact Status is already Request to Create Customer');

                    /*IF Status = Status::" " THEN BEGIN
                      IF CONFIRM('Do you want to change status to Request to Create Customer?',TRUE) THEN BEGIN
                        VALIDATE(Status,Status::"Request to Create Customer");
                        MODIFY;
                      END;
                    END;*/



                    IsDocAttachmentExist := DocAttachmentForContact();
                    Link12 := '';
                    IncomingDocumentAttachment.Reset;
                    IncomingDocumentAttachment.SetRange(IncomingDocumentAttachment."Document No.", Rec."No.");
                    if IncomingDocumentAttachment.FindFirst then
                        Link12 := IncomingDocumentAttachment.Name;
                    //MESSAGE(FORMAT(Link12));

                    Link123 := '';
                    DocArticles.Reset;
                    DocArticles.SetRange(DocArticles."Issued To", Rec."No.");
                    if DocArticles.FindSet then
                        repeat
                            Link123 := DocArticles.Link;
                        //MESSAGE(FORMAT(Link123));
                        until DocArticles.Next = 0;

                    /*IF (Status = Status::" ") OR (Status=Status::Rejected) THEN BEGIN
                      IF (Link12 <> '') OR (Link123 <> '') THEN BEGIN
                        IF CONFIRM('Do you want to change status to Request to Create Customer?',TRUE) THEN BEGIN
                          VALIDATE(Status,Status::"Request to Create Customer");
                          MODIFY;
                          SendMailtoSP;
                        END;
                    
                      END ELSE BEGIN
                        ERROR('Document Attachement for contact %1 does not exist',"No.");
                    END;
                    //win315--
                    END;
                    */


                    if (Rec.Status = Rec.Status::" ") or (Rec.Status = Rec.Status::Rejected) then begin
                        if (Link123 <> '') then begin
                            if Confirm('Do you want to change status to Request to Create Customer?', true) then begin
                                Rec.Validate(Status, Rec.Status::"Request to Create Customer");
                                Rec.Modify;

                            end;
                        end else
                            if (Link123 = '') and (Link12 <> '') then begin
                                if Confirm('Do you want to change status to Request to Create Customer?', true) then begin
                                    Rec.Validate(Status, Rec.Status::"Request to Create Customer");
                                    Rec.Modify;

                                end;
                            end else
                                if IsDocAttachmentExist then begin
                                    if Confirm('Do you want to change status to Request to Create Customer?', true) then begin
                                        Rec.Validate(Status, Rec.Status::"Request to Create Customer");
                                        Rec.Modify;
                                    end;
                                end else
                                    if (Link123 = '') and (Link12 = '') and (IsDocAttachmentExist = false) then begin
                                        Error('Document Attachement for contact %1 does not exist', Rec."No.");
                                    end;
                    end;

                    //win315--

                end;
            }
            action("Documents Verified")
            {
                ApplicationArea = Basic;
                Caption = 'Document Verified';
                Enabled = true;
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                Visible = EnableVeri;

                trigger OnAction()
                begin
                    //win315++
                    if Rec."Document Verifield" = true then
                        Error('Document is already verified');

                    if Rec.Status = Rec.Status::Rejected then
                        Error('Document is already rejected');

                    if (Rec.Status = Rec.Status::"Request to Create Customer") then begin
                        if Confirm('Are you sure you have verified all documents?', true) then begin
                            //VALIDATE(Status,Status::"Customer Created");
                            UserSetup.Get(UserId);
                            Rec."Verified By" := UserId;
                            Rec."Verified Date-Time" := CurrentDatetime;
                            Rec."Document Verifield" := true;
                            Rec.Modify;
                        end;
                    end else
                        Error('Status should be Request to Create Customer');
                    //win315--
                end;
            }
            action("Document Rejected")
            {
                ApplicationArea = Basic;
                Caption = 'Document Rejected';
                Enabled = true;
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = EnableReject;

                trigger OnAction()
                begin
                    //win315++
                    if (Rec.Status = Rec.Status::Rejected) then
                        Error('Document is already rejected.');

                    if Rec."Document Verifield" = true then
                        Error('Document is already verified.');

                    if (Rec.Status = Rec.Status::"Request to Create Customer") and (Rec."Document Verifield" = false) then begin
                        if Confirm('Are you sure you want to reject?', true) then begin
                            Rec.Validate(Status, Rec.Status::Rejected);
                            Rec.Modify;
                        end;
                    end;
                    //win315--
                end;
            }
            action("Link Attached")
            {
                ApplicationArea = Basic;
                Caption = 'Link Attached';
                Visible = false;

                trigger OnAction()
                begin
                    /*Link12:='';
                    DocArticles.RESET;
                    DocArticles.SETRANGE(DocArticles."Issued To",Rec."No.");
                    IF DocArticles.FINDFIRST THEN
                      Link12 := DocArticles.Link;
                      //MESSAGE(FORMAT(Link12));
                    
                      IF Link12 <> '' THEN BEGIN
                    
                      IF CONFIRM('Do you want to change status to Request to Create Customer?',TRUE) THEN BEGIN
                    
                        VALIDATE(Status,Status::"Request to Create Customer");
                        MODIFY;
                      END;
                    END ELSE BEGIN
                      ERROR('Documents');
                      END;
                      */

                    //SendMailtoSP;

                end;
            }
        }
        moveafter("Print Cover &Sheet"; Customer)
    }

    //WIN513++
    trigger OnOpenPage()
    begin
        UserSetup1.GET(USERID);
        IF UserSetup1."Document Verification" = TRUE THEN BEGIN
            EnableVeri := TRUE;
            EnableReject := TRUE
        END ELSE BEGIN
            EnableVeri := FALSE;
            EnableReject := FALSE;
        END;
    end;
    //WIN513--

    var
        UserSetup: Record "User Setup";
        DocArticles: Record 50009;
        RecCont: Record Contact;
        Link12: Text[250];
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        UserSetup1: Record "User Setup";
        EnableVeri: Boolean;
        EnableReject: Boolean;
        Link123: Text[250];
        IntitText: Code[10];
        SelectCountryCode: Code[20];
        PhoneNo: Text;
        TempCode: Code[20];
        ExistingSTDCode: Code[10];

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    xRec := Rec;
    EnableFields;

    #4..7

    IF CRMIntegrationEnabled THEN
      CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..10

    //win315++
    UserSetup1.GET(USERID);
    IF UserSetup1."Document Verification" = TRUE THEN BEGIN
        EnableVeri := TRUE;
        EnableReject := TRUE
    END ELSE BEGIN
        EnableVeri := FALSE;
        EnableReject := FALSE;
    END;
    //win315--

    {IF "Phone No."<>'' THEN
    SelectCountryCode:=COPYSTR("Phone No.",1,4)
    } // WIN210

    //end;

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OrganizationalLevelCodeEnable := TRUE;
    CompanyNameEnable := TRUE;
    VATRegistrationNoEnable := TRUE;
    CurrencyCodeEnable := TRUE;
    ActionVisible := CURRENTCLIENTTYPE = CLIENTTYPE::Windows;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    // TO Create Customer
    Type := Type::Company;
    "STD Code" := '+971';
    */
    //end;

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsOfficeAddin := OfficeManagement.IsAvailable;
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // MAZRealEstate
    OpenContact(SelectCountryCode,PhoneNo,Rec);
    // MAZRealEstate
    IsOfficeAddin := OfficeManagement.IsAvailable;
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    // TO Create Customer
    Type := Type::Company;
    */
    //end;

    local procedure OpenContact(var STDCode: Code[10]; var PhoneNo: Text; ContactRec: Record Contact)
    begin
        STDCode := ContactRec."STD Code";
        PhoneNo := ContactRec."Phone No.";
    end;

    procedure LookupSTDCode(var STDCode: Code[10])
    var
        CountryRegion: Record "Country/Region";
    begin
        Commit;
        if Page.RunModal(0, CountryRegion) = Action::LookupOK then begin
            STDCode := CountryRegion."STD Code";
        end;
    end;

    procedure DocAttachmentForContact(): Boolean
    var
        DocumentAttachment: Record "Document Attachment";

    begin
        DocumentAttachment.SetRange("Table ID", 5050);
        DocumentAttachment.SetRange("No.", Rec."No.");
        if DocumentAttachment.FindFirst() then
            exit(true);


    end;
}