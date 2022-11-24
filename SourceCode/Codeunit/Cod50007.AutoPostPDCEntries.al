codeunit 50007 "Auto Post PDC Entries"
{
    //Win593
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        PostDatedChkLine: Record "Post Dated Check Line";
        PostDatedCheckMgt: Codeunit PostDatedCheckMgt;
    begin
        PostDatedChkLine.SetRange("Payment Method", PostDatedChkLine."Payment Method"::PDC);
        PostDatedChkLine.SetRange("Check Date", WorkDate());
        PostDatedChkLine.SetRange(Status, PostDatedChkLine.Status::" ");
        PostDatedChkLine.ModifyAll(Status, PostDatedChkLine.Status::Received);

        PostDatedChkLine.SetRange(Status, PostDatedChkLine.Status::Received);
        if PostDatedChkLine.FindSet() then
            PostDatedCheckMgt.PostJournal(PostDatedChkLine, TRUE);
    end;
    //Win593
}