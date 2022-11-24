tableextension 50034 tableextension50034 extends "Deferral Template"
{
    fields
    {
        //Win513++
        //field(9; "Invoice Period"; Option)
        field(9; "Invoice Period"; Enum "Service Contract Header Invoice Period")
        //Win513--
        {
            Caption = 'Invoice Period';
            Description = 'PMD.AE';
            InitValue = "None";
            //Win513++
            // OptionCaption = 'Month,Two Months,Quarter,Half Year,Year,None,Other';
            // OptionMembers = Month,"Two Months",Quarter,"Half Year",Year,"None",Other;
            //Win513--

            trigger OnValidate()
            begin
                IF "Invoice Period" <> "Invoice Period"::None THEN
                    CASE
                     "Invoice Period" OF
                        "Invoice Period"::Month:
                            TESTFIELD("No. of Periods", 1);
                        "Invoice Period"::"Two Months":
                            TESTFIELD("No. of Periods", 2);
                        "Invoice Period"::Quarter:
                            TESTFIELD("No. of Periods", 3);
                        "Invoice Period"::"Half Year":
                            TESTFIELD("No. of Periods", 6);
                        "Invoice Period"::Year:
                            TESTFIELD("No. of Periods", 12);
                    END;
            end;
        }
    }
}

