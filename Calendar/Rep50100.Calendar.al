namespace Kalender.Kalender;

using System.Utilities;

report 50100 Calendar
{
    Caption = 'Calendar';
    DefaultRenderingLayout = Caldendar;
    ApplicationArea = All;

    dataset
    {
        dataitem(Date; "Date")
        {
            DataItemTableView = where("Period Type" = const(Week));
            DataItem(CopyLoop; Integer)
            {
                column(Year; Year)
                {
                }
                column(Month; Date2DMY(IIF(CopyLoop.Number < 3, Date."Period Start", Date."Period End"), 2))
                {
                }
                column(PeriodNo; Date."Period No.")
                {
                }
                column(Monday; Day[1])
                {
                }
                column(Tuesday; Day[2])
                {
                }
                column(Wednesday; Day[3])
                {
                }
                column(Thursday; Day[4])
                {
                }
                column(Friday; Day[5])
                {
                }
                column(Saturday; Day[6])
                {
                }
                column(Sunday; Day[7])
                {
                }

                trigger OnPreDataItem()
                begin
                    if (Date2DMY(Date."Period Start", 2) <> Date2DMY(Date."Period End", 2)) then begin //Monatswechsel
                        CopyLoop.SetRange(Number, 2, 3); // zwei Iterationen
                    end else begin
                        CopyLoop.SetRange(Number, 1); // eine Iteration
                    end;
                end;

                trigger OnAfterGetRecord()
                var
                    Count: Integer;
                begin
                    if Date2DMY(IIF(CopyLoop.Number < 3, Date."Period Start", Date."Period End"), 3) <> Year then
                        CurrReport.Skip();

                    //Number = 1 = normale Woche
                    if CopyLoop.Number = 1 then
                        for Count := 1 to ArrayLen(Day) do begin
                            Day[Count] := Format(Date2DMY(date."Period Start" + Count - 1, 1))
                        end;
                    //Woche Links
                    if CopyLoop.Number = 2 then
                        for Count := 1 to ArrayLen(Day) do begin
                            if Date2DMY(date."Period Start" + Count - 1, 2) = Date2DMY(date."Period Start", 2) then
                                Day[Count] := Format(Date2DMY(date."Period Start" + Count - 1, 1))
                            else
                                Day[Count] := '';
                        end;
                    //Woche Rechts
                    if CopyLoop.Number = 3 then
                        for Count := 1 to ArrayLen(Day) do begin
                            if Date2DMY(date."Period Start" + Count - 1, 2) = Date2DMY(date."Period End", 2) then
                                Day[Count] := Format(Date2DMY(date."Period Start" + Count - 1, 1))
                            else
                                Day[Count] := '';
                        end;
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Period Start", '<=%1', DMY2Date(31, 12, Year));
                SetFilter("Period End", '>=%1', DMY2Date(01, 01, Year));
            end;


        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Year; Year)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            Year := Date2DMY(Today, 3);
        end;
    }
    rendering
    {
        layout("Caldendar")
        {
            Type = RDLC;
            LayoutFile = '.\Caldendar.rdl';
        }
    }
    var
        Year: Integer;
        Day: Array[7] of Text;

    local procedure IIF(Condition: Boolean; ifTrue: Date; ifFalse: Date): Date
    begin
        if Condition then
            exit(ifTrue);
        exit(IfFalse);
    end;
}