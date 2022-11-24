page 50035 "Service Contract Subform(Leas)"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = 5964;
    SourceTableView = WHERE("Contract Type" = FILTER(Contract));

    layout
    {
        area(content)
        {
            repeater("-")
            {
                field("Service Item No."; Rec."Service Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Unit No.';
                    ToolTip = 'Specifies the number of the service item that is subject to the service contract.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ServContractMgt: Codeunit 5940;
                    begin
                        ServContractMgt.LookupServItemNo(Rec);
                        IF xRec.GET(Rec."Contract Type", Rec."Contract No.", Rec."Line No.") THEN;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field("Service Period"; Rec."Service Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the period of time that must pass between each servicing of an item.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Contract Expiration Date"; Rec."Contract Expiration Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Expiration Date';
                    ToolTip = 'Specifies the date when an item should be removed from the contract.';
                }
                field("Line Value"; Rec."Line Value")
                {
                    ApplicationArea = All;
                    Caption = 'Line Value';
                    ToolTip = 'Specifies the value of the service item line in the contract or contract quote.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount %';
                    ToolTip = 'Specifies the line discount percentage that will be provided on the service item line.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount Amount';
                    ToolTip = 'Specifies the amount of the discount that will be provided on the service contract line.';
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Line Amount';
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) of the service item line.';
                }
                field(Profit; Rec.Profit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profit, expressed as the difference between the Line Amount and Line Cost fields on the service contract line.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ship-to code for the customer associated with the service contract or service item.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the unit of measure used when the service item was sold.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number of the service item that is subject to the contract.';

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ItemLedgerEntry);
                        ItemLedgerEntry.SETRANGE("Item No.", Rec."Item No.");
                        ItemLedgerEntry.SETRANGE("Variant Code", Rec."Variant Code");
                        ItemLedgerEntry.SETRANGE("Serial No.", Rec."Serial No.");
                        PAGE.RUN(PAGE::"Item Ledger Entries", ItemLedgerEntry);
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the number of the item linked to the service item in the service contract.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code that specifies the variant of the service item on this line.';
                    Visible = false;
                }
                field("Response Time (Hours)"; Rec."Response Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response time for the service item associated with the service contract.';
                }
                field("Line Cost"; Rec."Line Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated cost of the service item line in the service contract or contract quote.';
                }
                field("Next Planned Service Date"; Rec."Next Planned Service Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the next planned service on the item included in the contract.';
                }
                field("Last Planned Service Date"; Rec."Last Planned Service Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the last planned service on this item.';
                    Visible = false;
                }
                field("Last Preventive Maint. Date"; Rec."Last Preventive Maint. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the last time preventative service was performed on this item.';
                    Visible = false;
                }
                field("Last Service Date"; Rec."Last Service Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the service item on the line was last serviced.';
                    Visible = false;
                }
                field("Credit Memo Date"; Rec."Credit Memo Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when you can create a credit memo for the service item that needs to be removed from the service contract.';
                }
                field(Credited; Rec.Credited)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the service contract line has been credited.';
                    Visible = false;
                }
                field("New Line"; Rec."New Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the service contract line is new or existing.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("&Comments")
                {
                    ApplicationArea = All;
                    Caption = '&Comments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        Rec.ShowComments;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        IF Rec."Contract Status" = Rec."Contract Status"::Signed THEN BEGIN
            ServContractLine.COPYFILTERS(Rec);
            CurrPage.SETSELECTIONFILTER(ServContractLine);
            NoOfSelectedLines := ServContractLine.COUNT;
            IF NoOfSelectedLines = 1 THEN
                CreateCreditfromContractLines.SetSelectionFilterNo(NoOfSelectedLines);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine;
    end;

    var
        ItemLedgerEntry: Record 32;
        ServContractLine: Record 5964;
        CreateCreditfromContractLines: Codeunit 5945;
        NoOfSelectedLines: Integer;
}

