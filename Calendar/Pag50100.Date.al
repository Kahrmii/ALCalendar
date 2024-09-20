namespace Kalender.Kalender;

using System.Utilities;

page 50100 "Date"
{
    ApplicationArea = All;
    Caption = 'Date';
    PageType = List;
    SourceTable = "Date";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Name"; Rec."Period Name")
                {
                }
                field("Period No."; Rec."Period No.")
                {
                }
                field("Period Start"; Rec."Period Start")
                {
                }
                field("Period Type"; Rec."Period Type")
                {
                }
                field("Period End"; Rec."Period End")
                {
                }
                field("Period Invariant Name"; Rec."Period Invariant Name")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}
