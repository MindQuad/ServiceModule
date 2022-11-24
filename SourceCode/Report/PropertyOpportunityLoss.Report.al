report 50070 "Property Opportunity Loss"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PropertyOpportunityLoss.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Service Item"; "Service Item")
        {
            DataItemTableView = WHERE("Occupancy Status" = CONST(Vacant));
            RequestFilterFields = "Building No.";
            column(OccupancyStatus_ServiceItem; "Service Item"."Occupancy Status")
            {
            }
            column(Type_ServiceItem; "Service Item".Type)
            {
            }
            column(CommercialVacant; CommercialVacant)
            {
            }
            column(ResidentialVacant; ResidentialVacant)
            {
            }
            column(ResidentialOccupied; ResidentialOccupied)
            {
            }
            column(CommercialOccupied; CommercialOccupied)
            {
            }
            column(NoofMonths; NoofMonths)
            {
            }
            column(MonthlyRent; MonthlyRent)
            {
            }
            column(CompPic; RecCompany.Picture)
            {
            }
            column(ResidentialLoss; ResidentialLoss)
            {
            }
            column(CommercialLoss; CommercialLoss)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(NoofMonths);
                CLEAR(NoofDays);
                CLEAR(MonthlyRent);


                /*
                NoofDays := CalculationDate - "Service Item"."Last Vacant Date";
                NoofMonths := ROUND(NoofDays DIV 30,1,'=');
                //MESSAGE(FORMAT(NoofMonths));
                MonthlyRent :=( "Service Item"."Potential Rent/Year" / 12);
                */


                IF "Service Item".Type = "Service Item".Type::Commercial THEN BEGIN
                    IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Occupied THEN BEGIN
                        CommercialOccupied += 1;

                    END


                    ELSE
                        IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Vacant THEN BEGIN
                            CommercialVacant += 1;
                            NoofDays := CalculationDate - "Service Item"."Last Vacant Date";
                            NoofMonths := ROUND(NoofDays DIV 30, 1, '=');
                            //MESSAGE(FORMAT(NoofMonths));
                            MonthlyRent := ROUND("Service Item"."Potential Rent/Year" / 12, 1, '=');
                            CommercialLoss += MonthlyRent * NoofMonths;

                        END;
                END
                ELSE
                    IF "Service Item".Type = "Service Item".Type::Residential THEN BEGIN
                        IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Occupied THEN
                            ResidentialOccupied += 1
                        ELSE
                            IF "Service Item"."Occupancy Status" = "Service Item"."Occupancy Status"::Vacant THEN BEGIN
                                ResidentialVacant += 1;
                                NoofDays := CalculationDate - "Service Item"."Last Vacant Date";
                                NoofMonths := ROUND(NoofDays DIV 30, 1, '=');
                                //MESSAGE(FORMAT(NoofMonths));
                                MonthlyRent := ROUND("Service Item"."Potential Rent/Year" / 12, 1, '=');
                                ResidentialLoss += MonthlyRent * NoofMonths;
                            END;
                    END;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Calculation Date"; CalculationDate)
                {
                }
            }
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
        CalculationDate: Date;
        NoofMonths: Integer;
        NoofDays: Integer;
        MonthlyRent: Decimal;
        ResidentialLoss: Decimal;
        CommercialLoss: Decimal;
}

