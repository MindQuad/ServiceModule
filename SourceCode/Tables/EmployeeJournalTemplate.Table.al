Table 50312 "Employee Journal Template"
{
    Caption = 'Employee Journal Template';


    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';

        }
        field(6; "Page ID"; Integer)
        {
            Caption = 'Page ID';


            trigger OnValidate()
            begin
                if "Page ID" = 0 then
                    Validate(Type);
            end;
        }
        field(7; "Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';

        }
        field(8; "Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Salary,Vacation';
            OptionMembers = Salary,Vacation;

            trigger OnValidate()
            begin

                //"Test Report ID" := REPORT::"Employee Journal - Test";
                SourceCodeSetup.Get;
                case Type of
                    Type::Salary:
                        begin
                            "Source Code" := SourceCodeSetup."Employee Journal";

                        end;
                end;
            end;
        }
        field(10; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";

            trigger OnValidate()
            begin
                EmployeeJnlLine.SetRange("Journal Template Name", Name);
                EmployeeJnlLine.ModifyAll("Source Code", "Source Code");
                Modify;
            end;
        }
        field(11; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        //Win513++
        //field(15; "Test Report Name"; Text[80])
        field(15; "Test Report Name"; Text[249])
        //Win513--
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Test Report ID")));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        //Win513++
        //field(16; "Page Name"; Text[80])
        field(16; "Page Name"; Text[249])
        //Win513--
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Page),
                                                                           "Object ID" = field("Page ID")));
            Caption = 'Page Name';
            Editable = false;
            FieldClass = FlowField;
        }
        //Win513++
        //field(17; "Posting Report Name"; Text[80])
        field(17; "Posting Report Name"; Text[249])
        //Win513--
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Posting Report ID")));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    if "No. Series" = "Posting No. Series" then
                        "Posting No. Series" := '';
                end;
            end;
        }
        field(20; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
            end;
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        EmployeeJnlLine.SetRange("Journal Template Name", Name);
        EmployeeJnlLine.DeleteAll(true);
        EmployeeJnlBatch.SetRange("Journal Template Name", Name);
        EmployeeJnlBatch.DeleteAll;
    end;

    var
        EmployeeJnlBatch: Record "Employee Journal Batch";
        EmployeeJnlLine: Record "Employee Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        Text001: label 'must not be %1';
}

