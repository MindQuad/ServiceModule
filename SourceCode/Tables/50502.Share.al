table 50502 Share
{
    DataClassification = ToBeClassified;
    Caption = 'Share';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(4; "No. of Shares"; Decimal)
        {
            Caption = 'No. of Shares';
            FieldClass = FlowField;
            CalcFormula = sum("Shares Ledger Entry"."No. of Shares" where("Share No." = field("No.")));
        }
        field(5; "Value of Shares"; Decimal)
        {
            Caption = 'Value of Shares';
            FieldClass = FlowField;
            CalcFormula = sum("Shares Ledger Entry"."Shares Value" where("Share No." = field("No.")));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        SharesSetup: Record "Shares Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SharesSetup.Get();
            SharesSetup.TestField("No. Series");
            NoSeriesMgt.InitSeries(SharesSetup."No. Series", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        if "No." <> xRec."No." then begin
            SharesSetup.Get();
            NoSeriesMgt.TestManual(SharesSetup."No. Series");
            "No. Series" := '';
        end;
    end;

    procedure AssistEdit(OldShares: Record Share): Boolean
    var
        Share: Record Share;
    begin
        Share := Rec;
        SharesSetup.Get();
        SharesSetup.TestField("No. Series");
        if NoSeriesMgt.SelectSeries(SharesSetup."No. Series", OldShares."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := Share;
            exit(true);
        end;
    end;
}