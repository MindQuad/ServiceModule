Codeunit 50003 "Check Bounce Notification-30D"
{

    trigger OnRun()
    var
        PostDatedCheckLine: Record "Post Dated Check Line";
        bouncegracedate: Date;
    begin
        bouncegracedate := CalcDate('-30d', Today);
        PostDatedCheckLine.SetRange(PostDatedCheckLine."Settlement Type", PostDatedCheckLine."settlement type"::"Notify Legal Department");
        PostDatedCheckLine.SetFilter(PostDatedCheckLine."Reversal Date", '<=%1', bouncegracedate);
        PostDatedCheckLine.SetRange("Bounce Notification Sent", false);
        if PostDatedCheckLine.FindFirst then begin
            repeat
                PostDatedCheckLine.Sendbouncemailaftergraceperiod(PostDatedCheckLine."Check No.");
            until PostDatedCheckLine.Next = 0;
        end;
    end;
}

