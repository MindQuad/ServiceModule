report 50002 "Renewal Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RenewalLetter.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Service Contract Header"; "Service Contract Header")
        {
            RequestFilterFields = "Contract Type", "Contract No.";
            column(ContractNo_ServiceContractHeader; "Service Contract Header"."Contract No.")
            {
            }
            column(ContractType_ServiceContractHeader; "Service Contract Header"."Contract Type")
            {
            }
            column(Description_ServiceContractHeader; "Service Contract Header".Description)
            {
            }
            column(Description2_ServiceContractHeader; "Service Contract Header"."Description 2")
            {
            }
            column(Status_ServiceContractHeader; "Service Contract Header".Status)
            {
            }
            column(ChangeStatus_ServiceContractHeader; "Service Contract Header"."Change Status")
            {
            }
            column(CustomerNo_ServiceContractHeader; "Service Contract Header"."Customer No.")
            {
            }
            column(Name_ServiceContractHeader; "Service Contract Header".Name)
            {
            }
            column(Address_ServiceContractHeader; "Service Contract Header".Address)
            {
            }
            column(Address2_ServiceContractHeader; "Service Contract Header"."Address 2")
            {
            }
            column(PostCode_ServiceContractHeader; "Service Contract Header"."Post Code")
            {
            }
            column(ServiceItemNo_ServiceContractHeader; "Service Contract Header"."Service Item No.")
            {
            }
            column(StartingDate_ServiceContractHeader; StartDate)
            {
            }
            column(EXPDATE; "Service Contract Header"."Expiration Date")
            {
            }
            column(BuildingNo_ServiceContractHeader; "Service Contract Header"."Building No.")
            {
            }
            column(UnitNo_ServiceContractHeader; "Service Contract Header"."Unit No.")
            {
            }
            column(AnnualAmount_ServiceContractHeader; "Service Contract Header"."Annual Amount")
            {
            }
            column(name; CompInfo.Name)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(EndDate1; EndDate1)
            {
            }
            dataitem("Post Dated Check Line"; "Post Dated Check Line")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemTableView = SORTING("Template Name", "Batch Name", "Account Type", "Account No.", "Customer No.", "Line Number")
                                    WHERE("Charge Code" = FILTER(''));
                RequestFilterFields = "Contract No.";
                column(CheckDate_PostDatedCheckLine; "Post Dated Check Line"."Check Date")
                {
                }
                column(CheckNo_PostDatedCheckLine; "Post Dated Check Line"."Check No.")
                {
                }
                column(Amount_PostDatedCheckLine; "Post Dated Check Line".Amount)
                {
                }
                column(SrNo; SrNo)
                {
                }
                column(LineNumber_PostDatedCheckLine; "Post Dated Check Line"."Line Number")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //SrNo+=1;

                    //IF "Post Dated Check Line"."Charge Code"  <> '' THEN
                    SrNo += 1;

                    /*IF "Post Dated Check Line"."Charge Code" <> '' THEN
                      CurrReport.SKIP;*/


                end;
            }
            dataitem("Service Charges"; "Service Charges")
            {
                DataItemLink = "Service Contract Quote No." = FIELD("Contract No.");
                column(ChargeCode_ServiceCharges; "Service Charges"."Charge Code")
                {
                }
                column(ChargeDescription_ServiceCharges; "Service Charges"."Charge Description")
                {
                }
                column(ServiceContractQuoteNo_ServiceCharges; "Service Charges"."Service Contract Quote No.")
                {
                }
                column(ChargeAmount_ServiceCharges; "Service Charges"."Charge Amount")
                {
                }
                column(ChargeDate_ServiceCharges; "Service Charges"."Charge Date")
                {
                }
                column(SrNo1; SrNo1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SrNo1 += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*StartDate:=0D;
                EndDate:=0D;
                EndDate1:=0D;
                ServContra.RESET;
                ServContra.SETRANGE(ServContra."Contract No.","Service Contract Header"."Previous Contract No.");
                IF ServContra.FINDFIRST THEN BEGIN
                  StartDate := ServContra."Starting Date";
                  EndDate := ServContra."Expiration Date";
                  EndDate1:= CALCDATE('<-30D>',EndDate);
                  //MESSAGE(FORMAT(StartDate));
                END;*/

                EndDate1 := CALCDATE('<-30D>', "Service Contract Header"."Expiration Date");

            end;

            trigger OnPreDataItem()
            begin
                // //Win593++
                if SendEmail then begin
                    "Service Contract Header".SetRange("Contract Type", ServiceContractHdrGlobal."Contract Type");
                    "Service Contract Header".SetRange("Contract No.", ServiceContractHdrGlobal."Contract No.");
                    "Service Contract Header".FindFirst();
                    ContractNo := "Service Contract Header"."Contract No.";
                end else
                    //     //Win593--
                    ContractNo := "Service Contract Header".GETFILTER("Service Contract Header"."Contract No.");
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
        SrNo := 0;
        SrNo1 := 0;
        CompInfo.GET;

        //Win593++
        if SendEmail then begin
            "Service Contract Header".Get(ServiceContractHdrGlobal."Contract Type", ServiceContractHdrGlobal."Contract No.");
            ContractNo := "Service Contract Header"."Contract No.";
        end;
        //Win593--
    end;

    //Win593++
    procedure SetServiceContractHdr(ServContractHdr: Record "Service Contract Header")
    begin
        SendEmail := true;
        ServiceContractHdrGlobal := ServContractHdr;
    end;
    //Win593--

    var
        CompInfo: Record 79;
        SrNo: Integer;
        SrNo1: Integer;
        StartDate: Date;
        ServContra: Record 5965;
        ContractNo: Code[20];
        EndDate: Date;
        EndDate1: Date;
        ServiceContractHdrGlobal: Record "Service Contract Header";
        SendEmail: Boolean;
}

