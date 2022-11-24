PageExtension 50291 pageextension50291 extends "Marketing Setup"
{
    layout
    {
        addafter("Inherit Communication Details")
        {
            field("Broker Nos."; Rec."Broker Nos.")
            {
                ApplicationArea = Basic;
            }
            field("Copy Contacts to Company"; Rec."Copy Contacts to Company")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Opportunity Nos.")
        {
            field("Court Case No."; Rec."Court Case No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Email Batch Size")
        {
            field("Email Sender To"; Rec."Email Sender To")
            {
                ApplicationArea = Basic;
            }
            field("Email Sender CC"; Rec."Email Sender CC")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

