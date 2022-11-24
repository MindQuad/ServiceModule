codeunit 60000 "TnC Contract Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::SignServContractDoc, 'OnAfterToServContractHeaderInsert', '', false, false)]
    local procedure OnAfterToServContractHeaderInsert(var ToServiceContractHeader: Record "Service Contract Header"; FromServiceContractHeader: Record "Service Contract Header")
    var
        ContractTnCQuote: Record "Contract TNC";
        ContractTnCContract: Record "Contract TNC";
    begin
        ContractTnCQuote.SetRange("Contact Type", FromServiceContractHeader."Contract Type");
        ContractTnCQuote.SetRange("Contract No.", FromServiceContractHeader."Contract No.");
        if ContractTnCQuote.FindSet() then
            repeat
                // Create Contract TnC table with Contract Type as Contract and Contract No from Contract
                ContractTnCContract.Init();
                ContractTnCContract.TransferFields(ContractTnCQuote, true);
                ContractTnCContract."Contact Type" := ContractTnCContract."Contact Type"::Contract;
                ContractTnCContract."Contract No." := ToServiceContractHeader."Contract No.";
                ContractTnCContract.Insert();

                // Delete old Contract Tnc Quote record 
                ContractTnCQuote.Delete();
            until ContractTnCQuote.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnAfterValidateEvent', 'Approval Status', false, false)]
    local procedure OnAfterValidateApprovalStatus(var Rec: Record "Service Contract Header")
    var
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceContractLine: Record "Service Contract Line";
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Released then
            exit;

        ServiceHeader.SetRange("Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader.SetRange("Contract No.", Rec."Contract No.");
        if ServiceHeader.FindFirst() then
            exit;

        //Service Header
        ServiceHeader.Init();
        ServiceHeader."Document Type" := ServiceHeader."Document Type"::Order;
        ServiceHeader.Insert(true);
        ServiceHeader.Validate("Customer No.", Rec."Customer No.");
        ServiceHeader."Type of Ticket" := ServiceHeader."Type of Ticket"::"Check In";
        ServiceHeader."Your Reference" := Rec."Your Reference";
        ServiceHeader.Modify(true);

        //Service Line
        ServiceContractLine.SetRange("Contract Type", ServiceContractLine."Contract Type"::Contract);
        ServiceContractLine.SetRange("Contract No.", Rec."Contract No.");
        if ServiceContractLine.FindSet() then
            repeat
                Clear(ServiceLine);
                ServiceLine.Init();
                ServiceLine."Document Type" := ServiceHeader."Document Type";
                ServiceLine."Document No." := ServiceHeader."No.";
                ServiceLine."Line No." := ServiceContractLine."Line No.";
                ServiceLine.Validate("Service Item No.", ServiceContractLine."Service Item No.");
                ServiceLine.Description := ServiceContractLine.Description;
                ServiceLine."Cost Amount" := ServiceContractLine."Line Cost";
                ServiceLine."Line Amount" := ServiceContractLine."Line Amount";
                if not ServiceLine.Insert(true) then
                    ServiceLine.Modify(true);
            until ServiceContractLine.Next() = 0;
    end;
}