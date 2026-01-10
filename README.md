# CSE 351: Dead Code Elimination (DCE) Tool

This project implements a **Dead Code Elimination (DCE)** algorithm for a specific Intermediate Language (IL) as the term project for the **CSE 351: Programming Languages** course. The tool is developed using **Lex (Flex)** and **Yacc (Bison)** to transform IL code by identifying and removing redundant assignment statements.

## 1. Project Overview
The primary goal is to optimize code by eliminating assignment statements that have no consumers or involve variables that are not "live" at the end of execution.

### Language Constraints
* **Syntax**: Very similar to C programming language assignments.
* **Operands**: Each statement may have at most two source operands (variables or signed integers).
* **Live Variables**: The last line explicitly lists variables that must remain live at the end of execution, formatted as `{variable1, variable2}`.

## 2. The Algorithm
The algorithm identifies dead code using a backward-flow analysis implemented in three major steps:

1.  **Initial Reversal**: The source IL code is reversed to allow for a single-pass liveness check from bottom to top.
2.  **Liveness Analysis**: 
    * Initialize a `LiveSet` with variables from the final list.
    * If a statement's destination is in the `LiveSet`, it is kept; otherwise, it is discarded as dead code.
    * Updating `LiveSet`: Remove the destination variable and add the source operands to the set.
3.  **Final Reversal**: The surviving "live" statements are reversed back to their original program order.



## 3. Technical Implementation

### Lexical Analysis (Lex)
The lexer identifies tokens using regular expressions:
* **Identifiers**: `{letter}({letter}|{digit})*`
* **Constants**: `{digit}+`
* **Operators**: Supports `+`, `-`, `*`, `/`, `^`, and `=`.
* **Communication**: Passes values to the parser via `yylval.str` for variables and `yylval.num` for integers.

### Syntax Analysis (Yacc)
The parser defines the Context-Free Grammar (CFG) and executes semantic actions:
* **Recursive Structure**: Uses right-recursion to process multiple assignment statements.
* **Liveness Logic**: Embedded directly in the assignment rules to update the global `LiveSet` and decide whether to print the reconstructed `g_currentLine`.

## 4. Testing and Execution

### Compilation
The project is managed via a `Makefile`. To compile:
```bash
make all
```
Running the Tool

Because the algorithm requires code reversal, the tool uses the tail -r utility (or tac on Linux) in a command pipeline:

```bash
# Process: Reverse -> Analyze/Eliminate -> Reverse back
tail -r input.il | ./dce_tool | tail -r
```

You can also use the make shortcut:

```bash
make run
```

5. Project Requirements & Submission
Source Files: Includes Lex (.l) and Yacc (.y) source files.

Scripts: Contains shell scripts or command-line statements to compile and run the project.

Report: A detailed technical report explaining the design and implementation.


6. Conclusion
The tool successfully optimizes IL code by removing unnecessary computations while maintaining functional integrity. The three-step reversal strategy allows for an efficient, single-pass liveness analysis within the Yacc parser.
