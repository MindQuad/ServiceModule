#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
PageExtension 50301 pageextension50301 extends "Customer Card"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Emirates ID"; Rec."Emirates ID")
            {
                ApplicationArea = Basic;
                Caption = 'Emirates ID';
            }
        }
        addafter("Search Name")
        {
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        moveafter("Search Name"; "Name 2")

        addafter("IC Partner Code")
        {
            field("<Balance1>"; Rec.Balance)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Phone No.")
        {
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = Basic;
                Caption = 'Mobile Phone No.';
            }
            group(Contact)
            {
            }
        }
        addafter("E-Mail")
        {
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = Basic;
            }
            field("<VAT Registration No.>"; Rec."VAT Reg. No.")
            {
                ApplicationArea = Basic;
                Caption = 'VAT Registration No.';
            }
        }
        addafter("Home Page")
        {
            field("<T/L Expiry Date>"; Rec."S/T Expiry Date")
            {
                ApplicationArea = Basic;
                Caption = 'T/L Expiry Date';
            }
            field("Emergency Contact Name"; Rec."Emergency Contact Name")
            {
                ApplicationArea = Basic;
            }
            field("Employer Name & Add."; Rec."Employer Name & Add.")
            {
                ApplicationArea = Basic;
            }
            field("Employer's Contact & Email"; Rec."Employer's Contact & Email")
            {
                ApplicationArea = Basic;
            }
            field(Nationality; Rec.Nationality)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Invoice Copies"; Rec."Invoice Copies")
            {
                ApplicationArea = Basic;
            }

            field("Tenancy Type"; Rec."Tenancy Type")
            {
                ApplicationArea = Basic;
            }

            field(Building; Rec."Building No.")
            {
                ApplicationArea = Basic;
            }
            field("Building Name"; Rec."Building Name")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Unit; Rec.Unit)
            {
                ApplicationArea = Basic;
            }
            field("Service Item No."; Rec."Service Item No.")
            {
                ApplicationArea = All;
            }

        }
        //WIN 269 FIN/2.8/1/1.5
        modify(Blocked)
        {
            Editable = AllowBlocked;
        }
        //WIN 269 END

        moveafter(County; City)
        moveafter(ShowMap; "E-Mail")
        moveafter("Customer Posting Group"; "Payment Terms Code")

        //Win513++
        addafter("Disable Search by Name")
        {
            field(Password; Rec.Password)
            {
                ApplicationArea = All;
                //Editable = false;
            }
        }

        addafter(Invoicing)
        {
            // part(Documents; "Documents and Articles")
            // {
            //     ApplicationArea = All;
            //     Enabled = Rec."No." <> '';
            //     SubPageLink = "Issued To Type" = const(Customer), "Issued To" = field("No.");
            //     UpdatePropagation = Both;
            // }
            part("Require Documents"; "Required Attached Documents")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
            }
        }
        //Win513--  

    }
    actions
    {
        addafter(Contact)
        {
            action(Action1000000013)
            {
                ApplicationArea = Basic;
                Caption = 'Contact';
                Image = ContactPerson;
                Promoted = true;
                PromotedIsBig = false;
                RunObject = Page "Contact List";
                RunPageLink = "No." = field("Primary Contact No.");
            }
            action("Interaction Log Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Interaction Log Entries';
                Image = InteractionLog;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Interaction Log Entries";
                RunPageLink = "Contact No." = field("Primary Contact No.");
            }
            action("Copy Customer")
            {
                ApplicationArea = Basic;
                Caption = 'Copy Customer';
                Image = InteractionLog;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lAction: Action;
                    lPage: Page "Customer Duplication";
                begin
                    ////Win593++
                    lAction := Page.RunModal(Page::"Customer Duplication", Rec);
                    //lAction := lPage.RunModal();
                    //Win593--
                    case lAction of
                        action::OK, action::LookupOK:
                            ExecuteOKCode();
                        action::Cancel, action::LookupCancel:
                            ExecuteCancelCode();
                    end;
                end;
            }
        }
        addafter("Ser&vice Contracts")
        {
            action("Active Service Contracts")
            {
                ApplicationArea = Service;
                Caption = 'Active Service Contracts';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ServiceAgreement;
                // RunObject = Page "Customer Service Contracts";
                // RunPageLink = "Customer No." = FIELD("No.");
                // RunPageView = SORTING("Customer No.", "Ship-to Code") where("Expiration Date" = filter(>= 'Today()'));
                ToolTip = 'Open the list of ongoing service contracts.';

                trigger OnAction()
                var
                    CustomerServiceContract: Record "Service Contract Header";
                begin
                    CustomerServiceContract.Reset();
                    CustomerServiceContract.SetRange("Customer No.", Rec."No.");
                    CustomerServiceContract.SetFilter("Expiration Date", '>=%1', Today);
                    RunModal(Page::"Customer Service Contracts", CustomerServiceContract);
                end;
            }
        }
    }

    //WIN 269 FIN/2.8/1/1.5
    trigger OnOpenPage()
    begin
        AllowBlocked := false;
    end;

    trigger OnAfterGetRecord()
    begin
        IF UserSetup.Get(UserId) then begin
            IF UserSetup."Admin User" = true then
                AllowBlocked := true;
        end;
    end;


    procedure ExecuteOKCode()
    var
        NewCustomer: Record Customer;
    begin
        if CompanyName = Rec."Company To" then
            Error('Selected Company same Company in which currently working');

        NewCustomer.ChangeCompany(Rec."Company To");
        NewCustomer.Init();
        NewCustomer.TransferFields(Rec);
        NewCustomer.Insert();

        Message('Customer ' + Rec."No." + 'is inserted in ' + Rec."Company To" + ' company.');
        Rec."Company To" := '';
        Rec.Modify();

    end;

    procedure ExecuteCancelCode()
    begin
        Message('Cancel');
    end;


    var
        UserSetup: Record "User Setup";
        AllowBlocked: Boolean;

    //WIN 269 END
}

