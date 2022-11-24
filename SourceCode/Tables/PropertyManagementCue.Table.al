table 59053 "Property Management Cue"
{
    Caption = 'Sales Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Buildings; Integer)
        {
            CalcFormula = Count(Building);
            Caption = 'Buildings';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; Units; Integer)
        {
            CalcFormula = Count("Service Item");
            Caption = 'Units';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Units / Apartments"; Integer)
        {
            CalcFormula = Count("Service Item");
            Caption = 'Units / Apartments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Units - Renewal Due"; Integer)
        {
            CalcFormula = Count("Service Item");
            Caption = 'Units - Renewal Due';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Documents Expiring [ Month ]"; Integer)
        {
            AccessByPermission = TableData 6660 = R;
            CalcFormula = Count("Documents and Articles");
            Caption = 'Documents Expiring [ Month ]';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Documents Expired"; Integer)
        {
            Caption = 'Documents Expired';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(8; "Units - Legal / Dispute"; Integer)
        {
            Caption = 'Units - Legal / Dispute';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(10; Enquiries; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Invoice Header" WHERE("Document Exchange Status" = FILTER("Sent to Document Exchange Service" | "Delivery Failed")));
            Caption = 'Sales Invoices - Pending Document Exchange';
            Editable = false;

        }
        field(12; "Sales CrM. - Pending Doc.Exch."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("Document Exchange Status" = FILTER("Sent to Document Exchange Service" | "Delivery Failed")));
            Caption = 'Sales Credit Memos - Pending Document Exchange';
            Editable = false;

        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Date Filter2"; Date)
        {
            Caption = 'Date Filter 2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(22; "Responsibility Center Filter"; Code[10])
        {
            Caption = 'Responsibility Center Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(26; "Service Contracts"; Integer)
        {
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = CONST(Contract)));
            Caption = 'Contracts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Service Contracts Pending Appr"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Contract),
                                                                 "Responsibility Center" = FIELD("Responsibility Center Filter"),
                                                                 "Approval Status" = FILTER("Pending Approval")));
            Caption = 'Service Contracts Pending Appr';
            Editable = false;

        }
        field(29; "Rental : Vacant"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Vacant),
                                                      "Unit Purpose" = CONST("Rental Unit")));

        }
        field(30; "Service Contr. Pending Renewal"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Contract Header" WHERE("Contract Type" = FILTER(Contract),
                                                                 "Responsibility Center" = FIELD("Responsibility Center Filter"),
                                                                 "Contract Document Status" = FILTER("Pending Renewal")));
            Caption = 'Service Contracts Pending Renewal';
            Editable = false;

        }
        field(50; Vacant; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Vacant),
                                                      "Unit Purpose" = CONST("Rental Unit")));

        }
        field(51; Occupied; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Occupied),
                                                      "Unit Purpose" = CONST("Rental Unit")));

        }
        field(52; "Pending Renewal"; Integer)
        {
            CalcFormula = Count("Service Item" WHERE("Occupancy Status" = CONST(Pending),
                                                      "Unit Purpose" = CONST("Rental Unit")));
            FieldClass = FlowField;
        }
        field(50004; "Expiry Date Filter"; Date)
        {
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
        RespCenterCode := UserSetupMgt.GetSalesFilter;
        IF RespCenterCode <> '' THEN BEGIN
            FILTERGROUP(2);
            //  SETRANGE("Responsibility Center Filter",RespCenterCode);
            FILTERGROUP(0);
        END;
    end;


    procedure CalculateAverageDaysDelayed() AverageDays: Decimal
    var
        SalesHeader: Record 36;
        SumDelayDays: Integer;
        CountDelayedInvoices: Integer;
    begin
        FilterOrders(SalesHeader, FIELDNO("Units - Renewal Due"));
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SumDelayDays += MaximumDelayAmongLines(SalesHeader);
                CountDelayedInvoices += 1;
            UNTIL SalesHeader.NEXT = 0;
            AverageDays := SumDelayDays / CountDelayedInvoices;
        END;
    end;

    local procedure MaximumDelayAmongLines(SalesHeader: Record 36) MaxDelay: Integer
    var
        SalesLine: Record 37;
    begin
        MaxDelay := 0;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER("Shipment Date", '<%1&<>%2', WORKDATE, 0D);
        IF SalesLine.FINDSET THEN
            REPEAT
                IF WORKDATE - SalesLine."Shipment Date" > MaxDelay THEN
                    MaxDelay := WORKDATE - SalesLine."Shipment Date";
            UNTIL SalesLine.NEXT = 0;
    end;


    procedure CountOrders(FieldNumber: Integer): Integer
    var
        CountSalesOrders: Query 9060;
    begin
        CountSalesOrders.SETRANGE(Status, CountSalesOrders.Status::Released);
        CountSalesOrders.SETRANGE(Completely_Shipped, FALSE);
        FILTERGROUP(2);
        //CountSalesOrders.SETFILTER(Responsibility_Center,GETFILTER("Responsibility Center Filter"));
        FILTERGROUP(0);

        CASE FieldNumber OF
            FIELDNO("Units / Apartments"):
                BEGIN
                    CountSalesOrders.SETRANGE(Ship);
                    CountSalesOrders.SETFILTER(Shipment_Date, GETFILTER("Date Filter2"));
                END;
            FIELDNO("Units - Legal / Dispute"):
                BEGIN
                    CountSalesOrders.SETRANGE(Shipped, TRUE);
                    CountSalesOrders.SETFILTER(Shipment_Date, GETFILTER("Date Filter2"));
                END;
            FIELDNO("Units - Renewal Due"):
                BEGIN
                    CountSalesOrders.SETRANGE(Ship);
                    CountSalesOrders.SETFILTER(Date_Filter, GETFILTER("Date Filter"));
                    CountSalesOrders.SETRANGE(Late_Order_Shipping, TRUE);
                END;
        END;
        CountSalesOrders.OPEN;
        CountSalesOrders.READ;
        EXIT(CountSalesOrders.Count_Orders);
    end;

    local procedure FilterOrders(var SalesHeader: Record 36; FieldNumber: Integer)
    begin
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE(Status, SalesHeader.Status::Released);
        SalesHeader.SETRANGE("Completely Shipped", FALSE);
        CASE FieldNumber OF
            FIELDNO("Units / Apartments"):
                BEGIN
                    SalesHeader.SETRANGE(Ship);
                    SalesHeader.SETFILTER("Shipment Date", GETFILTER("Date Filter2"));
                END;
            FIELDNO("Units - Legal / Dispute"):
                BEGIN
                    SalesHeader.SETRANGE(Shipped, TRUE);
                    SalesHeader.SETFILTER("Shipment Date", GETFILTER("Date Filter2"));
                END;
            FIELDNO("Units - Renewal Due"):
                BEGIN
                    SalesHeader.SETRANGE(Ship);
                    SalesHeader.SETFILTER("Date Filter", GETFILTER("Date Filter"));
                    SalesHeader.SETRANGE("Late Order Shipping", TRUE);
                END;
        END;
        FILTERGROUP(2);
        //SalesHeader.SETFILTER("Responsibility Center",GETFILTER("Responsibility Center Filter"));
        FILTERGROUP(0);
    end;


    procedure ShowOrders(FieldNumber: Integer)
    var
        SalesHeader: Record 36;
    begin
        FilterOrders(SalesHeader, FieldNumber);
        PAGE.RUN(PAGE::"Sales Order List", SalesHeader);
    end;
}

