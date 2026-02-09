# Submodule Icons Database Update

## Overview
This update adds an `icon` field to the `sub_modules` table and populates it with appropriate icons for each submodule.

## Files
- `add-submodule-icons.sql` - SQL script to add icon field and populate with icons

## How to Run
1. Connect to your PostgreSQL database
2. Execute the SQL script:
   ```sql
   \i add-submodule-icons.sql
   ```
   Or run it directly in your database client.

## What it does
1. Adds `icon` column to `sub_modules` table
2. Updates all existing submodules with appropriate icons based on their functionality
3. Icons are chosen to match the submodule's purpose (e.g., 'calendar' for appointments, 'user-plus' for registration, etc.)

## Icon Mapping Examples
- Dashboard → 'layout-dashboard'
- Patient Registration → 'user-plus'
- Appointments → 'calendar'
- Billing → 'credit-card'
- Reports → 'bar-chart-3'
- Settings → 'settings'

## After Running
The frontend sidebar will automatically use the specific icons for each submodule instead of inheriting the parent module's icon.