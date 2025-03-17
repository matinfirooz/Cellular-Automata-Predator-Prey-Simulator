# Cellular-Automata-Predator-Prey-Simulator

This repository contains the implementation of a **Cellular Automata Simulator** for a **Predator-Prey model** using hardware description methods. The project is part of the Bio-Inspired Computing course (Second Semester, 1402-1403).

##  Project Description

The goal of this project is to simulate the interaction between **sharks** and **fish** in a **2D grid (50x50)** based on predefined rules. The implementation follows **hardware-based modeling**, ensuring that the design is suitable for synthesis.

### **Simulation Rules**
Each cell in the grid can represent:
1. **An empty cell**
2. **A fish**
3. **A shark**

The system evolves based on the following rules:

#### **1. Birth Conditions**
- If an empty cell has at least **one neighbor of the same species** and at least **three neighbors of any species**, a **new creature is born**.
- The newborn’s age is:
  - **Fish:** Age = 1
  - **Shark:** Age = -1

#### **2. Survival Rules**
- **Fish:** Lives up to **8 generations** unless surrounded by **more than 3 sharks** or **6 fish**.
- **Shark:** Lives up to **16 generations** unless surrounded by **more than 3 sharks** and **fewer than 2 fish**.
- Sharks have a **1/32 probability of dying randomly** in each step.

### **Initialization**
- The grid is initialized randomly with:
  - **40% Fish**
  - **20% Sharks**
  - **30% Empty cells**
