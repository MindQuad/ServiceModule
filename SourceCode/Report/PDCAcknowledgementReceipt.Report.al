report 50200 "PDC Acknowledgement Receipt"
{
    // WINPDC : Added new column Status on report & modified the Report layout for the same.
    DefaultLayout = RDLC;
    RDLCLayout = './PDCAcknowledgementReceipt.rdl';

    Caption = 'PDC Acknowledgement Receipt';

    dataset
    {
        dataitem("Post Dated Check Line 2"; "Post Dated Check Line")
        {
            column(Addr_2_; Addr[2])
            {
            }
            column(COMPANYNAME; COMPANYNAME)
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
            //Win513--
            column(Addr_1_; Addr[1])
            {
            }
            column(Addr_3_; Addr[3])
            {
            }
            column(Addr_4_; Addr[4])
            {
            }
            column(Addr_5_; Addr[5])
            {
            }
            column(Addr_6_; Addr[6])
            {
            }
            column(Addr_7_; Addr[7])
            {
            }
            column(Addr_8_; Addr[8])
            {
            }
            column(Title; Title)
            {
            }
            column(Post_Dated_Check_Line_2__Check_Date_; FORMAT("Check Date"))
            {
            }
            column(Post_Dated_Check_Line_2__Check_No__; "Check No.")
            {
            }
            column(Post_Dated_Check_Line_2_Amount; Amount)
            {
            }
            column(Post_Dated_Check_Line_2__Applies_to_Doc__Type_; "Applies-to Doc. Type")
            {
            }
            column(Post_Dated_Check_Line_2__Applies_to_Doc__No__; "Applies-to Doc. No.")
            {
            }
            column(CurrencyCode; CurrencyCode)
            {
            }
            column(RecordNum; RecordNum)
            {
            }
            column(Post_Dated_Check_Line_2_Comment; Comment)
            {
            }
            column(CheckCount; CheckCount)
            {
            }
            column(Post_Dated_Check_Line_2_Template_Name; "Template Name")
            {
            }
            column(Post_Dated_Check_Line_2_Batch_Name; "Batch Name")
            {
            }
            column(Post_Dated_Check_Line_2_Account_Type; "Account Type")
            {
            }
            column(Post_Dated_Check_Line_2_Account_No_; "Account No.")
            {
            }
            column(Post_Dated_Check_Line_2_Line_Number; "Line Number")
            {
            }
            column(Post_Dated_Checks_Acknowledgement_ReceiptCaption; Post_Dated_Checks_Acknowledgement_ReceiptCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Post_Dated_Check_Line_2_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(Post_Dated_Check_Line_2__Check_Date_Caption; Post_Dated_Check_Line_2__Check_Date_CaptionLbl)
            {
            }
            column(Post_Dated_Check_Line_2__Check_No__Caption; FIELDCAPTION("Check No."))
            {
            }
            column(Post_Dated_Check_Line_2__Applies_to_Doc__Type_Caption; FIELDCAPTION("Applies-to Doc. Type"))
            {
            }
            column(Post_Dated_Check_Line_2__Applies_to_Doc__No__Caption; FIELDCAPTION("Applies-to Doc. No."))
            {
            }
            column(Comments_Caption; Comments_CaptionLbl)
            {
            }
            column(Signature_over_the_Printed_NameCaption; Signature_over_the_Printed_NameCaptionLbl)
            {
            }
            column(Total_No__of_Checks_Caption; Total_No__of_Checks_CaptionLbl)
            {
            }
            column(Received_By_Caption; Received_By_CaptionLbl)
            {
            }
            column(Status_PDCL; "Post Dated Check Line 2".Status)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "Check Date" <= WORKDATE THEN
                    Marked := 'BANK'
                ELSE
                    Marked := '';
                IF "Currency Code" <> '' THEN
                    CurrencyCode := "Currency Code"
                ELSE BEGIN
                    GLSetup.GET;
                    CurrencyCode := GLSetup."LCY Code";
                END;
                RecordNum += 1;
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    Title := 'Customer Name';
                    IF Cust.GET("Account No.") THEN
                        FormatAddr.Customer(Addr, Cust);
                END ELSE
                    IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                        Title := 'Vendor Name';
                        IF Vend.GET("Account No.") THEN
                            FormatAddr.Vendor(Addr, Vend);
                    END;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Check Date");
                CheckCount := COUNT;
                RecordNum := 0;
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

    var
        LastFieldNo: Integer;
        Marked: Text[10];
        CurrencyCode: Code[3];
        Addr: array[8] of Text[50];
        FormatAddr: Codeunit 365;
        Cust: Record 18;
        Vend: Record 23;
        GLSetup: Record 98;
        Title: Text[30];
        CheckCount: Integer;
        RecordNum: Integer;
        Post_Dated_Checks_Acknowledgement_ReceiptCaptionLbl: Label 'Post Dated Checks Acknowledgement Receipt';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Post_Dated_Check_Line_2__Check_Date_CaptionLbl: Label 'Check Date';
        Comments_CaptionLbl: Label 'Comments:';
        Signature_over_the_Printed_NameCaptionLbl: Label 'Signature over the Printed Name';
        Total_No__of_Checks_CaptionLbl: Label 'Total No. of Checks:';
        Received_By_CaptionLbl: Label 'Received By:';
}

