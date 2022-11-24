report 50011 "Lease Application Form1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LeaseApplicationForm1.rdl';
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
            dataitem("Post Dated Check Line"; "Post Dated Check Line")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemTableView = SORTING("Template Name", "Batch Name", "Account Type", "Account No.", "Customer No.", "Line Number")
                                    WHERE("Charge Code" = FILTER(''));
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

                trigger OnAfterGetRecord()
                begin
                    SrNo += 1;
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
                                            Parking := ServiceCharges."Charge Amount";
                    UNTIL ServiceCharges.NEXT = 0;


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
        ServiceCharges: Record "Service Charges";
        SD: Decimal;
        Commi: Decimal;
        Dewa: Decimal;
        Munici: Decimal;
        Admin: Decimal;
        Parking: Decimal;
        SerConHdr: Record 5965;
        CheckBox: Boolean;
        DOA: Date;
        RecCust: Record 18;
        DocArti: Record 50009;
        EMINo: Code[20];
        user: Record 2000000120;
        UserSetup: Record 91;
        username: Text[50];
        VAT: Decimal;
}

