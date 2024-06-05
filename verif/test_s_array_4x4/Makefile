# Makefile for cocotb-based testbench
# Cocotb settings 
TOPLEVEL_LANG ?= verilog   #HDL
SIM ?= vcs #verilator #icarus

PWD=$(shell pwd)
VERILOG_SOURCES = $(wildcard $(PWD)/../../source/*.sv)  #directory having all the verilog source files (.sv).

TOPLEVEL := s_array_4x4  				# RTL top-level module name
MODULE := test_s_array_4x4			# Name of the Python test module

include $(shell cocotb-config --makefiles)/Makefile.sim

#  rm -rf dump.vcd __pycache__/ sim_build/ a.out results.xml ucli.key 