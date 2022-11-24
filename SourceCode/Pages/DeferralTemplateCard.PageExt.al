PageExtension 50263 pageextension50263 extends "Deferral Template Card"
{
    layout
    {
        addafter("Deferral Schedule")
        {
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Invoice Period"; Rec."Invoice Period")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}

