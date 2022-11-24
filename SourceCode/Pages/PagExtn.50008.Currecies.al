pageextension 50008 Currencies_Extn extends Currencies
{
    layout
    {
        addafter(Description)
        {
            field("Curr. Description"; Rec."Currency Numeric Description")
            {
                ApplicationArea = All;
            }
            field("Decimal Curr. Description"; Rec."Decimal Curr. Description")
            {
                ApplicationArea = All;
            }
            field("BCP Arabic Curr. Description"; Rec."Arabic Curr. Description")
            {
                ApplicationArea = All;
            }
            field("BCP Arabic Decimal Curr. Descr"; Rec."Arabic Decimal Curr. Descr")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}