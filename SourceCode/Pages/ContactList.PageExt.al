PageExtension 50265 pageextension50265 extends "Contact List"
{
    layout
    {
        modify("Salesperson Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Territory Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Search Name")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter("Company Name")
        {
            field("Customer No."; Rec."Customer No.")
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
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
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

        moveafter(Name; "Phone No.")
    }
    actions
    {

        //Unsupported feature: Property Insertion (Visible) on ""Comp&any"(Action 34)".


        //Unsupported feature: Property Insertion (Visible) on ""Industry Groups"(Action 36)".


        //Unsupported feature: Property Insertion (Visible) on ""Web Sources"(Action 37)".


        //Unsupported feature: Property Insertion (Visible) on ""Job Responsibilities"(Action 39)".

        modify("Pro&files")
        {

            //Unsupported feature: Property Modification (Visible) on ""Pro&files"(Action 41)".

            Enabled = true;
        }

        //Unsupported feature: Property Insertion (Promoted) on ""Relate&d Contacts"(Action 33)".


        //Unsupported feature: Property Insertion (Visible) on ""Segmen&ts"(Action 55)".


        //Unsupported feature: Property Insertion (Visible) on ""Mailing &Groups"(Action 40)".



        //Unsupported feature: Property Insertion (Visible) on "Tasks(Action 7)".


        //Unsupported feature: Property Insertion (Visible) on ""Open Oppo&rtunities"(Action 3)".


        //Unsupported feature: Property Insertion (Visible) on "Documents(Action 9)".


        //Unsupported feature: Property Insertion (Visible) on ""Closed Oppo&rtunities"(Action 67)".


        //Unsupported feature: Property Insertion (Visible) on "MakePhoneCall(Action 54)".


        //Unsupported feature: Property Modification (Visible) on ""Launch &Web Source"(Action 56)".


        //Unsupported feature: Property Insertion (Visible) on "Customer(Action 59)".


        //Unsupported feature: Property Insertion (Visible) on "Vendor(Action 60)".


        //Unsupported feature: Property Insertion (Visible) on "Bank(Action 61)".


        //Unsupported feature: Property Insertion (Visible) on ""Link with existing"(Action 62)".


        //Unsupported feature: Property Insertion (Visible) on ""Create Oportunity"(Action 51)".


        //Unsupported feature: Property Insertion (Visible) on "SyncWithExchange(Action 28)".


        //Unsupported feature: Property Insertion (Visible) on "FullSyncWithExchange(Action 32)".


        //Unsupported feature: Property Insertion (Visible) on ""New Sales Quote"(Action 1900900305)".


        //Unsupported feature: Property Insertion (Visible) on ""Contact Labels"(Action 1904205506)".


        //Unsupported feature: Property Insertion (Visible) on ""Questionnaire Handout"(Action 1905922906)".


        //Unsupported feature: Property Insertion (Visible) on ""Sales Cycle Analysis"(Action 1900800206)".

        addafter(FullSyncWithExchange)
        {
            action("Document Verified")
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

                    if (Rec.Status = Rec.Status::"Request to Create Customer") then begin
                        if Confirm('Are you sure you want to reject?', true) then begin
                            Rec.Validate(Status, Rec.Status::Rejected);
                            Rec.Modify;
                        end;
                    end;
                    //win315--
                end;
            }
        }
    }

    var
        UserSetup1: Record "User Setup";
        EnableVeri: Boolean;
        EnableReject: Boolean;
        UserSetup: Record "User Setup";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    EnableFields;
    StyleIsStrong := Type = Type::Company;

    IF CRMIntegrationEnabled THEN
      CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

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
    */
    //end;
}

