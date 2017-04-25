#!/usr/bin/env ruby

class NWMatrix
  # SEQ1 is on Y-axis
  # SEQ2 is on X-axis

  def initialize(sequence1, sequence2, scoring)
    @sequence1 = sequence1.unshift('_')
    @sequence2 = sequence2.unshift('_')
    @gap = scoring[:gap] || -1
    @mismatch = scoring[:mismatch] || -1
    @match = scoring[:match] || 1
    build_matrix
    fill_matrix
  end

  def trace(y,x)
    @matrix[y][x][:trace]
  end

  private

  def build_matrix
    @matrix = []
    (@sequence1.size).times { @matrix.push([]) }
  end

  def fill_matrix
    @matrix[0][0] = { score: 0, trace: 'done' } 
    fill_first_row_and_column
    1.upto(@sequence1.size - 1) do |y|
      1.upto(@sequence2.size - 1) do |x|
        scores = [score_diag(y,x), score_left(y,x), score_down(y,x)]
        @matrix[y][x] = scores.max_by { |x| x[:score] }
      end
    end
  end

  def fill_first_row_and_column
    @sequence1.size.times do |i|
      next if i == 0
      score = find_score(i-1, 0) + @gap
      @matrix[i][0] = { score: score, trace: 'down' }
    end
    @sequence2.size.times do |i|
      next if i == 0
      score = find_score(0, i-1) + @gap
      @matrix[0][i] = { score: score, trace: 'left' }
    end
  end

  def diag(y,x)
    @matrix[y-1][x-1]
  end

  def left(y,x)
    @matrix[y][x-1]
  end

  def down(y,x)
    @matrix[y-1][x]
  end

  def score_diag(y,x)
    score = diag(y,x)[:score] + match_or_mismatch(y,x)
    { score: score, trace: 'diag' }
  end

  def score_left(y,x)
    score = left(y,x)[:score] + @gap
    { score: score, trace: 'left' }
  end

  def score_down(y,x)
    score = down(y,x)[:score] + @gap
    { score: score, trace: 'down' }
  end

  def find_score(y,x)
    @matrix[y][x][:score]
  end

  def match_or_mismatch(y,x)
    if @sequence1[y] != @sequence2[x]
      -1
    else
      1
    end
  end
end