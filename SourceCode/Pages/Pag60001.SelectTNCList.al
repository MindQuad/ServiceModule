page 60101 "Select TNC List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TNC Master";
    Caption = 'Select TNC List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field("TNC Type"; Rec."TNC Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TNC Type field.';
                    Editable = false;
                }
                field("TNC Code"; Rec."TNC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TNC Code field.';
                    Editable = false;
                }
                field("English Description "; Rec."English Description ")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Arabic Description"; Rec."Arabic Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Select field.';

                    trigger OnValidate()
                    begin
                        UpdateContractTNC();
                    end;
                }
            }
        }

    }

    procedure SetContractHeader(ServContractHdrP: Record "Service Contract Header")
    begin
        ServContractHdrG := ServContractHdrP;
    end;

    procedure UpdateContractTNC()
    var
        ContractTNC: Record "Contract TNC";
    begin
        if Rec.Select then begin
            ContractTNC.Init();
            ContractTNC.Validate("Contact Type", ServContractHdrG."Contract Type");
            ContractTNC.Validate("Contract No.", ServContractHdrG."Contract No.");
            ContractTNC.Validate("TNC Type", Rec."TNC Type");
            ContractTNC.Validate("TNC Code", Rec."TNC Code");
            ContractTNC.Insert(true);
        end
        else
            if ContractTNC.Get(ServContractHdrG."Contract Type", ServContractHdrG."Contract No.", Rec."TNC Type", Rec."TNC Code") then
                ContractTNC.Delete(true);
    end;

    trigger OnOpenPage()
    var
        TNCmaster: Record "TNC Master";
        ContractTnc: Record "Contract TNC";
    begin
        // Clear all the TnC Master records
        if TNCmaster.FindSet() then
            repeat
                TNCmaster.Select := false;
                TNCmaster.Modify(true);
            until TNCmaster.Next() = 0;

        // Make Select = True for those only have existing ContractTnC Records
        ContractTnc.SetRange("Contact Type", ServContractHdrG."Contract Type");
        ContractTnc.SetRange("Contract No.", ServContractHdrG."Contract No.");
        if ContractTnc.FindSet() then
            repeat
                if TNCmaster.Get(ContractTnc."TNC Type", ContractTnc."TNC Code") then begin
                    TNCmaster.Select := true;
                    TNCmaster.Modify(true);
                end;
            until ContractTnc.Next() = 0;
    end;

    var
        ServContractHdrG: Record "Service Contract Header";

}