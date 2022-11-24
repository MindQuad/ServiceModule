report 50097 "PDC Receipt"
{
    // WIN-438 : Created Report
    DefaultLayout = RDLC;
    RDLCLayout = './PDCReceipt.rdl';

    Caption = 'PDC Receipt';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Post Dated Check Line"; "Post Dated Check Line")
        {
            DataItemTableView = SORTING("Template Name", "Batch Name", "Account Type", "Account No.", "Line Number")
                                ORDER(Ascending)
                                WHERE("Account Type" = FILTER(' ' | Customer | "G/L Account"),
                                      Status = CONST(Received));
            RequestFilterFields = "Account No.", "Contract No.", "Building No.", "Unit No.";
            column(Comp_Name; CompInfo.Name)
            {
            }
            column(RecFrom; "Post Dated Check Line".Description)
            {
            }
            column(ProName; Building.Description)
            {
            }
            column(UnitNo; "Post Dated Check Line"."Unit No.")
            {
            }
            column(LeaseRef; "Post Dated Check Line"."Contract No.")
            {
            }
            column(RecDate; FORMAT(TODAY))
            {
            }
            column(RecNo; "Post Dated Check Line"."Document No.")
            {
            }
            column(MOP; 'Cheque')
            {
            }
            column(PRNo; "Post Dated Check Line"."Check No.")
            {
            }
            column(PayDate; FORMAT("Post Dated Check Line"."Check Date"))
            {
            }
            column(DOBank; BankAccount.Name)
            {
            }
            column(Purpose; '')
            {
            }
            column(Notes; "Post Dated Check Line".Comment)
            {
            }
            column(Amt; "Post Dated Check Line".Amount * -1)
            {
            }
            column(RecBy; USERID)
            {
            }
            column(AmtInWord; AmtInWord[1] + AmtInWord[2] + ' ONLY')
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF BankAccount.GET("Post Dated Check Line"."Bank Account") THEN;

                IF Building.GET("Post Dated Check Line"."Building No.") THEN;

                TotalAmt += "Post Dated Check Line".Amount;

                CLEAR(RepCheck);
                RepCheck.InitTextVariable;
                RepCheck.FormatNoText(AmtInWord, (TotalAmt * -1), '');
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
        IF "Post Dated Check Line".GETFILTER("Account No.") = '' THEN
            ERROR('Account No. should not be blank');

        IF "Post Dated Check Line".GETFILTER("Building No.") = '' THEN
            ERROR('Building No. should not be blank');

        IF "Post Dated Check Line".GETFILTER("Unit No.") = '' THEN
            ERROR('Unit No. should not be blank');


        CompInfo.GET();
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record 79;
        BankAccount: Record 270;
        Building: Record 50005;
        RepCheck: Report 1401;
        AmtInWord: array[2] of Text[80];
        TotalAmt: Decimal;
}

