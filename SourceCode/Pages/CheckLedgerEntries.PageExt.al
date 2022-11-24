PageExtension 50185 pageextension50185 extends "Check Ledger Entries" 
{
    layout
    {
        moveafter(Control1;"Entry No.")
        moveafter("Check No.";Amount)
        moveafter(Amount;"Posting Date")
        moveafter(Description;"Entry Status")
    }
}

