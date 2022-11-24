report 50506 "Lease Agreement"
{
    DefaultLayout = RDLC;
    // RDLCLayout = './LeaseAgreement.rdl';
    RDLCLayout = 'SourceCode/Report/LeaseAgreement.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Lease Agreement';
    ApplicationArea = All;
    UsageCategory = Documents;
    dataset
    {
        dataitem("Service Contract Header"; "Service Contract Header")
        {
            RequestFilterFields = "Contract Type", "Contract No.";
            column(ContractNo_ServiceContractHeader; "Service Contract Header"."Contract No.")
            {
            }
            column(ParkingNo_ServiceContractHeader; "Parking No.")
            {
            }
            column(OtherAmt; OtherAmt)
            {

            }
            column(VatAmt; VatAmt)
            {

            }
            column(SecurityDeposit; SecurityDeposit)
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
            column(Address_ServiceContractHeader; "Service Contract Header".Address)
            {
            }
            column(Address2_ServiceContractHeader; "Service Contract Header"."Address 2")
            {
            }
            column(PostCode_ServiceContractHeader; "Service Contract Header"."Post Code")
            {
            }
            column(City_ServiceContractHeader; "Service Contract Header".City)
            {
            }
            column(ServiceItemNo_ServiceContractHeader; "Service Contract Header"."Service Item No.")
            {
            }
            column(StartingDate_ServiceContractHeader; "Service Contract Header"."Starting Date")
            {
            }
            column(ExpirationDate_ServiceContractHeader; "Service Contract Header"."Expiration Date")
            {
            }
            column(BuildingNo_ServiceContractHeader; "Service Contract Header"."Building No.")
            {
            }
            column(UnitNo_ServiceContractHeader; "Service Contract Header"."Unit No.")
            {
            }
            column(PhoneNo_ServiceContractHeader; "Service Contract Header"."Phone No.")
            {
            }
            column(Email; "Service Contract Header"."E-Mail")
            {
            }
            column(name; CompInfo.Name)
            {
            }
            column(logo; CompInfo.Picture)
            {
            }
            column(VatRegiNo; CompInfo."VAT Registration No.")
            {
            }
            column(Email1; CompInfo."E-Mail")
            {
            }
            column(Phone; CompInfo."Phone No.")
            {
            }

            column(Emirates; CompInfo."Country/Region Code") { }
            column(Website; CompInfo."Home Page") { }
            column(PostCode; Compinfo."Post Code") { }
            column(AnnualAmount_ServiceContractHeader; "Service Contract Header"."Annual Amount")
            {
            }
            column(SD; SD)
            {
            }
            column(Commi; Commi)
            {
            }
            column(Dewa; Dewa)
            {
            }
            column(Munici; Munici)
            {
            }
            column(Admin; Admin)
            {
            }
            column(Parking; Parking)
            {
            }
            column(EC; EC)
            {

            }
            column(VAT; VAT)
            {
            }
            column(PaymentTermsCode_ServiceContractHeader; "Service Contract Header"."Payment Terms Code")
            {
            }
            column(CheckBox; CheckBox)
            {
            }
            column(DOA; DOA)
            {
            }
            column(Mobile; RecCust."Mobile Phone No.")
            {
            }
            column(EMINo; EMINo)
            {
            }
            column(User; username)
            {
            }
            column(TLExpitydate; RecCust."S/T Expiry Date")
            {
            }
            column(Emergency; RecCust."Emergency Contact Name")
            {
            }
            column(ServBuildingNo; ServBuildingNo) { }
            column(ContractDiscountAmount_ServiceContractHeader; "Contract Discount Amount")
            {
            }
            column(Remarks_ServiceContractHeader; Remarks)
            {
            }

            column(ServiceType; ServiceType) { }
            column(ContractGroupCode_ServiceContractHeader; "Contract Group Code")
            {
            }
            column(ServiceDesc; ServiceDesc) { }
            column(SerNoofBed; SerNoofBed) { }

            dataitem("Post Dated Check Line"; "Post Dated Check Line")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemTableView = SORTING("Template Name", "Batch Name", "Account Type", "Account No.", "Customer No.", "Line Number");
                // WHERE("Charge Code" = FILTER(''));
                column(CheckDate_PostDatedCheckLine; "Post Dated Check Line"."Check Date")
                {
                }
                column(CheckNo_PostDatedCheckLine; "Post Dated Check Line"."Check No.")
                {
                }
                column(Amount_PostDatedCheckLine; "Post Dated Check Line".Amount)
                {
                }
                column(PaymentMethod_PostDatedCheckLine; "Payment Method")
                {
                }
                column(ChargeDescription_PostDatedCheckLine; "Charge Description")
                {
                }

                column(SrNo; SrNo)
                {
                }
                column(DateReceived_PostDatedCheckLine; "Date Received")
                {
                }
                column(SrNo2; SrNo2)
                {

                }
                column(LineNumber_PostDatedCheckLine; "Line Number")
                {
                }
                column(ChargeCode_PostDatedCheckLine; "Charge Code")
                {
                }


                trigger OnAfterGetRecord()
                begin

                    if "Post Dated Check Line"."Payment Method" = "Post Dated Check Line"."Payment Method"::PDC
                    then begin
                        SrNo += 1;
                        //SrNo2 += 1;
                    end;
                    /* else
                         SrNo2 += 1;

                     if "Post Dated Check Line"."Payment Method" <> "Post Dated Check Line"."Payment Method"::PDC then begin

                         if "Post Dated Check Line"."Charge Code" = 'VAT' then
                             VatAmt += "Post Dated Check Line".Amount;
                         // OtherAmt := 0;
                         if "Post Dated Check Line"."Charge Code" <> 'SD' then
                             if "Post Dated Check Line"."Charge Code" <> 'VAT' then
                                 OtherAmt += "Post Dated Check Line".Amount;

                         if "Post Dated Check Line"."Charge Code" = 'SD' then
                             SecurityDeposit += "Post Dated Check Line".Amount;





                     end;*/


                    /*if "Post Dated Check Line".FindSet() then
                        repeat
                            if "Charge Code" = 'SD' then
                                SD := Amount
                            else
                                if "Charge Code" = 'COM' then
                                    Commi := Amount
                                else
                                    if "Charge Code" = 'VAT' then
                                        VAT := Amount
                                    else
                                        if "Charge Code" = 'ADMIN' then
                                            Admin := Amount
                                        ELSE
                                            IF "Charge Code" = 'CP' THEN
                                                Parking := Amount
                                            ELSE
                                                IF "Charge Code" = 'EC' THEN
                                                    EC := Amount;
                        UNTIL "Post Dated Check Line".Next() = 0;*/

                    RecServiceItem.Reset();
                    RecServiceItem.SetRange("Unit No.", "Post Dated Check Line"."Unit No.");
                    if RecServiceItem.FindFirst() then begin
                        ServBuildingNo := RecServiceItem."Building No.";
                        ServiceType := RecServiceItem.Type;
                        ServiceDesc := RecServiceItem.Description;
                        SerNoofBed := RecServiceItem."No. of Bedrooms";



                    end;


                end;
            }
            dataitem("Service Charges"; "Service Charges")
            {
                DataItemLink = "Service Contract No." = FIELD("Contract No.");
                column(Service_Contract_No_; "Service Contract No.")
                {

                }
                column(ChargeCode_ServiceCharges; "Charge Code")
                {
                }
                column(ChargeAmount_ServiceCharges; "Charge Amount")
                {
                }
                column(ChargeDate_ServiceCharges; "Charge Date")
                {
                }
                column(ChargeDescription_ServiceCharges; "Charge Description")
                {
                }


                trigger OnAfterGetRecord()
                begin
                    /*if "Post Dated Check Line"."Payment Method" = "Post Dated Check Line"."Payment Method"::PDC
                    then begin
                        SrNo += 1;
                        //SrNo2 += 1;
                    end
                    else*/
                    SrNo2 += 1;

                    /*if "Post Dated Check Line"."Payment Method" <> "Post Dated Check Line"."Payment Method"::PDC then begin

                        if "Post Dated Check Line"."Charge Code" = 'VAT' then
                            VatAmt += "Post Dated Check Line".Amount;
                        // OtherAmt := 0;
                        if "Post Dated Check Line"."Charge Code" <> 'SD' then
                            if "Post Dated Check Line"."Charge Code" <> 'VAT' then
                                OtherAmt += "Post Dated Check Line".Amount;

                        if "Post Dated Check Line"."Charge Code" = 'SD' then
                            SecurityDeposit += "Post Dated Check Line".Amount;*/



                    // if "Service Charges"."Charge Code" = 'VAT' then
                    //     VatAmt += "Service Charges"."Charge Amount";

                    // if "Service Charges"."Charge Code" = 'SD' then
                    //     SecurityDeposit += "Service Charges"."Charge Amount";

                    // if "Service Charges"."Charge Code" <> 'SD' then
                    //     if "Service Charges"."Charge Code" <> 'VAT' then
                    //         OtherAmt += "Service Charges"."Charge Amount";





                    //end;
                end;
            }
            dataitem("Contract TNC"; "Contract TNC")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemTableView = WHERE("Contact Type" = Filter('Contract'));


                column(ContactType_ContractTNC; "Contact Type")
                {
                }
                column(ContractNo_ContractTNC; "Contract No.")
                {
                }
                column(TNCCode_ContractTNC; "TNC Code")
                {
                }
                column(TNCType_ContractTNC; "TNC Type")
                {
                }
                column(TNCEnglish; TNCEnglish) { }
                column(TNCArabic; TNCArabic) { }
                trigger OnAfterGetRecord()
                begin
                    RecTNCMaster.Reset();
                    RecTNCMaster.SetRange(RecTNCMaster."TNC Code", "TNC Code");
                    if RecTNCMaster.FindSet() then begin
                        TNCEnglish := RecTNCMaster."English Description ";
                        TNCArabic := RecTNCMaster."Arabic Description";
                    end;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                DOA := WORKDATE;

                //Parking:=0;;
                ServiceCharges.RESET;
                ServiceCharges.SETRANGE(ServiceCharges."Service Contract Quote No.", "Service Contract Header"."Contract No.");
                IF ServiceCharges.FINDSET THEN
                    REPEAT
                        IF ServiceCharges."Charge Code" = 'SD' THEN
                            SD := ServiceCharges."Charge Amount"
                        ELSE
                            IF ServiceCharges."Charge Code" = 'COM' THEN
                                Commi := ServiceCharges."Charge Amount"
                            ELSE
                                IF ServiceCharges."Charge Code" = 'VAT' THEN
                                    VAT := ServiceCharges."Charge Amount"
                                ELSE
                                    IF ServiceCharges."Charge Code" = 'ADMIN' THEN
                                        Admin := ServiceCharges."Charge Amount"
                                    ELSE
                                        IF ServiceCharges."Charge Code" = 'CP' THEN
                                            Parking := ServiceCharges."Charge Amount"
                                        ELSE
                                            IF ServiceCharges."Charge Code" = 'EC' THEN
                                                EC := ServiceCharges."Charge Amount";
                    UNTIL ServiceCharges.NEXT = 0;


                SecurityDeposit := SD;
                OtherAmt := Commi + VAT + Admin + Parking + EC;
                VatAmt := VAT;

                IF "Service Contract Header"."Service Quote Type" = "Service Contract Header"."Service Quote Type"::"New Contract" THEN
                    CheckBox := TRUE
                ELSE
                    CheckBox := FALSE;

                RecCust.RESET;
                RecCust.SETRANGE(RecCust."No.", "Service Contract Header"."Customer No.");
                IF RecCust.FINDFIRST THEN;

                EMINo := '';
                DocArti.RESET;
                DocArti.SETRANGE(DocArti."Issued To", "Service Contract Header"."Contact No.");
                IF DocArti.FINDFIRST THEN BEGIN
                    IF DocArti."Confidential Code" = 'EID' THEN
                        EMINo := DocArti."Document No";
                END;

                IF UserSetup.GET(USERID) THEN;

                user.RESET;
                user.SETRANGE(user."User Name", UserSetup."User ID");
                IF user.FINDFIRST THEN
                    username := user."Full Name";

                /*RecServiceItem.Reset();
                RecServiceItem.SetRange("No.", "Service Contract Header"."Unit No.");
                if RecServiceItem.FindFirst() then begin
                    ServBuildingNo := RecServiceItem."Building No.";
                    ServiceType := RecServiceItem.Type;
                    ServiceDesc := RecServiceItem.Description;
                    SerNoofBed := RecServiceItem."No. of Bedrooms";
                    


                end;*/



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
    end;

    var
        CompInfo: Record 79;
        SrNo: Integer;
        SrNo2: Integer;
        ServiceCharges: Record "Service Charges";
        RecTNCMaster: Record "TNC Master";
        TNCEnglish: Text[2048];
        TNCArabic: Text[2048];
        SD: Decimal;
        EC: Decimal;
        OtherAmt: Decimal;
        VatAmt: Decimal;
        CarParkingNo: Text;
        SecurityDeposit: Decimal;
        Commi: Decimal;
        Dewa: Decimal;
        Munici: Decimal;
        Admin: Decimal;
        Parking: Decimal;
        SerConHdr: Record "Service Contract Header";
        RecServiceItem: Record "Service Item";
        ServiceType: Option;
        ServiceDesc: Text;
        ServBuildingNo: Code[20];
        SerNoofBed: Option;
        CheckBox: Boolean;
        DOA: Date;
        RecCust: Record Customer;
        DocArti: Record 50009;
        EMINo: Code[20];
        user: Record 2000000120;
        UserSetup: Record 91;
        username: Text[50];
        VAT: Decimal;


}

