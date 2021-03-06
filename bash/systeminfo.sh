#!/bin/bash
# This script implements the system report from lab4 of comp2101

# Declare variables and assign any default values.
runindefaultmode="yes"

# Define functions for error messages and displaying command line help.
function usage {
  echo "Usage:$0 [-h | --help] [-n | --name] [-o | --os] [-i | --ip] [-v | --version] [-c | --cpu] [-r | --ram | -m | --memory] [-d | --disk] [-p | --printer] [-s | --software] [-h | --help]"
}
function errormessage {
  echo "$@" >&2
}

# Process the command line options, saving the results in variables for later use.
while [ $# -gt 0 ]; do
  case "$1" in
    #Provides thorough help information to make it understandable to all users.
    -h|--help)
      echo "Usage: sysinfo.sh [OPTION]..."
      echo "Displays information about current system"
      echo "More than one option can be used at once, for example 'bash sysinfo.sh -o -d -v'"
      echo ""
      echo "Available arguments:"
      echo "-h, --help          help"
      echo "-n, --name          Displays hostname and Doamin name if available."
      echo "-o, --os            Displays The version of Linux."
      echo "-i, --ip            Displays the IP address and Default Gateway of this machine."
      echo "-v, --version       Displays more information about the version of Linux, including kernel version."
      echo "-c, --cpu           Displays information about processor."
      echo "-r, --ram,          Displays amount of RAM/Memory."
      echo "-m, --memory        Displays amount of RAM/Memory."
      echo "-d, --disk          Displays available disk space."
      echo "-p, --printer       lists connected printers."
      echo "-s, --software      list software installed on machine."
      exit 0
      ;;
    -n|--name)
      namesinfowanted="yes"
      runindefaultmode="no"
      ;;
    -o|--os)
      osinfowanted="yes"
      runindefaultmode="no"
      ;;
    -i|--ip)
      ipinfowanted="yes"
      runindefaultmode="no"
      ;;
    -v|--version)
      versioninfowanted="yes"
      runindefaultmode="no"
      ;;
    -c|--cpu)
      cpuinfowanted="yes"
      runindefaultmode="no"
      ;;
    -r|--ram|-m|--memory)
      raminfowanted="yes"
      runindefaultmode="no"
      ;;
    -d|--disk)
      diskinfowanted="yes"
      runindefaultmode="no"
      ;;
    -p|--printer)
      printerinfowanted="yes"
      runindefaultmode="no"
      ;;
    -s|--software)
      softwareinfowanted="yes"
      runindefaultmode="no"
      ;;
    *)
      errormessage "'$1' Isn't a valid argument. Try:"
      errormessage "Try -h or --help to see a list of possible arguments."
      exit 1
      ;;
  esac
  shift
done

# Gather the data into variables, using arrays where helpful.
osinfo="$(grep PRETTY /etc/os-release |sed -e 's/.*=//' -e 's/"//g')"
systemname="$(hostname)"
domainname="$(domainname)"

#IP data
ipinfo="$(hostname -I)"
dginfo="$(hostname -i)"

#OS Version, OS Names
versioninfo="$(uname -a)"
osversioninfo="$(lsb_release -a)"

#CPU Information
cpuinfo="$(grep -m 1 "model name" /proc/cpuinfo)"
cpu_coresinfo="$(grep -m 1 "cpu cores" /proc/cpuinfo)"

#RAM/Memory Information
raminfo="$(grep "MemTotal" /proc/meminfo)"

#Disk Information
diskinfo="$(df -h)"

#Printer Information
printerinfo="$(lpstat -a | cut -f1 -d ' ')"

#software Information
softwareinfo="$(dpkg --get-selections)"

# Create the output using the gathered data and command line options.
#Formatted OS Information
osinfoformatted="
Operating System Information:
=============================
$osinfo
"

#Formatted  Hostname and Domainname Information
nameinfoformatted="
System Names Information:
=============================
Hostname: $systemname
Domainname: $domainname
"

#Formatted IP and Defualt Gateway Information
ipinfoformatted="
IP Information:
=============================
System IP: $ipinfo
Default Gateway: $dginfo
"

#Formatted Kernel and Distribution version Information
versioninfoformatted="
Version Information:
=============================
Kernal Info: $versioninfo
$osversioninfo
"

#Formatted CPU Information
cpuinfoformatted="
CPU Information:
=============================
$cpuinfo
$cpu_coresinfo
"

#Formatted RAM/Memory Information
raminfoformatted="
RAM Information:
=============================
$raminfo
"

#Formatted Harddrive Information
diskinfoformatted="
Disk Information:
=============================
$diskinfo
"

#Formatted Software Information
printerinfoformatted="
Printer Information:
=============================
$printerinfo
"

#Formatted Software Information
softwareinfoformatted="
Software Information:
=============================
$softwareinfo
"

# Display the output.
if [ "$runindefaultmode" = "yes" -o "$namesinfowanted" = "yes" ]; then
  echo "$nameinfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$osinfowanted" = "yes" ]; then
  echo "$osinfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$ipinfowanted" = "yes" ]; then
  echo "$ipinfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$versioninfowanted" = "yes" ]; then
  echo "$versioninfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$cpuinfowanted" = "yes" ]; then
  echo "$cpuinfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$raminfowanted" = "yes" ]; then
  echo "$raminfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$diskinfowanted" = "yes" ]; then
  echo "$diskinfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$printerinfowanted" = "yes" ]; then
  echo "$printerinfoformatted"
fi

if [ "$runindefaultmode" = "yes" -o  "$softwareinfowanted" = "yes" ]; then
  echo "$softwareinfoformatted" | more
fi
# Do any cleanup of temporary files if needed
