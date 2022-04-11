@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.2.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Mon Apr 11 11:00:20 +0200 2022
REM SW Build 2729669 on Thu Dec  5 04:49:17 MST 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto caaf8dff34da4b76b132fd6bcbd9be6f --incr --debug typical --relax --mt 2 -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L fir_compiler_v7_2_13 -L xil_defaultlib -L secureip -L xpm --snapshot FIR_50k_TB_behav xil_defaultlib.FIR_50k_TB -log elaborate.log"
call xelab  -wto caaf8dff34da4b76b132fd6bcbd9be6f --incr --debug typical --relax --mt 2 -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L fir_compiler_v7_2_13 -L xil_defaultlib -L secureip -L xpm --snapshot FIR_50k_TB_behav xil_defaultlib.FIR_50k_TB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
