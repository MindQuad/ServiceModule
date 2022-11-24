table 59052 "Document Cue"
{
    Caption = 'Service Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Service Orders - in Process"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Header" WHERE("Document Type" = FILTER(Order),
                                                        Status = FILTER("In Process")));
            //"Responsibility Center" = FIELD("Responsibility Center Filter")));//WIN292

            Caption = 'Service Orders - in Process';
            Editable = false;

        }
        field(3; "Service Orders - Finished"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Header" WHERE("Document Type" = FILTER(Order),
                                                        Status = FILTER(Finished)));
            //"Responsibility Center" = FIELD("Responsibility Center Filter")));//WIN292
            Caption = 'Service Orders - Finished';
            Editable = false;

        }
        field(4; "Service Orders - Inactive"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Header" WHERE("Document Type" = FILTER(Order),
                                                        Status = FILTER(Pending | "On Hold")));
            //Responsibility Center=FIELD(Responsibility Center Filter)));//WIN292
            Caption = 'Service Orders - Inactive';
            Editable = false;

        }
        field(5; "Open Service Quotes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Header" WHERE("Document Type" = FILTER(Quote),
                                                        Status = FILTER(Pending | "On Hold")));
            //Responsibility Center=FIELD(Responsibility Center Filter)));//WIN292
            Caption = 'Open Service Quotes';
            Editable = false;

        }
        field(6; "Open Service Contract Quotes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Quote),
                                                                 Status = FILTER(' ')));
            //Responsibility Center=FIELD(Responsibility Center Filter)));//WIN292
            Caption = 'Open Lease Quotes';
            Editable = false;

        }
        field(7; "Service Contracts to Expire"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Contract),
                                                                 "Expiration Date" = FIELD("Date Filter")));//WIN292
                                                                                                            //Responsibility Center=FIELD(Responsibility Center Filter)));//WIN292
            Caption = 'Service Contracts to Expire';
            Editable = false;

        }
        field(8; "Service Orders - Today"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Header" WHERE("Document Type" = FILTER(Order),
                                                        "Response Date" = FIELD("Date Filter"),
                                                        "Responsibility Center" = FIELD("Responsibility Center Filter")));
            Caption = 'Service Orders - Today';
            Editable = false;

        }
        field(9; "Service Orders - to Follow-up"; Integer)
        {
            CalcFormula = Count("Service Header" WHERE("Document Type" = FILTER(Order),
                                                        Status = FILTER("In Process"),
                                                        "Responsibility Center" = FIELD("Responsibility Center Filter")));
            Caption = 'Service Orders - to Follow-up';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Responsibility Center Filter"; Code[10])
        {
            Caption = 'Responsibility Center Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetRespCenterFilter()
    var
        UserSetupMgt: Codeunit 5700;
        RespCenterCode: Code[10];
    begin
        RespCenterCode := UserSetupMgt.GetServiceFilter;
        IF RespCenterCode <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center Filter", RespCenterCode);
            FILTERGROUP(0);
        END;
    end;
}

