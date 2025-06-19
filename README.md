**Booth_Algorithm**
Booth's multiplication algorithm is an algorithm which multiplies 2 signed integers in 2's complement. The algorithm is depicted in the following figure with a brief description. This approach uses fewer additions and subtractions than more straightforward algorithms.
![image](https://github.com/user-attachments/assets/9ef1e52a-a214-4ea4-9256-f796c057900d)


# Algorithm
The multiplicand and multiplier are placed in the m and Q registers respectively. A 1 bit register is placed logically to the right of the LSB (least significant bit) Q0 of Q register. This is denoted by Q-1. A and Q-1 are initially set to 0. Control logic checks the two bits Q0 and Q-1. If the twi bits are same (00 or 11) then all of the bits of A, Q, Q-1 are shifted 1 bit to the right. If they are not the same and if the combination is 10 then the multiplicand is subtracted from A and if the combination is 01 then the multiplicand is added with A. In both the cases results are stored in A, and after the addition or subtraction operation, A, Q, Q-1 are right shifted. The shifting is the arithmetic right shift operation where the left most bit namely, An-1 is not only shifted into An-2 but also remains in An-1. This is to preserve the sign of the number in A and Q. The result of the multiplication will appear in the A and Q.	

Booth's algorithm can be implemented in many ways. This experiment is designed using a controller and a datapath. The operations on the data in the datapath is controlled by the control signal received from the controller. The datapath contains registers to hold multiplier, multiplicand, intermediate results, data processing units like ALU, adder/subtractor etc., counter and other combinational units. Following is the schemetic diagram of the Booth's multiplier which multiplies two 4-bit numbers in 2's complement of this experiment. Here the adder/subtractor unit is used as data processing unit.M, Q, A are 4-bit and Q-1 is a 1-bit rigister. M holds the multiplicand, Q holds the multiplier, A holds the results of adder/subtractor unit. The counter is a down counter which counts the number of operations needed for the multiplication. The data flow in the data path is controlled by the five control signals generated from the controller. these signals are load (to load data in registers), add (to initiate addition operation), sub (to initiate subtraction operation), shift (to initiate arithmetis right shift operation), dc (this is to decrement counter). The controller generates the control signals according to the input received from the datapath. Here the inputs are the least significant Q0 bit of Q register, Q-1 bit and count bit from the down counter.

# DataPath
# 1. Registers and Flip-Flop:
A: n-bit register (accumulator)
Q: n-bit register (multiplier)
Q-1: 1-bit flip-flop (stores previous LSB of Q)
M: n-bit register (holds the multiplicand)
These components—A, Q, and Q-1—are interconnected to act as a combined shift register.

# 2. Data Loading:
Multiplicand (M) and Multiplier (Q) must be loaded externally.
Control signals required:
ldM: Load control for M
ldQ: Load control for Q
ldA: Load control for A (to store result of ALU operation)

# 3. Initialization:
A needs to be cleared at the beginning of operation.
Control signal: clrA
Q may not need clearing as it will be loaded directly.

# 4. Shifting Control:
To enable proper shifting during multiplication:
sftA: Shift control for register A
sftQ: Shift control for register Q
clrff: Clear/reset control for flip-flop Q-1
qm1: Output from the flip-flop (Q-1)

# 5. ALU Operation:
ALU takes A and M as inputs.
Control signal: addsub
If addsub = 0: ALU performs A + M
If addsub = 1: ALU performs A - M
Output of ALU: Z


![image](https://github.com/user-attachments/assets/9f693464-c598-40db-8632-1e653231eeca)

# Controller
# 1. Data Loading States
Two separate states are used to load:
The multiplicand (M) from data_in
The multiplier (Q) from data_in
🔹 Why separate?
Because both M and Q are loaded from the same data_in line, they cannot be loaded in parallel. Hence, they require distinct states for loading.

# 2. Initialization
Along with loading M and Q, another register called count is used.
count is initialized to 15 (for a 16-bit example).
This count register is:
Loaded during initialization
Decremented after every shift operation
Loading count can be done in parallel with other operations like clearing A or Q-1.

# 3. State Definitions
State	Action
S0	Idle/Start state
S1	Load multiplicand (M)
S2	Load multiplier (Q) and initialize count
S3	Perform A = A + M (if Q0Q-1 = 01)
S4	Perform A = A - M (if Q0Q-1 = 10)
S5	Perform Arithmetic Shift Right on (A, Q, Q-1) and decrement count
S6	Final state → operation complete (count = 0)

# 4. State Transitions
From S0 → S1: On receiving the start signal.
From S1 → S2: Load Q and initialize count.
From S2:
If Q0Q-1 = 01 → go to S3 (Addition)
If Q0Q-1 = 10 → go to S4 (Subtraction)
If Q0Q-1 = 00 or 11 → go to S5 (Shift only)
From S3 → S5: Always after addition.
From S4 → S5: Always after subtraction.
From S5:
If count ≠ 0 and:
Q0Q-1 = 01 → go to S3
Q0Q-1 = 10 → go to S4
Q0Q-1 = 00 or 11 → stay in S5
If count = 0 → go to S6 (STOP)

# 5. Final State (S6)
Indicates completion of the multiplication.
No further transitions.

![image](https://github.com/user-attachments/assets/903ab490-016a-4283-ad2e-a11615dbaffc)

![image](https://github.com/user-attachments/assets/c2ea6370-a47b-4d41-8731-132f5dc85146)




# Example
M (Multiplicand) = -31 = 100001 (6-bit signed binary)
Q (Multiplier) = 28 = 011100 (6-bit signed binary)
-M = 011111 (2’s complement of M)
A and Q-1 initialized to 0
Product = -868 = (110010011100) in binary
**In Booth’s Algorithm, the number of steps is determined by the number of bits in the multiplier (Q), because each step processes one bit of the multiplier (along with Q-1).**
Here Q have  6 - bit signed binary number so number of steps are 6.

| Step   | A      | Q      | Q-1 | Operation                |
| ------ | ------ | ------ | --- | ------------------------ |
| Init   | 000000 | 011100 | 0   | Initialization           |
| Step 1 | 000000 | 001110 | 0   | Shift Right (Arithmetic) |
| Step 2 | 000000 | 000111 | 0   | Shift Right (Arithmetic) |
| Step 3 | 011111 | 000111 | 1   | A = A - M → Shift        |
| Step 4 | 001111 | 100011 | 1   | Shift Right (Arithmetic) |
| Step 5 | 100111 | 110001 | 1   | Shift Right (Arithmetic) |
| Step 6 | 110010 | 011100 | 0   | A = A + M → Shift        |

Final Product:
Concatenate A and Q:
A = 110010, Q = 011100
⇒ Product = 110010011100
⇒ Decimal = -868


