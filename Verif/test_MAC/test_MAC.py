import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, Join, ClockCycles
from cocotb.regression import TestFactory
import sys
import os
import numpy as np
import random

@cocotb.test() #no need with testfactory
async def test(dut):
    #initially all input signals are zero
    dut.clk     <= 0
    dut.rst     <= 0
    dut.ld_w    <= 0
    dut.w_in    <= 0
    dut.psum_in <= 0
    dut.a_in    <= 0

    # After 2ns simulation starts
    await Timer(1, units='ns')

    #Create 1ns period clock on port clk
    clock = Clock(dut.clk, 1, units="ns")                 
    #Start the clock
    cocotb.fork(clock.start())                                
    #Reset
    dut.rst      <= 1
    await Timer(2, units='ns')
    dut.rst      <= 0

    dut.ld_w <= 1
    dut.w_in <= random.randint(0,15)
    await Timer(1, units='ns')
    dut.w_in <= random.randint(0,15)
    await Timer(1, units='ns')
    dut.w_in <= random.randint(0,15)

    await Timer(1, units='ns')
    dut.ld_w <= 0
    for i in range(4):
        dut.w_in <= random.randint(0,15)
        dut.psum_in <= random.randint(0,15)
        dut.a_in <= random.randint(0,15)
        await Timer(1, units='ns')
        await Timer(1, units='ns')


