# Structural-Numerical-Symmetry-Hypothesis-Mikhail-Yuryevich-Yushchenko-2025

# Study of Integer Properties under Symmetric Partitioning and Partial Multiplication

## Title Page

Author: Mikhail Yuryevich Yushchenko

Date: May 4, 2025

## Article Title: Hypothesis of Structural Numerical Symmetry: Investigating Integer Properties under Symmetric Partitioning and Partial Multiplication

## Abstract

This work presents a new pattern in number theory — the Hypothesis of Structural Numerical Symmetry , discovered by me on May 4, 2025. The essence of this hypothesis is as follows:

For any integer N≥10, if it is divided into m parts that are as close as possible in length, each part is multiplied by the same natural number k, and then the results are concatenated to form a decimal number PQ, then:

Full match may occur: PQ = N * k

In most cases, both the leading and trailing digits match, although the numbers may differ in total digit count.

In some cases, only partial symmetry occurs: either the beginning or the end of PQ matches N×k

Even prime numbers can yield an exact match under specific partitioning and multiplier conditions.

Question: Is there any number N for which none of these rules apply?

## Clarification of the formulation:

N≥10: This is the minimum length required to allow meaningful symmetric partitioning

Partitioning into m parts : Should be as equal in length as possible across the number N

Each part is multiplied by k

Concatenation as a decimal number PQ: This is the key operation that gives structure

Possible types of match:

Exact

Partial (start or end)

Scaled (e.g., differing by powers of ten)

### The paper includes both theoretical analysis and a programmatic implementation in Julia, enabling automated verification of the hypothesis across arbitrary ranges. 

Research directions for future exploration are also proposed.

## Chapter 1. Introduction

### 1.1 Origin of the Idea:
The research began with an attempt to manually compute 999^9999. This number was too large for direct analysis, prompting an alternative approach — breaking it into segments and applying partial multiplication. Although this method initially produced numerous errors, continued experimentation led to the discovery of this unique hypothesis.

### 1.2 Research Objective:
The main goal was to investigate what can be formulated as the Hypothesis of Structural Numerical Symmetry , including:

Understanding under what conditions exact or partial matching occurs

Identifying patterns

Implementing a program for mass verification of the hypothesis

Testing applicability to prime numbers

## Chapter 2. Hypothesis Formulation

### 2.1 Structural Numerical Symmetry Hypothesis (SNS)
For any integer N≥10, if it is divided into m parts as close in length as possible, each part is multiplied by the same natural number k, and the results are concatenated as a decimal number PQ, then:

Exact match is possible: PQ = N * k

In most cases, partial symmetry is observed: either the beginning or the end of PQ matches N * k

In some cases, both the start and end digits may match, even if the total digit lengths differ

Even prime numbers can yield an exact match under specific partitioning and multiplier conditions

Open Question: Is there any number N for which none of these rules hold?

## Chapter 3. Theoretical Analysis

### 3.1 Condition for Exact Match
An exact match is possible only when multiplying each segment Ai * k does not increase the number of digits.

Formal condition:

∀i, length(Ai * k) = length(Ai) ⇒ PQ = N * k

### 3.2 Dependence on Multiplier k
Observations:

At k=1: Structure remains unchanged → always exact match

At k=7: Often leads to full or partial match

At k=4,6,8: More likely to produce scaled matches

## Chapter 4. Examples and Computational Verification

### 4.1 Examples of Full Match

| N    | K | Partitioning |   PQ  | N * K |
|------|---|--------------|-------|-------|
| 101  | 7 |    [10][1]   | 707   | 707   |
| 1001 | 7 |    [19][1]   | 7007  | 7007  |
| 7007 | 1 |    [70][7]   | 7007  | 7007  |

### 4.2 Examples of Partial Symmetry

|N       |   K |      PQ      |   N * K    |    Match      |
|--------|-----|--------------|------------|---------------|
|899766  |   4 |   35963064   |   3599064  |  359 and 064  |
|88844431|   4 |   3553617724 | 355377724  | 3553 and 7724 |
|  1234  |   4 |     48136    |   4936     |   4 and 36    |


### 4.3 Examples with Prime Numbers

| N   |  K  |  Partitioning  |     PQ     | N * K  |        Result            |
|-----|-----|----------------|------------|--------|--------------------------|
| 101 |  7  |     [10][01]   |    7007    |   707  |     Full match found     |
| 11  |  9  |      [1][1]    |     99     |   99   |     Full match found     |
| 13  |  7  |      [1][3]    |    721     |   91   |   Trailing digits match  |

## Chapter 5. Software Implementation

### 5.1 Programming Language: Julia
A program was written in Julia to verify the hypothesis, featuring:

Number partitioning

Partial multiplication

Result concatenation

Match classification

Data export to CSV

### 5.2 Key Functions

|            Name              |                  Purpose                         |
|------------------------------|--------------------------------------------------|
| `split_number(N, m)`         |             Splits number into m                 |
| `compare_pq_nk`              |             Compares PQ and N × k                |
| ` check_hypothesis`          |        Verifies hypothesis for one number        |
| ` run_tests`                 |        Runs checks over a range of numbers       |

### 5.3 Match Statistics (Range 10–100, k=7, m=2):

| ТИП СОВПАДЕНИЯ                 |                 КОЛИЧЕСТВО СЛУЧАЕВ  |
|--------------------------------|-------------------------------------|
| 🔄 Start matches:              |                          0          |
| 🔄 End matches:                |                          30         |
| 🔄 Start and end matches:      |                          42         |
| ✅ Full match:                 |                          19         |
| ❌ No match:                   |                           0         |


## Chapter 6. Data Analysis and Conclusions

### 6.1 Observations
Exact match is rare but real

Partial symmetry is the most common phenomenon

Prime numbers also satisfy the hypothesis under certain conditions

### 6.2 Conclusions

The Structural Numerical Symmetry Hypothesis is not random

It follows strict rules related to digit length and multiplication of least/most significant digits

This pattern may be useful in:

Number theory

Educational purposes

Large number analysis

Potential further research directions:

Identify classes of numbers yielding full match at given k

Generalize to other numeral systems

Analyze behavior at higher powers

Integrate into mathematical software (Julia, Mathematica, Python)

Copyright Notice

This discovery belongs to Mikhail Yuryevich Yushchenko, 2025.

License
This project is distributed under the GNU General Public License v3.0.

Author: Mikhail
Contact Email: misha0966.33@gmail.com
