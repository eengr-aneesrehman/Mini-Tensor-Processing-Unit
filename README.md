# Mini Tensor Processing Unit

## Overview

This repository contains the design and verification of a Mini Tensor Processing Unit (TPU). The mini TPU contains 4x4 Systolic Array with Multiply-Accumulate (MAC) units, followed by a quantization and activation unit. The design is simulated using Synopsys VCS using COCOTB-based Python test benches.

## Project Setup

![verif](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/1bc6d148-2885-493e-bbc1-f76f02bdc1b4)


## Top Level Design 

![MTPU](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/40cd947f-3278-42ee-8606-680d9b23cd16)


## Design Details

- **MAC Unit**: Each processing element contains a Multiply-Accumulate unit.

![MAC](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/8b99008d-a941-4268-8668-de4de1a43497)
  
- **Systolic Array**: A 4x4 array of processing elements.

![4x4 SA](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/6a53efda-dfa5-4028-876e-a535422e969b)

  
- **Quantization Unit**: Reduces the precision of the MAC output.

![image](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/fe83d423-3e6c-453c-a606-fc77b174a11a)
  
- **Activation Unit**: Applies an activation function to the quantized output.

![image](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/1a36a257-4ebd-44c0-bb76-50b1f680c48c)

## Simulation and Verification

- **Simulation Tool**: Synopsys VCS
- **Verification Framework**: COCOTB (Coroutine-based co-simulation testbench in Python)
- **Test Benches**: Python scripts for verifying the functionality of the Systolic Array and its components.

## Results

![image (1)](https://github.com/eengr-aneesrehman/Mini-Tensor-Processing-Unit/assets/103167188/34fc171b-d502-45de-9bff-33ce5705c3bb)
