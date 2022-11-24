pageextension 50004 FixedAssetExtension extends "Fixed Asset Card"
{
    actions
    {
        addafter("Co&mments")
        {
            action("Mapped Assets")
            {
                ApplicationArea = All;
                Caption = 'Mapped Assets';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Fixed Asset Mapping";
                RunPageLink = "Mapped against Service Item" = field("No.");
            }
        }
        addafter("C&opy Fixed Asset")
        {
            action("Calculate Depreciation")
            {
                ApplicationArea = All;
                Caption = 'Calculate Depreciation';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Calculate Depreciation";
            }
        }
    }

    var
        myInt: Integer;
}