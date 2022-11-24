report 50201 "Post Dated Checks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostDatedChecks.rdl';
    Caption = 'Post Dated Checks';

    dataset
    {
        dataitem("Post Dated Check Line 2"; "Post Dated Check Line")
        {
            DataItemTableView = SORTING("Check Date");
            RequestFilterFields = "Check Date", "Account No.";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(ReportFilter; ReportFilter)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            //Win513++
            // column(CurrReport_PAGENO; CurrReport.PAGENO)
            // {
            // }
            //Win513++
            column(Post_Dated_Check_Line_2__Account_Type_; "Account Type")
            {
            }
            column(Marked; Marked)
            {
            }
            column(Post_Dated_Check_Line_2__Check_Date_; FORMAT("Check Date"))
            {
            }
            column(Post_Dated_Check_Line_2__Account_No__; "Account No.")
            {
            }
            column(Post_Dated_Check_Line_2_Description; Description)
            {
            }
            column(Post_Dated_Check_Line_2__Check_No__; "Check No.")
            {
            }
            column(Post_Dated_Check_Line_2__Currency_Code_; "Currency Code")
            {
            }
            column(Post_Dated_Check_Line_2_Amount; Amount)
            {
            }
            column(Post_Dated_Check_Line_2__Amount__LCY__; "Amount (LCY)")
            {
            }
            column(Post_Dated_Check_Line_2__Date_Received_; FORMAT("Date Received"))
            {
            }
            column(Post_Dated_Check_Line_2__Replacement_Check_; FORMAT("Replacement Check"))
            {
            }
            column(Post_Dated_Check_Line_2_Comment; Comment)
            {
            }
            column(TotalFor___FIELDCAPTION__Check_Date__; TotalFor + FIELDCAPTION("Check Date"))
            {
            }
            column(Post_Dated_Check_Line_2_Amount_Control1500030; Amount)
            {
            }
            column(myCheck_Date; FIELDNO("Check Date"))
            {
            }
            column(myflag; flag)
            {
            }
            column(Post_Dated_Check_Line_2_Amount_Control1500031; Amount)
            {
            }
            column(ReportTotal; ReportTotal)
            {
            }
            column(Post_Dated_Check_Line_2_Template_Name; "Template Name")
            {
            }
            column(Post_Dated_Check_Line_2_Batch_Name; "Batch Name")
            {
            }
            column(Post_Dated_Check_Line_2_Line_Number; "Line Number")
            {
            }
            column(Post_Dated_Check_Line_2_Check_Date; "Check Date")
            {
            }
            column(Post_Dated_ChecksCaption; Post_Dated_ChecksCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Post_Dated_Check_Line_2__Check_Date_Caption; Post_Dated_Check_Line_2__Check_Date_CaptionLbl)
            {
            }
            column(Post_Dated_Check_Line_2__Account_Type_Caption; FIELDCAPTION("Account Type"))
            {
            }
            column(Post_Dated_Check_Line_2__Account_No__Caption; FIELDCAPTION("Account No."))
            {
            }
            column(Post_Dated_Check_Line_2_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(Post_Dated_Check_Line_2__Check_No__Caption; FIELDCAPTION("Check No."))
            {
            }
            column(Post_Dated_Check_Line_2__Currency_Code_Caption; FIELDCAPTION("Currency Code"))
            {
            }
            column(Post_Dated_Check_Line_2_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(Post_Dated_Check_Line_2__Amount__LCY__Caption; FIELDCAPTION("Amount (LCY)"))
            {
            }
            column(Post_Dated_Check_Line_2__Date_Received_Caption; Post_Dated_Check_Line_2__Date_Received_CaptionLbl)
            {
            }
            column(Post_Dated_Check_Line_2__Replacement_Check_Caption; Post_Dated_Check_Line_2__Replacement_Check_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "Check Date" <= WORKDATE THEN
                    Marked := 'BANK'
                ELSE
                    Marked := '';
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Check Date");
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
        ReportFilter := "Post Dated Check Line 2".GETFILTERS;
    end;

    var
        ReportFilter: Text[250];
        LastFieldNo: Integer;
        Marked: Text[10];
        TotalFor: Label 'Total for ';
        ReportTotal: Label 'Report Total';
        flag: Integer;
        Post_Dated_ChecksCaptionLbl: Label 'Post Dated Checks';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Post_Dated_Check_Line_2__Check_Date_CaptionLbl: Label 'Check Date';
        Post_Dated_Check_Line_2__Date_Received_CaptionLbl: Label 'Date Received';
        Post_Dated_Check_Line_2__Replacement_Check_CaptionLbl: Label 'Replacement Check';
}

