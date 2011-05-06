require 'active_support'

module MetricFu
  class Grapher
    GATIMELINE_DEFAULT_OPTIONS = <<-EOS
      google.load('visualization', '1', {'packages':['annotatedtimeline']});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = loadData();
        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('chart_div'));
        chart.draw(data, {legendPosition: 'newRow'});
      }
    EOS
  end

  class FlayGatimelineGrapher < FlayGrapher
    def graph!
      data_rows = ""
      @labels.zip(@flay_score).each do |label, value|
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{value}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Score');
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'flay.js'), 'w') {|f| f << content }
    end
  end

  class FlogGatimelineGrapher < FlogGrapher
    def graph!
      data_rows = ""
      @labels.zip(@flog_average, @top_five_percent_average).each do |label, average, top_five|
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{average}, #{top_five}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Average');
          data.addColumn('number', 'Top 5% Average');
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'flog.js'), 'w') {|f| f << content }
    end
  end

  class RcovGatimelineGrapher < RcovGrapher
    def graph!
      data_rows = ""
      @labels.zip(@rcov_percent).each do |label, value|
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{value}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Coverage');
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'rcov.js'), 'w') {|f| f << content }
    end
  end

  class ReekGatimelineGrapher < ReekGrapher
    def graph!
      legend = @reek_count.keys.sort
      legend_data = ""
      legend.each do |name|
        legend_data += "data.addColumn('number', '#{name}');\n";
      end
      data_rows = ""
      @labels.each_with_index do |label, i|
        data = @reek_count.keys.sort.collect{|k| @reek_count[k][i] }
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{data.join(',')}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          #{legend_data}
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'reek.js'), 'w') {|f| f << content }
    end
  end

  class RoodiGatimelineGrapher < RoodiGrapher
    def graph!
      data_rows = ""
      @labels.zip(@roodi_count).each do |label, value|
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{value}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Design Issues');
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'roodi.js'), 'w') {|f| f << content }
    end
  end

  class StatsGatimelineGrapher < StatsGrapher
    def graph!
      data_rows = ""
      @labels.zip(@loc_counts, @lot_counts).each do |label, loc, lot|
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{loc}, #{lot}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'LOC');
          data.addColumn('number', 'LOT');
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'stats.js'), 'w') {|f| f << content }
    end
  end

  class RailsBestPracticesGatimelineGrapher < RailsBestPracticesGrapher
    def graph!
      data_rows = ""
      @labels.zip(@rails_best_practices_count).each do |label, value|
        year, month, day = label[1].split('/')
        data_rows += "data.addRow([new Date(#{year}, #{month}, #{day}), #{value}]);\n"
      end
      content = <<-EOS
        #{GATIMELINE_DEFAULT_OPTIONS}
        function loadData() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Warnings');
          #{data_rows}
          return data;
        }
      EOS
      File.open(File.join(MetricFu.output_directory, 'rails_best_practices.js'), 'w') {|f| f << content }
    end
  end
end
