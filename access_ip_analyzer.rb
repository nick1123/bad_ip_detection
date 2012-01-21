require 'rubygems'
require 'trollop'
require 'pp'

# http://www.ip-adress.com/ip_tracer/

opts = Trollop::options do
  opt :date_pattern, "02/Oct/2011:15:05 OR 02/Oct", :type => :string
#  opt :min_occurances, "Min IP occurances", :type => :int, :default => 100
  opt :top_occurances, "Show top occurances", :type => :int, :default => 20
  opt :verbose, "Be really verbose"
  opt :nick, "Only search NicksTrafficTricks access log"
  opt :comments, "Only search for hits to wp-comments"
  opt :block, "Group IP's by block i.e. 123.123.123.*"
end

Trollop::die :date_pattern, "is required" if opts[:date_pattern].nil?

ip_names = {}

# Legitmate crawlers
ip_names['173.255.219.144'] = 'Linode NJ'
ip_names['207.46.195.240'] = 'MS Bot'
ip_names['157.55.116.24'] =  'MS Bot'
ip_names['66.249.67.144'] = 'GoogleBot'
ip_names['66.249.67.42'] =  'GoogleBot'
ip_names['66.249.67.129'] = 'GoogleBot'
ip_names['67.195.115.54'] = 'YahooBot'
ip_names['67.195.114.34'] = 'YahooBot'
ip_names['76.8.201.113'] = 'Nick-Orem'
ip_names['66.249.67.213'] = 'GoogleBot'
ip_names['66.249.67.235'] = 'GoogleBot'
ip_names['66.249.68.230'] = 'GoogleBot'
ip_names['207.46.13.94'] = 'MS Bot'
ip_names['66.249.67.176'] = 'GoogleBot'
#ip_names[''] = ''
#ip_names[''] = ''
#ip_names[''] = ''
#ip_names[''] = ''

# IPs that should be banned
#ip_names[''] = 'Banned IP'
#ip_names[''] = 'Banned IP'
#ip_names[''] = 'Banned IP'
#ip_names[''] = 'Banned IP'
#ip_names[''] = 'Banned IP'

restrict_to_ntt = opts[:nick] ? "grep nicks |" : ""
restrict_to_comments = opts[:comments] ? " | grep wp-comments" : ""

# Fetch matching lines
cmd = "find /var/log/ | grep access | grep -v gz | #{restrict_to_ntt} xargs grep -h #{opts[:date_pattern]} #{restrict_to_comments}"
puts cmd if opts[:verbose]
lines = (`#{cmd}`).split('\n')

scan_pattern = opts[:block] ? /\d{1,3}\.\d{1,3}\.\d{1,3}\./ : /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/

ip_total = 0
ip_hash = Hash.new(0)
lines.each do |line|
  ips = line.scan(scan_pattern)
  ips.each do |ip|
    ip_hash[ip] += 1
    ip_total += 1
  end
end

puts "IP\t\tCount\tPercent"
ip_hash.sort{|a,b| b[1]<=>a[1]}.each_with_index { |elem, index|
  ip = elem[0]
  count = elem[1]
  percent = (1000.0 * count / ip_total).to_i / 10.0
  puts "#{ip}\t#{count}\t#{ip_names[ip]}\t#{percent}" #if elem[1] > opts[:min_occurances]
  break if index >= opts[:top_occurances]
}

puts ""
puts "Total IP Hits: #{ip_total}"
