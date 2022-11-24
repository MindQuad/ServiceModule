report 50008 "Contract Closingl Proces"
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
                    ServMgtSetup.TESTFIELD("Closing Contract Nos.");
                    NoSeriesMgt.InitSeries(ServMgtSetup."Closing Contract Nos.", "Service Contract Header"."No. Series2", 0D, NewNo, NewServiceContractHeader."No. Series2");
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
                NewServiceContractHeader."Service Quote Type" := NewServiceContractHeader."Service Quote Type"::Closing;
                //NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Starting Date","Service Contract Header"."Expiration Date" + 1);
                // WIN210
                NewServiceContractHeader.VALIDATE("Last Invoice Date", 0D);
                // WIN210
                NewServiceContractHeader.VALIDATE("Deal Closing Date", "Service Contract Header"."Expiration Date" + 1); //win315
                // NewServiceContractHeader."Starting Date" := "Service Contract Header"."Expiration Date"+1; //  WIN210
                NewServiceContractHeader.VALIDATE("Starting Date", "Service Contract Header"."Expiration Date" + 1); // WIN210
                NewServiceContractHeader.VALIDATE("Expiration Date", "Service Contract Header"."Contract Closing Date"); // WIN210
                // NewServiceContractHeader."Next Invoice Date" := CALCDATE('-CM',NewServiceContractHeader."Starting Date"); // WIN210
                NewServiceContractHeader.VALIDATE("Next Invoice Date", NewServiceContractHeader."Starting Date"); // WIN210
                NewServiceContractHeader."Service Item No." := "Service Contract Header"."Service Item No.";
                NewD := (FORMAT((NewServiceContractHeader."Expiration Date" - NewServiceContractHeader."Starting Date") + 1) + 'D');
                Done := EVALUATE(NewServiceContractHeader."Contract Period", NewD);
                //NewServiceContractHeader."Contract Period":=NewServiceContractHeader."Contract Period";
                NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Contract Period", NewServiceContractHeader."Contract Period");
                NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Service Period", NewServiceContractHeader."Contract Period");

                //NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Contract Period",FORMAT(Diff) + 'D');
                NewServiceContractHeader."Previous Contract No." := "Service Contract Header"."Contract No.";
                //Diff := (NewServiceContractHeader."Expiration Date" - NewServiceContractHeader."Starting Date");
                //InvPrd := FORMAT(Diff) + 'D';
                //NewServiceContractHeader.VALIDATE("Invoice Period",FORMAT(Diff) + 'D'); // WIN210

                NewServiceContractHeader.VALIDATE(NewServiceContractHeader."Invoice Period", "Service Contract Header"."Invoice Period");
                NewServiceContractHeader.VALIDATE("Defferal Code", "Service Contract Header"."Defferal Code"); // WIN210
                "Service Contract Header"."Closing Contract No." := NewServiceContractHeader."Contract No.";
                //NewServiceContractHeader.VALIDATE("Amount per Period","Service Contract Header"."Amount per Period");
                //"Actual Utilized Rent Amount" := ServContractManagement.CalcContractLineAmount("Annual Amount","Starting Date","Termination Date");
                NewServiceContractHeader.VALIDATE("Amount per Period", ServContractManagement.CalcContractLineAmount(NewServiceContractHeader."Annual Amount", NewServiceContractHeader."Starting Date", NewServiceContractHeader."Expiration Date"));
                NewServiceContractHeader."VAT Amount" := (NewServiceContractHeader."Amount per Period" * 5) / 100;
                NewServiceContractHeader."Contact Amt Incl VAT" := NewServiceContractHeader."Amount per Period" + NewServiceContractHeader."VAT Amount";
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
                //"Service Contract Header"."Renewal Contract" := TRUE;
                "Service Contract Header"."Contract Closed" := TRUE;
                "Service Contract Header".Status := "Service Contract Header".Status::Canceled;
                "Service Contract Header".MODIFY;
                MESSAGE('Closed Service Contract is created with Contract No. %1', NewServiceContractHeader."Contract No.");
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
        GlbContractType: Option Quote,Contract;
        GlbContractNo: Code[20];
        NewServiceContractLine: Record 5964;
        ServiceContractLine: Record 5964;
        ServMgtSetup: Record 5911;
        NoSeriesMgt: Codeunit 396;
        Diff: Integer;
        InvPrd: Text;
        Done: Boolean;
        NewD: Text;
        ServContractManagement: Codeunit 5940;


    procedure SetServiceContract(ContractType: Option Quote,Contract; ContractNo: Code[20])
    begin
        GlbContractType := ContractType;
        GlbContractNo := ContractNo;
    end;
}

