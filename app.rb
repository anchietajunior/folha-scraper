require 'readline'
require 'mechanize'
require 'terminal-table'

prompt = "> "

def agent
  @agent ||= Mechanize.new
end

def search_car(name)
  page = agent.get("https://folhacar.com.br/resultados/tipo/carros/busca/#{name}")
  rows = page.search('.tab-content').map do |item|
    row = []
    title = item.search('.listings-grid__body h5').text.strip
    price_and_year = item.search('.listings-grid__price').text.strip
    row << title
    row << price_and_year[0..3]
    row << price_and_year[-7..-1]
    item.search('.listings-grid__attrs li').each do |attr|
      row << attr.text
    end
    row
  end

  puts Terminal::Table.new :headings => ['Modelo', 'Ano', 'Preço', 'Combustível', 'Cor', 'KM'], :rows => rows.sort_by{|a,b,c,d,e,f| b}.reverse
end

while buf = Readline.readline(prompt, true)
  search_car(buf)
end

