page 50032 "Service Lease Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = 9052;

    layout
    {
        area(content)
        {
            cuegroup("Service Orders")
            {
                Caption = 'Service Orders';
                field(Buildings; Rec.Buildings)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Service Contract Quotes"; Rec."Service Contract Quotes")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Service Contract Quotes";
                }
                field("Service Contracts"; Rec."Service Contracts")
                {
                    ApplicationArea = All;
                }

                actions
                {
                    action("New Service Contract")
                    {
                        ApplicationArea = All;
                        Caption = 'New Service Contract';
                        Image = TileYellow;
                        RunObject = Page 6050;
                        RunPageMode = Create;
                    }
                    action("New Service Item")
                    {
                        ApplicationArea = All;
                        Caption = 'New Service Item';
                        RunObject = Page 5980;
                        RunPageMode = Create;
                    }
                    action("Edit Dispatch Board")
                    {
                        ApplicationArea = All;
                        Caption = 'Edit Dispatch Board';
                        RunObject = Page 6000;
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
        Rec.SETRANGE("Date Filter", 0D, WORKDATE);
    end;
}

