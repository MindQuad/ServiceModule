tableextension 50045 tableextension50045 extends "Service Contract Line"
{
    fields
    {


        //Unsupported feature: Code Insertion (VariableCollection) on ""Line Value"(Field 22).OnValidate".

        //trigger (Variable: OldServContractHeader)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Line Value"(Field 22).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Line Value" < 0 THEN
          FIELDERROR("Line Value");

        VALIDATE("Line Discount %");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..4

        GetServContractHeader;
        ServContractHeader."Annual Amount" := ServContractLine."Line Amount" + "Line Amount";
        ServContractHeader.VALIDATE("Invoice Period",ServContractHeader."Invoice Period");
        // ServContractHeader.MODIFY; // WIN210
        */
        //end;


        //Unsupported feature: Code Modification on ""Line Discount %"(Field 23).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        Currency.InitRoundingPrecision;
        "Line Value" := ROUND("Line Value",Currency."Amount Rounding Precision");
        #4..6
        "Line Discount Amount" :=
          ROUND("Line Value" - "Line Amount",Currency."Amount Rounding Precision");
        Profit := ROUND("Line Amount" - "Line Cost",Currency."Amount Rounding Precision");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..9
        //CalculatePDCAmount;  //win315

        //win315++
        ServMgtSetup.GET;
        IF "Line Discount %" >= ServMgtSetup."Renew Discount %" THEN BEGIN
          IF ServContractHeader.GET(Rec."Contract Type",Rec."Contract No.") THEN BEGIN
            ServContractHeader."Discount Hold" := TRUE;
            //ServContractHeader.VALIDATE(ServContractHeader."Invoice Period");
            // ServContractHeader.MODIFY; // WIN210
          END;
        END ELSE BEGIN
          ServContractHeader."Discount Hold" := FALSE;
          //ServContractHeader.VALIDATE(ServContractHeader."Invoice Period");
          // ServContractHeader.MODIFY; // WIN210
        END;
        //win315--

        {IF ServContractHeader1.GET(Rec."Contract Type",Rec."Contract No.") THEN BEGIN

            ServContractHeader1.VALIDATE(ServContractHeader1."Invoice Period");
            ServContractHeader1.MODIFY;
          END;}
        */
        //end;


        //Unsupported feature: Code Modification on ""Line Amount"(Field 24).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        TESTFIELD("Line Value");
        Currency.InitRoundingPrecision;
        "Line Discount Amount" := ROUND("Line Value" - "Line Amount",Currency."Amount Rounding Precision");
        "Line Discount %" := "Line Discount Amount" / "Line Value" * 100;
        Profit := ROUND("Line Amount" - "Line Cost",Currency."Amount Rounding Precision");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..6
        //CalculatePDCAmount;  //win315
        */
        //end;

        //Unsupported feature: Property Deletion (Editable) on ""Starting Date"(Field 29)".


        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            var
                ServMgtSetup: Record "Service Mgt. Setup";
                ServContractHeader: Record "Service Contract Header";
            begin
                ServMgtSetup.GET;
                IF "Line Discount %" >= ServMgtSetup."Renew Discount %" THEN BEGIN
                    IF ServContractHeader.GET(Rec."Contract Type", Rec."Contract No.") THEN BEGIN
                        ServContractHeader."Discount Hold" := TRUE;
                        //ServContractHeader.VALIDATE(ServContractHeader."Invoice Period");
                        // ServContractHeader.MODIFY; // WIN210
                    END;
                END ELSE BEGIN
                    ServContractHeader."Discount Hold" := FALSE;
                    //ServContractHeader.VALIDATE(ServContractHeader."Invoice Period");
                    // ServContractHeader.MODIFY; // WIN210
                END;
            end;
        }

        field(50000; Components; Boolean)
        {
        }
        field(50001; Deposit; Decimal)
        {
        }
        field(50002; Commission; Decimal)
        {
        }
        field(50003; "PDC amount"; Decimal)
        {
            Editable = false;
        }
        field(50004; "Contract Amount"; Decimal)
        {
        }
    }




    local procedure CalculatePDCAmount()
    var
        ServContractHdr: Record 5965;
        PDCAmt: Decimal;
        ServContractManagement: Codeunit 5940;
    begin
        ServContractHdr.RESET;
        ServContractHdr.SETRANGE(ServContractHdr."Contract Type", ServContractHdr."Contract Type"::Quote);
        ServContractHdr.SETRANGE(ServContractHdr."Contract No.", Rec."Contract No.");
        IF ServContractHdr.FINDFIRST THEN BEGIN
            //IF (ServContractHdr."No. of PDC" <> 0)THEN BEGIN
            //"PDC amount" := "Line Amount" / ServContractHdr."No. of PDC";
            //ServContractHdr.VALIDATE(ServContractHdr."Invoice Option");
            //RecPDCL.Amount := -(ServContractManagement.CalcContractLineAmount("Annual Amount","Starting Date","Expiration Date")) / ServContractHdr."No. of PDC";
            //ServContractHdr."Amount per Period" := ServContractManagement.CalcContractLineAmount(ServContractHdr."Annual Amount",ServContractHdr."Starting Date",ServContractHdr."Expiration Date");
            "Contract Amount" := ServContractManagement.CalcContractLineAmount("Line Amount", ServContractHdr."Starting Date", ServContractHdr."Expiration Date");
            ServContractHdr."VAT Amount" := (("Contract Amount" * 5) / 100);
            ServContractHdr."Contact Amt Incl VAT" := "Contract Amount" + ServContractHdr."VAT Amount";
            ServContractHdr.MODIFY;
            //END;
            //MESSAGE(FORMAT("PDC amount"));
        END;
    end;

    procedure GetServContractHeader()
    var

        ServContractHeader: Record "Service Contract Header";
    begin
        TESTFIELD("Contract No.");
        IF ("Contract Type" <> ServContractHeader."Contract Type") OR
           ("Contract No." <> ServContractHeader."Contract No.")
        THEN
            ServContractHeader.GET("Contract Type", "Contract No.");
    end;

    var
        OldServContractHeader: Record 5965;
        Deleting: Boolean;

    var
        ServContractHeader1: Record 5965;
}

