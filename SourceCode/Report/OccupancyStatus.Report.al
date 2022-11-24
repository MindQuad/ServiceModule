report 50069 "Occupancy Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './OccupancyStatus.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Service Item"; "Service Item")
        {
            DataItemTableView = WHERE("Unit Purpose" = CONST("Rental Unit"));
            RequestFilterFields = "Building No.";
            column(OccupancyStatus_ServiceItem; "Service Item"."Occupancy Status")
            {
            }
            column(Type_ServiceItem; "Service Item".Type)
            {
            }
            column(CommercialOccupied; CommercialOccupied)
            {
            }
            column(CommercialVacant; CommercialVacant)
            {
            }
            column(ResidentialOccupied; ResidentialOccupied)
            {
            }
            column(ResidentialVacant; ResidentialVacant)
            {
            }
            column(CompPic; RecCompany.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin


                IF "Service Item".Type = "Service Item".Type::Commercial THEN BEGIN
                    IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Occupied THEN
                        CommercialOccupied += 1



                    ELSE
                        IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Vacant THEN
                            CommercialVacant += 1;
                END
                ELSE
                    IF "Service Item".Type = "Service Item".Type::Residential THEN BEGIN
                        IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Occupied THEN
                            ResidentialOccupied += 1
                        ELSE
                            IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Vacant THEN
                                ResidentialVacant += 1;
                    END;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        RecCompany.GET();
        RecCompany.CALCFIELDS(Picture);
    end;

    var
        RecServiceItem: Record 5940;
        CommercialOccupied: Integer;
        CommercialVacant: Integer;
        ResidentialOccupied: Integer;
        ResidentialVacant: Integer;
        RecCompany: Record 79;
}

