table 50202 "Employee Journal Batch"
{
    // version WRHRPR10.00 AE

    Caption = 'Employee Journal Batch';


    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Employee Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate();
            begin
                IF "No. Series" <> '' THEN BEGIN
                    IF "No. Series" = "Posting No. Series" THEN
                        VALIDATE("Posting No. Series", '');
                END;
            end;
        }
        field(6; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate();
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                    FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
                EmployeeJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                EmployeeJnlLine.SETRANGE("Journal Batch Name", Name);
                EmployeeJnlLine.MODIFYALL("Posting No. Series", "Posting No. Series");
                MODIFY;
            end;
        }
        field(21; "Template Type"; Option)
        {
            CalcFormula = Lookup("Employee Journal Template".Type WHERE(Name = FIELD("Journal Template Name")));
            Caption = 'Template Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Salary,Vacation';
            OptionMembers = Salary,Vacation;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeJnlTemplate: Record "Employee Journal Template";
        EmployeeJnlLine: Record "Employee Journal Line";
        Text001: Label 'must not be %1';

    procedure SetupNewBatch();
    begin
        EmployeeJnlTemplate.GET("Journal Template Name");
        "No. Series" := EmployeeJnlTemplate."No. Series";
        "Posting No. Series" := EmployeeJnlTemplate."Posting No. Series";
        "Reason Code" := EmployeeJnlTemplate."Reason Code";
    end;
}
