page 50022 "Broker Card"
{
    // //WIN325 - Added Field Control -"Emirates ID"

    Caption = 'Broker Card';
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Related Information';
    SourceTable = 5050;
    SourceTableView = WHERE(Broker = FILTER(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the contact number.';

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEditBroker(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.';

                    trigger OnAssistEdit()
                    begin
                        Rec.MODIFY;
                        COMMIT;
                        Cont.SETRANGE("No.", Rec."No.");
                        IF Rec.Type = Rec.Type::Person THEN BEGIN
                            CLEAR(NameDetails);
                            NameDetails.SETTABLEVIEW(Cont);
                            NameDetails.SETRECORD(Cont);
                            NameDetails.RUNMODAL;
                        END ELSE BEGIN
                            CLEAR(CompanyDetails);
                            CompanyDetails.SETTABLEVIEW(Cont);
                            CompanyDetails.SETRECORD(Cont);
                            CompanyDetails.RUNMODAL;
                        END;
                        REc.GET(Rec."No.");
                        CurrPage.UPDATE;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of contact, either company or person.';

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Enabled = CompanyNameEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.';

                    trigger OnAssistEdit()
                    begin
                        Rec.LookupCompany;
                    end;
                }
                field(IntegrationCustomerNo; IntegrationCustomerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Integration Customer No.';
                    ToolTip = 'Specifies the number of a customer that is integrated through Dynamics CRM.';
                    Visible = false;

                    trigger OnValidate()
                    var
                        Customer: Record 18;
                        ContactBusinessRelation: Record 5054;
                    begin
                        IF NOT (IntegrationCustomerNo = '') THEN BEGIN
                            Customer.GET(IntegrationCustomerNo);
                            ContactBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                            ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                            ContactBusinessRelation.SETRANGE("No.", Customer."No.");
                            IF ContactBusinessRelation.FINDFIRST THEN
                                Rec.VALIDATE("Company No.", ContactBusinessRelation."Contact No.");
                        END ELSE
                            Rec.VALIDATE("Company No.", '');
                    end;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the search name of the contact. You can use this field to search for a contact when you cannot remember the contact number.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the salesperson who normally handles this contact.';
                }
                field("Salutation Code"; Rec."Salutation Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the salutation code that will be used when you interact with the contact. The salutation code is only used in Word documents. To see a list of the salutation codes already defined, click the field.';
                }
                field("Organizational Level Code"; Rec."Organizational Level Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = OrganizationalLevelCodeEnable;
                    Importance = Additional;
                    ToolTip = 'Specifies the organizational code for the contact, for example, top management. This field is valid for persons only.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the contact card was last modified. This field is not editable.';
                }
                field("Date of Last Interaction"; Rec."Date of Last Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the date of the last interaction involving the contact, for example, a received or sent mail, e-mail, or phone call. This field is not editable.';

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record 5065;
                    begin
                        InteractionLogEntry.SETCURRENTKEY("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                        InteractionLogEntry.SETRANGE("Contact Company No.", Rec."Company No.");
                        InteractionLogEntry.SETFILTER("Contact No.", Rec."Lookup Contact No.");
                        InteractionLogEntry.SETRANGE("Attempt Failed", FALSE);
                        IF InteractionLogEntry.FINDLAST THEN
                            PAGE.RUN(0, InteractionLogEntry);
                    end;
                }
                field("Last Date Attempted"; Rec."Last Date Attempted")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the contact was last contacted, for example, when you tried to call the contact, with or without success. This field is not editable.';

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record 5065;
                    begin
                        InteractionLogEntry.SETCURRENTKEY("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                        InteractionLogEntry.SETRANGE("Contact Company No.", Rec."Company No.");
                        InteractionLogEntry.SETFILTER("Contact No.", Rec."Lookup Contact No.");
                        InteractionLogEntry.SETRANGE("Initiated By", InteractionLogEntry."Initiated By"::Us);
                        IF InteractionLogEntry.FINDLAST THEN
                            PAGE.RUN(0, InteractionLogEntry);
                    end;
                }
                field("Next To-do Date"; Rec."Next To-do Date")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the date of the next to-do involving the contact.';
                }
                field("Exclude from Segment"; Rec."Exclude from Segment")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies if the contact should be excluded from segments:';
                }
                field("Building No."; Rec."Building No.")
                {
                    Editable = EmiratesIDEditable;
                }
                field("Source of Lead"; Rec."Source of Lead")
                {
                }
                field("Source Company"; Rec."Source Company")
                {
                }
                field("Reason for Inactive"; Rec."Reason for Inactive")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                group(Addresses)
                {
                    Caption = 'Address';
                    field(Address; Rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s address.';
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies another line of the contact''s address.';
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the post code for the contact.';
                    }
                    field(County; Rec.County)
                    {
                    }
                    field(City; Rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the city where the contact is located.';
                    }
                    field("Country/Region Code"; Rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country/region code for the contact.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the contact''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.UPDATE(TRUE);
                            Rec.DisplayMap;
                        end;
                    }
                }
                group(ContactDetails)
                {
                    Caption = 'Contact';
                    field("Phone No."; Rec."Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s phone number.';
                    }
                    field("Mobile Phone No."; Rec."Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s mobile telephone number.';
                    }
                    field("E-Mail"; Rec."E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the email address of the contact.';
                    }
                    field("Fax No."; Rec."Fax No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the contact''s fax number.';
                    }
                    field("Home Page"; Rec."Home Page")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s home page address. You can enter a maximum of 80 characters, both numbers and letters.';
                    }
                    field("Correspondence Type"; Rec."Correspondence Type")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the type of correspondence that is preferred for this interaction. There are three options:';
                    }
                    field("Language Code"; Rec."Language Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the language code for the contact.';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Enabled = CurrencyCodeEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for the contact.';
                }
                field("Territory Code"; rec."Territory Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the territory code for the contact.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = VATRegistrationNoEnable;
                    Importance = Additional;
                    ToolTip = 'Specifies the contact''s VAT registration number. This field is valid for companies only.';

                    trigger OnDrillDown()
                    var
                        VATRegistrationLogMgt: Codeunit 249;
                    begin
                        VATRegistrationLogMgt.AssistEditContactVATReg(Rec);
                    end;
                }
            }
            group(Registration)
            {
                Caption = 'Registration';
                field("IRD No."; rec."IRD No.")
                {
                    ToolTip = 'Specifies the Australian Company Number for Australia or the Inland Revenue Department Number for New Zealand.';
                }
                field(ABN; rec.ABN)
                {
                    ToolTip = 'Specifies the Australian Business Number.';
                }
                field("ABN Division Part No."; rec."ABN Division Part No.")
                {
                    ToolTip = 'Specifies the Australian Business Number Division Part Number.';
                }
                field(Registered; rec.Registered)
                {
                    ToolTip = 'Specifies if the vendor is Registered for VAT with the ATO.';
                }
            }
            part("Profile Questionnaire"; "Broker Card Subform")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Profile Questionnaire';
                SubPageLink = "Contact No." = FIELD("No.");
                Visible = ActionVisible;
            }
        }
        area(factboxes)
        {
            part("Contact Picture"; "Contact Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = NOT IsOfficeAddin;
            }
            part("Contact Statistics FactBox"; 9130)
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter");
            }
            systempart(RecordLinks; Links)
            {
            }
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontact")
            {
                Caption = 'C&ontact';
                Image = ContactPerson;
                group("Comp&any")
                {
                    Caption = 'Comp&any';
                    Enabled = CompanyGroupEnabled;
                    Image = Company;
                    action("Business Relations")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Business Relations';
                        Image = BusinessRelation;
                        ToolTip = 'View or edit the contact''s business relations, such as customers, vendors, banks, lawyers, consultants, competitors, and so on.';

                        trigger OnAction()
                        var
                            ContactBusinessRelationRec: Record 5054;
                        begin
                            Rec.TESTFIELD(Rec.Type, Rec.Type::Company);
                            ContactBusinessRelationRec.SETRANGE("Contact No.", Rec."Company No.");
                            PAGE.RUN(PAGE::"Contact Business Relations", ContactBusinessRelationRec);
                        end;
                    }
                    action("Industry Groups")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Industry Groups';
                        Image = IndustryGroups;
                        ToolTip = 'View or edit the industry groups, such as Retail or Automobile, that the contact belongs to.';

                        trigger OnAction()
                        var
                            ContactIndustryGroupRec: Record 5058;
                        begin
                            Rec.TESTFIELD(Rec.Type, Rec.Type::Company);
                            ContactIndustryGroupRec.SETRANGE("Contact No.", Rec."Company No.");
                            PAGE.RUN(PAGE::"Contact Industry Groups", ContactIndustryGroupRec);
                        end;
                    }
                    action("Web Sources")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Web Sources';
                        Image = Web;
                        ToolTip = 'View a list of the web sites with information about the contact.';

                        trigger OnAction()
                        var
                            ContactWebSourceRec: Record 5060;
                        begin
                            Rec.TESTFIELD(Rec.Type, Rec.Type::Company);
                            ContactWebSourceRec.SETRANGE("Contact No.", Rec."Company No.");
                            PAGE.RUN(PAGE::"Contact Web Sources", ContactWebSourceRec);
                        end;
                    }
                }
                /*   group("Activate/Deactivate")
                 {
                 }  */
                action(Activate)
                {
                    Caption = 'Activate';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = Changestatusvisible;
                }
                action(Deactivate)
                {
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = Changestatusvisible;
                }
                action("Customer Card")
                {
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        rec.ShowCustomerCard; //WIN325
                    end;
                }
                group("P&erson")
                {
                    Caption = 'P&erson';
                    Enabled = PersonGroupEnabled;
                    Image = User;
                    action("Job Responsibilities")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Job Responsibilities';
                        Image = Job;
                        ToolTip = 'View or edit the contact''s job responsibilities.';

                        trigger OnAction()
                        var
                            ContJobResp: Record 5067;
                        begin
                            Rec.TESTFIELD(Rec.Type, Rec.Type::Person);
                            ContJobResp.SETRANGE("Contact No.", Rec."No.");
                            PAGE.RUNMODAL(PAGE::"Contact Job Responsibilities", ContJobResp);
                        end;
                    }
                }
                action("Pro&files")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Pro&files';
                    Image = Answers;
                    ToolTip = 'Open the Profile Questionnaires window.';
                    Visible = ActionVisible;

                    trigger OnAction()
                    var
                        ProfileManagement: Codeunit 5059;
                    begin
                        ProfileManagement.ShowContactQuestionnaireCard(Rec, '', 0);
                    end;
                }
                action("&Picture")
                {
                    ApplicationArea = Suite, RelationshipMgmt;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Contact Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ToolTip = 'View or add a picture of the contact person, or for example, the company''s logo.';
                    Visible = ActionVisible;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Contact),
                                  "No." = FIELD("No."),
                                  "Sub No." = CONST(0);
                    ToolTip = 'View or add comments.';
                }
                group("Alternati&ve Address")
                {
                    Caption = 'Alternati&ve Address';
                    Image = Addresses;
                    action(Card)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Card';
                        Image = EditLines;
                        RunObject = Page "Contact Alt. Address List";
                        RunPageLink = "Contact No." = FIELD("No.");
                        ToolTip = 'View or change detailed information about the contact.';
                    }
                    action("Date Ranges")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date Ranges';
                        Image = DateRange;
                        RunObject = Page "Contact Alt. Addr. Date Ranges";
                        RunPageLink = "Contact No." = FIELD("No.");
                        ToolTip = 'Specify date ranges that apply to the contact''s alternate address.';
                    }
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Enabled = (Rec.Type <> Rec.Type::Company) AND (Rec."Company No." <> '');
                Visible = CRMIntegrationEnabled;
                action(CRMGotoContact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    Image = CoupledContactPerson;
                    ToolTip = 'Open the coupled Dynamics CRM contact.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RECORDID);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData 5331 = IM;
                    ApplicationArea = All;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        CRMIntegrationManagement.UpdateOneNow(Rec.RECORDID);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData 5331 = IM;
                        ApplicationArea = All;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM contact.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit 5330;
                        begin
                            CRMIntegrationManagement.DefineCoupling(Rec.RECORDID);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData 5331 = IM;
                        ApplicationArea = All;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM contact.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit 5331;
                        begin
                            CRMCouplingManagement.RemoveCoupling(Rec.RECORDID);
                        end;
                    }
                }
            }
            group("Related Information")
            {
                Caption = 'Related Information';
                Image = Users;
                action("Relate&d Contacts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Relate&d Contacts';
                    Image = Users;
                    RunObject = Page "Contact List";
                    RunPageLink = "Company No." = FIELD("Company No.");
                    ToolTip = 'View a list of all contacts.';
                }
                action("Segmen&ts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Segmen&ts';
                    Image = Segment;
                    RunObject = Page "Contact Segment List";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact No.", "Segment No.");
                    ToolTip = 'View the segments that are related to the contact.';
                }
                action("Mailing &Groups")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Mailing &Groups';
                    Image = DistributionGroup;
                    RunObject = Page "Contact Mailing Groups";
                    RunPageLink = "Contact No." = FIELD("No.");
                    ToolTip = 'View or edit the mailing groups that the contact is assigned to, for example, for sending price lists or Christmas cards.';
                }
                action("C&ustomer/Vendor/Bank Acc.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'C&ustomer/Vendor/Bank Acc.';
                    Image = ContactReference;
                    ToolTip = 'View the related customer, vendor, or bank account that is associated with the current record.';

                    trigger OnAction()
                    begin
                        //ShowCustVendBank;
                        rec.ShowBusinessRelation(Rec."Contact Business Relation", true);
                    end;
                }
                action("Online Map")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'View the address on an online map.';

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                action("Office Customer/Vendor")
                {
                    ApplicationArea = All;
                    Caption = 'Customer/Vendor';
                    Image = ContactReference;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View the related customer, vendor, or bank account.';
                    Visible = IsOfficeAddin;

                    trigger OnAction()
                    begin
                        //ShowCustVendBank;
                        rec.ShowBusinessRelation(Rec."Contact Business Relation", true);
                    end;
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                Image = Task;
                action("T&o-dos")
                {
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                  "System To-do Type" = FILTER("Contact Attendee");
                    RunPageView = SORTING("Contact Company No.", Date, "Contact No.", Closed);
                }
                action("Oppo&rtunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Oppo&rtunities';
                    Image = OpportunityList;
                    RunObject = Page "Opportunity List";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact Company No.", "Contact No.");
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action("Postponed &Interactions")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Postponed &Interactions';
                    Image = PostponedInteractions;
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                    ToolTip = 'View postponed interactions for the contact.';
                    Visible = ActionVisible;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("Sales &Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Quotes';
                    Enabled = IsActive;
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Sell-to Contact No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Contact No.");
                    ToolTip = 'View sales quotes that exist for the contact.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contact Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Launch &Web Source")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Launch &Web Source';
                    Image = LaunchWeb;
                    ToolTip = 'Search for information about the contact online.';
                    Visible = ActionVisible;

                    trigger OnAction()
                    var
                        ContactWebSource: Record 5060;
                    begin
                        ContactWebSource.SETRANGE("Contact No.", Rec."Company No.");
                        IF PAGE.RUNMODAL(PAGE::"Web Source Launch", ContactWebSource) = ACTION::LookupOK THEN
                            ContactWebSource.Launch;
                    end;
                }
                action("Print Cover &Sheet")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print Cover &Sheet';
                    Image = PrintCover;
                    ToolTip = 'View cover sheets to send to your contact.';

                    trigger OnAction()
                    var
                        Cont: Record 5050;
                    begin
                        Cont := Rec;
                        Cont.SETRECFILTER;
                        REPORT.RUN(REPORT::"Contact - Cover Sheet", TRUE, FALSE, Cont);
                    end;
                }
                group("Create as")
                {
                    Caption = 'Create as';
                    Image = CustomerContact;
                    action(Customer)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer';
                        Image = Customer;
                        ToolTip = 'Create the contact as a customer.';

                        trigger OnAction()
                        begin
                            //CreateCustomer(ChooseCustomerTemplate);
                            rec.ChooseNewCustomerTemplate();
                        end;
                    }
                    action(Vendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor';
                        Image = Vendor;
                        ToolTip = 'Create the contact as a vendor.';

                        trigger OnAction()
                        begin
                            Rec.CreateVendor;
                        end;
                    }
                    action(Bank)
                    {
                        AccessByPermission = TableData 270 = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank';
                        Image = Bank;
                        ToolTip = 'Create the contact as a bank.';

                        trigger OnAction()
                        begin
                            Rec.CreateBankAccount;
                        end;
                    }
                }
                group("Link with existing")
                {
                    Caption = 'Link with existing';
                    Image = Links;
                    Visible = ActionVisible;
                    action("Existing Customer")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer';
                        Image = Customer;
                        ToolTip = 'Link the contact to an existing customer.';

                        trigger OnAction()
                        begin
                            Rec.CreateCustomerLink;
                        end;
                    }
                    action("Existing Vendor")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor';
                        Image = Vendor;
                        ToolTip = 'Link the contact to an existing vendor.';

                        trigger OnAction()
                        begin
                            Rec.CreateVendorLink;
                        end;
                    }
                    action("Existing Bank")
                    {
                        AccessByPermission = TableData 270 = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank';
                        Image = Bank;
                        ToolTip = 'Link the contact to an existing bank.';

                        trigger OnAction()
                        begin
                            Rec.CreateBankAccountLink;
                        end;
                    }
                }
                action("Apply Template")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Select a defined template to quickly create a new record.';

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit 8612;
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
                action(CreateAsCustomer)
                {
                    ApplicationArea = All;
                    Caption = 'Create as Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create a new customer based on this contact.';
                    Visible = IsOfficeAddin;

                    trigger OnAction()
                    begin
                        //CreateCustomer(ChooseCustomerTemplate);
                        rec.ChooseNewCustomerTemplate()
                    end;
                }
                action(CreateAsVendor)
                {
                    ApplicationArea = All;
                    Caption = 'Create as Vendor';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create a new vendor based on this contact.';
                    Visible = IsOfficeAddin;

                    trigger OnAction()
                    begin
                        Rec.CreateVendor;
                    end;
                }
            }
            action("Create &Interact")
            {
                AccessByPermission = TableData 5062 = R;
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
            action("Create Opportunity")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create Opportunity';
                Image = NewOpportunity;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Opportunity Card";
                RunPageLink = "Contact No." = FIELD("No."),
                              "Contact Company No." = FIELD("Company No.");
                RunPageMode = Create;
                ToolTip = 'Register a sales opportunity for the contact.';
            }
        }
        area(reporting)
        {
            action("Contact Cover Sheet")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Contact Cover Sheet';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Print or save cover sheets to send to one or more of your contacts.';

                trigger OnAction()
                begin
                    Cont := Rec;
                    Cont.SETRECFILTER;
                    REPORT.RUN(REPORT::"Contact - Cover Sheet", TRUE, FALSE, Cont);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit 5331;
    begin
        xRec := Rec;
        EnableFields;

        IF Rec.Type = Rec.Type::Person THEN
            IntegrationFindCustomerNo
        ELSE
            IntegrationCustomerNo := '';

        IF CRMIntegrationEnabled THEN
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(rec.RECORDID);
    end;

    trigger OnAfterGetRecord()
    begin
        //WIN325
        IF Rec.CustomerExists OR (Rec.Type = Rec.Type::Person) THEN
            EmiratesIDEditable := FALSE
        ELSE
            EmiratesIDEditable := TRUE;

        IF Rec.Type = Rec.Type::Company THEN
            ChangeStatusVisible := TRUE
        ELSE
            ChangeStatusVisible := FALSE;
        //WIN325

        IF Rec.Status = Rec.Status::"Request to Create Customer" THEN
            IsActive := TRUE
        ELSE
            IsActive := FALSE;
    end;

    trigger OnInit()
    begin
        OrganizationalLevelCodeEnable := TRUE;
        CompanyNameEnable := TRUE;
        VATRegistrationNoEnable := TRUE;
        CurrencyCodeEnable := TRUE;
        ActionVisible := CURRENTCLIENTTYPE = CLIENTTYPE::Windows;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Broker := TRUE; //WIN325
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Contact: Record 5050;

    begin
        IF Rec.GETFILTER("Company No.") <> '' THEN BEGIN
            Rec."Company No." := Rec.GETRANGEMAX("Company No.");
            Rec.Broker := TRUE; //WIN325
            Rec.Type := Rec.Type::Person;
            Contact.GET(Rec."Company No.");
            Rec.InheritCompanyToPersonData(Contact);
        END;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit 5330;
        OfficeManagement: Codeunit 1630;
    begin
        IsOfficeAddin := OfficeManagement.IsAvailable;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        IF rec.CustomerExists OR (rec.Type = rec.Type::Person) THEN
            EmiratesIDEditable := FALSE
        ELSE
            EmiratesIDEditable := TRUE;

        IF rec.Type = rec.Type::Company THEN
            ChangeStatusVisible := TRUE
        ELSE
            ChangeStatusVisible := FALSE;
    end;

    var
        Cont: Record 5050;
        CompanyDetails: Page 5054;
        NameDetails: Page 5055;
        IntegrationCustomerNo: Code[20];
        [InDataSet]

        CurrencyCodeEnable: Boolean;
        [InDataSet]
        VATRegistrationNoEnable: Boolean;
        [InDataSet]
        CompanyNameEnable: Boolean;
        [InDataSet]
        OrganizationalLevelCodeEnable: Boolean;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        IsOfficeAddin: Boolean;
        ActionVisible: Boolean;
        ShowMapLbl: Label 'Show Map';
        EmiratesIDEditable: Boolean;
        ChangeStatusVisible: Boolean;
        IsActive: Boolean;

    local procedure EnableFields()
    begin
        CompanyGroupEnabled := rec.Type = rec.Type::Company;
        PersonGroupEnabled := rec.Type = rec.Type::Person;
        CurrencyCodeEnable := rec.Type = rec.Type::Company;
        VATRegistrationNoEnable := rec.Type = rec.Type::Company;
        CompanyNameEnable := rec.Type = rec.Type::Person;
        OrganizationalLevelCodeEnable := rec.Type = rec.Type::Person;
    end;

    local procedure IntegrationFindCustomerNo()
    var
        ContactBusinessRelation: Record 5054;
    begin
        ContactBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SETRANGE("Contact No.", rec."Company No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            IntegrationCustomerNo := ContactBusinessRelation."No.";
        END ELSE
            IntegrationCustomerNo := '';
    end;

    local procedure TypeOnAfterValidate()
    begin
        EnableFields;
    end;
}

