page 50024 "Companies Lookup"
{
    // //WIN325050617 - Added Functions()
    //                - GetSelectionFilter()
    //                - SetSelection()

    Caption = 'Companies';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = 2000000006;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of a company that has been created in the current database.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Recordlinks; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CopyCompany)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy';
                Image = Copy;
                Promoted = true;
                PromotedIsBig = false;
                ToolTip = 'Copy an existing company to a new company.';

                trigger OnAction()
                var
                    Company: Record 2000000006;
                    CopyCompany: Report 357;
                begin
                    Company.SETRANGE(Name, Rec.Name);
                    CopyCompany.SETTABLEVIEW(Company);
                    CopyCompany.RUNMODAL;

                    IF Rec.GET(CopyCompany.GetCompanyName) THEN;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        AssistedCompanySetupStatus: Record 1802;
    begin
        IF AssistedCompanySetupStatus.GET(Rec.Name) THEN
            EnableAssistedCompanySetup := AssistedCompanySetupStatus.Enabled
        ELSE
            EnableAssistedCompanySetup := FALSE;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        AssistedCompanySetupStatus: Record 1802;
    begin
        IF NOT CONFIRM(DeleteCompanyQst, FALSE) THEN
            EXIT(FALSE);

        IF AssistedCompanySetupStatus.GET(Rec.Name) THEN
            AssistedCompanySetupStatus.DELETE;

        EXIT(TRUE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnableAssistedCompanySetup := FALSE;
    end;

    var
        DeleteCompanyQst: Label 'Do you want to delete the company?\All company data will be deleted.\\Do you want to continue?';
        EnableAssistedCompanySetup: Boolean;


    procedure GetSelectionFilter(): Text
    var
        Comp: Record 2000000006;
        SelectionFilterManagement: Codeunit 46;
    begin
        //WIN325
        CurrPage.SETSELECTIONFILTER(Comp);
        //EXIT(SelectionFilterManagement.GetSelectionFilterForCompany(Comp));//WIN292
    end;


    procedure SetSelection(var Comp: Record 2000000006)
    begin
        CurrPage.SETSELECTIONFILTER(Comp);//WIN325
    end;
}

