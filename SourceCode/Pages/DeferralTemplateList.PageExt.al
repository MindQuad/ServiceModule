PageExtension 50264 pageextension50264 extends "Deferral Template List"
{
    layout
    {
        addafter("Period Description")
        {
            field("Invoice Period"; Rec."Invoice Period")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

