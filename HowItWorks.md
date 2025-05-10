
---

## ⚙️ How It Works

1. **Network Setup**:
   - Cells are placed using hexagonal geometry.
   - Channels are assigned to cells based on reuse factor (e.g., 3-cell reuse).

2. **User Initialization**:
   - Primary users are randomly located in cells and assigned required BW classes.
   - Channels are allocated to them considering SNR and interference.

3. **Secondary Allocation & Pricing**:
   - Secondary users scan available primary-free channels.
   - They select channels using a learning algorithm that balances price and achievable BW.

4. **Learning Process**:
   - A probabilistic pricing model (`Learn.m`) updates price selections based on:
     - Provider gain
     - User satisfaction
     - Penalty imposed if QoS thresholds are not met

5. **Benefit & Penalty Calculation**:
   - Provider benefit is revenue from secondary leasing minus penalty for unsatisfied primary users.

---

## 📈 Performance Outputs

- 📤 **Benefit per provider**
- ❌ **Penalty due to under-served primary users**
- 💰 **Total revenue from users**
- 📶 **Spectrum utilization efficiency**
- 📊 **Bandwidth per user over time**

---

## 🛠 Requirements

- MATLAB R2017a or newer
- Optimization Toolbox (for `intlinprog`)
- Optional: Parallel Computing Toolbox for speed

---

## 🚀 Getting Started

1. Open MATLAB
2. Set the root folder as the working directory
3. Run the main simulation:
```matlab
CogntvPric
