class Lono::Pro
  class Repo < Base
    def run
      data = api.repos(@options[:type])
      # data = data[7..9]
      header = ["Name", "Docs", "Description"]
      rows = data.map do |d|
        desc = truncate(d[:description])
        [d[:name], d[:docs_url], desc]
      end
      show_table(header, rows)
    end

  private
    def truncate(string, max=36)
      string.length > max ? "#{string[0...max]}..." : string
    end

    def show_table(header, data)
      table = Text::Table.new
      table.head = header
      data.each do |item|
        table.rows << item
      end
      puts table
    end
  end
end
