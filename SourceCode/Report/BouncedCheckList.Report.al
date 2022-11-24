report 50066 "Bounced Check List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './BouncedCheckList.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Post Dated Check Line"; "Post Dated Check Line")
        {
            column(CompName; CompInfo.Name)
            {
            }
            column(logo; CompInfo.Picture)
            {
            }
            column(Name; Name)
            {
            }
            column(BuildName; RecBuild.Description)
            {
            }
            column(SrNo; SrNo)
            {
            }
            column(TodayDate; TodayDate)
            {
            }
            column(Days; Days)
            {
            }
            column(CustBankAccName; CustBankAcc.Name)
            {
            }
            column(DocumentNo_PostDatedCheckLine; "Post Dated Check Line"."Document No.")
            {
            }
            column(AccountType_PostDatedCheckLine; "Post Dated Check Line"."Account Type")
            {
            }
            column(AccountNo_PostDatedCheckLine; "Post Dated Check Line"."Account No.")
            {
            }
            column(CheckDate_PostDatedCheckLine; "Post Dated Check Line"."Check Date")
            {
            }
            column(CheckNo_PostDatedCheckLine; "Post Dated Check Line"."Check No.")
            {
            }
            column(Description_PostDatedCheckLine; "Post Dated Check Line".Description)
            {
            }
            column(Amount_PostDatedCheckLine; "Post Dated Check Line".Amount)
            {
            }
            column(AmountLCY_PostDatedCheckLine; "Post Dated Check Line"."Amount (LCY)")
            {
            }
            column(BankAccount_PostDatedCheckLine; "Post Dated Check Line"."Bank Account")
            {
            }
            column(Comment_PostDatedCheckLine; "Post Dated Check Line".Comment)
            {
            }
            column(BankPaymentType_PostDatedCheckLine; "Post Dated Check Line"."Bank Payment Type")
            {
            }
            column(ContractNo_PostDatedCheckLine; "Post Dated Check Line"."Contract No.")
            {
            }
            column(BuildingNo_PostDatedCheckLine; "Post Dated Check Line"."Building No.")
            {
            }
            column(UnitNo_PostDatedCheckLine; UnitNo)
            {
            }
            column(Status_PostDatedCheckLine; "Post Dated Check Line".Status)
            {
            }
            column(ReversalReasonCode_PostDatedCheckLine; "Post Dated Check Line"."Reversal Reason Code")
            {
            }
            column(SettlementType_PostDatedCheckLine; "Post Dated Check Line"."Settlement Type")
            {
            }
            column(SettlementComments_PostDatedCheckLine; "Post Dated Check Line"."Settlement Comments")
            {
            }
            column(ReversalReasonComments_PostDatedCheckLine; "Post Dated Check Line"."Reversal Reason Comments")
            {
            }
            column(ServiceContractType_PostDatedCheckLine; "Post Dated Check Line"."Service Contract Type")
            {
            }
            column(Charges_PostDatedCheckLine; "Post Dated Check Line".Charges)
            {
            }
            column(AmountPaid_PostDatedCheckLine; "Post Dated Check Line"."Amount Paid")
            {
            }
            column(UpdatedwithLegalDept_PostDatedCheckLine; "Post Dated Check Line"."Updated with Legal Dept")
            {
            }

            trigger OnAfterGetRecord()
            begin
                SrNo += 1;
                Name := '';
                Days := 0;
                UnitNo := '';

                RecBuild.RESET;
                IF RecBuild.GET("Post Dated Check Line"."Building No.") THEN;

                Days := (TodayDate - "Post Dated Check Line"."Check Date");

                CustBankAcc.RESET;
                IF CustBankAcc.GET("Post Dated Check Line"."Bank Account") THEN;

                SerContractLine.RESET;
                SerContractLine.SETRANGE(SerContractLine."Contract No.", "Post Dated Check Line"."Contract No.");
                IF SerContractLine.FINDFIRST THEN
                    UnitNo := SerContractLine."Service Item No.";
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
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
        SrNo := 0;
        TodayDate := WORKDATE;
    end;

    var
        CompInfo: Record 79;
        SrNo: Integer;
        RecCust: Record 18;
        Name: Text;
        RecVendor: Record 23;
        RecGL: Record 15;
        RecBuild: Record 50005;
        TodayDate: Date;
        Days: Integer;
        RecBank: Integer;
        CustBankAcc: Record 287;
        SerContractLine: Record 5964;
        UnitNo: Code[10];
}

