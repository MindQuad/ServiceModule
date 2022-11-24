tableextension 50037 tableextension50037 extends "Customer Templ."
{
    fields
    {
        field(50000; "Building No."; Code[30])
        {
            TableRelation = Building;
        }
        field(50001; "Tenancy Type"; Option)
        {
            OptionCaption = ' ,Residential,Commercial';
            OptionMembers = "  ",Residential,Commercial;

            trigger OnValidate()
            begin
                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN BEGIN
                    "Gen. Bus. Posting Group" := 'COM-TENANT';
                    "VAT Bus. Posting Group" := 'VAT-5';
                END ELSE
                    IF "Tenancy Type" = "Tenancy Type"::Residential THEN BEGIN
                        "Gen. Bus. Posting Group" := 'RES-TENANT';
                        "VAT Bus. Posting Group" := 'NO VAT';
                    END;
            end;
        }

    }
}

