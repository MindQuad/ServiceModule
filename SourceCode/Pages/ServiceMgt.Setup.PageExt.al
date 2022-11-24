PageExtension 50280 pageextension50280 extends "Service Mgt. Setup"
{
    layout
    {
        addafter("Copy Time Sheet to Order")
        {
            field("Renew Discount %"; Rec."Renew Discount %")
            {
                ApplicationArea = Basic;
            }
            field("Penalty Month"; Rec."Penalty Month")
            {
                ApplicationArea = Basic;
            }
            field("Penalty Account"; Rec."Penalty Account")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Service Contract Nos.")
        {
            field("Renewal Contract Nos."; Rec."Renewal Contract Nos.")
            {
                ApplicationArea = Basic;
            }
            field("Closing Contract Nos."; Rec."Closing Contract Nos.")
            {
                ApplicationArea = Basic;
            }
            field("Service Charge Nos."; Rec."Service Charge Nos.")
            {
                ApplicationArea = Basic;
            }

            field("Post Utility Entries"; Rec."Post Utility Entries")
            {
                ApplicationArea = All;
                ToolTip = 'Enable this to post utility entries automatically once user process utility entries.';
                Caption = 'Post Utility Entries';
            }
        }
        //Win593
        addafter("Prepaid Posting Document Nos.")
        {

            field("FMS Quote Nos."; Rec."FMS Quote Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FMS Quote Nos. field.';
            }
            field("FMS Order Nos."; Rec."FMS Order Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FMS Order Nos. field.';
            }
        }
        //Win593
    }
}

