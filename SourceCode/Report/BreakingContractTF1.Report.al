report 50014 "Breaking Contract-TF1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './BreakingContractTF1.rdl';

    dataset
    {
        dataitem("Service Contract Header"; "Service Contract Header")
        {
            RequestFilterFields = "Contract No.", "Contract Type";
            column(ContractNo_ServiceContractHeader; "Service Contract Header"."Contract No.")
            {
            }
            column(ContractType_ServiceContractHeader; "Service Contract Header"."Contract Type")
            {
            }
            column(Description_ServiceContractHeader; "Service Contract Header".Description)
            {
            }
            column(Status_ServiceContractHeader; "Service Contract Header".Status)
            {
            }
            column(CustomerNo_ServiceContractHeader; "Service Contract Header"."Customer No.")
            {
            }
            column(Name_ServiceContractHeader; "Service Contract Header".Name)
            {
            }
            column(ServiceItemNo_ServiceContractHeader; "Service Contract Header"."Service Item No.")
            {
            }
            column(BuildingNo_ServiceContractHeader; "Service Contract Header"."Building No.")
            {
            }
            column(BuildingName_ServiceContractHeader; "Service Contract Header"."Building Name")
            {
            }
            column(UnitNo_ServiceContractHeader; "Service Contract Header"."Unit No.")
            {
            }
            column(StartingDate_ServiceContractHeader; "Service Contract Header"."Starting Date")
            {
            }
            column(ExpirationDate_ServiceContractHeader; "Service Contract Header"."Expiration Date")
            {
            }
            column(TerminationDate_ServiceContractHeader; "Service Contract Header"."Termination Date")
            {
            }
            column(PenaltyAmount_ServiceContractHeader; "Service Contract Header"."Penalty Amount")
            {
            }
            column(ActualUtilizedRentAmount_ServiceContractHeader; "Service Contract Header"."Actual Utilized Rent Amount")
            {
            }
            column(TenantName_ServiceContractHeader; "Service Contract Header"."Tenant Name")
            {
            }
            column(PenaltyDate; PenaltyDate)
            {
            }
            column(Date1; Date1)
            {
            }
            column(VacantDays; VacantDays)
            {
            }
            column(logo; CompInfo.Picture)
            {
            }
            column(Withdrawal; Withdrawal)
            {
            }
            column(RSD; RSD)
            {
            }
            column(RCP; RCP)
            {
            }
            column(RC; RC)
            {
            }
            column(maint; maint)
            {
            }
            column(ContractAmount; ContractAmount)
            {
            }
            column(HealthClubDeposit; HealthClubDeposit)
            {
            }
            dataitem("Service Contract Line"; "Service Contract Line")
            {
                DataItemLink = "Contract No." = FIELD("Contract No."),
                               "Contract Type" = FIELD("Contract Type");
                column(ContractNo_ServiceContractLine; "Service Contract Line"."Contract No.")
                {
                }
                column(LineAmount_ServiceContractLine; "Service Contract Line"."Line Amount")
                {
                }
            }
            dataitem("Post Dated Check Line"; "Post Dated Check Line")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemTableView = SORTING("Check Date")
                                    WHERE("G/L Transaction No." = FILTER(<> 0),
                                          "Charge Code" = FILTER(''));
                column(CheckDate_PostDatedCheckLine; "Post Dated Check Line"."Check Date")
                {
                }
                column(CheckNo_PostDatedCheckLine; "Post Dated Check Line"."Check No.")
                {
                }
                column(Status_PostDatedCheckLine; "Post Dated Check Line".Status)
                {
                }
                column(Amount_PostDatedCheckLine; PostedPDCAmt)
                {
                }
                column(ReversedPDCAmt; ReversedPDCAmt)
                {
                }
                column(TotalPostedPDCAmt; TotalPostedPDCAmt)
                {
                }
                column(SrNo; SrNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SrNo += 1;
                    PostedPDCAmt := 0;
                    ReversedPDCAmt := 0;
                    PostedPDCAmt := "Post Dated Check Line".Amount * -1;
                    IF "Post Dated Check Line".Status <> "Post Dated Check Line".Status::Deposited THEN
                        ReversedPDCAmt := PostedPDCAmt * -1;
                    TotalPostedPDCAmt := PostedPDCAmt + ReversedPDCAmt;
                end;

                trigger OnPreDataItem()
                begin
                    TotalPostedPDCAmt := 0;
                end;
            }
            dataitem("<Post Dated Check Line1>"; "Post Dated Check Line")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemTableView = SORTING("Template Name", "Batch Name", "Account Type", "Account No.", "Customer No.", "Line Number")
                                    WHERE("G/L Transaction No." = FILTER(0),
                                          "Charge Code" = FILTER(''));
                column(CheckDate_PostDatedCheckLine1; "<Post Dated Check Line1>"."Check Date")
                {
                }
                column(CheckNo_PostDatedCheckLine1; "<Post Dated Check Line1>"."Check No.")
                {
                }
                column(Status_PostDatedCheckLine1; "<Post Dated Check Line1>".Status)
                {
                }
                column(Amount_PostDatedCheckLine1; "<Post Dated Check Line1>".Amount)
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
            dataitem("Service Charges"; "Service Charges")
            {
                DataItemLink = "Service Contract Quote No." = FIELD("Contract No.");
                column(ChargeCode_ServiceCharges; "Service Charges"."Charge Code")
                {
                }
                column(ServiceContractQuoteNo_ServiceCharges; "Service Charges"."Service Contract Quote No.")
                {
                }
                column(ChargeDescription_ServiceCharges; "Service Charges"."Charge Description")
                {
                }
                column(ChargeAmount_ServiceCharges; "Service Charges"."Charge Amount")
                {
                }
                column(BalAccountNo_ServiceCharges; "Service Charges"."Bal. Account No.")
                {
                }
                column(Post_ServiceCharges; "Service Charges".Post)
                {
                }
                column(Unposted_ServiceCharges; "Service Charges".Unposted)
                {
                }
                column(ChargeDate_ServiceCharges; "Service Charges"."Charge Date")
                {
                }
                column(DocumentNo_ServiceCharges; "Service Charges"."Document No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Date1 := WORKDATE;
                //PenaltyMonth:=

                PenaltyDate := 0D;
                VacantDays := 0;
                PenaltyDate := CALCDATE('2M', "Service Contract Header"."Termination Date");
                VacantDays := ("Service Contract Header"."Termination Date" - "Service Contract Header"."Starting Date") + 1;

                //RecPDCL.Amount := -(ServContractManagement.CalcContractLineAmount("Annual Amount","Starting Date","Expiration Date")) / ServContractHdr."No. of PDC";
                ContractAmount := ServContractManagement.CalcContractLineAmount("Service Contract Header"."Annual Amount", "Service Contract Header"."Starting Date", "Service Contract Header"."Expiration Date");


                ServiceCharges.RESET;
                ServiceCharges.SETRANGE(ServiceCharges."Service Contract Quote No.", "Service Contract Header"."Contract No.");
                IF ServiceCharges.FINDSET THEN
                    REPEAT
                        IF ServiceCharges."Charge Code" = 'WITHDRAWAL' THEN
                            Withdrawal := ServiceCharges."Charge Amount"
                        ELSE
                            IF ServiceCharges."Charge Code" = 'CHQRETURN' THEN
                                RC := ServiceCharges."Charge Amount"
                            ELSE
                                IF ServiceCharges."Charge Code" = 'RCP' THEN
                                    RCP := ServiceCharges."Charge Amount"
                                ELSE
                                    IF ServiceCharges."Charge Code" = 'MAINT' THEN
                                        maint := ServiceCharges."Charge Amount"
                                    ELSE
                                        IF ServiceCharges."Charge Code" = 'RHC' THEN
                                            HealthClubDeposit := ServiceCharges."Charge Amount"
                                        ELSE
                                            IF ServiceCharges."Charge Code" = 'RSD' THEN
                                                RSD := ServiceCharges."Charge Amount";
                    UNTIL ServiceCharges.NEXT = 0;
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
        CompInfo.CALCFIELDS(Picture);
        ServMgtSetup.GET;
    end;

    var
        CompInfo: Record 79;
        SrNo: Integer;
        SrNo1: Integer;
        ServMgtSetup: Record 5911;
        Date1: Date;
        PenaltyDate: Date;
        PenaltyMonth: Integer;
        VacantDays: Integer;
        Status1: Code[10];
        ServiceCharges: Record "Service Charges";
        Withdrawal: Decimal;
        RSD: Decimal;
        RCP: Decimal;
        RC: Decimal;
        maint: Decimal;
        ServContractManagement: Codeunit 5940;
        ContractAmount: Decimal;
        PostedPDCAmt: Decimal;
        TotalPostedPDCAmt: Decimal;
        ReversedPDCAmt: Decimal;
        HealthClubDeposit: Decimal;
}

