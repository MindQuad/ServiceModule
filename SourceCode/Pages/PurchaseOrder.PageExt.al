PageExtension 50162 pageextension50162 extends "Purchase Order"
{
    layout
    {

        //Unsupported feature: Property Deletion (Visible) on ""No."(Control 2)".

        addafter("No.")
        {
            field(Category; Rec.Category)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Due Date")
        {
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = Basic;
            }
            field("End Date"; Rec."End Date")
            {
                ApplicationArea = Basic;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Job Queue Status")
        {
            group("Work Description")
            {
                field("<WorkDescription>"; Rec."Work Description")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Standard;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered';
                }
                field(Details; Rec.Details)
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ShowCaption = false;
                }
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Receiving No."; Rec."Receiving No.")
            {
                ApplicationArea = Basic;
            }
            field("Receiving No. Series"; Rec."Receiving No. Series")
            {
                ApplicationArea = Basic;
            }
        }
        addfirst(Prepayment)
        {
            field("Prepayment No. Series"; Rec."Prepayment No. Series")
            {
                ApplicationArea = Basic;
            }
            field("Prepmt. Cr. Memo No. Series"; Rec."Prepmt. Cr. Memo No. Series")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

