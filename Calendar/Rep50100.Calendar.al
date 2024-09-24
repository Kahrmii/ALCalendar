namespace Kalender.Kalender;

using System.Utilities;
using Microsoft.Foundation.Calendar;

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
                column(Month2; IdentifyMonth())
                {
                }
                column(PeriodNo; Date."Period No.")
                {
                }
                column(MondayIsNonWorking; IsNonWorking[1])
                {
                }
                column(TuesdayIsNonWorking; IsNonWorking[2])
                {
                }
                column(WednesdayIsNonWorking; IsNonWorking[3])
                {
                }
                column(ThursdayIsNonWorking; IsNonWorking[4])
                {
                }
                column(FridayIsNonWorking; IsNonWorking[5])
                {
                }
                column(SaturdayIsNonWorking; IsNonWorking[6])
                {
                }
                column(SundayIsNonWorking; IsNonWorking[7])
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
                    CalendarManagement: Codeunit "Calendar Management";
                    CustomizedCalendarChange: Record "Customized Calendar Change";
                begin
                    CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::Company, '', '', SelectedCalendar);
                    if Date2DMY(IIF(CopyLoop.Number < 3, Date."Period Start", Date."Period End"), 3) <> Year then
                        CurrReport.Skip();

                    //normale Woche
                    if CopyLoop.Number = 1 then
                        for DayCount := 1 to ArrayLen(Day) do begin
                            if CalendarManagement.IsNonworkingDay((date."Period Start" + DayCount - 1), CustomizedCalendarChange) then begin
                                Day[DayCount] := Format(Date2DMY(date."Period Start" + DayCount - 1, 1));
                                IsNonWorking[DayCount] := true
                            end else begin
                                Day[DayCount] := Format(Date2DMY(date."Period Start" + DayCount - 1, 1));
                                IsNonWorking[DayCount] := false
                            end;
                        end;
                    //Woche Links
                    if CopyLoop.Number = 2 then
                        for DayCount := 1 to ArrayLen(Day) do begin
                            SetDay(date."Period Start");
                        end;
                    //Woche Rechts
                    if CopyLoop.Number = 3 then
                        for DayCount := 1 to ArrayLen(Day) do begin
                            SetDay(date."Period End");
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
                group(Filter)
                {
                    field(Year; Year)
                    {
                        ApplicationArea = All;
                    }
                    field(SelectCalendar; SelectedCalendar)
                    {
                        TableRelation = "Base Calendar".Code;
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
        SelectedCalendar: Code[20];
        IsNonWorking: Array[7] of Boolean;
        Day: Array[7] of Text;
        Month: Text;
        DayCount: Integer;

    local procedure IIF(Condition: Boolean; ifTrue: Date; ifFalse: Date): Date
    begin
        if Condition then
            exit(ifTrue);
        exit(IfFalse);
    end;

    local procedure SetDay(MonthOfDate: Date)
    var
        CalendarManagement: Codeunit "Calendar Management";
        CustomizedCalendarChange: Record "Customized Calendar Change";
    begin
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::Company, '', '', SelectedCalendar);
        if Date2DMY(date."Period Start" + DayCount - 1, 2) = Date2DMY(MonthOfDate, 2) then begin
            if CalendarManagement.IsNonworkingDay((date."Period Start" + DayCount - 1), CustomizedCalendarChange) then begin
                Day[DayCount] := Format(Date2DMY(date."Period Start" + DayCount - 1, 1));
                IsNonWorking[DayCount] := true
            end else begin
                Day[DayCount] := Format(Date2DMY(date."Period Start" + DayCount - 1, 1));
                IsNonWorking[DayCount] := false
            end;
        end else
            Day[DayCount] := '';
    end;

    local procedure IdentifyMonth(): Text
    begin
        case Format(Date2DMY(IIF(CopyLoop.Number < 3, Date."Period Start", Date."Period End"), 2)) of
            '1':
                Month := 'Januar';
            '2':
                Month := 'Februar';
            '3':
                Month := 'März';
            '4':
                Month := 'April';
            '5':
                Month := 'Mai';
            '6':
                Month := 'Juni';
            '7':
                Month := 'Juli';
            '8':
                Month := 'August';
            '9':
                Month := 'September';
            '10':
                Month := 'Oktober';
            '11':
                Month := 'November';
            '12':
                Month := 'Dezember';
            else
                Month := 'Ungültiger Monat';
        end;
        exit(Month)
    end;
}