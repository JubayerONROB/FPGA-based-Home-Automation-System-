# FPGA-Based Home Automation System

## 🚀 **Project Overview**
This project demonstrates a smart home automation system using an FPGA. The system uses Verilog to design a multi-functional control unit capable of managing lighting, fan speed, and occupancy tracking in a room or corridor. The design incorporates entry detection logic, real-time sensor data processing, and decision-making to optimize energy usage and improve user experience.

---

## 🛠️ **Features**

1. **Automatic Fan Speed Control**
   - Fan speed is dynamically controlled based on the number of people in the room.
   - Speed Modes:
     - 1-3 people: Mode A (Low Speed)
     - 4-5 people: Mode B (Medium Speed)
     - 6-7 people: Mode C (High Speed)
     - 8-9 people: Mode D (Maximum Speed)

2. **Corridor Lamp Control**
   - Lamp automatically turns on and off based on movement detection from IR sensors.
   - Override feature allows the light to be turned off during the night to conserve energy.

3. **Real-Time Occupancy Tracking**
   - Uses two IR sensors to detect entry and exit movements, updating the number of people inside.
   - The count of people is displayed on a 7-segment display.

4. **Multi-State Entry Detection Logic**
   - An advanced state machine tracks entry status with the following states:
     - **Idle**: No movement detected.
     - **Entry**: Person detected at the first IR sensor.
     - **Interim1**: Person is in between IR1 and IR2.
     - **Interim2**: Person crosses IR1 but not IR2.
     - **Room**: Person successfully enters the room.

5. **Fan Speed Control via NTC Temperature Sensor**
   - Temperature-sensitive control adjusts fan speed for better energy efficiency.

6. **User-Defined Reset and Override**
   - Reset buttons for the system, people count, and fan control.

---

## 📋 **System Architecture**
The system consists of the following key modules:

1. **Clock Divider**
   - Generates slower clocks from the main clock to drive sub-modules such as the state machine and PWM.

2. **PWM (Pulse Width Modulation) Generator**
   - Controls fan speed according to the logic derived from the occupancy count.
   
3. **Fan Controller**
   - Determines the fan speed based on occupancy count and NTC temperature sensor status.

4. **Entry Detection State Machine**
   - Tracks the movement of people using IR sensors and updates the occupancy count.

5. **Lamp Control State Machine**
   - Activates or deactivates the corridor lamp based on IR sensor input and the night override condition.

6. **7-Segment Display Controller**
   - Displays the number of people in the room on a 7-segment display.

7. **Sensor Control Unit**
   - Interfaces with IR sensors, NTC sensor, and buttons to collect real-time status.

---

## 💾 **File Structure**
```
📁 FPGA-Home-Automation-System
├── 📄 README.md (This file)
├── 📄 design.sv (Main Verilog design file)
├── 📄 testbench.sv (Testbench to verify system logic)
├── 📄 clock_divisor.sv (Clock divider module)
├── 📄 pwm_generator.sv (PWM module for fan speed control)
├── 📄 entry_detection.sv (Entry detection state machine logic)
├── 📄 fan_controller.sv (Fan speed controller logic)
├── 📄 lamp_control.sv (Lamp state machine logic)
├── 📄 display_controller.sv (7-segment display logic for people count)
└── 📄 waveform.vcd (Waveform file to visualize simulation results)
```

---

## 🛠️ **Hardware Requirements**
- **FPGA Board** (e.g., Intel/Altera DE1, DE2, Xilinx Basys 3, etc.)
- **IR Sensors** (2 units for entry/exit detection)
- **NTC Temperature Sensor** (for fan speed control)
- **7-Segment Display** (to display the number of people in the room)
- **Push Buttons** (for system reset, manual control, etc.)
- **LEDs** (for corridor lamp display)
- **Fan (or Fan Simulation)** (controlled using PWM logic)

---

## 🚦 **How It Works**

1. **Entry Detection:**
   - As people enter or exit, two IR sensors track their movements, updating the people count.
   - The system updates the 7-segment display to show the current count.

2. **Fan Speed Control:**
   - The fan speed is controlled by occupancy and temperature using PWM signals.
   - The fan speed automatically adjusts between 25%, 50%, 75%, and 100%.

3. **Lamp Control:**
   - The lamp turns on automatically when motion is detected and turns off after a set time.
   - Night mode override keeps the light off to save energy.

---

## 📘 **Usage Instructions**

1. **Upload the Design to FPGA**
   - Use Quartus/ModelSim or another FPGA development tool.
   - Load `design.sv` and `testbench.sv` into your development environment.
   - Synthesize the design and upload it to the FPGA.

2. **Connect Sensors and Display**
   - Attach IR sensors, NTC sensor, 7-segment display, push buttons, and LEDs to the FPGA pins.

3. **Simulate the Design**
   - Run the testbench to verify the system.
   - Generate the `waveform.vcd` file and view it using any VCD waveform viewer.

4. **Run the System**
   - Activate the sensors to see automatic fan speed, lamp control, and people counting in action.

---

## 🔬 **Testing and Validation**
1. **Testbench Verification:**
   - Use the testbench file `testbench.sv` to verify all modules using simulation.
   - View the output waveform (`waveform.vcd`) to confirm the system logic.

2. **Real-World Testing:**
   - Place the IR sensors at a door to track entry/exit movements.
   - Place the NTC sensor to detect temperature changes.
   - Observe fan speed changes, light control, and 7-segment display changes.

---

## ⚙️ **Future Enhancements**
- **Energy Efficiency:** Add AI-based predictions to optimize fan/lamp usage.
- **Remote Control:** Connect the system to Wi-Fi or Bluetooth for remote control.
- **Smartphone App:** Create a mobile app for controlling fan and light settings.
- **Expanded People Counting:** Implement a more accurate people tracking algorithm.

---

## 🧪 **Simulation and Testing Commands**

Run the following command to compile and simulate the Verilog files:
```bash
iverilog -o output.vvp design.sv testbench.sv
vvp output.vvp
```
To view the waveform, ensure you have a VCD viewer (like GTKWave):
```bash
gtkwave waveform.vcd
```


---

## 🤝 **Contributing**
Contributions are welcome! If you'd like to add new features or fix issues, please create a pull request.

---

## 📞 **Contact**
If you have questions or need support, feel free to reach out!

**Email:** [ajajubayertalukder@gmail.com]  
**GitHub:** [https://github.com/JubayerONROB]  

---

