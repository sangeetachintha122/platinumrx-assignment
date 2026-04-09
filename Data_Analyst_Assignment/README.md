# PlatinumRx Assignment Deliverables

## What's included (final structure)
- SQL/01_Hotel_Schema_Setup.sql - table creation + seed data for Hotel.
- SQL/02_Hotel_Queries.sql - Hotel query solutions (Q1–Q5).
- SQL/03_Clinic_Schema_Setup.sql - table creation + seed data for Clinic.
- SQL/04_Clinic_Queries.sql - Clinic query solutions (Q1–Q5).
- Spreadsheets/Ticket_Analysis.xlsx - Excel workbook with required formulas and sample data.
- Python/01_Time_Converter.py - converts minutes into X hr(s) Y minute(s).
- Python/02_Remove_Duplicates.py - removes duplicate characters while preserving order.

## SQL notes
- Target database: PostgreSQL. Adjust date functions/parameter style for MySQL if needed.
- Schema setup files include drops + FK relationships and minimal seed rows.
- Hotel totals use item_quantity * item_rate; date filters use inclusive start / exclusive end.
- Clinic profitability = revenue (sales) - expense per clinic.

## Spreadsheet (Ticket_Analysis.xlsx)
Sheets:
- Tickets: ticket_id, created_at, closed_at, outlet_id, cms_id (sample data included).
- Feedbacks: ticket_created_at is auto-filled with  
  `=IFERROR(INDEX(Tickets!$B:$B, MATCH(A2, Tickets!$E:$E, 0)), "")`
- Summary: outlet-wise counts  
  - same day: `=SUMPRODUCT((Tickets!$D$2:$D$1000=A2)*(INT(Tickets!$B$2:$B$1000)=INT(Tickets!$C$2:$C$1000)))`  
  - same hour: `=SUMPRODUCT((Tickets!$D$2:$D$1000=A2)*(INT(Tickets!$B$2:$B$1000*24)=INT(Tickets!$C$2:$C$1000*24)))`

Google Sheets link:
- Not created here. Upload Spreadsheets/Ticket_Analysis.xlsx to Drive, set sharing to "Anyone with the link -> Viewer," and share the link if needed in the README.

## Python scripts
- `python Python/01_Time_Converter.py 130` -> `2 hrs 10 minutes` (raises on negative input).
- `python Python/02_Remove_Duplicates.py "balloon"` -> `balon`.

## How to verify
1) Run SQL files against databases with the provided schemas; ensure date columns are timestamp-compatible.  
2) Open Spreadsheets/Ticket_Analysis.xlsx; confirm INDEX/MATCH fills ticket_created_at and SUMPRODUCT counts update with data changes.  
3) Run both Python scripts with sample and edge inputs (0, 1, 59, 60, negatives).  
