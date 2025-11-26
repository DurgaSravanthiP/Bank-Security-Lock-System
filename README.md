# Bank Security Lock System – EMU8086 Assembly Program

This project is a Bank Security Lock System written in 8086 Assembly Language and tested on EMU8086. The system allows employees to log in using their Employee ID and Password, validates each attempt, tracks failed attempts, locks accounts after maximum retries, and supports password changing after successful login.

## Features
- Stores 20 employee IDs inside an array.
- Each ID has a matching password stored in a separate table.
- Validates ID using a linear search function.
- Allows maximum 3 password attempts.
- Locks account after 3 wrong attempts.
- Resets attempts after successful login.
- Option to change password after login.
- Works with SCAN_NUM from `emu8086.inc`.

## How It Works
1. Program displays the title screen.
2. User enters Employee ID.
3. Program searches for the ID in the EmpTable.
4. If found, it checks if the account is locked.
5. If the account is not locked, user enters password.
6. If password matches:
   - Access is granted.
   - Attempts counter resets to 0.
   - User can choose to change the password.
7. If the password is wrong:
   - Attempts counter increases.
   - After 3 wrong attempts, system locks the account.
8. Program loops back to the main menu.

## Data Tables
- `EmpTable` → Contains 20 employee IDs (word array).
- `PassTable` → Contains corresponding passwords (byte array).
- `Attempts` → Tracks failed login attempts per employee.

## Important Constants
- `MAX_EMP = 20`
- `MAX_ATTEMPTS = 3`

## File Requirements
- Must include `emu8086.inc`
- Requires `DEFINE_SCAN_NUM` for numeric input.

## Running the Program
1. Open EMU8086.
2. Create a new project and paste all code.
3. Make sure `emu8086.inc` is available in the same directory.
4. Compile and run the program.

## Functions Used
### FindEmp
Searches for employee ID inside `EmpTable`.  
Returns:
- Zero flag = 1 when found  
- `BL` = index of the employee

### SCAN_NUM (from emu8086)
Reads a number from keyboard and stores result in CX.

## Notes
- Passwords are stored as numbers from 0–15.
- System uses simple text-based I/O using INT 21h services.
- Time display code is removed for cleaner execution.

## License
Free to use for learning and academic purposes.


