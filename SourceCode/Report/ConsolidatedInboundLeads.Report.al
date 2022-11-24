report 50208 "Consolidated Inbound Leads"
{
    Caption = 'Consolidated Inbound Leads';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company; Company)
        {
            DataItemTableView = SORTING(Name);
            RequestFilterFields = Name;

            trigger OnAfterGetRecord()
            begin
                Contact.RESET;
                Contact.CHANGECOMPANY(Name); //filter to be add from request page
                Contact.SETCURRENTKEY(Contact."Company No.");
                Contact.ASCENDING(TRUE);
                Contact.SETRANGE(Contact.Type, Contact.Type::Person);
                IF ContactNo <> '' THEN
                    Contact.SETRANGE(Contact."No.", ContactNo);
                IF CompanyNo <> '' THEN
                    Contact.SETRANGE(Contact."Company No.", CompanyNo);
                IF Contact.FINDSET THEN
                    REPEAT

                        CLEAR(SalespersonPurchaser);
                        IF SalespersonPurchaser.GET(Contact."Salesperson Code") THEN;

                        CLEAR(RecContact);
                        IF RecContact.GET(Contact."Company No.") THEN;

                        CLEAR(InteractionDesc);
                        InteractionLogEntry.RESET;
                        InteractionLogEntry.SETRANGE(InteractionLogEntry."Contact Company No.", Contact."Company No.");
                        InteractionLogEntry.SETRANGE(InteractionLogEntry."Contact No.", Contact."No.");
                        InteractionLogEntry.SETRANGE(InteractionLogEntry."Attempt Failed", FALSE);
                        InteractionLogEntry.SETRANGE(InteractionLogEntry.Postponed, FALSE);
                        IF InteractionLogEntry.FINDLAST THEN
                            InteractionDesc := InteractionLogEntry.Description;


                        ExcelBuffer.NewRow;

                        IF CompName2 <> Name THEN
                            ExcelBuffer.AddColumn(Name, FALSE, '', FALSE, FALSE, FALSE, '', 0)
                        ELSE
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        CompName2 := Name;

                        ExcelBuffer.AddColumn(Contact."No.", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact."First Name", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact."Middle Name", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact.Surname, FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact."E-Mail", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact."Phone No.", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact."Company No.", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(Contact."Company Name", FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(FORMAT(RecContact."Source of Lead"), FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(FORMAT(RecContact."Creation Date"), FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(InteractionDesc, FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(FORMAT(Contact."Date of Last Interaction"), FALSE, '', FALSE, FALSE, FALSE, '', 0);
                        ExcelBuffer.AddColumn(SalespersonPurchaser.Name, FALSE, '', FALSE, FALSE, FALSE, '', 0);
                    UNTIL Contact.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                CreateHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Filters)
                {
                    field("Contact No."; ContactNo)
                    {
                        TableRelation = Contact."No." WHERE(Type = FILTER(Person));
                    }
                    field("Company No."; CompanyNo)
                    {
                        TableRelation = Contact."No." WHERE(Type = FILTER(Company));
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        //ExcelBuffer.CreateBookAndOpenExcel('', 'Consolidate Inbound Leads Report', 'Consolidate Inbound Leads Report', '', USERID);
    end;

    trigger OnPreReport()
    begin
        ExcelBuffer.DELETEALL;
    end;

    var
        Contact: Record 5050;
        RecContact: Record 5050;
        SalespersonPurchaser: Record 13;
        InteractionLogEntry: Record 5065;
        InteractionDesc: Text[100];
        ExcelBuffer: Record 370 temporary;
        CompName2: Text;
        ContactNo: Code[20];
        CompanyNo: Code[20];

    local procedure CreateHeader()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Company', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Contact No.', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('First Name', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Middle Name', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Last Name', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('E-Mail', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Mobile No.', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Business Unit Code', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Business Unit Name', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Source', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Date Sourced', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Type of Enquiry', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Date of Contact', FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuffer.AddColumn('Sales Person Assigned', FALSE, '', TRUE, FALSE, FALSE, '', 0);
    end;
}

