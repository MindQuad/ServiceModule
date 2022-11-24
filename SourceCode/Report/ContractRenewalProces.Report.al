report 50000 "Contract Renewal Proces"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Service Contract Header"; "Service Contract Header")
        {

            trigger OnAfterGetRecord()
            begin
                NewServiceContractHeader.INIT;
                IF NewNo = '' THEN BEGIN
                    ServMgtSetup.GET;
                    ServMgtSetup.TESTFIELD("Renewal Contract Nos.");
                    NoSeriesMgt.InitSeries(ServMgtSetup."Renewal Contract Nos.", "Service Contract Header"."No. Series1", 0D, NewNo, NewServiceContractHeader."No. Series1");
                END;
                NewServiceContractHeader."Contract Type" := "Service Contract Header"."Contract Type"::Quote;
                NewServiceContractHeader."Contract No." := NewNo;
                //NewServiceContractHeader."Starting Date" := "Service Contract Header"."Expiration Date"+1;

                //win315 ++ Insert Service contract header
                NewServiceContractHeader.INSERT(TRUE);
                NewServiceContractHeader.TRANSFERFIELDS("Service Contract Header", FALSE);
                NewServiceContractHeader.Status := Status::" ";
                NewServiceContractHeader."Change Status" := "Service Contract Header"."Change Status"::Open;
                NewServiceContractHeader."Approval Status" := "Service Contract Header"."Approval Status"::Open;
                NewServiceContractHeader.VALIDATE("Approval Status", "Approval Status"::Open);
                NewServiceContractHeader."PDC Entry Generated" := FALSE;
                NewServiceContractHeader."Service Quote Type" := NewServiceContractHeader."Service Quote Type"::Renewal;
                //NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Starting Date","Service Contract Header"."Expiration Date" + 1);
                // WIN210
                NewServiceContractHeader.VALIDATE("Last Invoice Date", 0D);
                // WIN210
                NewServiceContractHeader.VALIDATE("Deal Closing Date", "Service Contract Header"."Expiration Date" + 1); //win315
                // NewServiceContractHeader."Starting Date" := "Service Contract Header"."Expiration Date"+1; //  WIN210
                NewServiceContractHeader.VALIDATE("Starting Date", "Service Contract Header"."Expiration Date" + 1); // WIN210
                NewServiceContractHeader.VALIDATE("Expiration Date", CALCDATE("Service Contract Header"."Contract Period", "Service Contract Header"."Expiration Date")); // WIN210
                //NewServiceContractHeader.VALIDATE("Expiration Date",CALCDATE('1Y',"Service Contract Header"."Expiration Date")); // WIN210
                // NewServiceContractHeader."Next Invoice Date" := CALCDATE('-CM',NewServiceContractHeader."Starting Date"); // WIN210
                NewServiceContractHeader.VALIDATE("Next Invoice Date", NewServiceContractHeader."Starting Date"); // WIN210
                NewServiceContractHeader."Service Item No." := "Service Contract Header"."Service Item No.";
                NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Service Period", "Service Contract Header"."Service Period");
                NewServiceContractHeader."Previous Contract No." := "Service Contract Header"."Contract No.";
                NewServiceContractHeader.VALIDATE("Invoice Period", "Service Contract Header"."Invoice Period"); // WIN210
                NewServiceContractHeader.VALIDATE("Defferal Code", "Service Contract Header"."Defferal Code"); // WIN210
                NewServiceContractHeader.VALIDATE("Amount per Period", "Service Contract Header"."Amount per Period");
                "Service Contract Header"."Renewal Contract No." := NewServiceContractHeader."Contract No.";
                NewServiceContractHeader.MODIFY;

                //win315 ++ Insert Service contract line
                ServiceContractLine.RESET;
                ServiceContractLine.SETRANGE(ServiceContractLine."Contract Type", "Service Contract Header"."Contract Type");
                ServiceContractLine.SETRANGE(ServiceContractLine."Contract No.", "Service Contract Header"."Contract No.");
                IF ServiceContractLine.FINDSET THEN
                    REPEAT
                        NewServiceContractLine.INIT;
                        NewServiceContractLine."Contract Type" := NewServiceContractLine."Contract Type"::Quote;
                        NewServiceContractLine."Contract No." := NewNo;
                        NewServiceContractLine."Line No." += 10000;
                        NewServiceContractLine."Customer No." := "Service Contract Header"."Customer No.";
                        //NewServiceContractLine.VALIDATE(NewServiceContractLine."Service Item No.",ServiceContractLine."Service Item No.");
                        NewServiceContractLine."Service Item No." := ServiceContractLine."Service Item No.";
                        NewServiceContractLine.Description := ServiceContractLine.Description;
                        NewServiceContractLine.INSERT;
                        //NewServiceContractLine.VALIDATE(NewServiceContractLine."Line Value",ServiceContractLine."Line Value");
                        NewServiceContractLine.TRANSFERFIELDS(ServiceContractLine, FALSE);
                        NewServiceContractLine."Invoiced to Date" := 0D; // WIN210
                        NewServiceContractLine."New Line" := TRUE; // WIN210
                        NewServiceContractLine.MODIFY;
                    UNTIL ServiceContractLine.NEXT = 0;
                //win315--





                //END;
            end;

            trigger OnPostDataItem()
            begin
                "Service Contract Header"."Renewal Contract" := TRUE;
                "Service Contract Header".Status := "Service Contract Header".Status::Canceled;
                "Service Contract Header"."Contract Current Status" := "Service Contract Header"."Contract Current Status"::Expired;//WIN586
                "Service Contract Header".MODIFY;
                MESSAGE('Service Contract is Renewed with Contract No. %1', NewServiceContractHeader."Contract No.");
            end;

            trigger OnPreDataItem()
            begin
                "Service Contract Header".SETRANGE("Service Contract Header"."Contract Type", GlbContractType);
                "Service Contract Header".SETRANGE("Service Contract Header"."Contract No.", GlbContractNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Renewal No."; NewNo)
                    {
                        Visible = false;
                    }
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

    var
        NewNo: Code[20];
        NewServiceContractHeader: Record 5965;

        //Win513++
        //GlbContractType: Option Quote,Contract;
        GlbContractType: Enum "Service Contract Type";
        //Win513--
        GlbContractNo: Code[20];
        NewServiceContractLine: Record 5964;
        ServiceContractLine: Record 5964;
        ServMgtSetup: Record 5911;
        NoSeriesMgt: Codeunit 396;


    //Win513++
    //procedure SetServiceContract(ContractType: Option Quote,Contract; ContractNo: Code[20])
    procedure SetServiceContract(ContractType: Enum "Service Contract Type"; ContractNo: Code[20])
    //Win513--
    begin
        GlbContractType := ContractType;
        GlbContractNo := ContractNo;
    end;
}

