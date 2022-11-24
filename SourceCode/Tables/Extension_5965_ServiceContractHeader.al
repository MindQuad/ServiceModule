tableextension 50056 "Service Contract Header Ext" extends "Service Contract Header"
{
    fields
    {
        field(50000; "Defferal Code"; Code[10])
        {
            Caption = 'Defferal Code';
            TableRelation = "Deferral Template"."Deferral Code" WHERE("Invoice Period" = FIELD("Invoice Period"));
            ValidateTableRelation = true;
        }
        field(50001; "Service Item No."; Code[20])
        {
            Caption = 'Service Item No.';
            TableRelation = "Service Item" WHERE("Building No." = FIELD("Building No."), "Occupancy Status" = FILTER(Vacant), "Primary Unit No." = filter(''));

            trigger OnValidate()
            //Win513++
            var
                DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
                DimMgt: Codeunit DimensionManagement;
            //Win513--
            begin
                IF (Rec."Service Item No." <> xRec."Service Item No.") THEN BEGIN
                    IF "Service Item No." <> '' THEN BEGIN
                        IF ServItem.GET("Service Item No.") THEN BEGIN
                            ServItem.TESTFIELD("Building No.");
                            ServItem.TESTFIELD("No.");
                            "Building No." := ServItem."Building No.";
                            "Unit No." := ServItem."Unit No.";
                            IF ServItem."VAT Prod. Posting Group" <> '' THEN BEGIN
                                VALIDATE("VAT Prod. Posting Group", ServItem."VAT Prod. Posting Group");
                                //IF ServItem."Customer No." <> '' THEN BEGIN
                                //VALIDATE("Customer No.",ServItem."Customer No.");           //win315
                                MODIFY;
                                COMMIT;
                            END ELSE //BEGIN
                                ERROR('VAT Prod posting should not be blank for Service Item %1', ServItem."No.");   //win315

                        END
                    END ELSE
                        CLEAR("Unit No.");
                    IF "Service Item No." = '' THEN BEGIN
                        CLEAR("VAT Prod. Posting Group");
                    END;
                    UpdateServiceItemWithCustomer();
                    CreateServiceOrderLines; //WIN315
                END;
                //Win513++
                // // WIN210 Temp
                // CreateDim(
                //   DATABASE::Customer, "Bill-to Customer No.",
                //   DATABASE::"Service Item", "Service Item No.",
                //   DATABASE::"Responsibility Center", "Responsibility Center",
                //   DATABASE::"Service Contract Template", "Template No.",
                //   DATABASE::"Service Order Type", "Service Order Type");
                // // WIN210 Temp
                // WIN210 Temp

                DimMgt.AddDimSource(DefaultDimSource, Database::Customer, "Bill-to Customer No.");
                DimMgt.AddDimSource(DefaultDimSource, DATABASE::"Service Item", "Service Item No.");
                DimMgt.AddDimSource(DefaultDimSource, DATABASE::"Responsibility Center", "Responsibility Center");
                DimMgt.AddDimSource(DefaultDimSource, DATABASE::"Service Contract Template", "Template No.");
                DimMgt.AddDimSource(DefaultDimSource, DATABASE::"Service Order Type", "Service Order Type");

                CreateDim(DefaultDimSource);
                // WIN210 Temp

                //Win513--
            end;
        }
        field(50002; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(50003; "Special Condition"; Text[250])
        {
            Caption = 'Special Condition';

        }
        field(50004; "Building No."; Code[20])
        {
            Caption = 'Building No.';
            TableRelation = Building;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::" ");
                building.GET("Building No.");
                "Building Name" := building.Description;
                Rec.VALIDATE("Serv. Contract Acc. Gr. Code", building."Serv. Contract Acc. Gr. Code");
                //WIN325
                IF (Rec."Building No." <> xRec."Building No.") THEN
                    IF Rec."Building No." = '' THEN BEGIN
                        VALIDATE("Unit No.", '');
                        VALIDATE("Service Item No.", '');
                    END;
            end;
        }
        field(50005; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = IF ("Tenancy Type" = CONST(Residential)) "Service Item"."Unit No." WHERE("Building No." = FIELD("Building No."), "Occupancy Status" = FILTER(Vacant), "VAT Prod. Posting Group" = FILTER('NO VAT'), "Primary Unit No." = filter('')) ELSE
            IF ("Tenancy Type" = CONST(Commercial)) "Service Item"."Unit No." WHERE("Building No." = FIELD("Building No."), "Occupancy Status" = FILTER(Vacant), "VAT Prod. Posting Group" = FILTER('VAT-5'), "Primary Unit No." = filter(''));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF (Rec."Unit No." <> xRec."Unit No.") THEN
                    IF "Unit No." <> '' THEN BEGIN
                        ServItem1.RESET;
                        ServItem1.SETRANGE("Building No.", "Building No.");
                        ServItem1.SETRANGE("Unit No.", "Unit No.");
                        //ServItem1.SETRANGE("Unit Purpose", ServItem1."Unit Purpose"::"Rental Unit");
                        IF ServItem1.FINDSET THEN
                            VALIDATE("Service Item No.", ServItem1."No.")
                        ELSE
                            VALIDATE("Service Item No.", '');
                    END ELSE
                        VALIDATE("Service Item No.", '');
            end;

        }
        field(50006; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            Editable = false;
        }
        field(50007; "Service Contract Type"; Option)
        {
            Caption = 'Service Contract Type';
            OptionMembers = " ",Internal,External;
            OptionCaption = ' ,Internal,External';
        }
        field(50008; "Contract Period"; DateFormula)
        {
            Caption = 'Contract Period';
            trigger OnValidate()
            begin
                //win start
                IF FORMAT("Contract Period") <> '' THEN
                    "Expiration Date" := (CALCDATE("Contract Period", "Starting Date") - 1)
                ELSE
                    "Expiration Date" := 0D;
                //win end

            end;

        }
        field(50009; "Created Datetime"; DateTime)
        {
            Caption = 'Created Datetime';
        }
        field(50010; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(50011; "Signature Datetime"; DateTime)
        {
            Caption = 'Signature Datetime';

        }
        field(50012; "Signed By"; Code[50])
        {
            Caption = 'Signed By';

        }
        field(50013; "Below Min Price"; Boolean)
        {
            Caption = 'Below Min Price';
            Editable = false;
        }
        field(50014; "Clearance No."; Text[50])
        {
            Caption = 'Clearance No.';

        }
        field(50015; "Clearance Date"; Date)
        {
            Caption = 'Clearance Date';
        }
        field(50016; "Proceed for Cancellation"; Boolean)
        {
            Caption = 'Proceed for Cancellation';
            Editable = false;
        }
        field(50017; "Cancellation Datetime"; DateTime)
        {
            Caption = 'Cancellation Datetime';
            Editable = false;
        }
        field(50018; "Cancelled By"; Code[50])
        {
            Caption = 'Cancelled By';
            Editable = false;
        }
        field(50019; "Penalty Applicable"; Boolean)
        {
            Caption = 'Penalty Applicable';
            Editable = false;
        }
        field(50020; "Short Close days"; Integer)
        {
            Caption = 'Short Close days';
            Editable = false;
        }
        field(50021; "Penalty Amount"; Decimal)
        {
            Caption = 'Penalty Amount';
            Editable = false;
        }
        field(50022; "Status Description"; Text[250])
        {
            Caption = 'Status Description';

        }
        field(50023; Tenant; Code[10])
        {
            Caption = 'Tenant';
            TableRelation = Contact."No." WHERE("No." = FIELD("Contact No."), Type = FILTER(Person));

            trigger OnValidate()
            begin
                IF ("Customer No." <> xRec."Customer No.") OR
                 ("Ship-to Code" <> xRec."Ship-to Code")
                THEN BEGIN
                    IF ContractLinesExist THEN BEGIN
                        ERROR(Text011, FIELDCAPTION("Ship-to Code"));

                    END;
                    UpdateServZone;
                END;

            end;
        }
        field(50024; "Tenant Name"; Text[100])
        {
            Caption = 'Tenant Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Contact No.")));
            Editable = false;
        }
        field(50042; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."No. 2" WHERE("No." = FIELD("Item No.")));
        }
        field(50050; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50052; Charges; Decimal)
        {
            Caption = 'Charges';
        }
        field(50053; Terminated; Boolean)
        {
            Caption = 'Terminated';
        }
        field(50054; "Termination Date"; Date)
        {
            Caption = 'Termination Date';

            trigger OnValidate()
            var

                ServContractManagement: Codeunit ServContractManagement;
                ServiceMgtSetup: Record "Service Mgt. Setup";
            begin
                //win315++
                // "Actual Utilized Rent Amount" := (((("Termination Date" - "Starting Date") +1) / 365 ) * "Annual Amount");
                ServiceMgtSetup.GET;
                // ServiceMgtSetup.TESTFIELD("Penalty Month");
                "Actual Utilized Rent Amount" := ServContractManagement.CalcContractLineAmount("Annual Amount", "Starting Date", "Termination Date");
                // "Penalty Amount" := (("Annual Amount" / 365) * 60);
                "Penalty Amount" := (("Annual Amount" / 12) * ServiceMgtSetup."Penalty Month");
                //win315--
            end;
        }
        field(50055; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(50056; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
        }
        field(50057; "Contract Document Status"; Option)
        {
            Caption = 'Contract Document Status';
            OptionMembers = " ",Expired,Occupied,"Pending Renewal";
            OptionCaption = ' ,Expired,Occupied,Pending Renewal';
        }
        field(50058; "No. of Cheque"; Integer)
        {
            Caption = 'No. of Cheque';

        }
        field(50059; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(50060; "Mode of Payment"; Code[10])
        {
            Caption = 'Mode of Payment';
            TableRelation = "Payment Method";
        }
        field(50061; "PDC Entry Generated"; Boolean)
        {
            Caption = 'PDC Entry Generated';

        }
        field(50062; "PDC amount"; Decimal)
        {
            Caption = 'PDC amount';
        }
        field(50063; "No. of PDC"; Integer)
        {
            Caption = 'No. of PDC';
            Editable = false;
        }
        field(50064; "Service Period Expiry Date"; Date)
        {
            Caption = 'Service Period Expiry Date';

        }
        field(50065; "Service Quote Type"; Option)

        {
            Caption = 'Service Quote Type';
            OptionMembers = "New Contract",Renewal,Closing;
            OptionCaption = 'New Contract,Renewal,Closing';
            Editable = false;
        }
        field(50066; "Discount Hold"; Boolean)
        {
            Caption = 'Discount Hold';
            Editable = false;
        }
        field(50067; "Termination Reason Code"; Code[20])
        {
            Caption = 'Termination Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(50068; "Penalty Amount Days"; Text[30])
        {
            Caption = 'Penalty Amount Days';
        }
        field(50069; "Actual Utilized Rent Amount"; Decimal)
        {
            Caption = 'Actual Utilized Rent Amount';
            Editable = false;
        }
        field(50070; "Contract Closing Date"; Date)
        {
            Caption = 'Contract Closing Date';
        }
        field(50071; "Contract Closed"; Boolean)
        {
            Caption = 'Contract Closed';
        }
        field(50072; "Previous Contract No."; Code[20])
        {
            Caption = 'Previous Contract No.';
            Editable = false;
        }
        field(50073; "Credit Memo Posted"; Boolean)
        {
            Caption = 'Credit Memo Posted';

        }
        field(50074; "Renewal Contract"; Boolean)
        {
            Caption = 'Renewal Contract';
        }
        field(50075; "Cash Amount"; Decimal)
        {
            Caption = 'Cash Amount';

            trigger OnValidate()
            begin
                TESTFIELD("No. of Cheque");
            end;
        }
        field(50076; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Building."Bank Account No." WHERE(Code = FIELD("Building No.")));
        }
        field(50077; "Deal Closing Date"; Date)
        {
            Caption = 'Deal Closing Date';
        }
        field(50078; "No. of Credit Memo Posted"; Integer)
        {
            Caption = 'No. of Credit Memo Posted';
            FieldClass = FlowField;
            CalcFormula = Count("Service Cr.Memo Header" WHERE("Customer No." = FIELD("Customer No.")));
            Editable = false;
        }
        field(50079; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."VAT Bus. Posting Group");
            Editable = false;
        }
        field(50080; "Tenancy Type"; Option)
        {
            Caption = 'Tenancy Type';
            OptionMembers = " ",Residential,Commercial;
            OptionCaption = '  ,Residential,Commercial';
        }
        field(50081; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
        }
        field(50082; "No. Series1"; Code[20])
        {
            Caption = 'No. Series1';
            TableRelation = "No. Series";
            Editable = false;
        }
        field(50083; "No. Series2"; Code[20])
        {
            Caption = 'No. Series2';
            TableRelation = "No. Series";
        }
        field(50084; "Renewal Contract No."; Code[20])
        {
            Caption = 'Renewal Contract No.';

        }
        field(50085; "Contact Amt Incl VAT"; Decimal)
        {
            Caption = 'Contact Amt Incl VAT';
            Editable = false;
        }
        field(50101; "Invoice Generation"; Option)
        {
            Caption = 'Invoice Generation';
            OptionCaption = ' ,Single Invoice,Multiple Invoice';
            OptionMembers = " ","Single Invoice","Multiple Invoice";
        }
        field(50102; "Invoice Option"; Option)
        {
            Caption = 'Invoice Option';
            OptionMembers = Calendar,Actual;
            OptionCaption = 'Calendar,Actual';
            Editable = false;

            trigger OnValidate()
            begin
                //>>WIN-SC001
                IF (xRec."Expiration Date" = 0D) AND ("Expiration Date" <> 0D) THEN BEGIN
                    ServLedgEntry.RESET;
                    ServLedgEntry.SETRANGE(Type, ServLedgEntry.Type::"Service Contract");
                    ServLedgEntry.SETRANGE("No.", "Contract No.");
                    IF ServLedgEntry.FINDSET THEN
                        ERROR(Text123, FIELDCAPTION("Invoice Option"), "Contract No.");
                END;
                //<<WIN
                //JACK --
                IF "Invoice Option" = "Invoice Option"::Actual THEN BEGIN
                    VALIDATE("Next Invoice Date", "Starting Date");
                    CASE "Invoice Period" OF
                        "Invoice Period"::Month:
                            BEGIN
                                "Amount per Period" := "Amount per month";
                                "Service Period In months" := 1;
                            END;
                        "Invoice Period"::"Two Months":
                            BEGIN
                                "Amount per Period" := "Amount per month" * 2;
                                "Service Period In months" := 2;
                            END;
                        "Invoice Period"::Quarter:
                            BEGIN
                                "Amount per Period" := "Amount per month" * 3;
                                "Service Period In months" := 3;
                            END;
                        "Invoice Period"::"Half Year":
                            BEGIN
                                "Amount per Period" := "Amount per month" * 6;
                                "Service Period In months" := 6;
                            END;
                        "Invoice Period"::Year:
                            BEGIN
                                "Amount per Period" := "Amount per month" * 12;
                                "Service Period In months" := 12;
                            END;
                        "Invoice Period"::Other:
                            BEGIN  // WIN210 // For contract more that 1 Year            //win-271119++
                                TESTFIELD("Starting Date");
                                TESTFIELD("Expiration Date");
                                CALCFIELDS("Calcd. Annual Amount");
                                "Amount per Period" := ROUND(ServContractMgt.CalcContractLineAmount("Calcd. Annual Amount", "Starting Date", "Expiration Date"), 0.01);
                                "Service Period In months" := FindNoOfMonths("Starting Date", "Expiration Date");   //win-271119--
                            END;
                        "Invoice Period"::None:
                            "Amount per Period" := 0;
                    END;
                END ELSE
                    IF Prepaid THEN
                        VALIDATE("Next Invoice Date", CALCDATE('<-CM+1M>', "Starting Date"));
                //JACK ++
            end;
        }
        field(50103; "Amount per month"; Decimal)
        {
            Caption = 'Amount per month';
        }
        field(50104; "Service Period In months"; Decimal)
        {
            Caption = 'Service Period In months';

        }
        field(50105; "Defferral Invoice Posted"; Boolean)
        {
            Caption = 'Defferral Invoice Posted';

        }
        field(50106; "Closing Contract No."; Code[20])
        {
            Caption = 'Closing Contract No.';
        }
        field(50107; "Parking No."; Text[30])
        {
            Caption = 'Parking No.';
        }
        field(50108; "Building Name"; Text[50])
        {
            Caption = 'Building Name';
        }
        field(50109; "Contract Status"; Option)
        {
            Caption = 'Contract Status';
            OptionMembers = Pending,"In Process",Processed,"On Hold",Cancelled,Expired;
            OptionCaption = 'Pending,In Process,Processed,On Hold,Cancelled,Expired';
        }
        field(50110; "Assigned User ID"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                UserSetupMgt: Codeunit "User Setup Management";
                RespCenter: Record "Responsibility Center";
                Text061: Label 'The annual amount difference has been distributed and one or more contract lines have zero or less in the %1 fields.\You can enter an amount in the %1 field.';
            begin
                IF NOT AllSubs.CheckRespCenter2(0, "Responsibility Center", "Assigned User ID") THEN
                    ERROR(
                      Text061, "Assigned User ID",
                      RespCenter.TABLECAPTION, AllSubs.GetSalesFilter2("Assigned User ID"));
            end;

        }

        Field(50111; "Work Description"; Text[250])
        {
            Caption = 'Work Description';
        }
        field(50112; "Contract Current Status"; Option)
        {

            OptionMembers = " ",Terminated,Expired,Closed;
            OptionCaption = ' ,Terminated,Expired,Closed';

        }

        modify("Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;

            begin
                Cust.get("Customer No.");
                VALIDATE("Building No.", Cust."Building No.");
                "Tenancy Type" := Cust."Tenancy Type";


                VALIDATE("Invoice after Service", FALSE);
                VALIDATE("Invoice Option", "Invoice Option"::Actual);
                "Invoice after Service" := FALSE;
                "Automatic Credit Memos" := FALSE;
                "Combine Invoices" := FALSE;
                "Contract Lines on Invoice" := TRUE;
                "Allow Unbalanced Amounts" := FALSE;

            end;


        }
        modify("Invoice Period")
        {
            trigger OnAfterValidate()
            var
                ServLedgEntry: Record "Service Ledger Entry";

                Text123: Label 'You can not change %1 of %2 because one or more service ledger entries exist for this contract';

                Text041: Label '%1 cannot be changed to %2 because this %3 has been invoiced';
            begin
                IF (xRec."Expiration Date" = 0D) AND ("Expiration Date" <> 0D) THEN BEGIN
                    ServLedgEntry.RESET;
                    ServLedgEntry.SETRANGE(Type, ServLedgEntry.Type::"Service Contract");
                    ServLedgEntry.SETRANGE("No.", "Contract No.");
                    IF ServLedgEntry.FINDSET THEN
                        ERROR(Text123, FIELDCAPTION("Invoice Period"), "Contract No.");
                END;
                IF "Invoice Option" = "Invoice Option"::Calendar THEN BEGIN
                end;

                IF "Invoice Period" = "Invoice Period"::None THEN begin
                    "Amount per month" := 0;
                end;



                "Amount per month" := "Annual Amount" / 12;

                IF "Invoice Option" = "Invoice Option"::Actual THEN BEGIN
                    IF ("Invoice Period" = "Invoice Period"::None) AND
                        ("Last Invoice Date" <> 0D)
                    THEN
                        ERROR(Text041,
                          FIELDCAPTION("Invoice Period"),
                          FORMAT("Invoice Period"),
                          TABLECAPTION);

                    IF "Invoice Period" = "Invoice Period"::None THEN BEGIN
                        "Amount per Period" := 0;
                        "Next Invoice Date" := 0D;
                        "Next Invoice Period Start" := 0D;
                        "Next Invoice Period End" := 0D;
                        "Amount per month" := 0;
                    END ELSE
                        IF Prepaid THEN BEGIN
                            TESTFIELD("Starting Date");
                            IF ("Last Invoice Date" = 0D) THEN
                                VALIDATE("Next Invoice Date", CALCDATE('<1M>', "Starting Date"))
                            ELSE
                                VALIDATE("Next Invoice Date", CALCDATE('<1D>', "Last Invoice Date"));

                            IF ("Expiration Date" <> 0D) AND ("Last Invoice Date" >= "Expiration Date") THEN
                                VALIDATE("Next Invoice Date", 0D);
                        END;

                    IF "Invoice Period" <> "Invoice Period"::None THEN BEGIN
                        "Amount per month" := "Annual Amount" / 12;
                        //"Monthly Fee" := "Annual Amount"/12;
                    END;
                    IF ("Last Invoice Date" = 0D) THEN
                        VALIDATE("Invoice Option");
                END;


                IF "Invoice Option" = "Invoice Option"::Actual THEN BEGIN
                    CASE "Invoice Period" OF
                        "Invoice Period"::Month:
                            BEGIN
                                "Amount per Period" := "Amount per month";
                                "Service Period In months" := 1;
                                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN
                                    "VAT Amount" := (("Amount per Period" * 5) / 100)
                                ELSE
                                    "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                        "Invoice Period"::"Two Months":
                            BEGIN
                                "Amount per Period" := "Amount per month" * 2;
                                "Service Period In months" := 2;
                                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN
                                    "VAT Amount" := (("Amount per Period" * 5) / 100)
                                ELSE
                                    "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                        "Invoice Period"::Quarter:
                            BEGIN
                                "Amount per Period" := "Amount per month" * 3;
                                "Service Period In months" := 3;
                                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN
                                    "VAT Amount" := (("Amount per Period" * 5) / 100)
                                ELSE
                                    "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                        "Invoice Period"::"Half Year":
                            BEGIN
                                "Amount per Period" := "Amount per month" * 6;
                                "Service Period In months" := 6;
                                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN
                                    "VAT Amount" := (("Amount per Period" * 5) / 100)
                                ELSE
                                    "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                        "Invoice Period"::Year:
                            BEGIN
                                "Amount per Period" := "Amount per month" * 12;
                                "Service Period In months" := 12;
                                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN
                                    "VAT Amount" := (("Amount per Period" * 5) / 100)
                                ELSE
                                    "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                        "Invoice Period"::Other:
                            BEGIN
                                TESTFIELD("Starting Date");
                                TESTFIELD("Expiration Date");
                                // "Amount per Period" := "Amount per month" * FindNoOfMonths("Starting Date","Expiration Date");
                                CALCFIELDS("Calcd. Annual Amount");
                                "Amount per Period" := ROUND(ServContractMgt.CalcContractLineAmount("Calcd. Annual Amount", "Starting Date", "Expiration Date"), 0.01);
                                "Service Period In months" := FindNoOfMonths("Starting Date", "Expiration Date");
                                IF "Tenancy Type" = "Tenancy Type"::Commercial THEN
                                    "VAT Amount" := (("Amount per Period" * 5) / 100)
                                ELSE
                                    "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                        "Invoice Period"::None:
                            BEGIN
                                "Amount per Period" := 0;
                                "VAT Amount" := 0;
                                "Contact Amt Incl VAT" := "Amount per Period" + "VAT Amount";
                            END;
                    END;
                END;

                IF "Invoice Period" <> xRec."Invoice Period" THEN
                    "Defferal Code" := '';

            End;
        }

        modify("Last Invoice Date")
        {
            trigger OnAfterValidate()
            begin
                IF "Invoice Option" = "Invoice Option"::Calendar THEN BEGIN
                    TESTFIELD("Starting Date");

                    InvDays := 0;
                    IF "Expiration Date" <> 0D THEN
                        InvDays := "Expiration Date" - "Starting Date";

                    IF "Last Invoice Date" = 0D THEN
                        IF Prepaid THEN
                            TempDate := CALCDATE('<-1D-CM>', "Starting Date")
                        ELSE
                            TempDate := CALCDATE('<-1D+CM>', "Starting Date")
                    ELSE
                        TempDate := "Last Invoice Date";
                    CASE "Invoice Period" OF
                        "Invoice Period"::Month:
                            BEGIN
                                "Next Invoice Date" := CALCDATE('<1M>', TempDate);
                                "Service Period In months" := 1;
                            END;
                        "Invoice Period"::"Two Months":
                            BEGIN
                                "Next Invoice Date" := CALCDATE('<2M>', TempDate);
                                "Service Period In months" := 2;
                            END;
                        "Invoice Period"::Quarter:
                            BEGIN
                                "Next Invoice Date" := CALCDATE('<3M>', TempDate);
                                "Service Period In months" := 3;
                            END;
                        "Invoice Period"::"Half Year":
                            BEGIN
                                "Next Invoice Date" := CALCDATE('<6M>', TempDate);
                                "Service Period In months" := 6;
                            END;
                        "Invoice Period"::Year:
                            BEGIN
                                "Next Invoice Date" := CALCDATE('<12M>', TempDate);
                                "Service Period In months" := 12;
                            END;
                        "Invoice Period"::None:
                            IF Prepaid THEN
                                "Next Invoice Date" := 0D;
                        "Invoice Period"::Other:
                            "Next Invoice Date" := CALCDATE('<' + FORMAT(InvDays) + 'D' + '>', TempDate);
                    END;
                    IF NOT Prepaid AND ("Next Invoice Date" <> 0D) THEN
                        "Next Invoice Date" := CALCDATE('<CM>', "Next Invoice Date");

                    IF ("Last Invoice Date" <> 0D) AND ("Last Invoice Date" <> xRec."Last Invoice Date") THEN
                        IF Prepaid THEN
                            VALIDATE("Last Invoice Period End", "Next Invoice Period End")
                        ELSE
                            VALIDATE("Last Invoice Period End", "Last Invoice Date");

                    VALIDATE("Next Invoice Date");


                END ELSE
                    IF "Invoice Option" = "Invoice Option"::Actual THEN BEGIN
                        TESTFIELD("Starting Date");
                        IF "Last Invoice Date" = 0D THEN
                            TempDate := "Starting Date"
                        ELSE
                            TempDate := "Last Invoice Date";
                        CASE "Invoice Period" OF
                            "Invoice Period"::Month:
                                BEGIN
                                    "Next Invoice Date" := CALCDATE('<1M>', TempDate);
                                    "Service Period In months" := 1;
                                END;
                            "Invoice Period"::"Two Months":
                                BEGIN
                                    "Next Invoice Date" := CALCDATE('<2M>', TempDate);
                                    "Service Period In months" := 2;
                                END;
                            "Invoice Period"::Quarter:
                                BEGIN
                                    "Next Invoice Date" := CALCDATE('<3M>', TempDate);
                                    "Service Period In months" := 3;
                                END;
                            "Invoice Period"::"Half Year":
                                BEGIN
                                    "Next Invoice Date" := CALCDATE('<6M>', TempDate);
                                    "Service Period In months" := 6;
                                END;
                            "Invoice Period"::Year:
                                BEGIN
                                    "Next Invoice Date" := CALCDATE('<12M>', TempDate);
                                    "Service Period In months" := 12;
                                END;
                            "Invoice Period"::Other:
                                BEGIN
                                    TESTFIELD("Starting Date");
                                    TESTFIELD("Expiration Date");
                                    "Next Invoice Date" := CALCDATE('<' + FORMAT(InvDays) + 'D>', TempDate);
                                    "Service Period In months" := FindNoOfMonths("Starting Date", "Expiration Date");
                                END;
                            "Invoice Period"::None:
                                IF Prepaid THEN
                                    "Next Invoice Date" := 0D;
                        END;
                        IF ("Last Invoice Date" <> 0D) AND ("Last Invoice Date" <> xRec."Last Invoice Date") THEN
                            IF Prepaid THEN
                                VALIDATE("Last Invoice Period End", "Next Invoice Period End")
                            ELSE
                                VALIDATE("Last Invoice Period End", "Last Invoice Date");
                        VALIDATE("Next Invoice Date");

                    END;
            end;
        }

        modify("Next Invoice Date")
        {
            trigger OnAfterValidate()
            begin
                IF "Invoice Option" = "Invoice Option"::Calendar THEN BEGIN //JACK  //Win355
                    IF "Next Invoice Date" = 0D THEN BEGIN
                        "Next Invoice Period Start" := 0D;
                        "Next Invoice Period End" := 0D;
                        EXIT;
                    END;
                    IF "Last Invoice Date" <> 0D THEN
                        IF "Last Invoice Date" > "Next Invoice Date" THEN BEGIN
                            ServLedgEntry.RESET;
                            ServLedgEntry.SETCURRENTKEY(Type, "No.", "Entry Type", "Moved from Prepaid Acc.", "Posting Date", Open);
                            ServLedgEntry.SETRANGE(Type, ServLedgEntry.Type::"Service Contract");
                            ServLedgEntry.SETRANGE("No.", "Contract No.");
                            IF ServLedgEntry.FINDFIRST THEN
                                ERROR(Text023, FIELDCAPTION("Next Invoice Date"), FIELDCAPTION("Last Invoice Date"));
                            "Last Invoice Date" := 0D;
                        END;

                    IF "Next Invoice Date" < "Starting Date" THEN
                        ERROR(Text024, FIELDCAPTION("Next Invoice Date"), FIELDCAPTION("Starting Date"));

                    IF Prepaid THEN BEGIN
                        IF "Next Invoice Date" <> CALCDATE('<-CM>', "Next Invoice Date") THEN
                            ERROR(Text026, FIELDCAPTION("Next Invoice Date"));
                        TempDate := CalculateEndPeriodDate(TRUE, "Next Invoice Date");
                        IF "Expiration Date" <> 0D THEN
                            IF "Next Invoice Date" > "Expiration Date" THEN
                                "Next Invoice Date" := 0D
                            ELSE
                                IF TempDate > "Expiration Date" THEN
                                    TempDate := "Expiration Date";
                        IF ("Next Invoice Date" <> 0D) AND (TempDate <> 0D) THEN BEGIN
                            "Next Invoice Period Start" := "Next Invoice Date";
                            "Next Invoice Period End" := TempDate;
                        END ELSE BEGIN
                            "Next Invoice Period Start" := 0D;
                            "Next Invoice Period End" := 0D;
                        END;
                    END ELSE BEGIN
                        IF "Next Invoice Date" <> CALCDATE('<CM>', "Next Invoice Date") THEN
                            ERROR(Text028, FIELDCAPTION("Next Invoice Date"));
                        TempDate := CalculateEndPeriodDate(FALSE, "Next Invoice Date");
                        IF TempDate < "Starting Date" THEN
                            TempDate := "Starting Date";

                        IF "Expiration Date" <> 0D THEN
                            IF "Expiration Date" < TempDate THEN
                                "Next Invoice Date" := 0D
                            ELSE
                                IF "Expiration Date" < "Next Invoice Date" THEN
                                    "Next Invoice Date" := "Expiration Date";

                        IF ("Next Invoice Date" <> 0D) AND (TempDate <> 0D) THEN BEGIN
                            "Next Invoice Period Start" := TempDate;
                            "Next Invoice Period End" := "Next Invoice Date";
                        END ELSE BEGIN
                            "Next Invoice Period Start" := 0D;
                            "Next Invoice Period End" := 0D;
                        END;
                    END;

                    ValidateNextInvoicePeriod;
                END ELSE
                    IF "Invoice Option" = "Invoice Option"::Actual THEN BEGIN//JACK --
                        IF "Next Invoice Date" = 0D THEN BEGIN
                            "Next Invoice Period Start" := 0D;
                            "Next Invoice Period End" := 0D;
                            EXIT;
                        END;
                        IF "Last Invoice Date" <> 0D THEN
                            IF "Last Invoice Date" > "Next Invoice Date" THEN BEGIN
                                ServLedgEntry.RESET;
                                ServLedgEntry.SETCURRENTKEY(Type, "No.", "Entry Type", "Moved from Prepaid Acc.", "Posting Date", Open);
                                ServLedgEntry.SETRANGE(Type, ServLedgEntry.Type::"Service Contract");
                                ServLedgEntry.SETRANGE("No.", "Contract No.");
                                IF ServLedgEntry.FINDFIRST THEN
                                    ERROR(Text023, FIELDCAPTION("Next Invoice Date"), FIELDCAPTION("Last Invoice Date"));
                                "Last Invoice Date" := 0D;
                            END;

                        IF "Next Invoice Date" < "Starting Date" THEN
                            ERROR(Text024, FIELDCAPTION("Next Invoice Date"), FIELDCAPTION("Starting Date"));
                        IF Prepaid THEN BEGIN
                            TempDate := CalculateEndPeriodDate(TRUE, "Next Invoice Date");
                            IF "Expiration Date" <> 0D THEN
                                IF "Next Invoice Date" > "Expiration Date" THEN
                                    "Next Invoice Date" := "Expiration Date"
                                ELSE
                                    IF TempDate > "Expiration Date" THEN
                                        // TempDate := "Expiration Date";
                                        TempDate := CALCDATE('+1D', "Expiration Date");
                            IF ("Next Invoice Date" <> 0D) AND (TempDate <> 0D) THEN BEGIN
                                "Next Invoice Period Start" := "Next Invoice Date";
                                IF "Invoice Period" = "Invoice Period"::Other THEN
                                    "Next Invoice Period End" := TempDate
                                //ELSE
                                //  "Next Invoice Period End" := CALCDATE('-1D', TempDate);//WIN593

                            END ELSE BEGIN
                                "Next Invoice Period Start" := 0D;
                                "Next Invoice Period End" := 0D;
                            END;
                        END ELSE BEGIN
                            //postpaid

                            TempDate := CalculateEndPeriodDate(TRUE, "Next Invoice Date");
                            IF "Expiration Date" <> 0D THEN
                                IF "Next Invoice Date" > "Expiration Date" THEN
                                    "Next Invoice Date" := "Expiration Date"
                                ELSE
                                    IF TempDate > "Expiration Date" THEN
                                        TempDate := CALCDATE('+1D', "Expiration Date");
                            IF ("Next Invoice Date" <> 0D) AND (TempDate <> 0D) THEN BEGIN
                                "Next Invoice Period Start" := "Next Invoice Date";
                                //"Next Invoice Period End" := CALCDATE('-1D', TempDate);//WIN593

                            END ELSE BEGIN
                                "Next Invoice Period Start" := 0D;
                                "Next Invoice Period End" := 0D;
                            END;
                            "Next Invoice Date" := "Next Invoice Period End";
                        END;

                    END;
            end;
        }

        modify("Starting Date")
        {
            trigger OnAfterValidate()
            begin

                ServCntLine.RESET;
                ServCntLine.SETRANGE(ServCntLine."Contract Type", Rec."Contract Type");
                ServCntLine.SETRANGE(ServCntLine."Contract No.", Rec."Contract No.");
                IF ServCntLine.FINDFIRST THEN BEGIN
                    ServCntLine."Starting Date" := "Starting Date";
                    ServCntLine.MODIFY;
                END;



                IF "Starting Date" <> 0D THEN
                    "Service Period Expiry Date" := (CALCDATE("Service Period", "Starting Date")) - 1   //win315
                ELSE
                    CLEAR("Service Period Expiry Date");
                VALIDATE("Invoice Period");
                VALIDATE("Contract Period");



            end;


        }
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin
                IF "Expiration Date" <> 0D THEN
                    IF ("Expiration Date" < "Next Invoice Date") AND (NOT Prepaid) THEN BEGIN
                        "Next Invoice Period End" := "Expiration Date";
                        "Next Invoice Date" := "Expiration Date";
                    END;
            end;
        }

        modify("Annual Amount")
        {
            trigger OnAfterValidate()
            begin
                IF "Invoice Period" <> "Invoice Period"::None THEN BEGIN
                    "Amount per month" := "Annual Amount" / 12;
                    // "Monthly Fee" := "Annual Amount"/12;
                END
                ELSE
                    "Amount per month" := 0;
            end;
        }

        modify("Service Period")
        {
            trigger OnAfterValidate()
            begin
                IF FORMAT("Service Period") <> '' THEN
                    "Service Period Expiry Date" := (CALCDATE("Service Period", "Starting Date")) - 1
                ELSE
                    CLEAR("Service Period Expiry Date");
            end;
        }
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            begin
                PaymentTerms.RESET;
                PaymentTerms.SETRANGE(Code, "Payment Terms Code");
                IF PaymentTerms.FINDFIRST THEN BEGIN
                    DeferralTemplate.RESET;
                    //DeferralHeader.SETRANGE(pay
                    DeferralTemplate.SETRANGE("Deferral Code", PaymentTerms."Defferal Code");
                    IF DeferralTemplate.FINDFIRST THEN
                        VALIDATE("Defferal Code", DeferralTemplate."Deferral Code");
                END;
                //


                RecPT.RESET;
                RecPT.SETRANGE(RecPT.Code, Rec."Payment Terms Code");
                IF RecPT.FINDFIRST THEN BEGIN
                    IF "Mode of Payment" <> '' THEN BEGIN
                        "No. of PDC" := RecPT."No. of PDC";
                        "PDC amount" := "Annual Amount" / "No. of PDC";
                    END
                END ELSE BEGIN
                    CLEAR("No. of PDC");
                    CLEAR("PDC amount");
                END;
            end;
        }
        field(50113; "No. of Bedrooms"; Text[20])
        {
            Caption = 'No. of Bedrooms';

            // OptionMembers = "0","1","2","3","4","5","6","7","8","9","10",Studio;
            // OptionCaption = '0,1,2,3,4,5,6,7,8,9,10,Studio';
        }
        field(50114; Floor; Text[30])
        {
            Caption = 'Floor';

        }
        field(50115; "Planned Rate"; Decimal)
        {
            Caption = 'Planned Rate';
        }

    }
    var

        TempDate: Date;
        InvDays: Integer;

        Text023: Label '%1 cannot be less than %2.';
        Text024: Label 'The %1 cannot be before the %2.';
        Text026: Label '%1 must be the first day in the month.';
        Text028: Label '%1 must be the last day in the month.';

        ServCntLine: Record "Service Contract Line";

        DeferralTemplate: Record "Deferral Template";
        PaymentTerms: Record "Payment Terms";
        RecPT: Record "Payment Terms";

    trigger OnInsert()
    var

        DefTemp: Record "Deferral Template";
        CompInfo: Record "Company Information";
    begin
        "Created By" := USERID;
        Prepaid := TRUE;  //win315
        "Invoice Period" := "Invoice Period"::Year;
        "Invoice Generation" := "Invoice Generation"::"Single Invoice";
        DefTemp.RESET;
        DefTemp.SETRANGE(DefTemp."Invoice Period", Rec."Invoice Period");
        //DefTemp.SETRANGE(DefTemp."Deferral Code",Rec."Defferal Code");
        IF DefTemp.FINDFIRST THEN
            "Defferal Code" := DefTemp."Deferral Code";

        //win315++
        CompInfo.GET;
        IF CompInfo."Leasing Module" = TRUE THEN BEGIN
            //"Invoice Period" := "Invoice Period"::Year;
            //"Invoice Period" := "Invoice Period"::Other;
            IF (("Invoice Period" <> "Invoice Period"::Year) AND ("Invoice Period" <> "Invoice Period"::Other)) THEN
                ERROR('You do not have permission to select this Invoice Period');
        END;
        ///win315--
    end;

    trigger OnModify()
    begin
        "Last Modified By" := USERID;
    end;

    var
        myInt: Integer;
        ServItem: Record "Service Item";
        building: Record Building;
        ServItem1: Record "Service Item";
        ServContractLine: Record "Service Contract Line";
        ServLedgEntry: Record "Service Ledger Entry";
        ShipToAddr: Record "Ship-to Address";

        ServContractMgt: Codeunit ServContractManagement;


        Text011: Label 'You cannot change the %1 field manually because there are contract lines for this customer.';

        Text123: Label 'You can not change %1 of %2 because one or more service ledger entries exist for this contract';

        AllSubs: Codeunit "All Subscriber";
        GlbSingleCrMemo: Boolean;
        GlbContractStartDate: Date;
        GlbDealDate: Date;

    procedure CreateServiceOrderLines()
    var

        lServOrdLine: Record "Service Item Line";
        lServItem: Record "Service Item";
        ServCotraLine: Record "Service Contract Line";
        ServItem: Integer;
        lText001: Label 'Lines already exists.If you change Service Item, lines will be deleted and recreated. Do you want to change the Service Item No.?';
        ShipToAddr: Record "Ship-to Address";

    begin
        ServCotraLine.RESET;
        ServCotraLine.SETRANGE(ServCotraLine."Contract Type", Rec."Contract Type");
        ServCotraLine.SETRANGE(ServCotraLine."Contract No.", Rec."Contract No.");

        IF ServCotraLine.FINDFIRST THEN
            IF CONFIRM(lText001) THEN
                ServCotraLine.DELETEALL
            ELSE
                EXIT;
        COMMIT;
        IF "Service Item No." = '' THEN
            EXIT;
        lServItem.GET("Service Item No.");
        ServCotraLine.VALIDATE(ServCotraLine."Contract Type", Rec."Contract Type");
        ServCotraLine.VALIDATE(ServCotraLine."Contract No.", Rec."Contract No.");
        ServCotraLine.VALIDATE("Line No.", 10000);
        ServCotraLine.VALIDATE("Customer No.", "Customer No.");
        ServCotraLine.VALIDATE(ServCotraLine."Starting Date", Rec."Starting Date");
        ServCotraLine."Service Item No." := "Service Item No.";
        // ServCotraLine.VALIDATE("Service Item No.","Service Item No.");

        ServCotraLine.INSERT;
        ServCotraLine.VALIDATE("Service Item No.");
        ServCotraLine.MODIFY;
        //win315--  
    end;

    procedure ContractLinesExist(): Boolean
    begin
        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type", "Contract Type");
        ServContractLine.SETRANGE("Contract No.", "Contract No.");
        EXIT(ServContractLine.FIND('-'));
    end;

    /* procedure UpdateServZone()
    begin
        IF "Ship-to Code" <> '' THEN BEGIN
            ShipToAddr.GET("Customer No.", "Ship-to Code");
            "Service Zone Code" := ShipToAddr."Service Zone Code";
        END ELSE
            IF "Customer No." <> '' THEN BEGIN
                Cust.GET("Customer No.");
                "Service Zone Code" := Cust."Service Zone Code";
            END ELSE
                "Service Zone Code" := '';
    end; */

    Procedure FindNoOfMonths(StartDate: Date; ExpiryDate: Date): Decimal
    begin
        //EXIT(DateandTime.DateDiff('M', "Starting Date", "Expiration Date", DayOfWeekInput, WeekOfYearInput));

    end;

    procedure UpdateDefInvoice()
    var

        ServiceContractHeader1: Record "Service Contract Header";
    begin
        ServiceContractHeader1.GET("Contract Type", "Contract No.");
        ServiceContractHeader1."Defferral Invoice Posted" := TRUE;
        ServiceContractHeader1.MODIFY;
    end;

    procedure UpdateCustServiceItem()
    var

        SIC: Record "Service Item Component";
        ServiceItem2: Record "Service Item";
    begin


        //WIN325
        IF ("Contract Type" = "Contract Type"::Contract) AND (Status = Status::Signed) THEN BEGIN
            IF ServItem.GET("Service Item No.") THEN BEGIN
                ServItem."Customer No." := "Customer No.";
                ServItem."Ship-to Code" := "Ship-to Code";
                //ServItem."Sales Order No." := SalesHeader."No.";
                ServItem.MODIFY;
            END;
        END;
        //WIN325

        SIC.RESET;
        SIC.SETRANGE(SIC."Parent Service Item No.", "Service Item No.");
        SIC.SETRANGE(SIC.Type, SIC.Type::"Service Item");
        IF SIC.FINDFIRST THEN BEGIN
            REPEAT
                IF ServiceItem2.GET(SIC."No.") THEN BEGIN
                    ServiceItem2."Customer No." := "Customer No.";
                    ServiceItem2."Ship-to Code" := "Ship-to Code";
                    //ServItem."Sales Order No." := SalesHeader."No.";
                    ServiceItem2.MODIFY;
                END;
            UNTIL SIC.NEXT = 0;
        END;
    end;

    procedure SetCreditMemo(SingleCreditMemo: Boolean; ContractStartDate: Date; ContractDealDate: Date)
    begin
        GlbSingleCrMemo := SingleCreditMemo;
        GlbContractStartDate := ContractStartDate;
        GlbDealDate := ContractDealDate;
    end;

    Procedure CreateSingleCrMemo()
    var

        W1: Dialog;
        CreditNoteNo: Code[20];
        i: Integer;
        j: Integer;
        LineFound: Boolean;
        ServContractLine1: Record "Service Contract Line";
        AllSubs: Codeunit "All Subscriber";
        Text1009: Label 'There are unposted credit memos associated with this contract.\\Do you want to continue?';
        Text1010: Label '	Do you want to create a credit note for the contract?';
        Text1011: Label '	Processing...        \\';
        Text1012: Label '	Contract lines have been credited.\\Credit memo %1 was created.';
        Text1013: Label '	A credit memo cannot be created. There must be at least one invoiced and expired service contract line which has not yet been credited.';
        Text1014: Label '	Do you want to file the contract?';
        Text1015: Label '	%1 must not be %2 in %3 %4';
        Text1016: Label '	A credit memo cannot be created, because the %1 %2 is after the work date.';
    begin
        TESTFIELD("Deal Closing Date");
        TESTFIELD("Starting Date");
        TESTFIELD("Expiration Date");
        TESTFIELD(Status, Status::Signed);
        IF "No. of Unposted Credit Memos" <> 0 THEN
            IF NOT CONFIRM(Text1009) THEN
                EXIT;

        ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

        IF NOT CONFIRM(Text1010, FALSE) THEN
            EXIT;

        ServContractLine.RESET;
        ServContractLine.SETCURRENTKEY("Contract Type", "Contract No.", Credited, "New Line");
        ServContractLine.SETRANGE("Contract Type", "Contract Type");
        ServContractLine.SETRANGE("Contract No.", "Contract No.");
        ServContractLine.SETRANGE(Credited, FALSE);
        i := ServContractLine.COUNT;
        j := 0;
        IF ServContractLine.FIND('-') THEN BEGIN
            LineFound := TRUE;
            W1.OPEN(
              Text1011 +
              '@1@@@@@@@@@@@@@@@@@@@@@');
            CLEAR(ServContractMgt);
            ServContractMgt.InitCodeUnit;
            REPEAT
                ServContractLine1 := ServContractLine;
                // TO Post Cr Memo on Deal Closed Date
                IF GlbSingleCrMemo THEN
                    ServContractLine1."Credit Memo Date" := "Starting Date"
                ELSE
                    ServContractLine1."Credit Memo Date" := "Termination Date" + 1;
                // TO Post Cr Memo on Deal Closed Date
                AllSubs.SetCreditMemo(GlbSingleCrMemo, GlbContractStartDate, GlbDealDate);
                CreditNoteNo := AllSubs.CreateSingleContractLineCreditMemo(ServContractLine1, FALSE); // To create Leasing Cr Memo *///WIN292
                j := j + 1;
                W1.UPDATE(1, ROUND(j / i * 10000, 1));
            UNTIL ServContractLine.NEXT = 0;
            ServContractMgt.FinishCodeunit;
            W1.CLOSE;
        END;
        ServContractLine.SETFILTER("Credit Memo Date", '>%1', WORKDATE);
        IF CreditNoteNo <> '' THEN
            MESSAGE(STRSUBSTNO(Text1012, CreditNoteNo))
        ELSE
            IF NOT ServContractLine.FIND('-') OR LineFound THEN
                MESSAGE(Text1013)
            ELSE
                MESSAGE(Text1016, ServContractLine.FIELDCAPTION("Credit Memo Date"), ServContractLine."Credit Memo Date");
    end;

    procedure UpdateServiceItemWithCustomer()
    var
        ServiceItem: Record "Service Item";
    begin
        if ServiceItem.Get(Rec."Service Item No.") then begin
            ServiceItem.Validate(ServiceItem."Customer No.", Rec."Customer No.");
            ServiceItem.Modify();
        end;
    end;
}