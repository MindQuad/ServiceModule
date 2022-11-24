/* table 9065 "Maintenance Cue"
{
    Caption = 'Relationship Mgmt. Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Contacts; Integer)
        {
            CalcFormula = Count(Contact);
            Caption = 'Contacts';
            FieldClass = FlowField;
        }
        field(3; Contracts; Integer)
        {
            CalcFormula = Count("Service Contract Header");
            Caption = 'Contracts';
            FieldClass = FlowField;
        }
        field(4; Interactions; Integer)
        {
            CalcFormula = Count("Interaction Log Entry");
            Caption = 'Interactions';
            FieldClass = FlowField;
        }
        field(5; "Open Opportunities"; Integer)
        {
            CalcFormula = Count(Opportunity WHERE(Closed = FILTER(false)));
            Caption = 'Open Opportunities';
            FieldClass = FlowField;
        }
        field(6; "Closed Opportunities"; Integer)
        {
            CalcFormula = Count(Opportunity WHERE(Closed = FILTER(true)));
            Caption = 'Closed Opportunities';
            FieldClass = FlowField;
        }
        field(7; "Opportunities Due in 7 Days"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Opportunity Entry" WHERE(Active = FILTER(true),
                                                           "Date Closed" = FILTER(''),
                                                           "Estimated Close Date" = FIELD("Due Date Filter")));
            Caption = 'Opportunities Due in 7 Days';

        }
        field(8; "Overdue Opportunities"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Opportunity Entry" WHERE(Active = FILTER(true),
                                                           "Date Closed" = FILTER(''),
                                                           "Estimated Close Date" = FIELD("Overdue Date Filter")));
            Caption = 'Overdue Opportunities';

        }
        field(10; "Sales Persons"; Integer)
        {
            CalcFormula = Count("Salesperson/Purchaser");
            Caption = 'Sales Persons';
            FieldClass = FlowField;
        }
        field(11; "Contacts - Open Opportunities"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Contact WHERE("No. of Opportunities" = FILTER(<> 0)));
            Caption = 'Contacts - Open Opportunities';

        }
        field(18; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            FieldClass = FlowFilter;
        }
        field(19; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(20; "Open Sales Quotes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Quote),
                                                      Status = FILTER(Open)));
            Caption = 'Open Sales Quotes';

        }
        field(21; "Open Sales Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order),
                                                      Status = FILTER(Open)));
            Caption = 'Open Sales Orders';

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
}

 */