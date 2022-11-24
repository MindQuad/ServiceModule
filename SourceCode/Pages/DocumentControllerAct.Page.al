page 59066 "Document Controller Act."
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = 59053;

    layout
    {
        area(content)
        {
            cuegroup("Outbound Service Orders")
            {
                Caption = 'Outbound Service Orders';
                field(Buildings; Rec.Buildings)
                {
                    ApplicationArea = All;
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = All;
                }
                field("Units / Apartments"; Rec."Units / Apartments")
                {
                    ApplicationArea = All;
                }
                field("Units - Renewal Due"; Rec."Units - Renewal Due")
                {
                    ApplicationArea = All;
                }
                field("Documents Expiring [ Month ]"; Rec."Documents Expiring [ Month ]")
                {
                    ApplicationArea = All;
                }
                field("Documents Expired"; Rec."Documents Expired")
                {
                    ApplicationArea = All;
                }
                field("Units - Legal / Dispute"; Rec."Units - Legal / Dispute")
                {
                    ApplicationArea = All;
                }
                field(Vacant; Rec.Vacant)
                {
                    ApplicationArea = All;
                }
                field(Occupied; Rec.Occupied)
                {
                    ApplicationArea = All;
                }
                field("Pending Renewal"; Rec."Pending Renewal")
                {
                    ApplicationArea = All;
                }

                actions
                {
                    action("New Service Order")
                    {
                        ApplicationArea = All;
                        Caption = 'New Service Order';
                        Image = TileBlue;
                        RunObject = Page "Service Order";
                        RunPageMode = Create;
                    }
                    action("Service Item Worksheet")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Item Worksheet';
                        Image = TileLightGreen;
                        RunObject = Report 5936;
                    }
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

        Rec.SetRespCenterFilter;
        Rec.SETRANGE("Date Filter", WORKDATE, WORKDATE);
    end;
}

