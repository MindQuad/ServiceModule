codeunit 50111 "Utility Entries Events"
{

    [EventSubscriber(ObjectType::Table, Database::"Service Invoice Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertOfServiceHeader(var Rec: Record "Service Invoice Header")
    var
        UtilityEntries: Record "Utility Entries";
    begin
        UtilityEntries.SetRange("Service Invoice No.", Rec."Pre-Assigned No.");
        if UtilityEntries.FindSet() then
            repeat
                UtilityEntries."Posted Service Invoice No." := Rec."No.";
                UtilityEntries."Error Message" := '';
                UtilityEntries.Modify(true);
            until UtilityEntries.Next() = 0;

    end;
}