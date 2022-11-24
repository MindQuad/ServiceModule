page 50031 "Leasing Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = 1313;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(Contacts)
            {
                Caption = 'Contacts';
                field("To Verify Documents"; Rec."To Verify Documents")
                {
                    ApplicationArea = All;
                }
                field("Rejected Documents"; Rec."Rejected Documents")
                {
                    ApplicationArea = All;
                }
                field("Customer Created Contacts"; Rec."Customer Created Contacts")
                {
                    ApplicationArea = All;
                }
            }
            cuegroup("Service Contracts")
            {
                Caption = 'Service Contracts';
                field("Service Contracts Expire in1M"; Rec."Service Contracts Expire in1M")
                {
                    ApplicationArea = All;
                }
                field("Contracts to expire in 100days"; Rec."Contracts to expire in 100days")
                {
                    ApplicationArea = All;
                }
                field("Approved Serv Cntr Quotes"; Rec."Approved Serv Cntr Quotes")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Service Contract Quotes";
                }
                field("Open Serv Cntr Quotes"; Rec."Rejected Serv Cntr Quotes")
                {
                    ApplicationArea = All;
                    Caption = 'Open Lease Quotes';
                    DrillDownPageID = "Service Contract Quotes";
                }
                field("Requests to Approve"; Rec."Requests to Approve")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Requests to Approve";
                    ToolTip = 'Specifies the number of approval requests that require your approval.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

        //SetRespCenterFilter;
        //SETRANGE("Date Filter",WORKDATE,WORKDATE);
    end;
}

