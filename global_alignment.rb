#!/usr/bin/env ruby

require 'optparse'
require_relative './nw_matrix.rb'

class GlobalAlignment
  def initialize
    @options = Hash.new
    parse_options
    @sequence1_alignment = []
    @sequence2_alignment = []
    @nw_matrix = NWMatrix.new(@sequence1, @sequence2, gap: @gap_penalty, 
                              match: @match, mismatch: @mismatch)
  end

  def print
    puts @sequence1_alignment.join('')
    puts @sequence2_alignment.join('')
  end

  def traceback
    y_coord = @sequence1.size - 1
    x_coord = @sequence2.size - 1
    until @nw_matrix.trace(y_coord, x_coord) == 'done' do 
      y_coord, x_coord = align(y_coord, x_coord)
    end
  end

  private

  def align(y, x)
    case @nw_matrix.trace(y,x)
    when 'diag'
      @sequence1_alignment.unshift(@sequence1[y])
      @sequence2_alignment.unshift(@sequence2[x])
      [y - 1, x - 1]
    when 'left'
      @sequence1_alignment.unshift('_')
      @sequence2_alignment.unshift(@sequence2[x])
      [y, x - 1]
    when 'down'
      @sequence1_alignment.unshift(@sequence1[y])
      @sequence2_alignment.unshift('_')   
      [y - 1, x]
    end
  end

  def parse_options
    OptionParser.new do |opts|
      opts.banner = "Usage: global_alignment.rb [options]"
      opts.on('-s', '--sequences S1,S2', 
              'Takes a comma delimited list of two sequences to align') do |v| 
        @sequence1, @sequence2 = v.to_s.split(',').map{ |s| s.split('') }
      end
      opts.on('-g', '--gap-penalty INTEGER', 
              'The value to be scored as the gap penalty during alignment') do |v| 
        @gap_penalty = v.to_i
      end
      opts.on('-m', '--match INTEGER', 
              'The value to be scored for a match during alignment') do |v| 
        @match = v.to_i
      end
      opts.on('-i', '--mismatch INTEGER', 
              'The value to be scored for a mismatch during alignment') do |v| 
        @mismatch = v.to_i
      end
    end.parse!
    raise OptionParser::MissingArgument unless @sequence1 && @sequence2
  end
end

alignment = GlobalAlignment.new
alignment.traceback
alignment.print