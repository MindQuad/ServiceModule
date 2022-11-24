report 50096 "Proposal External"
{
    // WIN-438 : Created Report
    DefaultLayout = RDLC;
    RDLCLayout = './ProposalExternal.rdl';

    Caption = 'Proposal External';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Service Header"; "Service Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";
            column(Comp_Name; CompInfo.Name)
            {
            }
            column(Comp_Pic; CompInfo.Picture)
            {
            }
            column(Comp_Add1; CompInfo.Address)
            {
            }
            column(Comp_Add2; CompInfo."Address 2")
            {
            }
            column(Comp_City; CompInfo.City)
            {
            }
            column(Comp_Country; CompInfo."Country/Region Code")
            {
            }
            column(Comp_PhNo; CompInfo."Phone No.")
            {
            }
            column(Comp_TRN; CompInfo."VAT Registration No.")
            {
            }
            column(DocNo_SH; "Service Header"."No.")
            {
            }
            column(PostingDate_SH; "Service Header"."Posting Date")
            {
            }
            column(Name_SH; "Service Header".Name)
            {
            }
            column(BuildingName_SH; "Service Header"."Building Name")
            {
            }
            column(UnitNo_SH; "Service Header"."Unit No.")
            {
            }
            column(CurrCod_SH; "Service Header"."Currency Code")
            {
            }
            column(PhNo_SH; "Service Header"."Phone No.")
            {
            }
            column(EMail_SH; "Service Header"."E-Mail")
            {
            }
            column(City_SH; "Service Header".City)
            {
            }
            column(Country_SH; "Service Header"."Country/Region Code")
            {
            }
            column(PostCode_SH; "Service Header"."Post Code")
            {
            }
            column(TotalAmt; TotalAmt)
            {
            }
            column(Comm1; CommentTxt[1])
            {
            }
            column(Comm2; CommentTxt[2])
            {
            }
            column(Comm3; CommentTxt[3])
            {
            }
            column(TodayDate; TodayDate)
            {
            }
            column(ServiceOrderType_ServiceHeader; "Service Header"."Service Order Type")
            {
            }
            dataitem("Service Line"; "Service Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    ORDER(Ascending);
                column(SrNo; RepSrNo)
                {
                }
                column(Desc; RepDesc)
                {
                }
                column(Qty; RepQty)
                {
                }
                column(QDes; RepQtyDes)
                {
                }
                column(Amt; RepAmt)
                {
                }
                column(AmtInWord; AmtInWord[1] + AmtInWord[2])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Initialization
                    CLEAR(RepDesc);
                    CLEAR(RepQty);
                    CLEAR(RepQtyDes);
                    CLEAR(RepAmt);
                    //----------------

                    //Serial No.
                    CLEAR(RepSrNo);
                    IF "Service Line".Type = "Service Line".Type::"Begin-Total" THEN BEGIN
                        IF HeadingSrNo = '' THEN
                            HeadingSrNo := 'A'
                        ELSE BEGIN
                            SrNum += 1;
                            HeadingSrNo := FORMAT(SrNum);
                        END;
                        RepSrNo := HeadingSrNo;
                    END;
                    //-------------------------------------------------------------------


                    //NON LSM Group
                    IF "Service Line"."LSM Group" = FALSE THEN BEGIN
                        RepDesc := "Service Line".Description;
                        RepQty := "Service Line".Quantity;
                        RepAmt := "Service Line".Amount;
                        RepQtyDes := "Service Line"."Unit of Measure Code";
                    END;
                    //-----------------------------------------------------


                    //Skipping Items related lines
                    IF ("Service Line".Type <> "Service Line".Type::"Begin-Total") THEN
                        CurrReport.SKIP;
                    //--------------------------------------------------------------------


                    //LSM Group
                    IF ("Service Line"."LSM Group" = TRUE) AND ("Service Line".Type = "Service Line".Type::"Begin-Total") THEN BEGIN
                        RepDesc := "Service Line".Description;
                        RepQty := 0;
                        RepQtyDes := 'LSM';

                        CLEAR(LSMTotalAmt);
                        ServiceLineRec.RESET;
                        ServiceLineRec.SETCURRENTKEY(ServiceLineRec."Document Type", ServiceLineRec."Document No.", ServiceLineRec."Line No.");
                        ServiceLineRec.SETRANGE(ServiceLineRec."Document Type", "Service Line"."Document Type");
                        ServiceLineRec.SETRANGE(ServiceLineRec."Document No.", "Service Line"."Document No.");
                        ServiceLineRec.SETFILTER(ServiceLineRec."Line No.", '>%1', "Service Line"."Line No.");
                        IF ServiceLineRec.FINDSET THEN
                            REPEAT
                                LSMTotalAmt += ServiceLineRec.Amount;
                            UNTIL (ServiceLineRec.NEXT = 0) OR (ServiceLineRec.Type = ServiceLineRec.Type::"Begin-Total");

                        RepAmt := LSMTotalAmt;
                    END;
                    //----------------------------------------------------------------------------------------------------------------------
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //Amount Total
                CLEAR(TotalAmt);
                RecServiceLine.RESET;
                RecServiceLine.SETCURRENTKEY(RecServiceLine."Document Type", RecServiceLine."Document No.");
                RecServiceLine.SETRANGE(RecServiceLine."Document Type", "Service Header"."Document Type");
                RecServiceLine.SETRANGE(RecServiceLine."Document No.", "Service Header"."No.");
                RecServiceLine.SETRANGE(RecServiceLine."LSM Group", TRUE);
                IF RecServiceLine.FINDSET THEN
                    REPEAT
                        TotalAmt += RecServiceLine."Amount Including VAT";
                    UNTIL RecServiceLine.NEXT = 0;

                CLEAR(RepCheck);
                RepCheck.InitTextVariable;
                RepCheck.FormatNoText(AmtInWord, TotalAmt, "Service Header"."Currency Code");
                //--------------------------------------------------------------------------


                //Header Comments
                CLEAR(CommentTxt);
                ServiceCommentLine.RESET;
                ServiceCommentLine.SETRANGE("Table Name", ServiceCommentLine."Table Name"::"Service Header");
                ServiceCommentLine.SETRANGE("Table Subtype", 1);
                ServiceCommentLine.SETRANGE("Table Line No.", 0);
                ServiceCommentLine.SETRANGE(Type, ServiceCommentLine.Type::General);
                ServiceCommentLine.SETRANGE("No.", "Service Header"."No.");
                IF ServiceCommentLine.FINDSET THEN
                    REPEAT
                        i += 1;
                        CommentTxt[i] := ServiceCommentLine.Comment;
                    UNTIL (ServiceCommentLine.NEXT = 0) OR (i = 3);
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

    trigger OnInitReport()
    begin
        HeadingSrNo := '';
    end;

    trigger OnPreReport()
    begin
        CompInfo.GET();
        CompInfo.CALCFIELDS(Picture);
        TodayDate := WORKDATE;
    end;

    var
        CompInfo: Record 79;
        RepCheck: Report 1401;
        AmtInWord: array[2] of Text[80];
        RecServiceLine: Record 5902;
        HeadingSrNo: Code[10];
        RepSrNo: Code[10];
        RepDesc: Text[100];
        RepQty: Decimal;
        RepQtyDes: Text[10];
        RepAmt: Decimal;
        TotalAmt: Decimal;
        StringSrNo: Code[10];
        SrNum: Integer;
        Marking: Boolean;
        ServiceLineRec: Record 5902;
        LSMTotalAmt: Decimal;
        ServiceCommentLine: Record 5906;
        CommentTxt: array[3] of Text[80];
        i: Integer;
        TodayDate: Date;
}

