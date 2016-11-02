//-----------------------------------------------------------------------------
// Original Author: Alina Ivanova
// Contact Point: Alina Ivanova (alina.al.ivanova@gmail.com)
// amp_ph_detector_top.v
// Created: 10.26.2016
//-----------------------------------------------------------------------------
// Amplitude and Phase Detector Top Module.
//-----------------------------------------------------------------------------
// Напишите модуль на языке Verilog, оптимизированный для работы на 
// максимальной тактовой частоте и выполняющий вычисление модуля и фазы
// сигнала. На вход поступают отсчеты сигнала в комплексном виде I и Q с
// частотой равной тактовой. Выходные значения так же должны выдаваться на
// тактовой частоте. Разрядность входных и выходных значений задаются параметрически. 
// Ответье на следующие вопросы:
// 1)  Чему равна задержка модуля в тактах?
// 2)  Дайте предварительную оценку ресурсов (FlipFlops, Fulladders, MUXs, gates) без синтеза.
//-----------------------------------------------------------------------------
// Copyright (c) 2016 by Alina Ivanova
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps
//----------------------------------------------------------------------------- 
import package_settings::*;
//-----------------------------------------------------------------------------
module amp_ph_detector_top (
//-----------------------------------------------------------------------------
// Input Ports
//-----------------------------------------------------------------------------
    input  wire                                           clk,
    input  wire                                           reset,
//-----------------------------------------------------------------------------
    input  wire        [SIZE_DATA-1:0]                    data_i,
    input  wire        [SIZE_DATA-1:0]                    data_q,
//-----------------------------------------------------------------------------
// Output Ports
//-----------------------------------------------------------------------------
    output reg         [SIZE_DATA-1:0]                    output_amp,
    output reg         [SIZE_DATA-1:0]                    output_ph);
//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------
    reg                                                   reset_synch;
    reg                [2:0]                              reset_z;
//-----------------------------------------------------------------------------
    reg                [SIZE_DATA-1:0]                    amp_output;
    reg                [SIZE_DATA-1:0]                    phase_output;
//-----------------------------------------------------------------------------
// Function Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Sub Module Section
//-----------------------------------------------------------------------------
    Amplitude amplitude (
        .clk                                              (clk),
        .reset                                            (reset_synch),
//-----------------------------------------------------------------------------
        .data_i                                           (data_i),
        .data_q                                           (data_q),
//-----------------------------------------------------------------------------
        .output_data                                      (amp_output));
//-----------------------------------------------------------------------------
    Phase phase (
        .clk                                              (clk),
        .reset                                            (reset_synch),
//-----------------------------------------------------------------------------
        .data_i                                           (data_i),
        .data_q                                           (data_q),
//-----------------------------------------------------------------------------
        .output_data                                      (phase_output));    
//-----------------------------------------------------------------------------
// Signal Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Process Section
//-----------------------------------------------------------------------------
    always_ff @(negedge reset or posedge clk) begin: AMP_PH_DETECTOR_TOP_RESET_SYNCH
        reset_z                                         <= {reset_z[1:0], reset};
        reset_synch                                     <= (reset_z[1] & (~reste_z[2]) ? '1 : '0 ;
    end: AMP_PH_DETECTOR_TOP_RESET_SYNCH
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: AMP_PH_DETECTOR_TOP_OUTPUT_DATA
        if (reset_synch) begin
            {output_amp, output_ph}                      <= '0;
        end else begin
            output_amp                                   <= amp_output;
            output_ph                                    <= phase_output;
        end
    end: AMP_PH_DETECTOR_TOP_OUTPUT_DATA
//-----------------------------------------------------------------------------
endmodule: amp_ph_detector_top
