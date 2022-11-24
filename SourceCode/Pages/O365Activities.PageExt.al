PageExtension 50288 pageextension50288 extends "O365 Activities"
{
    layout
    {
        modify("Ongoing Sales Quotes")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Ongoing Sales Orders")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Ongoing Sales Invoices")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Sales This Month")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Ongoing Purchase Invoices")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Overdue Purch. Invoice Amount")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Purch. Invoices Due Next Week")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addfirst("Ongoing Sales")
        {
            field("To Verify Documents"; Rec."To Verify Documents")
            {
                ApplicationArea = Basic;
            }
            field("Rejected Documents"; Rec."Rejected Documents")
            {
                ApplicationArea = Basic;
            }
            field("Customer Created Contacts"; Rec."Customer Created Contacts")
            {
                ApplicationArea = Basic;
            }
            field("Only Verified Documents"; Rec."Only Verified Documents")
            {
                ApplicationArea = Basic;
            }
            cuegroup(Jobs)
            {
                Caption = 'Jobs';
                field("Service Contracts Expire in1M"; Rec."Service Contracts Expire in1M")
                {
                    ApplicationArea = Basic;
                }
                field("Contracts to expire in 100days"; Rec."Contracts to expire in 100days")
                {
                    ApplicationArea = Basic;
                }
                field("Expired Contracts"; Rec."Expired Contracts")
                {
                    ApplicationArea = Basic;
                }
                field("Evicted Cases"; Rec."Evicted Cases")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Court Case Entries";
                }
            }
        }
        addafter("Purchase Orders")
        {
            //Win513++
            field("Requests to Approve"; Rec."Requests to Approve")
            {
                ApplicationArea = all;
            }
            //Win513--
            field("Approved Serv Cntr Quotes"; Rec."Approved Serv Cntr Quotes")
            {
                ApplicationArea = Basic;
                DrillDownPageID = "Service Contract Quotes";
            }
            field("Open Serv Cntr Quotes"; Rec."Rejected Serv Cntr Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Open Lease Quotes';
                DrillDownPageID = "Service Contract Quotes";
            }

        }
        addafter("Incoming Documents")
        {
            cuegroup("Dropped Cheque/Cash")
            {
                Caption = 'Dropped Cheque/Cash';
                //Visible = ShowIncomingDocuments;
                field("Cheque/Cash Dropped"; Rec."Cheque/Cash Dropped")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        //Win513++
        //moveafter("Purchase Orders"; "Requests to Approve")
        //Win513--
    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    IF NOT GET THEN BEGIN
      INIT;
      INSERT;
    END;
    SETFILTER("Due Date Filter",'>=%1',WORKDATE);
    SETFILTER("Overdue Date Filter",'<%1',WORKDATE);
    SETFILTER("Due Next Week Filter",'%1..%2',CALCDATE('<1D>',WORKDATE),CALCDATE('<1W>',WORKDATE));
    SETRANGE("User ID Filter",USERID);

    HasCamera := CameraProvider.IsAvailable;
    #12..33
    ShowAwaitingIncomingDoc := OCRServiceMgt.OcrServiceIsEnable;

    RoleCenterNotificationMgt.ShowNotifications;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    SETFILTER("Expiry date Filter",'%1..%2',WORKDATE,CALCDATE('<1M>',WORKDATE));
    SETFILTER("Expiry date1 Filter",'%1..%2',WORKDATE,CALCDATE('<100D>',WORKDATE));
    #9..36
    */
    //end;
}

