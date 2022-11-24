PageExtension 50153 pageextension50153 extends "Vendor List"
{
    layout
    {
        addafter("Balance Due (LCY)")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

