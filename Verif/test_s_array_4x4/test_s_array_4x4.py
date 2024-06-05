import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, Join, ClockCycles
from cocotb.regression import TestFactory
import sys
import os
import numpy as np
import random

@cocotb.test() #we use it without test factory
async def test(dut):
    dut.clk    <= 0
    dut.rst    <= 0

    dut.ld_w_en    <= 0
    dut.ld_w_id    <= 0

    dut.a_in_1 <= 0
    dut.a_in_2 <= 0
    dut.a_in_3 <= 0
    dut.a_in_4 <= 0
    
    dut.w_in_1 <= 0
    dut.w_in_2 <= 0
    dut.w_in_3 <= 0
    dut.w_in_4 <= 0

    dut.psum_in_1 <= 0
    dut.psum_in_2 <= 0
    dut.psum_in_3 <= 0
    dut.psum_in_4 <= 0

    #Create 0.002ns period clock on port clk
    clock = Clock(dut.clk, 1, units="ns")                 
    #Start the clock
    cocotb.fork(clock.start())   
    #Reset
    dut.rst      <= 1
    await Timer(2, units='ns')
    dut.rst      <= 0                             

    # # define input activation matrix
    # matrix_act = np.array([ [1, 2, 3, 4],
    #                         [1, 2, 3, 4],
    #                         [1, 2, 3, 4],
    #                         [1, 2, 3, 4]])
        # define input activation matrix
    matrix_act = np.array([ [1, 2, 3, 4],
                            [5, 6, 7, 8],
                            [9, 10, 11, 12],
                            [13, 14, 15, 16]])

    # define input weight matrix
    matrix_wt = np.array([  [4, 0, 2, 1],
                            [4, 3, 2, 0],
                            [4, 3, 0, 1],
                            [4, 3, 2, 1]])
    
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
    # Ideal result
    print("Resultant Matrix:\n",np.dot(matrix_act, matrix_wt))