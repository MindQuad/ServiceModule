page 50509 "Fixed Asset Mapping"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Fixed Asset";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater("Already Mapped")
            {
                Caption = 'Already mapped Assets';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Mapped against Service Item"; Rec."Mapped against Service Item")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Available_SelectforMapping; Rec."Select for Mapping")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Select for Mapping" = false then begin
                            if Rec."Mapped against Service Item" <> '' then begin
                                Rec."Mapped against Service Item" := '';
                                Rec.Modify();
                            end;
                        end
                        else begin
                            Rec."Mapped against Service Item" := ServiceItem."No.";
                            Rec.Modify();
                        end;
                    end;
                }
            }
        }
    }

    var
        ServiceItem: Record "Service Item";

    procedure SetServiceItem(SerItem: Record "Service Item")
    begin
        ServiceItem := SerItem;
    end;
}
