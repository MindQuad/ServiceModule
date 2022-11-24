page 50021 "Service Inspection"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Inspection Checklist";
    SourceTableView = WHERE(Template = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                    Editable = false;
                    HideValue = Hidearea;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        hidearea := FALSE;
        DocumentNoOnFormat;
    end;

    var
        Lastarea: Text[100];
        hidearea: Boolean;

    local procedure IsFirstDocLine(): Boolean
    var
        InspectionChecklist: Record 50008;
    begin
        InspectionChecklist.SETRANGE(InspectionChecklist."Document No.", Rec."Document No.");
        InspectionChecklist.SETRANGE(InspectionChecklist.Area, Rec.Area);
        IF InspectionChecklist.FINDFIRST THEN
            IF InspectionChecklist."Line No." = Rec."Line No." THEN
                EXIT(TRUE);
    end;

    local procedure DocumentNoOnFormat()
    begin
        IF NOT IsFirstDocLine THEN
            hidearea := TRUE;
    end;
}

