tableextension 50008 tableextension50008 extends "Sales Header"
{
    fields
    {
        field(50001; "Probability %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Probability %';
            DecimalPlaces = 0 : 0;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50002; "Expected Order Inflow"; DateFormula)
        {
            Caption = 'Expected Order Inflow';
        }
        field(50003; "Followup Date"; Date)
        {
            Caption = 'Followup Date';
        }
        field(50004; "Decision Date"; Date)
        {
            Caption = 'Decision Date';
        }
        field(50005; Competition; Text[30])
        {
            Caption = 'Competition';
        }
        field(50006; "Competitor Price"; Decimal)
        {
            Caption = 'Competitor Price';
        }
        field(50007; "Filed Date"; Date)
        {
            Caption = 'Filed Date';
        }
        field(50008; "Filed User ID"; Code[50])
        {
            Caption = 'Filed User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50009; "Quote valid until"; Text[30])
        {
            Caption = 'Quote valid until';
        }
        field(50010; "Service Item No."; Code[20])
        {
        }
        field(50011; "Loan Type"; Enum "Loan Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Loan Type';
        }
        field(50012; "Own Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Down Payment';
        }
        field(50013; "RDK Loan"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'RDK Loan';
        }
        field(50014; "Bank Loan"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Loan';
        }
        field(50015; "RDK Loan Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'RDK Loan Tenure in Months';
        }
        field(50016; "No of Installments for Loan"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'No of Installments for Loan';
        }
        field(50017; "Amortization Entries Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amortization Entries Generated';
        }
        field(50018; "Min. Own Contribution %"; Decimal)
        {
            Caption = 'Down Payment %';
        }
        field(50019; "RDK Loan Interest %"; Decimal)
        {
            Caption = 'RDK Loan Interest %';
        }
        field(50020; "SPA Date"; Date)
        {
            Caption = 'SPA Date';
        }
        field(50021; "RDK Loan Intrest Amount"; Decimal)
        {
            Caption = 'RDK Loan Intrest Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Amortization Entry"."Interest Amount"
             where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }


    }
    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            Rec."Min. Own Contribution %" := SalesSetup."Min. Own Contribution %";
            Rec."RDK Loan Interest %" := SalesSetup."RDK Loan Interest %";
        end;
    end;



}

