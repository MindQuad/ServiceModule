tableextension 50044 tableextension50044 extends "Service Mgt. Setup"
{
    fields
    {
        field(50000; "Renew Discount %"; Decimal)
        {
        }
        field(50001; "Penalty Month"; Decimal)
        {
        }
        field(50002; "Penalty Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50003; "Renewal Contract Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50004; "Service Charge Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50005; "Closing Contract Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50100; "Post Utility Entries"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        //Win593
        field(50101; "FMS Quote Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50102; "FMS Order Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        //Win593
    }
}

