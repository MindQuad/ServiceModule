page 50044 "Maintenance Activities2"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = 50010;

    layout
    {
        area(content)
        {
            cuegroup("Outbound Service Orders")
            {
                Caption = 'Outbound Service Orders';
                field(Contracts; Rec.Contracts)
                {
                    ApplicationArea = All;
                }
                field(Interactions; Rec.Interactions)
                {
                    ApplicationArea = All;
                }

                actions
                {
                    action("New Service Order")
                    {
                        ApplicationArea = All;
                        Caption = 'New Service Order';
                        Image = TileYellow;
                        RunObject = Page "Service Order";
                        RunPageMode = Create;
                    }
                    action("Service Item Worksheet")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Item Worksheet';
                        Image = TileBrickCalendar;
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
    end;
}

