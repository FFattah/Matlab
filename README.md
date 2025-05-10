# 📡 Cognitive Radio Pricing Simulator (Cellular Network Model)
**Author:** Zahra Fattah  
**Language:** MATLAB  
**Purpose:** Simulation and optimization of pricing and spectrum allocation in a multi-cell cellular Cognitive Radio Network (CRN)

---

## 🧠 Overview

This MATLAB-based simulation models a **cellular cognitive radio network** consisting of multiple base stations and two classes of users:

- **Primary Users** (licensed spectrum owners)
- **Secondary Users** (unlicensed users who lease idle spectrum opportunistically)

The network is structured using an **even-q vertical hexagonal grid** to simulate realistic cellular coverage. Each cell contains **multiple spectrum channels**, and users may request services based on different **Quality of Service (QoS) classes** with corresponding bandwidth and pricing requirements.

Secondary users dynamically select optimal spectrum channels based on **signal quality**, **interference**, and **price**, using a **Simulated Annealing (SA)**-inspired learning mechanism to maximize utility while minimizing cost.

---

## 📌 Key Features

- 📶 **Cellular Grid Creation**: Hexagonal cell layout using even-q vertical placement.
- 🧍‍♂️ **Primary and Secondary Users**: With distinct spectrum rights and behaviors.
- 📊 **Dynamic Spectrum Allocation**: Users are allocated channels based on SNR and availability.
- 💸 **Pricing Model**:
  - Primary users are charged based on fixed class-based pricing.
  - Secondary users negotiate prices through dynamic optimization.
- 📉 **Interference-Aware Bandwidth Calculation**:
  - Signal degradation due to co-channel interference is considered.
  - Bandwidth is recalculated based on distance from BS and other consumers.
- 🔁 **Learning-Based Spectrum Pricing**:
  - The `Learn` function implements a probabilistic learning model similar to **Simulated Annealing** to iteratively refine secondary pricing decisions.
- 📈 **Performance Metrics**:
  - Provider benefit (revenue – penalty)
  - Achieved bandwidth (vs. requested)
  - Penalties for under-service

---

## 📂 Folder Structure

