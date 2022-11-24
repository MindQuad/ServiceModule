tableextension 50028 tableextension50028 extends "CV Ledger Entry Buffer"
{
    local procedure "PY.WINS."()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyFromEmplLedgerEntry(var CVLedgerEntryBuffer: Record 382; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
    end;
}

