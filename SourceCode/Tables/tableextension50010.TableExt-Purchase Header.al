tableextension 50010 tableextension50010 extends "Purchase Header"
{
    fields
    {

        //Unsupported feature: Property Deletion (Editable) on ""Quote No."(Field 151)".

        field(200; "Work Description"; Text[250])
        {
            Caption = 'Work Description';
            Description = '//WINS.20180730.PUR';
            Enabled = true;
        }
        field(50000; "Requisition No."; Code[20])
        {
            Caption = 'Requisition No.';

            trigger OnValidate()
            var
                PurchSetup: record "Purchases & Payables Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;

            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
        field(50016; Category; Option)
        {
            InitValue = General;
            OptionCaption = ',General,Service';
            OptionMembers = ,General,Service;
        }
        field(50017; Details; Text[250])
        {
        }
        field(50018; "Start Date"; Date)
        {
        }
        field(50019; "End Date"; Date)
        {
        }
        field(50020; "Order Type"; Option)
        {
            OptionMembers = ,Regular,AMC;
        }
    }

    trigger OnDelete()
    //>>>> MODIFIED CODE:
    begin
        //ApprovalsMgmt.DeleteApprovalEntry(Rec);
    end;
}

