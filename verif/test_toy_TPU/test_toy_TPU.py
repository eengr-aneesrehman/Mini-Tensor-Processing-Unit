import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, Join, ClockCycles
from cocotb.regression import TestFactory
import sys
import os
import numpy as np
import random

# import custom python methods aka software model of the dut
sys.path.insert(1, "../../model/")
from model import model

# #Seed
# seed=12345
# random.seed(seed)
# np.random.seed(seed)

if ("Random_Flag" in os.environ):
    Random_Flag = int(os.environ["Random_Flag"])
else:
    Random_Flag = 0

async def driver(dut, matrix_act, matrix_wt):
    # dut.clk    <= 0
    # dut.rst    <= 0

    # dut.ld_w_en    <= 0
    # dut.ld_w_id    <= 0

    # dut.a_in_1 <= 0
    # dut.a_in_2 <= 0
    # dut.a_in_3 <= 0
    # dut.a_in_4 <= 0
    
    # dut.w_in_1 <= 0
    # dut.w_in_2 <= 0
    # dut.w_in_3 <= 0
    # dut.w_in_4 <= 0

    dut.psum_in_1 <= 0
    dut.psum_in_2 <= 0
    dut.psum_in_3 <= 0
    dut.psum_in_4 <= 0

    dut.rst      <= 1
    await Timer(2, units='ns')
    dut.rst      <= 0                             

    # Loading weights
    await Timer(1, units='ns')
    dut.ld_w_en   <= int(1)
    for i in range(4):
        dut.ld_w_id <= int(i)
        dut.w_in_1  <= int(matrix_wt[i, 0])
        dut.w_in_2  <= int(matrix_wt[i, 1])
        dut.w_in_3  <= int(matrix_wt[i, 2])
        dut.w_in_4  <= int(matrix_wt[i, 3])
        await Timer(1, units='ns')
    dut.ld_w_en   <= 0

    # Inputing activations
    await Timer(1, units='ns')
    for i in range(4):
        dut.a_in_1 <= int(matrix_act[i, 0])
        if(i>0):
            dut.a_in_2 <= int(matrix_act[i-1, 1])
        else:
            dut.a_in_2 <= int(0)
        if(i>1):
            dut.a_in_3 <= int(matrix_act[i-2, 2])
        else:
            dut.a_in_3 <= int(0)
        if(i>2):
            dut.a_in_4 <= int(matrix_act[i-3, 3])
        else:
            dut.a_in_4 <= int(0)
        await Timer(1, units='ns')
    dut.a_in_1 <= int(0)
    for i in range(4):
        if(i<1):
            dut.a_in_2 <= int(matrix_act[i+3, 1])
        else:
            dut.a_in_2 <= int(0)
        if(i<2):
            dut.a_in_3 <= int(matrix_act[i+2, 2])
        else:
            dut.a_in_3 <= int(0)
        if(i<3):
            dut.a_in_4 <= int(matrix_act[i+1, 3])
        else:
            dut.a_in_4 <= int(0)
        await Timer(1, units='ns')
    
    await Timer(5, units='ns')

async def monitor(dut):
    res = np.zeros((4, 4))
    await Timer(13, units='ns')

    for i in range(4):
        res[i, 0] = (int(dut.out_1.value.binstr,2))
        if(i>0):
            res[i-1, 1] = (int(dut.out_2.value.binstr,2))
        if(i>1):
            res[i-2, 2] = (int(dut.out_3.value.binstr,2))
        if(i>2):
            res[i-3, 3] = (int(dut.out_4.value.binstr,2))
        await Timer(1, units='ns')
    for i in range(4):
        if(i<1):
            res[i+3, 1] = (int(dut.out_2.value.binstr,2))
        if(i<2):
            res[i+2, 2] = (int(dut.out_3.value.binstr,2))
        if(i<3):
            res[i+1, 3] = (int(dut.out_4.value.binstr,2))
        await Timer(1, units='ns')
    return res

@cocotb.test() 
async def test(dut):
    #Create 0.002ns period clock on port clk
    clock = Clock(dut.clk, 1, units="ns")                 
    #Start the clock
    cocotb.fork(clock.start())   
                           
    # define input activation and weigth matrix
    if(not Random_Flag):
        matrix_act = np.array([ [1, 2, 3, 4],
                                [1, 2, 3, 4],
                                [1, 2, 3, 4],
                                [1, 2, 3, 4]])

        matrix_wt = np.array([  [4, 0, 2, 1],
                                [4, 3, 2, 0],
                                [4, 3, 0, 1],
                                [4, 3, 2, 1]])
    else:
        matrix_act = np.random.randint(0, 10, (4, 4))
        matrix_wt  = np.random.randint(0, 10, (4, 4))

    #start the driver and monitor 
    driver_task = cocotb.fork(driver(dut,matrix_act,matrix_wt))
    monitor_task = cocotb.fork(monitor(dut))

    #Wait for the processes to finish and capture the result
    await Join(driver_task)
    result_matrix = await Join(monitor_task)

    result_matrix_ideal = model(matrix_act, matrix_wt)

    # Print result
    print("Resultant Matrix (DUT):\n",result_matrix)
    print("\nResultant Matrix (Software Model):\n",result_matrix_ideal)

    # Checking the dut and model results match
    difference = result_matrix - result_matrix_ideal
    if np.array_equal(difference, np.zeros((4, 4))):
        print("\n Test Passed!")
    else:
        assert False, f"Test Failed! Difference matrix:\n{difference}" 