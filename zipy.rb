#!/usr/bin/env ruby
#
# Zip Archive Password Cracker in Ruby
# By: Osanda Malith and Hood3dRob1n
#

require 'optparse'
require 'rubygems'
require 'archive/zip'

# Catch System Interupts
trap("SIGINT") { 
  puts "\n\nWARNING! CTRL+C Detected, Shutting things down.....\n\n"
  exit 
}

# Simple Banner
def banner
  puts
  puts "[+] Zipy - A Zip Archive Cracker"
  puts "[+] Osanda Malith and Hood3dRob1n"
  puts "[+] OsandaJayathissa@gmail.com"
end
#Big Thanks to my best buddie Hood3dRob1n
# Simple Terminal Clear
def cls
  if RUBY_PLATFORM =~ /win32|win64|WoW64|\.NET|windows/i
    system('cls')
  else
    system('clear')
  end
end

### MAIN ###
options = {}
optparse = OptionParser.new do |opts| 
  opts.banner = "Usage: #{$0} [OPTIONS]"
  opts.separator ""
  opts.separator "EX: #{$0} --file secret.zip --wordlist passwords.txt"
  opts.separator ""
  opts.on('-f', '--file FILE', "\n\tProtected Zip Archive File") do |zipper|
    if File.exists?(zipper.strip.chomp)
      options[:file] = zipper.strip.chomp
      if RUBY_PLATFORM =~ /win32|win64|WoW64|\.NET|windows/i
        @extraction = zipper.strip.chomp.split('/')[-1].split('.')[0]
      else
        @extraction = zipper.strip.chomp.split('\\')[-1].split('.')[0]
      end
    else
      banner
      puts "\nUnable to load or find zip archive file!"
      puts "Please check path or permissions and try again....\n\n"
      exit
    end
  end
  opts.on('-w', '--wordlist FILE', "\n\tPassword File to Use") do |wordlist|
    if File.exists?(wordlist.strip.chomp)
      options[:wordlist] = wordlist.strip.chomp
    else
      banner
      puts "\nUnable to load or find zip archive file!"
      puts "Please check path or permissions and try again....\n\n"
      exit
    end
  end
  opts.on('-h', '--help', "\n\tHelp Menu") do 
    cls
    banner
    puts "\n#{opts}\n"
    exit 69;
  end
end
begin
  foo = ARGV[0] || ARGV[0] = "-h"
  optparse.parse!
  mandatory = [ :file, :wordlist ]
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?
    cls
    banner
    puts "\nMissing options: #{missing.join(', ')}\n#{optparse}"
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  cls
  banner
  puts "\n#{$!.to_s}\n#{optparse}\n"
  exit   
end

cls
banner
passwords=File.open(options[:wordlist]).readlines.shuffle
puts "\n[*] Loaded #{passwords.size} passwords...."
puts "[*] Launching Zipy Cracker...."
total=passwords.size
while(passwords.size > 0)
  pass=passwords.pop.chomp
  begin
    print "\r  (#{(((total.to_f - passwords.size.to_f) / total.to_f) * 100).to_i}%)> #{pass.chomp}"
    Archive::Zip.extract(options[:file], @extraction, :password => pass)
    puts "\n[+] Cracked using password: #{pass}\n\n"
    exit
  rescue => e
    next
  end
end
puts "\n[~] Password not found in wordlist!\n\n"
#EOF
