PageExtension 50172 pageextension50172 extends "General Ledger Setup"
{
    layout
    {

        //Unsupported feature: Property Deletion (Visible) on ""Payroll Transaction Import"(Control 7)".

        addafter("Bank Account Nos.")
        {
            field("PDC Document Nos."; Rec."PDC Document Nos.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Print VAT specification in LCY")
        {
            field("Legal Department Mail ID"; Rec."Legal Department Mail ID")
            {
                ApplicationArea = Basic;
            }
            field("Property Management Mail ID"; Rec."Property Management Mail ID")
            {
                ApplicationArea = Basic;
            }
            field("Finance/Legal User Mail ID"; Rec."Finance/Legal User Mail ID")
            {
                ApplicationArea = Basic;
            }
        }
        addfirst("Payroll Transaction Import")
        {
            field("HR Claim No."; Rec."HR Claim No.")
            {
                ApplicationArea = Basic;
            }
            field("Expense Claim No."; Rec."Expense Claim No.")
            {
                ApplicationArea = Basic;
            }
            field("Expense Batch Name"; Rec."Expense Batch Name")
            {
                ApplicationArea = Basic;
            }
            field("Expense Template Name"; Rec."Expense Template Name")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

