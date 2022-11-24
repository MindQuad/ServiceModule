tableextension 50036 tableextension50036 extends Opportunity
{
    fields
    {
        field(50000; "Building No."; Code[20])
        {
            TableRelation = Building;

            trigger OnValidate()
            var
                lBuildRec: Record 50005;
            begin
                //WIN325
                IF Rec."Building No." <> xRec."Building No." THEN BEGIN
                    IF "Building No." <> '' THEN BEGIN
                        IF lBuildRec.GET("Building No.") THEN BEGIN
                        END;
                    END;
                END;
                //GetAmenitiesfromBuilding;
            end;
        }
        field(50001; "Unit No."; Code[20])
        {
            TableRelation = "Service Item"."No." WHERE("Building No." = FIELD("Building No."));
        }
        field(50003; "From Borker"; Boolean)
        {
            Caption = 'From Broker';
            FieldClass = FlowField;
            CalcFormula = exist(Contact where("No." = field("Contact No."), Broker = const(true)));
        }
    }
}

