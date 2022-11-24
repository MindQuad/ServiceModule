tableextension 50032 tableextension50032 extends "Activities Cue"
{
    // WINPDC : Added new field for Cheque/Cash Cheque Dropped.
    fields
    {
        field(50000; "Pending Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Pending)));
            FieldClass = FlowField;
        }
        field(50001; "Approved Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Approved)));
            FieldClass = FlowField;
        }
        field(50002; "Invoicing Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Invoicing)));
            FieldClass = FlowField;
        }
        field(50003; "Closed Jobs"; Integer)
        {
            CalcFormula = Count(Job WHERE(Stage = FILTER(Closed)));
            FieldClass = FlowField;
        }
        field(50004; "Expiry date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50005; "Service Contracts Expire in1M"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Expiration Date" = FIELD("Expiry date Filter")));
            FieldClass = FlowField;
        }
        field(50006; "Cheque/Cash Dropped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Post Dated Check Line" WHERE("Cheque Dropped" = CONST(true)));
            Description = 'WINPDC';

        }
        field(50007; "To Verify Documents"; Integer)
        {
            CalcFormula = Count(Contact WHERE(Status = FILTER("Request to Create Customer"),
                                               "Document Verifield" = FILTER(False)));
            FieldClass = FlowField;
        }
        field(50008; "Contracts to expire in 100days"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Expiration Date" = FIELD("Expiry date1 Filter")));
            FieldClass = FlowField;
        }
        field(50009; "Expired Contracts"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Expiration Date" = FILTER(< '11-08-19')));
            FieldClass = FlowField;
        }
        field(50010; "Expiry date1 Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50011; "Rejected Documents"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Contact WHERE(Status = FILTER(Rejected)));

        }
        field(50012; "Customer Created Contacts"; Integer)
        {
            CalcFormula = Count(Contact WHERE(Status = FILTER("Customer Created")));
            FieldClass = FlowField;
        }
        field(50013; "Approved Serv Cntr Quotes"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Quote),
                                                                 "Approval Status" = FILTER(Released)));
            FieldClass = FlowField;
        }
        field(50014; "Rejected Serv Cntr Quotes"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Quote),
                                                                 "Approval Status" = FILTER(Open)));
            FieldClass = FlowField;
        }
        field(50015; "Only Verified Documents"; Integer)
        {
            CalcFormula = Count(Contact WHERE(Status = FILTER("Request to Create Customer"),
                                               "Document Verifield" = FILTER(true)));
            FieldClass = FlowField;
        }
        field(50016; "Evicted Cases"; Integer)
        {
            CalcFormula = Count("Court Case Insertion" WHERE("Case Status" = FILTER(Eviction)));
            FieldClass = FlowField;
        }

        //Win513++
        field(50050; "Requests to Approve"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE(Status = FILTER(Open)));
        }
        //Win513--
    }
}

